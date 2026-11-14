import 'dart:convert';

import 'package:drift/drift.dart' as d;

import '../models/assignment.dart';
import '../models/enums.dart';
import '../services/cloud_gateway.dart';
import '../services/id_service.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';

class AssignmentRepository {
  AssignmentRepository(this._database, this._writer, this._gateway);

  final LocalDatabase _database;
  final PendingOperationWriter _writer;
  final CloudGateway _gateway;

  Future<List<Assignment>> cached(
    String accountId, {
    String? classroomId,
    bool publishedOnly = false,
  }) async {
    final query = _database.select(_database.cachedAssignments)
      ..where((t) => t.accountId.equals(accountId) & t.deletedAt.isNull())
      ..orderBy([(t) => d.OrderingTerm.asc(t.dueDate)]);

    if (classroomId != null) {
      query.where((t) => t.classroomId.equals(classroomId));
    }
    if (publishedOnly) {
      query.where((t) => t.status.equals('published'));
    }

    final rows = await query.get();
    return rows.map(_map).toList();
  }

  Future<Map<String, AssignmentProgress>> progressFor(String accountId) async {
    final rows = await (_database.select(
      _database.localAssignmentProgress,
    )..where((t) => t.accountId.equals(accountId))).get();
    return {
      for (final row in rows)
        row.assignmentId: AssignmentProgress(
          id: row.id,
          accountId: row.accountId,
          assignmentId: row.assignmentId,
          isCompleted: row.isCompleted,
          completedAt: row.completedAt,
          revision: row.revision,
          syncStatus: SyncStatus.fromCode(row.syncStatus),
          updatedAt: row.updatedAt,
        ),
    };
  }

  /// Student-visible published assignments, refreshed from the cloud. The
  /// cache is replaced only after a successful authorized response.
  Future<List<Assignment>> refreshMyAssignments(String accountId) async {
    final payload = await _gateway.fetchMyAssignments();
    await _database.transaction(() async {
      await (_database.delete(
        _database.cachedAssignments,
      )..where((t) => t.accountId.equals(accountId))).go();
      for (final item in payload) {
        await upsertFromPayload(accountId, item);
      }
    });
    return cached(accountId, publishedOnly: true);
  }

  Future<void> upsertFromPayload(
    String accountId,
    Map<String, dynamic> payload,
  ) async {
    final assignment = _fromPayload(accountId, payload);
    await _database
        .into(_database.cachedAssignments)
        .insertOnConflictUpdate(
          CachedAssignmentsCompanion.insert(
            id: assignment.id,
            accountId: accountId,
            classroomId: assignment.classroomId,
            classroomName: d.Value(assignment.classroomName),
            title: assignment.title,
            description: d.Value(assignment.description),
            dueDate: assignment.dueDate,
            dueTime: d.Value(assignment.dueTime),
            hasExplicitTime: d.Value(assignment.hasExplicitTime),
            status: assignment.status.code,
            publishedAt: d.Value(assignment.publishedAt),
            deletedAt: d.Value(assignment.deletedAt),
            revision: d.Value(assignment.revision),
            cachedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> replaceForClassroom(
    String accountId,
    String classroomId,
    List<Map<String, dynamic>> payload,
  ) async {
    await _database.transaction(() async {
      await (_database.delete(_database.cachedAssignments)..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.classroomId.equals(classroomId),
          ))
          .go();
      for (final item in payload) {
        await upsertFromPayload(accountId, item);
      }
    });
  }

  Future<Assignment> createAssignment({
    required String accountId,
    required String classroomId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    required bool publish,
  }) async {
    _validate(title: title, dueDate: dueDate, dueTime: dueTime);
    final payload = await _gateway.createAssignment(
      classroomId: classroomId,
      title: title.trim(),
      dueDate: dueDate,
      description: description,
      dueTime: dueTime,
      publish: publish,
    );
    await upsertFromPayload(accountId, payload);
    return _fromPayload(accountId, payload);
  }

  Future<Assignment> updateAssignment({
    required String accountId,
    required String assignmentId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    String? status,
  }) async {
    _validate(title: title, dueDate: dueDate, dueTime: dueTime);
    final payload = await _gateway.updateAssignment(
      assignmentId: assignmentId,
      title: title.trim(),
      dueDate: dueDate,
      description: description,
      dueTime: dueTime,
      status: status,
    );
    await upsertFromPayload(accountId, payload);
    return _fromPayload(accountId, payload);
  }

  Future<void> deleteAssignment(String accountId, String assignmentId) async {
    await _gateway.deleteAssignment(assignmentId);
    await (_database.delete(_database.cachedAssignments)..where(
          (t) => t.id.equals(assignmentId) & t.accountId.equals(accountId),
        ))
        .go();
  }

  /// Student completion is saved locally first and queued; the server
  /// validates membership, publication and deletion state at push time
  /// (FR-ASG-004, FR-SYNC-012).
  Future<AssignmentProgress> setProgress({
    required String accountId,
    required Assignment assignment,
    required bool completed,
  }) async {
    final existing =
        await (_database.select(_database.localAssignmentProgress)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.assignmentId.equals(assignment.id),
            ))
            .getSingleOrNull();

    final now = DateTime.now().toUtc();
    final progressId = existing?.id ?? IdService.newId();
    final revision = existing?.revision ?? 0;
    final completedAt = completed ? now : null;

    await _database.transaction(() async {
      await _database
          .into(_database.localAssignmentProgress)
          .insertOnConflictUpdate(
            LocalAssignmentProgressCompanion.insert(
              id: progressId,
              accountId: accountId,
              assignmentId: assignment.id,
              isCompleted: d.Value(completed),
              completedAt: d.Value(completedAt),
              revision: d.Value(revision),
              syncStatus: const d.Value('pending'),
              updatedAt: now,
            ),
          );

      await _writer.enqueue(
        accountId: accountId,
        entity: SyncEntity.assignmentProgress,
        entityId: progressId,
        type: SyncOperationType.update,
        baseRevision: revision,
        data: {
          'id': progressId,
          'account_id': accountId,
          'assignment_id': assignment.id,
          'is_completed': completed,
          'completed_at': completedAt?.toIso8601String(),
          'revision': revision,
        },
      );
    });

    return AssignmentProgress(
      id: progressId,
      accountId: accountId,
      assignmentId: assignment.id,
      isCompleted: completed,
      completedAt: completedAt,
      revision: revision,
      syncStatus: SyncStatus.pending,
      updatedAt: now,
    );
  }

  void _validate({
    required String title,
    required String dueDate,
    String? dueTime,
  }) {
    if (title.trim().isEmpty) {
      throw const AssignmentValidationException(
        'Assignment title is required.',
      );
    }
    if (dueDate.isEmpty) {
      throw const AssignmentValidationException(
        'Assignment due date is required.',
      );
    }
    if (dueTime != null && dueTime.isNotEmpty) {
      final parts = dueTime.split(':');
      if (parts.length < 2) {
        throw const AssignmentValidationException('Invalid due time.');
      }
    }
  }

  Assignment _fromPayload(String accountId, Map<String, dynamic> payload) {
    return Assignment(
      id: payload['id'] as String? ?? IdService.newId(),
      classroomId: payload['classroom_id'] as String? ?? '',
      title: payload['title'] as String? ?? '',
      description: payload['description'] as String?,
      dueDate: payload['due_date'] as String? ?? '',
      dueTime: payload['due_time'] as String?,
      hasExplicitTime: payload['has_explicit_time'] as bool? ?? false,
      status: AssignmentStatus.fromCode(payload['status'] as String?),
      classroomName: payload['classroom_name'] as String?,
      publishedAt: DateTime.tryParse(payload['published_at'] as String? ?? ''),
      deletedAt: DateTime.tryParse(payload['deleted_at'] as String? ?? ''),
      revision: (payload['revision'] as num?)?.toInt() ?? 0,
      cachedAt: DateTime.now().toUtc(),
    );
  }

  Assignment _map(CachedAssignmentRow row) {
    return Assignment(
      id: row.id,
      classroomId: row.classroomId,
      title: row.title,
      description: row.description,
      dueDate: row.dueDate,
      dueTime: row.dueTime,
      hasExplicitTime: row.hasExplicitTime,
      status: AssignmentStatus.fromCode(row.status),
      classroomName: row.classroomName,
      publishedAt: row.publishedAt,
      deletedAt: row.deletedAt,
      revision: row.revision,
      cachedAt: row.cachedAt,
    );
  }
}

class AssignmentValidationException implements Exception {
  const AssignmentValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Debug helper used by the sync diagnostics screen.
String describeProgress(AssignmentProgress progress) {
  return jsonEncode({
    'assignment_id': progress.assignmentId,
    'completed': progress.isCompleted,
    'sync_status': progress.syncStatus.code,
  });
}
