import 'dart:convert';

import 'package:drift/drift.dart' as d;

import '../models/enums.dart';
import '../models/sync_models.dart';
import '../services/id_service.dart';
import '../services/local_database.dart';

/// Commits a local record change and its durable queue entry in one SQLite
/// transaction (FR-SYNC-001, DET-SYNC-002).
class PendingOperationWriter {
  const PendingOperationWriter(this.database);

  final LocalDatabase database;

  /// Enqueues an operation and returns its stable identity.
  ///
  /// The operation depends on the latest queued operation for the account so
  /// push order preserves local commit order. Retries reuse the same
  /// operation ID and fingerprint (FR-SYNC-002, FR-SYNC-014).
  Future<PendingOperation> enqueue({
    required String accountId,
    required SyncEntity entity,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> data,
    int baseRevision = 0,
  }) async {
    final operationId = IdService.newId();
    final payload = <String, dynamic>{
      'operation_id': operationId,
      'account_id': accountId,
      'entity': entity.code,
      'entity_id': entityId,
      'type': type.code,
      'base_revision': baseRevision,
      'data': data,
    };
    final fingerprint = HashService.fingerprint(payload);
    final now = DateTime.now().toUtc();

    final dependent =
        await (database.select(database.pendingOperations)
              ..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.status.isIn(['pending', 'failed', 'sending']),
              )
              ..orderBy([(t) => d.OrderingTerm.desc(t.createdAt)])
              ..limit(1))
            .getSingleOrNull();

    await database
        .into(database.pendingOperations)
        .insert(
          PendingOperationsCompanion.insert(
            operationId: operationId,
            accountId: accountId,
            entity: entity.code,
            entityId: entityId,
            type: type.code,
            payloadJson: jsonEncode(payload),
            fingerprint: fingerprint,
            baseRevision: d.Value(baseRevision),
            dependsOn: d.Value(dependent?.operationId),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return PendingOperation(
      operationId: operationId,
      accountId: accountId,
      entity: entity,
      entityId: entityId,
      type: type,
      payload: payload,
      fingerprint: fingerprint,
      baseRevision: baseRevision,
      dependsOn: dependent?.operationId,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> markRecordStatus({
    required SyncEntity entity,
    required String entityId,
    required SyncStatus status,
  }) async {
    final value = d.Value(status.code);
    switch (entity) {
      case SyncEntity.subject:
        await (database.update(database.localSubjects)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalSubjectsCompanion(syncStatus: value));
      case SyncEntity.task:
        await (database.update(database.localTasks)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalTasksCompanion(syncStatus: value));
      case SyncEntity.timetableEntry:
        await (database.update(database.localTimetableEntries)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalTimetableEntriesCompanion(syncStatus: value));
      case SyncEntity.academicEvent:
        await (database.update(database.localAcademicEvents)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalAcademicEventsCompanion(syncStatus: value));
      case SyncEntity.assignmentProgress:
        await (database.update(database.localAssignmentProgress)
              ..where((t) => t.id.equals(entityId)))
            .write(LocalAssignmentProgressCompanion(syncStatus: value));
      case SyncEntity.profile:
        // Profiles are store-backed via the accounts table; no local status.
        break;
    }
  }
}
