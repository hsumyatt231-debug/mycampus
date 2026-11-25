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

  /// Builds the stable operation identity without persisting it.
  ///
  /// Online writes push this same object immediately; offline writes hand it
  /// to [enqueueBuilt]. Both paths therefore share one operation ID and
  /// fingerprint (FR-SYNC-002, FR-SYNC-014).
  PendingOperation build({
    required String accountId,
    required SyncEntity entity,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> data,
    int baseRevision = 0,
  }) {
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
    final now = DateTime.now().toUtc();
    return PendingOperation(
      operationId: operationId,
      accountId: accountId,
      entity: entity,
      entityId: entityId,
      type: type,
      payload: payload,
      fingerprint: HashService.fingerprint(payload),
      baseRevision: baseRevision,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Enqueues a pre-built operation and returns it.
  ///
  /// The operation depends on the latest queued operation for the account so
  /// push order preserves local commit order.
  Future<PendingOperation> enqueueBuilt(PendingOperation operation) async {
    final dependent =
        await (database.select(database.pendingOperations)
              ..where(
                (t) =>
                    t.accountId.equals(operation.accountId) &
                    t.status.isIn(['pending', 'failed', 'sending']),
              )
              ..orderBy([(t) => d.OrderingTerm.desc(t.createdAt)])
              ..limit(1))
            .getSingleOrNull();

    final queued = PendingOperation(
      operationId: operation.operationId,
      accountId: operation.accountId,
      entity: operation.entity,
      entityId: operation.entityId,
      type: operation.type,
      payload: operation.payload,
      fingerprint: operation.fingerprint,
      baseRevision: operation.baseRevision,
      dependsOn: dependent?.operationId,
      createdAt: operation.createdAt,
      updatedAt: operation.updatedAt,
    );

    await database
        .into(database.pendingOperations)
        .insert(
          PendingOperationsCompanion.insert(
            operationId: queued.operationId,
            accountId: queued.accountId,
            entity: queued.entity.code,
            entityId: queued.entityId,
            type: queued.type.code,
            payloadJson: jsonEncode(queued.payload),
            fingerprint: queued.fingerprint,
            baseRevision: d.Value(queued.baseRevision),
            dependsOn: d.Value(queued.dependsOn),
            createdAt: queued.createdAt ?? DateTime.now().toUtc(),
            updatedAt: queued.updatedAt ?? DateTime.now().toUtc(),
          ),
        );

    return queued;
  }

  /// Backwards-compatible helper used by callers that do not need to push the
  /// operation immediately.
  Future<PendingOperation> enqueue({
    required String accountId,
    required SyncEntity entity,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> data,
    int baseRevision = 0,
  }) {
    return enqueueBuilt(
      build(
        accountId: accountId,
        entity: entity,
        entityId: entityId,
        type: type,
        data: data,
        baseRevision: baseRevision,
      ),
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
