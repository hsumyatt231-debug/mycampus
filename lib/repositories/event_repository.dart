import 'package:drift/drift.dart' as d;

import '../models/academic_event.dart';
import '../models/enums.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';

class EventRepository {
  EventRepository(this._database, this._writer);

  final LocalDatabase _database;
  final PendingOperationWriter _writer;

  Future<List<AcademicEvent>> getAll(String accountId) async {
    final rows =
        await (_database.select(_database.localAcademicEvents)
              ..where(
                (t) => t.accountId.equals(accountId) & t.deletedAt.isNull(),
              )
              ..orderBy([(t) => d.OrderingTerm.asc(t.eventDate)]))
            .get();
    return rows.map(_map).toList();
  }

  Future<List<AcademicEvent>> getForDate(
    String accountId,
    String dateKey,
  ) async {
    final rows =
        await (_database.select(_database.localAcademicEvents)
              ..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.eventDate.equals(dateKey) &
                    t.deletedAt.isNull(),
              )
              ..orderBy([(t) => d.OrderingTerm.asc(t.startTime)]))
            .get();
    return rows.map(_map).toList();
  }

  Future<AcademicEvent> create(AcademicEvent event) async {
    _validate(event);
    final now = DateTime.now().toUtc();
    final normalized = _normalize(event).copyWith(updatedAt: now);

    await _database.transaction(() async {
      await _database
          .into(_database.localAcademicEvents)
          .insert(
            LocalAcademicEventsCompanion.insert(
              id: normalized.id,
              accountId: normalized.accountId,
              title: normalized.title.trim(),
              type: d.Value(normalized.type.code),
              eventDate: normalized.eventDate,
              startTime: d.Value(normalized.startTime),
              endTime: d.Value(normalized.endTime),
              description: d.Value(normalized.description),
              location: d.Value(normalized.location),
              reminderOffsetMinutes: d.Value(normalized.reminderOffsetMinutes),
              updatedAt: now,
            ),
          );

      await _writer.enqueue(
        accountId: normalized.accountId,
        entity: SyncEntity.academicEvent,
        entityId: normalized.id,
        type: SyncOperationType.create,
        data: {...normalized.toJson(), 'account_id': normalized.accountId},
      );
    });

    return normalized;
  }

  Future<AcademicEvent> update(AcademicEvent event) async {
    _validate(event);
    final now = DateTime.now().toUtc();
    final normalized = _normalize(event).copyWith(updatedAt: now);

    await _database.transaction(() async {
      await (_database.update(_database.localAcademicEvents)..where(
            (t) =>
                t.id.equals(normalized.id) &
                t.accountId.equals(normalized.accountId),
          ))
          .write(
            LocalAcademicEventsCompanion(
              title: d.Value(normalized.title.trim()),
              type: d.Value(normalized.type.code),
              eventDate: d.Value(normalized.eventDate),
              startTime: d.Value(normalized.startTime),
              endTime: d.Value(normalized.endTime),
              description: d.Value(normalized.description),
              location: d.Value(normalized.location),
              reminderOffsetMinutes: d.Value(normalized.reminderOffsetMinutes),
              syncStatus: const d.Value('pending'),
              updatedAt: d.Value(now),
            ),
          );

      await _writer.enqueue(
        accountId: normalized.accountId,
        entity: SyncEntity.academicEvent,
        entityId: normalized.id,
        type: SyncOperationType.update,
        baseRevision: normalized.revision,
        data: {...normalized.toJson(), 'account_id': normalized.accountId},
      );
    });

    return normalized.copyWith(syncStatus: SyncStatus.pending);
  }

  Future<void> delete(AcademicEvent event) async {
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(_database.localAcademicEvents)..where(
            (t) => t.id.equals(event.id) & t.accountId.equals(event.accountId),
          ))
          .write(
            LocalAcademicEventsCompanion(
              deletedAt: d.Value(now),
              syncStatus: const d.Value('pending'),
              updatedAt: d.Value(now),
            ),
          );

      await _writer.enqueue(
        accountId: event.accountId,
        entity: SyncEntity.academicEvent,
        entityId: event.id,
        type: SyncOperationType.delete,
        baseRevision: event.revision,
        data: {
          'id': event.id,
          'account_id': event.accountId,
          'deleted_at': now.toIso8601String(),
        },
      );
    });
  }

  void _validate(AcademicEvent event) {
    if (event.title.trim().isEmpty) {
      throw const EventValidationException('Event title is required.');
    }
    if (event.eventDate.isEmpty) {
      throw const EventValidationException('Event date is required.');
    }
    if (event.startTime != null &&
        event.endTime != null &&
        event.endTime!.compareTo(event.startTime!) <= 0) {
      throw const EventValidationException(
        'End time must be after start time.',
      );
    }
  }

  AcademicEvent _normalize(AcademicEvent event) {
    final hasStart = event.startTime != null && event.startTime!.isNotEmpty;
    return event.copyWith(
      startTime: hasStart ? event.startTime : null,
      clearStartTime: !hasStart,
      endTime: hasStart ? event.endTime : null,
      clearEndTime: !hasStart,
      reminderOffsetMinutes: hasStart ? event.reminderOffsetMinutes : null,
      clearReminder: !hasStart,
    );
  }

  AcademicEvent _map(AcademicEventRow row) {
    return AcademicEvent(
      id: row.id,
      accountId: row.accountId,
      title: row.title,
      type: AcademicEventType.fromCode(row.type),
      eventDate: row.eventDate,
      startTime: row.startTime,
      endTime: row.endTime,
      description: row.description,
      location: row.location,
      reminderOffsetMinutes: row.reminderOffsetMinutes,
      revision: row.revision,
      syncStatus: SyncStatus.fromCode(row.syncStatus),
      deletedAt: row.deletedAt,
      updatedAt: row.updatedAt,
    );
  }
}

class EventValidationException implements Exception {
  const EventValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
