import 'dart:convert';

import 'package:drift/drift.dart' as d;

import '../models/enums.dart';
import '../models/sync_models.dart';
import '../services/cloud_gateway.dart';
import '../services/id_service.dart';
import '../services/local_database.dart' hide SyncMetadata;

class SyncRepository {
  SyncRepository(this._database);

  final LocalDatabase _database;

  Future<SyncMetadata> metadata(String accountId) async {
    final row = await (_database.select(
      _database.syncMetadata,
    )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();

    return SyncMetadata(
      accountId: accountId,
      cursor: row?.cursor,
      lastPullAt: row?.lastPullAt,
      lastPushAt: row?.lastPushAt,
      lastError: row?.lastError,
    );
  }

  Future<List<PendingOperation>> queue(String accountId) async {
    final rows =
        await (_database.select(_database.pendingOperations)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => d.OrderingTerm.asc(t.createdAt)]))
            .get();
    return rows.map(_mapOperation).toList();
  }

  Future<int> queueCount(String accountId) async {
    final count = _database.pendingOperations.operationId.count();
    final query = _database.selectOnly(_database.pendingOperations)
      ..addColumns([count])
      ..where(_database.pendingOperations.accountId.equals(accountId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> conflictCount(String accountId) async {
    final count = _database.syncConflicts.id.count();
    final query = _database.selectOnly(_database.syncConflicts)
      ..addColumns([count])
      ..where(
        _database.syncConflicts.accountId.equals(accountId) &
            _database.syncConflicts.resolvedAt.isNull(),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<SyncConflict>> conflicts(String accountId) async {
    final rows =
        await (_database.select(_database.syncConflicts)
              ..where(
                (t) => t.accountId.equals(accountId) & t.resolvedAt.isNull(),
              )
              ..orderBy([(t) => d.OrderingTerm.desc(t.createdAt)]))
            .get();

    return rows
        .map(
          (row) => SyncConflict(
            id: row.id,
            accountId: row.accountId,
            entity: SyncEntity.fromCode(row.entity) ?? SyncEntity.task,
            entityId: row.entityId,
            localPayload: jsonDecode(row.localJson) as Map<String, dynamic>,
            cloudPayload: jsonDecode(row.cloudJson) as Map<String, dynamic>,
            createdAt: row.createdAt,
            resolvedAt: row.resolvedAt,
            resolution: row.resolution,
          ),
        )
        .toList();
  }

  /// Ordered queue: pending/failed operations in creation order, respecting
  /// declared dependencies (FR-SYNC-004).
  Future<List<PendingOperation>> orderedQueue(String accountId) async {
    final all = await queue(accountId);
    final eligible = <PendingOperation>[];
    final completed = <String>{};

    for (final operation in all) {
      if (operation.status == SyncStatus.synced) continue;
      final dependency = operation.dependsOn;
      if (dependency != null &&
          !completed.contains(dependency) &&
          all.any((op) => op.operationId == dependency)) {
        // Dependent operation is still queued; it will be attempted after the
        // dependency is acknowledged.
        continue;
      }
      eligible.add(operation);
      completed.add(operation.operationId);
    }
    return eligible;
  }

  Future<void> markSending(String operationId) async {
    await (_database.update(_database.pendingOperations)
          ..where((t) => t.operationId.equals(operationId)))
        .write(const PendingOperationsCompanion(status: d.Value('sending')));
  }

  Future<void> markPushed(
    PendingOperation operation,
    PushApplied outcome,
  ) async {
    await _database.transaction(() async {
      await _applyServerRevision(
        operation: operation,
        revision: outcome.newRevision,
        synced: true,
      );
      await (_database.delete(
        _database.pendingOperations,
      )..where((t) => t.operationId.equals(operation.operationId))).go();
    });
  }

  Future<void> markConflict(
    PendingOperation operation,
    PushConflict conflict,
  ) async {
    await _database.transaction(() async {
      await (_database.update(_database.pendingOperations)
            ..where((t) => t.operationId.equals(operation.operationId)))
          .write(const PendingOperationsCompanion(status: d.Value('conflict')));

      await _writerStatus(
        operation.entity,
        operation.entityId,
        SyncStatus.conflict,
      );

      await _database
          .into(_database.syncConflicts)
          .insert(
            SyncConflictsCompanion.insert(
              id: IdService.newId(),
              accountId: operation.accountId,
              entity: operation.entity.code,
              entityId: operation.entityId,
              localJson: jsonEncode(operation.payload),
              cloudJson: jsonEncode(conflict.cloudPayload),
              createdAt: DateTime.now().toUtc(),
            ),
          );
    });
  }

  Future<void> markFailed(
    PendingOperation operation, {
    required String error,
    required bool permanent,
    required DateTime? nextAttemptAt,
  }) async {
    await (_database.update(
      _database.pendingOperations,
    )..where((t) => t.operationId.equals(operation.operationId))).write(
      PendingOperationsCompanion(
        status: const d.Value('failed'),
        lastError: d.Value(error),
        retryCount: d.Value(
          permanent ? operation.retryCount : operation.retryCount + 1,
        ),
        nextAttemptAt: d.Value(nextAttemptAt),
        updatedAt: d.Value(DateTime.now().toUtc()),
      ),
    );

    await _writerStatus(
      operation.entity,
      operation.entityId,
      SyncStatus.failed,
    );
  }

  Future<void> retryFailed(String accountId) async {
    await (_database.update(_database.pendingOperations)..where(
          (t) =>
              t.accountId.equals(accountId) &
              t.status.isIn(['failed', 'conflict']),
        ))
        .write(
          const PendingOperationsCompanion(
            status: d.Value('pending'),
            nextAttemptAt: d.Value(null),
            lastError: d.Value(null),
          ),
        );
  }

  Future<void> resolveConflict(
    SyncConflict conflict, {
    required String resolution,
    required String accountId,
  }) async {
    await _database.transaction(() async {
      if (resolution == 'local') {
        await _requeueLocal(conflict);
      } else {
        await _applyCloudConflict(conflict);
        await (_database.delete(_database.pendingOperations)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entity.equals(conflict.entity.code) &
                  t.entityId.equals(conflict.entityId),
            ))
            .go();
        await _writerStatus(
          conflict.entity,
          conflict.entityId,
          SyncStatus.synced,
        );
      }

      await (_database.update(
        _database.syncConflicts,
      )..where((t) => t.id.equals(conflict.id))).write(
        SyncConflictsCompanion(
          resolution: d.Value(resolution),
          resolvedAt: d.Value(DateTime.now().toUtc()),
        ),
      );
    });
  }

  /// Applies one authorized pull page and advances the cursor in the same
  /// transaction (FR-SYNC-006). A failure rolls back both.
  Future<void> applyPullPage({
    required String accountId,
    required List<CloudChange> changes,
    required String? nextCursor,
  }) async {
    await _database.transaction(() async {
      for (final change in changes) {
        await _applyChange(accountId, change);
      }

      await _writeMetadata(
        accountId: accountId,
        cursor: nextCursor,
        lastPullAt: DateTime.now().toUtc(),
      );
    });
  }

  Future<void> recordSyncError(String accountId, String? error) async {
    await _writeMetadata(
      accountId: accountId,
      lastPushAt: DateTime.now().toUtc(),
      lastError: error,
    );
  }

  Future<void> recordPushSuccess(String accountId) async {
    await _writeMetadata(
      accountId: accountId,
      lastPushAt: DateTime.now().toUtc(),
      lastError: null,
    );
  }

  Future<void> _writeMetadata({
    required String accountId,
    String? cursor,
    DateTime? lastPullAt,
    DateTime? lastPushAt,
    String? lastError,
  }) async {
    final existing = await (_database.select(
      _database.syncMetadata,
    )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();

    await _database
        .into(_database.syncMetadata)
        .insertOnConflictUpdate(
          SyncMetadataCompanion.insert(
            accountId: accountId,
            cursor: d.Value(cursor ?? existing?.cursor),
            lastPullAt: d.Value(lastPullAt ?? existing?.lastPullAt),
            lastPushAt: d.Value(lastPushAt ?? existing?.lastPushAt),
            lastError: d.Value(lastError),
          ),
        );
  }

  Future<void> _applyChange(String accountId, CloudChange change) async {
    final payload = change.payload;

    if (change.revoked || change.changeType == 'revoke') {
      if (change.entity == 'assignment') {
        await (_database.delete(_database.cachedAssignments)..where(
              (t) =>
                  t.id.equals(change.entityId) & t.accountId.equals(accountId),
            ))
            .go();
      } else if (change.entity == 'classroom') {
        await (_database.delete(_database.cachedClassrooms)..where(
              (t) =>
                  t.id.equals(change.entityId) & t.accountId.equals(accountId),
            ))
            .go();
        await (_database.delete(_database.cachedClassroomMembers)..where(
              (t) =>
                  t.classroomId.equals(change.entityId) &
                  t.accountId.equals(accountId),
            ))
            .go();
      }
      return;
    }

    if (payload == null) return;

    switch (change.entity) {
      case 'subject':
        if (payload['user_id'] != null && payload['user_id'] != accountId) {
          return;
        }
        await _database
            .into(_database.localSubjects)
            .insertOnConflictUpdate(
              LocalSubjectsCompanion(
                id: d.Value(change.entityId),
                accountId: d.Value(accountId),
                name: d.Value(payload['name'] as String? ?? ''),
                code: d.Value(payload['code'] as String? ?? ''),
                colorValue: d.Value(
                  (payload['color'] as num?)?.toInt() ?? 0xFF6236F5,
                ),
                teacherName: d.Value(payload['teacher_name'] as String?),
                room: d.Value(payload['room'] as String?),
                revision: d.Value(change.revision),
                syncStatus: const d.Value('synced'),
                updatedAt: d.Value(DateTime.now().toUtc()),
              ),
            );
      case 'task':
        await _database
            .into(_database.localTasks)
            .insertOnConflictUpdate(
              LocalTasksCompanion(
                id: d.Value(change.entityId),
                accountId: d.Value(accountId),
                title: d.Value(payload['title'] as String? ?? ''),
                description: d.Value(payload['description'] as String?),
                subjectId: d.Value(payload['subject_id'] as String?),
                dueDate: d.Value(payload['due_date'] as String?),
                dueTime: d.Value(payload['due_time'] as String?),
                hasExplicitTime: d.Value(
                  payload['has_explicit_time'] as bool? ?? false,
                ),
                priority: d.Value(payload['priority'] as String? ?? 'medium'),
                status: d.Value(payload['status'] as String? ?? 'pending'),
                revision: d.Value(change.revision),
                syncStatus: const d.Value('synced'),
                deletedAt: d.Value(
                  DateTime.tryParse(payload['deleted_at'] as String? ?? ''),
                ),
                updatedAt: d.Value(DateTime.now().toUtc()),
              ),
            );
      case 'timetable_entry':
        await _database
            .into(_database.localTimetableEntries)
            .insertOnConflictUpdate(
              LocalTimetableEntriesCompanion(
                id: d.Value(change.entityId),
                accountId: d.Value(accountId),
                subjectId: d.Value(payload['subject_id'] as String? ?? ''),
                weekday: d.Value((payload['weekday'] as num?)?.toInt() ?? 1),
                startMinutes: d.Value(
                  (payload['start_minutes'] as num?)?.toInt() ?? 0,
                ),
                endMinutes: d.Value(
                  (payload['end_minutes'] as num?)?.toInt() ?? 0,
                ),
                room: d.Value(payload['room'] as String?),
                revision: d.Value(change.revision),
                syncStatus: const d.Value('synced'),
                updatedAt: d.Value(DateTime.now().toUtc()),
              ),
            );
      case 'academic_event':
        await _database
            .into(_database.localAcademicEvents)
            .insertOnConflictUpdate(
              LocalAcademicEventsCompanion(
                id: d.Value(change.entityId),
                accountId: d.Value(accountId),
                title: d.Value(payload['title'] as String? ?? ''),
                type: d.Value(payload['type'] as String? ?? 'other'),
                eventDate: d.Value(payload['event_date'] as String? ?? ''),
                startTime: d.Value(payload['start_time'] as String?),
                endTime: d.Value(payload['end_time'] as String?),
                description: d.Value(payload['description'] as String?),
                location: d.Value(payload['location'] as String?),
                revision: d.Value(change.revision),
                syncStatus: const d.Value('synced'),
                updatedAt: d.Value(DateTime.now().toUtc()),
              ),
            );
      case 'classroom':
        await _database
            .into(_database.cachedClassrooms)
            .insertOnConflictUpdate(
              CachedClassroomsCompanion.insert(
                id: change.entityId,
                accountId: accountId,
                teacherId: payload['teacher_id'] as String? ?? '',
                teacherName: d.Value(payload['teacher_name'] as String?),
                name: payload['name'] as String? ?? '',
                subjectName: payload['subject_name'] as String? ?? '',
                description: d.Value(payload['description'] as String?),
                joinCode: d.Value(payload['join_code'] as String?),
                timezone: payload['timezone'] as String? ?? 'Asia/Yangon',
                archived: d.Value(payload['archived'] as bool? ?? false),
                cachedAt: DateTime.now().toUtc(),
              ),
            );
      case 'assignment':
        await _database
            .into(_database.cachedAssignments)
            .insertOnConflictUpdate(
              CachedAssignmentsCompanion.insert(
                id: change.entityId,
                accountId: accountId,
                classroomId: payload['classroom_id'] as String? ?? '',
                classroomName: d.Value(payload['classroom_name'] as String?),
                title: payload['title'] as String? ?? '',
                description: d.Value(payload['description'] as String?),
                dueDate: payload['due_date'] as String? ?? '',
                dueTime: d.Value(payload['due_time'] as String?),
                hasExplicitTime: d.Value(
                  payload['has_explicit_time'] as bool? ?? false,
                ),
                status: payload['status'] as String? ?? 'draft',
                publishedAt: d.Value(
                  DateTime.tryParse(payload['published_at'] as String? ?? ''),
                ),
                deletedAt: d.Value(
                  DateTime.tryParse(payload['deleted_at'] as String? ?? ''),
                ),
                revision: d.Value(change.revision),
                cachedAt: DateTime.now().toUtc(),
              ),
            );
      case 'assignment_progress':
        await _database
            .into(_database.localAssignmentProgress)
            .insertOnConflictUpdate(
              LocalAssignmentProgressCompanion.insert(
                id: change.entityId,
                accountId: accountId,
                assignmentId: payload['assignment_id'] as String? ?? '',
                isCompleted: d.Value(payload['is_completed'] as bool? ?? false),
                completedAt: d.Value(
                  DateTime.tryParse(payload['completed_at'] as String? ?? ''),
                ),
                revision: d.Value(change.revision),
                syncStatus: const d.Value('synced'),
                updatedAt: DateTime.now().toUtc(),
              ),
            );
    }
  }

  Future<void> _requeueLocal(SyncConflict conflict) async {
    final revision = (conflict.cloudPayload['revision'] as num?)?.toInt() ?? 0;
    await _database
        .into(_database.pendingOperations)
        .insert(
          PendingOperationsCompanion.insert(
            operationId: IdService.newId(),
            accountId: conflict.accountId,
            entity: conflict.entity.code,
            entityId: conflict.entityId,
            type: 'update',
            payloadJson: jsonEncode(conflict.localPayload),
            fingerprint: HashService.fingerprint(conflict.localPayload),
            baseRevision: d.Value(revision),
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    await _writerStatus(conflict.entity, conflict.entityId, SyncStatus.pending);
  }

  Future<void> _applyCloudConflict(SyncConflict conflict) async {
    final payload = conflict.cloudPayload;
    final change = CloudChange(
      changeId: 'conflict-${conflict.id}',
      entity: conflict.entity.code,
      entityId: conflict.entityId,
      changeType: 'update',
      revision: (payload['revision'] as num?)?.toInt() ?? 0,
      payload: payload,
    );
    await _applyChange(conflict.accountId, change);
  }

  Future<void> _applyServerRevision({
    required PendingOperation operation,
    required int revision,
    required bool synced,
  }) async {
    final companion = synced
        ? const d.Value('synced')
        : const d.Value('pending');
    switch (operation.entity) {
      case SyncEntity.subject:
        await (_database.update(
          _database.localSubjects,
        )..where((t) => t.id.equals(operation.entityId))).write(
          LocalSubjectsCompanion(
            revision: d.Value(revision),
            syncStatus: companion,
          ),
        );
      case SyncEntity.task:
        await (_database.update(
          _database.localTasks,
        )..where((t) => t.id.equals(operation.entityId))).write(
          LocalTasksCompanion(
            revision: d.Value(revision),
            syncStatus: companion,
          ),
        );
      case SyncEntity.timetableEntry:
        await (_database.update(
          _database.localTimetableEntries,
        )..where((t) => t.id.equals(operation.entityId))).write(
          LocalTimetableEntriesCompanion(
            revision: d.Value(revision),
            syncStatus: companion,
          ),
        );
      case SyncEntity.academicEvent:
        await (_database.update(
          _database.localAcademicEvents,
        )..where((t) => t.id.equals(operation.entityId))).write(
          LocalAcademicEventsCompanion(
            revision: d.Value(revision),
            syncStatus: companion,
          ),
        );
      case SyncEntity.assignmentProgress:
        await (_database.update(
          _database.localAssignmentProgress,
        )..where((t) => t.id.equals(operation.entityId))).write(
          LocalAssignmentProgressCompanion(
            revision: d.Value(revision),
            syncStatus: companion,
          ),
        );
      case SyncEntity.profile:
        break;
    }
  }

  Future<void> _writerStatus(
    SyncEntity entity,
    String entityId,
    SyncStatus status,
  ) async {
    final value = d.Value(status.code);
    switch (entity) {
      case SyncEntity.subject:
        await (_database.update(_database.localSubjects)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalSubjectsCompanion(syncStatus: value));
      case SyncEntity.task:
        await (_database.update(_database.localTasks)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalTasksCompanion(syncStatus: value));
      case SyncEntity.timetableEntry:
        await (_database.update(_database.localTimetableEntries)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalTimetableEntriesCompanion(syncStatus: value));
      case SyncEntity.academicEvent:
        await (_database.update(_database.localAcademicEvents)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalAcademicEventsCompanion(syncStatus: value));
      case SyncEntity.assignmentProgress:
        await (_database.update(_database.localAssignmentProgress)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalAssignmentProgressCompanion(syncStatus: value));
      case SyncEntity.profile:
        break;
    }
  }

  PendingOperation _mapOperation(PendingOperationRow row) {
    return PendingOperation(
      operationId: row.operationId,
      accountId: row.accountId,
      entity: SyncEntity.fromCode(row.entity) ?? SyncEntity.task,
      entityId: row.entityId,
      type: SyncOperationType.fromCode(row.type),
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      fingerprint: row.fingerprint,
      baseRevision: row.baseRevision,
      retryCount: row.retryCount,
      status: SyncStatus.fromCode(row.status),
      lastError: row.lastError,
      dependsOn: row.dependsOn,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      nextAttemptAt: row.nextAttemptAt,
    );
  }
}
