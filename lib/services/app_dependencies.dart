import 'package:drift/drift.dart' show TableUpdateQuery;

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
import 'connectivity_service.dart';
import 'encryption_key_service.dart';
import 'local_database.dart';
import 'notification_service.dart';
import 'supabase_service.dart';
import 'sync_engine.dart';

/// Composition root for the local-first build.
///
/// The cloud gateway is intentionally [OfflineCloudGateway]; configuring a
/// live Supabase project replaces this one binding without touching feature
/// code (FR-SYNC-017).
class AppDependencies {
  AppDependencies._({
    required this.database,
    required this.settings,
    required this.keyService,
    required this.notifications,
    required this.connectivity,
    required this.gateway,
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

    // Supabase is optional in this build: absent environment values leave the
    // client unconfigured and every cloud call reports unavailability.
    final supabase = SupabaseService.instance;
    try {
      await supabase.initialize();
    } catch (_) {
      // A malformed configuration must not stop the local-first app.
    }

    const gateway = OfflineCloudGateway();

    final timetable = TimetableRepository(database, writer);
    final subjects = SubjectRepository(database, writer, timetable);
    final tasks = TaskRepository(database, writer);
    final events = EventRepository(database, writer);
    final assignments = AssignmentRepository(database, writer, gateway);
    final classrooms = ClassroomRepository(database, gateway, assignments);

    final accounts = AccountRepository(
      database: database,
      settings: settings,
      writer: writer,
      keyService: keyService,
      gateway: gateway,
    );

    final syncRepository = SyncRepository(database);
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
