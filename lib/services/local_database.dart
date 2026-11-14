import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

/// Account record for the local-only authentication mode. Production builds
/// use Supabase Auth and never persist a password hash locally.
@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get fullName => text()();
  TextColumn get role => text()();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  TextColumn get academicTimezone => text()();
  TextColumn get timeFormat => text().withDefault(const Constant('12'))();
  BoolColumn get emailVerified => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('SubjectRow')
class LocalSubjects extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();
  IntColumn get colorValue =>
      integer().withDefault(const Constant(0xFF6236F5))();
  TextColumn get teacherName => text().nullable()();
  TextColumn get room => text().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TaskRow')
class LocalTasks extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get subjectId => text().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get dueTime => text().nullable()();
  BoolColumn get hasExplicitTime =>
      boolean().withDefault(const Constant(false))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get reminderOffsetMinutes => integer().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TimetableRow')
class LocalTimetableEntries extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get subjectId => text()();
  IntColumn get weekday => integer()();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  TextColumn get room => text().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AcademicEventRow')
class LocalAcademicEvents extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get title => text()();
  TextColumn get type => text().withDefault(const Constant('other'))();
  TextColumn get eventDate => text()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();
  IntColumn get reminderOffsetMinutes => integer().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CachedClassroomRow')
class CachedClassrooms extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get teacherId => text()();
  TextColumn get teacherName => text().nullable()();
  TextColumn get name => text()();
  TextColumn get subjectName => text()();
  TextColumn get description => text().nullable()();
  TextColumn get joinCode => text().nullable()();
  TextColumn get timezone => text()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CachedMemberRow')
class CachedClassroomMembers extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get classroomId => text()();
  TextColumn get studentId => text()();
  TextColumn get studentName => text().nullable()();
  TextColumn get studentEmail => text().nullable()();
  TextColumn get status => text()();
  BoolColumn get rejoinBlocked =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get joinedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MembershipEventRow')
class CachedMembershipEvents extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get classroomId => text()();
  TextColumn get membershipId => text()();
  TextColumn get studentName => text().nullable()();
  TextColumn get performedBy => text()();
  TextColumn get eventType => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CachedAssignmentRow')
class CachedAssignments extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get classroomId => text()();
  TextColumn get classroomName => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get dueDate => text()();
  TextColumn get dueTime => text().nullable()();
  BoolColumn get hasExplicitTime =>
      boolean().withDefault(const Constant(false))();
  TextColumn get status => text()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AssignmentProgressRow')
class LocalAssignmentProgress extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get assignmentId => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PendingOperationRow')
class PendingOperations extends Table {
  TextColumn get operationId => text()();
  TextColumn get accountId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get type => text()();
  TextColumn get payloadJson => text()();
  TextColumn get fingerprint => text()();
  IntColumn get baseRevision => integer().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
  TextColumn get dependsOn => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {operationId};
}

@DataClassName('SyncMetadataRow')
class SyncMetadata extends Table {
  TextColumn get accountId => text()();
  TextColumn get cursor => text().nullable()();
  DateTimeColumn get lastPullAt => dateTime().nullable()();
  DateTimeColumn get lastPushAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {accountId};
}

@DataClassName('SyncConflictRow')
class SyncConflicts extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get localJson => text()();
  TextColumn get cloudJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get resolution => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReminderStateRow')
class LocalReminderState extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Accounts,
    AppSettings,
    LocalSubjects,
    LocalTasks,
    LocalTimetableEntries,
    LocalAcademicEvents,
    CachedClassrooms,
    CachedClassroomMembers,
    CachedMembershipEvents,
    CachedAssignments,
    LocalAssignmentProgress,
    PendingOperations,
    SyncMetadata,
    SyncConflicts,
    LocalReminderState,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  LocalDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // NFR-009: upgrades must preserve pending operations. Future schema
      // migrations are applied additively here.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> clearAccountPersonalData(String accountId) async {
    await transaction(() async {
      await (delete(
        localTasks,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        localSubjects,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        localTimetableEntries,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        localAcademicEvents,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        localAssignmentProgress,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        pendingOperations,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        syncConflicts,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        localReminderState,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        syncMetadata,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(

        cachedClassrooms,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        cachedClassroomMembers,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        cachedMembershipEvents,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (delete(
        cachedAssignments,
      )..where((t) => t.accountId.equals(accountId))).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final file = File(p.join(directory.path, 'mycampus_local.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
