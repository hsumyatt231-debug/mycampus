import 'package:drift/drift.dart' show TableUpdateQuery;

import '../constants/api_config.dart';
import '../logic/app_lock/app_lock_cubit.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/sync/sync_cubit.dart';
import '../repositories/account_repository.dart';
import '../repositories/assignment_repository.dart';
import '../repositories/classroom_repository.dart';
import '../repositories/event_repository.dart';
import '../repositories/pending_operation_writer.dart';
import '../repositories/settings_repository.dart';
import '../repositories/subject_repository.dart';
import '../repositories/sync_repository.dart';
import '../repositories/task_repository.dart';
import '../repositories/timetable_repository.dart';
import 'academic_clock.dart';
import 'cloud_gateway.dart';
import 'cloud_write_service.dart';
import 'connectivity_service.dart';
import 'encryption_key_service.dart';
import 'http_cloud_gateway.dart';
import 'local_database.dart';
import 'notification_service.dart';
import 'sync_engine.dart';

/// Composition root for the online-first build with an offline queue fallback.
///
/// The cloud gateway is [HttpCloudGateway], pointed at the SQLite/SQLAlchemy
/// API by `MYCAMPUS_API_BASE_URL` (see [ApiConfig]). Swapping this one binding
/// is enough to change the whole app's cloud endpoint (FR-SYNC-017).
class AppDependencies {
  AppDependencies._({
    required this.database,
    required this.settings,
    required this.keyService,
    required this.notifications,
    required this.connectivity,
    required this.gateway,
    required this.cloudWrites,
    required this.subjects,
    required this.tasks,
    required this.timetable,
    required this.events,
    required this.assignments,
    required this.classrooms,
    required this.accounts,
    required this.syncRepository,
    required this.syncEngine,
    required this.syncCubit,
    required this.authBloc,
    required this.appLock,
    required this.resumedSession,
  });

  final LocalDatabase database;
  final SettingsRepository settings;
  final EncryptionKeyService keyService;
  final NotificationService notifications;
  final ConnectivityService connectivity;
  final CloudGateway gateway;
  final CloudWriteService cloudWrites;

  final SubjectRepository subjects;
  final TaskRepository tasks;
  final TimetableRepository timetable;
  final EventRepository events;
  final AssignmentRepository assignments;
  final ClassroomRepository classrooms;
  final AccountRepository accounts;
  final SyncRepository syncRepository;
  final SyncEngine syncEngine;

  final SyncCubit syncCubit;
  final AuthBloc authBloc;
  final AppLockCubit appLock;

  /// True when a session record existed before this launch (cold-start lock).
  final bool resumedSession;

  /// Emits after any local table write. Dashboards use it to invalidate their
  /// cached view when another tab changes planner data.
  Stream<void> get dataChanges => database
      .tableUpdates(TableUpdateQuery.onAllTables(database.allTables))
      .map((_) {});

  static Future<AppDependencies> create() async {
    AcademicClock.initialize();

    final database = LocalDatabase();
    final settings = SettingsRepository(database);
    final resumedSession = await settings.sessionAccountId() != null;

    final writer = PendingOperationWriter(database);
    final keyService = EncryptionKeyService(database);

    // Single cloud binding: the REST gateway talks to the SQLite/SQLAlchemy
    // API. Online writes go straight through it; offline writes stay queued.
    final gateway = HttpCloudGateway(tokenProvider: settings.cloudToken);

    final syncRepository = SyncRepository(database);
    final cloudWrites = CloudWriteService(gateway, settings, syncRepository);

    final timetable = TimetableRepository(database, writer, cloudWrites);
    final subjects = SubjectRepository(
      database,
      writer,
      timetable,
      cloudWrites,
    );
    final tasks = TaskRepository(database, writer, cloudWrites);
    final events = EventRepository(database, writer, cloudWrites);
    final assignments = AssignmentRepository(
      database,
      writer,
      gateway,
      cloudWrites,
    );
    final classrooms = ClassroomRepository(database, gateway, assignments);

    final accounts = AccountRepository(
      database: database,
      settings: settings,
      writer: writer,
      keyService: keyService,
      gateway: gateway,
      cloud: cloudWrites,
    );

    final syncEngine = SyncEngine(repository: syncRepository, gateway: gateway);

    final notifications = InAppNotificationService();
    await notifications.initialize();

    final authBloc = AuthBloc(accountRepository: accounts);
    final appLock = AppLockCubit(accountRepository: accounts);
    final syncCubit = SyncCubit(
      engine: syncEngine,
      repository: syncRepository,
      changes: database
          .tableUpdates(TableUpdateQuery.onAllTables(database.allTables))
          .map((_) {}),
    );

    return AppDependencies._(
      database: database,
      settings: settings,
      keyService: keyService,
      notifications: notifications,
      connectivity: ConnectivityService(),
      gateway: gateway,
      cloudWrites: cloudWrites,
      subjects: subjects,
      tasks: tasks,
      timetable: timetable,
      events: events,
      assignments: assignments,
      classrooms: classrooms,
      accounts: accounts,
      syncRepository: syncRepository,
      syncEngine: syncEngine,
      syncCubit: syncCubit,
      authBloc: authBloc,
      appLock: appLock,
      resumedSession: resumedSession,
    );
  }

  Future<void> dispose() async {
    await syncCubit.close();
    await authBloc.close();
    await appLock.close();
    await syncEngine.dispose();
    await connectivity.dispose();
    await database.close();
  }
}
