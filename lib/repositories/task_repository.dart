import 'package:drift/drift.dart' as d;

import '../models/enums.dart';
import '../models/task.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';

class TaskRepository {
  TaskRepository(this._database, this._writer);

  final LocalDatabase _database;
  final PendingOperationWriter _writer;

  Future<List<Task>> getAll(String accountId) async {
    final rows =
        await (_database.select(_database.localTasks)
              ..where(
                (t) => t.accountId.equals(accountId) & t.deletedAt.isNull(),
              )
              ..orderBy([
                (t) => d.OrderingTerm.asc(t.completedAt),
                (t) => d.OrderingTerm.asc(t.dueDate),
                (t) => d.OrderingTerm.asc(t.priority),
              ]))
            .get();
    return rows.map(_map).toList();
  }

  Future<Task?> getById(String accountId, String id) async {
    final row =
        await (_database.select(_database.localTasks)..where(
              (t) =>
                  t.id.equals(id) &
                  t.accountId.equals(accountId) &
                  t.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<Task> create(Task task) async {
    _validate(task);
    final now = DateTime.now().toUtc();
    final normalized = _normalize(task).copyWith(updatedAt: now);

    await _database.transaction(() async {
      await _database
          .into(_database.localTasks)
          .insert(
            LocalTasksCompanion.insert(
              id: normalized.id,
              accountId: normalized.accountId,
              title: normalized.title.trim(),
              description: d.Value(_emptyToNull(normalized.description)),
              subjectId: d.Value(normalized.subjectId),
              dueDate: d.Value(normalized.dueDate),
              dueTime: d.Value(normalized.dueTime),
              hasExplicitTime: d.Value(normalized.hasExplicitTime),
              priority: d.Value(normalized.priority.code),
              status: d.Value(normalized.status.code),
              reminderOffsetMinutes: d.Value(normalized.reminderOffsetMinutes),
              updatedAt: now,
            ),
          );

      await _writer.enqueue(
        accountId: normalized.accountId,
        entity: SyncEntity.task,
        entityId: normalized.id,
        type: SyncOperationType.create,
        data: {...normalized.toJson(), 'account_id': normalized.accountId},
      );
    });

    return normalized;
  }

  Future<Task> update(Task task, {Task? previous}) async {
    _validate(task);
    final now = DateTime.now().toUtc();
    final normalized = _normalize(task).copyWith(updatedAt: now);

    await _database.transaction(() async {
      await (_database.update(_database.localTasks)..where(
            (t) =>
                t.id.equals(normalized.id) &
                t.accountId.equals(normalized.accountId),
          ))
          .write(
            LocalTasksCompanion(
              title: d.Value(normalized.title.trim()),
              description: d.Value(_emptyToNull(normalized.description)),
              subjectId: d.Value(normalized.subjectId),
              dueDate: d.Value(normalized.dueDate),
              dueTime: d.Value(normalized.dueTime),
              hasExplicitTime: d.Value(normalized.hasExplicitTime),
              priority: d.Value(normalized.priority.code),
              status: d.Value(normalized.status.code),
              completedAt: d.Value(normalized.completedAt),
              reminderOffsetMinutes: d.Value(normalized.reminderOffsetMinutes),
              syncStatus: const d.Value('pending'),
              updatedAt: d.Value(now),
            ),
          );

      await _writer.enqueue(
        accountId: normalized.accountId,
        entity: SyncEntity.task,
        entityId: normalized.id,
        type: SyncOperationType.update,
        baseRevision: normalized.revision,
        data: {...normalized.toJson(), 'account_id': normalized.accountId},
      );
    });

    return normalized.copyWith(syncStatus: SyncStatus.pending);
  }

  /// Reversible completion; records completion time (DET-TASK-002).
  Future<Task> setCompletion(Task task, {required bool completed}) async {
    final now = DateTime.now().toUtc();
    final updated = task.copyWith(
      status: completed ? TaskStatus.completed : TaskStatus.pending,
      completedAt: completed ? now : null,
      clearCompletedAt: !completed,
      updatedAt: now,
    );

    return update(updated, previous: task);
  }

  Future<void> delete(Task task) async {
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(_database.localTasks)..where(
            (t) => t.id.equals(task.id) & t.accountId.equals(task.accountId),
          ))
          .write(
            LocalTasksCompanion(
              deletedAt: d.Value(now),
              syncStatus: const d.Value('pending'),
              updatedAt: d.Value(now),
            ),
          );

      await _writer.enqueue(
        accountId: task.accountId,
        entity: SyncEntity.task,
        entityId: task.id,
        type: SyncOperationType.delete,
        baseRevision: task.revision,
        data: {
          'id': task.id,
          'account_id': task.accountId,
          'deleted_at': now.toIso8601String(),
        },
      );
    });
  }

  void _validate(Task task) {
    if (task.title.trim().isEmpty) {
      throw const TaskValidationException('Task title is required.');
    }
    if (task.reminderOffsetMinutes != null &&
        (task.dueDate == null || task.dueDate!.isEmpty)) {
      throw const TaskValidationException('A reminder requires a deadline.');
    }
  }

  Task _normalize(Task task) {
    final hasDate = task.dueDate != null && task.dueDate!.isNotEmpty;
    final hasTime =
        hasDate &&
        task.hasExplicitTime &&
        task.dueTime != null &&
        task.dueTime!.isNotEmpty;

    return task.copyWith(
      dueDate: hasDate ? task.dueDate : null,
      clearDueDate: !hasDate,
      dueTime: hasTime ? task.dueTime : null,
      clearDueTime: !hasTime,
      hasExplicitTime: hasTime,
      reminderOffsetMinutes: hasDate ? task.reminderOffsetMinutes : null,
      clearReminder: !hasDate,
    );
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Task _map(TaskRow row) {
    return Task(
      id: row.id,
      accountId: row.accountId,
      title: row.title,
      description: row.description,
      subjectId: row.subjectId,
      dueDate: row.dueDate,
      dueTime: row.dueTime,
      hasExplicitTime: row.hasExplicitTime,
      priority: TaskPriority.fromCode(row.priority),
      status: TaskStatus.fromCode(row.status),
      completedAt: row.completedAt,
      reminderOffsetMinutes: row.reminderOffsetMinutes,
      revision: row.revision,
      syncStatus: SyncStatus.fromCode(row.syncStatus),
      deletedAt: row.deletedAt,
      updatedAt: row.updatedAt,
    );
  }
}

class TaskValidationException implements Exception {
  const TaskValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
