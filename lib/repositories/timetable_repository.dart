import 'package:drift/drift.dart' as d;

import '../models/enums.dart';
import '../models/timetable_entry.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';

class TimetableRepository {
  TimetableRepository(this._database, this._writer);

  final LocalDatabase _database;
  final PendingOperationWriter _writer;

  Future<List<TimetableEntry>> getAll(String accountId) async {
    final rows =
        await (_database.select(_database.localTimetableEntries)
              ..where(
                (t) => t.accountId.equals(accountId) & t.deletedAt.isNull(),
              )
              ..orderBy([
                (t) => d.OrderingTerm.asc(t.weekday),
                (t) => d.OrderingTerm.asc(t.startMinutes),
              ]))
            .get();
    return rows.map(_map).toList();
  }

  Future<List<TimetableEntry>> getForDay(String accountId, int weekday) async {
    final rows =
        await (_database.select(_database.localTimetableEntries)
              ..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.weekday.equals(weekday) &
                    t.deletedAt.isNull(),
              )
              ..orderBy([(t) => d.OrderingTerm.asc(t.startMinutes)]))
            .get();
    return rows.map(_map).toList();
  }

  /// Returns entries that overlap [candidate] (FR-CAL-006). Overlaps warn but
  /// never silently modify other entries.
  Future<List<TimetableEntry>> overlapping(TimetableEntry candidate) async {
    final all = await getAll(candidate.accountId);
    return all
        .where((entry) => entry.id != candidate.id)
        .where(candidate.overlaps)
        .toList();
  }

  Future<TimetableEntry> create(TimetableEntry entry) async {
    await _validate(entry);
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await _database
          .into(_database.localTimetableEntries)
          .insert(
            LocalTimetableEntriesCompanion.insert(
              id: entry.id,
              accountId: entry.accountId,
              subjectId: entry.subjectId,
              weekday: entry.weekday,
              startMinutes: entry.startMinutes,
              endMinutes: entry.endMinutes,
              room: d.Value(entry.room),
              updatedAt: now,
            ),
          );

      await _writer.enqueue(
        accountId: entry.accountId,
        entity: SyncEntity.timetableEntry,
        entityId: entry.id,
        type: SyncOperationType.create,
        data: {...entry.toJson(), 'account_id': entry.accountId},
      );
    });

    return entry.copyWith(updatedAt: now);
  }

  Future<TimetableEntry> update(TimetableEntry entry) async {
    await _validate(entry);
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.localTimetableEntries,
      )..where((t) => t.id.equals(entry.id))).write(
        LocalTimetableEntriesCompanion(
          subjectId: d.Value(entry.subjectId),
          weekday: d.Value(entry.weekday),
          startMinutes: d.Value(entry.startMinutes),
          endMinutes: d.Value(entry.endMinutes),
          room: d.Value(entry.room),
          syncStatus: const d.Value('pending'),
          updatedAt: d.Value(now),
        ),
      );

      await _writer.enqueue(
        accountId: entry.accountId,
        entity: SyncEntity.timetableEntry,
        entityId: entry.id,
        type: SyncOperationType.update,
        baseRevision: entry.revision,
        data: {...entry.toJson(), 'account_id': entry.accountId},
      );
    });

    return entry.copyWith(syncStatus: SyncStatus.pending, updatedAt: now);
  }

  Future<void> delete(TimetableEntry entry) async {
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.localTimetableEntries,
      )..where((t) => t.id.equals(entry.id))).write(
        LocalTimetableEntriesCompanion(
          deletedAt: d.Value(now),
          syncStatus: const d.Value('pending'),
          updatedAt: d.Value(now),
        ),
      );

      await _writer.enqueue(
        accountId: entry.accountId,
        entity: SyncEntity.timetableEntry,
        entityId: entry.id,
        type: SyncOperationType.delete,
        baseRevision: entry.revision,
        data: {
          'id': entry.id,
          'account_id': entry.accountId,
          'deleted_at': now.toIso8601String(),
        },
      );
    });
  }

  /// Removes timetable rows attached to a deleted subject (DET-SUB-003),
  /// queuing a delete for each entry.
  Future<int> deleteForSubject(String accountId, String subjectId) async {
    final rows =
        await (_database.select(_database.localTimetableEntries)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.subjectId.equals(subjectId) &
                  t.deletedAt.isNull(),
            ))
            .get();

    for (final row in rows) {
      await delete(_map(row));
    }
    return rows.length;
  }

  Future<void> _validate(TimetableEntry entry) async {
    if (entry.subjectId.isEmpty) {
      throw const TimetableValidationException('Choose a subject.');
    }
    if (entry.weekday < 1 || entry.weekday > 5) {
      throw const TimetableValidationException(
        'Timetable entries are Monday to Friday only.',
      );
    }
    if (entry.endMinutes <= entry.startMinutes) {
      throw const TimetableValidationException(
        'End time must be after start time.',
      );
    }
  }

  TimetableEntry _map(TimetableRow row) {
    return TimetableEntry(
      id: row.id,
      accountId: row.accountId,
      subjectId: row.subjectId,
      weekday: row.weekday,
      startMinutes: row.startMinutes,
      endMinutes: row.endMinutes,
      room: row.room,
      revision: row.revision,
      syncStatus: SyncStatus.fromCode(row.syncStatus),
      deletedAt: row.deletedAt,
      updatedAt: row.updatedAt,
    );
  }
}

class TimetableValidationException implements Exception {
  const TimetableValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
