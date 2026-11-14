import 'package:drift/drift.dart' as d;

import '../models/enums.dart';
import '../models/subject.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';
import 'timetable_repository.dart';

class SubjectImpact {
  const SubjectImpact({
    required this.tasksToDetach,
    required this.timetableEntriesToRemove,
  });

  final int tasksToDetach;
  final int timetableEntriesToRemove;

  bool get hasImpact => tasksToDetach > 0 || timetableEntriesToRemove > 0;
}

class SubjectRepository {
  SubjectRepository(this._database, this._writer, this._timetable);

  final LocalDatabase _database;
  final PendingOperationWriter _writer;
  final TimetableRepository _timetable;

  Future<List<Subject>> getAll(String accountId) async {
    final rows =
        await (_database.select(_database.localSubjects)
              ..where(
                (t) => t.accountId.equals(accountId) & t.deletedAt.isNull(),
              )
              ..orderBy([(t) => d.OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_map).toList();
  }

  Future<Subject?> getById(String accountId, String id) async {
    final row =
        await (_database.select(_database.localSubjects)..where(
              (t) =>
                  t.id.equals(id) &
                  t.accountId.equals(accountId) &
                  t.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<Subject> create(Subject subject) async {
    await _validate(subject, checkId: null);
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await _database
          .into(_database.localSubjects)
          .insert(
            LocalSubjectsCompanion.insert(
              id: subject.id,
              accountId: subject.accountId,
              name: subject.name.trim(),
              code: subject.code.trim(),
              colorValue: d.Value(subject.colorValue),
              teacherName: d.Value(subject.teacherName),
              room: d.Value(subject.room),
              updatedAt: now,
            ),
          );

      await _writer.enqueue(
        accountId: subject.accountId,
        entity: SyncEntity.subject,
        entityId: subject.id,
        type: SyncOperationType.create,
        data: {...subject.toJson(), 'account_id': subject.accountId},
      );
    });

    return subject.copyWith(updatedAt: now);
  }

  Future<Subject> update(Subject subject) async {
    await _validate(subject, checkId: subject.id);
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(_database.localSubjects)..where(
            (t) =>
                t.id.equals(subject.id) & t.accountId.equals(subject.accountId),
          ))
          .write(
            LocalSubjectsCompanion(
              name: d.Value(subject.name.trim()),
              code: d.Value(subject.code.trim()),
              colorValue: d.Value(subject.colorValue),
              teacherName: d.Value(subject.teacherName),
              room: d.Value(subject.room),
              syncStatus: const d.Value('pending'),
              updatedAt: d.Value(now),
            ),
          );

      await _writer.enqueue(
        accountId: subject.accountId,
        entity: SyncEntity.subject,
        entityId: subject.id,
        type: SyncOperationType.update,
        baseRevision: subject.revision,
        data: {...subject.toJson(), 'account_id': subject.accountId},
      );
    });

    return subject.copyWith(syncStatus: SyncStatus.pending, updatedAt: now);
  }

  /// Returns impact counts shown in the delete confirmation (FR-SUB-004).
  Future<SubjectImpact> impact(String accountId, String subjectId) async {
    final taskCount =
        await (_database.selectOnly(_database.localTasks)
              ..addColumns([_database.localTasks.id.count()])
              ..where(
                _database.localTasks.accountId.equals(accountId) &
                    _database.localTasks.subjectId.equals(subjectId) &
                    _database.localTasks.deletedAt.isNull(),
              ))
            .map((row) => row.read(_database.localTasks.id.count()) ?? 0)
            .getSingle();

    final timetableCount =
        await (_database.selectOnly(_database.localTimetableEntries)
              ..addColumns([_database.localTimetableEntries.id.count()])
              ..where(
                _database.localTimetableEntries.accountId.equals(accountId) &
                    _database.localTimetableEntries.subjectId.equals(
                      subjectId,
                    ) &
                    _database.localTimetableEntries.deletedAt.isNull(),
              ))
            .map(
              (row) =>
                  row.read(_database.localTimetableEntries.id.count()) ?? 0,
            )
            .getSingle();

    return SubjectImpact(
      tasksToDetach: taskCount,
      timetableEntriesToRemove: timetableCount,
    );
  }

  /// Deletes the subject, detaches related tasks into General Tasks and
  /// removes related timetable entries, all in one local transaction.
  Future<void> delete(String accountId, String subjectId) async {
    final subject = await getById(accountId, subjectId);
    if (subject == null) return;

    final now = DateTime.now().toUtc();
    final tasks =
        await (_database.select(_database.localTasks)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.subjectId.equals(subjectId) &
                  t.deletedAt.isNull(),
            ))
            .get();

    await _database.transaction(() async {
      for (final task in tasks) {
        await (_database.update(
          _database.localTasks,
        )..where((t) => t.id.equals(task.id))).write(
          LocalTasksCompanion(
            subjectId: const d.Value(null),
            syncStatus: const d.Value('pending'),
            updatedAt: d.Value(now),
          ),
        );

        await _writer.enqueue(
          accountId: accountId,
          entity: SyncEntity.task,
          entityId: task.id,
          type: SyncOperationType.update,
          baseRevision: task.revision,
          data: {
            'id': task.id,
            'account_id': accountId,
            'subject_id': null,
            'revision': task.revision,
          },
        );
      }

      await _timetable.deleteForSubject(accountId, subjectId);

      await (_database.update(
        _database.localSubjects,
      )..where((t) => t.id.equals(subjectId))).write(
        LocalSubjectsCompanion(
          deletedAt: d.Value(now),
          syncStatus: const d.Value('pending'),
          updatedAt: d.Value(now),
        ),
      );

      await _writer.enqueue(
        accountId: accountId,
        entity: SyncEntity.subject,
        entityId: subjectId,
        type: SyncOperationType.delete,
        baseRevision: subject.revision,
        data: {
          'id': subjectId,
          'account_id': accountId,
          'deleted_at': now.toIso8601String(),
        },
      );
    });
  }

  Future<void> _validate(Subject subject, {required String? checkId}) async {
    final name = subject.name.trim();
    final code = subject.code.trim();

    if (name.isEmpty) {
      throw const SubjectValidationException('Subject name is required.');
    }
    if (code.isEmpty) {
      throw const SubjectValidationException('Subject code is required.');
    }

    final duplicate =
        await (_database.select(_database.localSubjects)
              ..where(
                (t) =>
                    t.accountId.equals(subject.accountId) &
                    t.deletedAt.isNull() &
                    t.code.lower().equals(code.toLowerCase()),
              )
              ..limit(1))
            .getSingleOrNull();

    if (duplicate != null && duplicate.id != checkId) {
      throw SubjectValidationException(
        'A subject with code "$code" already exists.',
      );
    }
  }

  Subject _map(SubjectRow row) {
    return Subject(
      id: row.id,
      accountId: row.accountId,
      name: row.name,
      code: row.code,
      colorValue: row.colorValue,
      teacherName: row.teacherName,
      room: row.room,
      revision: row.revision,
      syncStatus: SyncStatus.fromCode(row.syncStatus),
      deletedAt: row.deletedAt,
      updatedAt: row.updatedAt,
    );
  }
}

class SubjectValidationException implements Exception {
  const SubjectValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
