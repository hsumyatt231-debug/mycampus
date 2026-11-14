import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/academic_event.dart';
import '../../models/assignment.dart';
import '../../models/classroom.dart';
import '../../models/dashboard_data.dart';
import '../../models/enums.dart';
import '../../models/reminder_item.dart';
import '../../models/subject.dart';
import '../../models/task.dart';
import '../../models/user_profile.dart';
import '../../repositories/assignment_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/subject_repository.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/timetable_repository.dart';
import '../../services/academic_clock.dart';
import '../reminders/reminder_builder.dart';

class HomeState extends Equatable {
  const HomeState({
    this.loading = true,
    this.data = const DashboardData(),
    this.reminders = const [],
    this.completedAssignments = const {},
    this.error,
  });

  final bool loading;
  final DashboardData data;
  final List<ReminderItem> reminders;
  final Set<String> completedAssignments;
  final String? error;

  HomeState copyWith({
    bool? loading,
    DashboardData? data,
    List<ReminderItem>? reminders,
    Set<String>? completedAssignments,
    String? error,
    bool clearError = false,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      reminders: reminders ?? this.reminders,
      completedAssignments: completedAssignments ?? this.completedAssignments,
      error: clearError ? null : error ?? this.error,
    );
  }

  List<ReminderItem> byBucket(ReminderBucket bucket) =>
      reminders.where((item) => item.bucket == bucket).toList();

  @override
  List<Object?> get props => [
    loading,
    data,
    reminders,
    completedAssignments,
    error,
  ];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this._subjects,
    required this._tasks,
    required this._timetable,
    required this._events,
    required this._classrooms,
    required this._assignments,
    required Stream<void> changes,
  }) : super(const HomeState()) {
    _changes = changes.listen((_) => _scheduleReload());
  }

  final SubjectRepository _subjects;
  final TaskRepository _tasks;
  final TimetableRepository _timetable;
  final EventRepository _events;
  final ClassroomRepository _classrooms;
  final AssignmentRepository _assignments;

  StreamSubscription<void>? _changes;
  Timer? _reloadTimer;
  UserProfile? _profile;

  /// Reloads the dashboard after any local write so the Home tab is never
  /// stale when another tab changes subjects, tasks, events or assignments.
  void _scheduleReload() {
    _reloadTimer?.cancel();
    _reloadTimer = Timer(const Duration(milliseconds: 150), () {
      final profile = _profile;
      if (profile == null) return;
      unawaited(load(profile, silent: true));
    });
  }

  Future<void> load(UserProfile profile, {bool silent = false}) async {
    _profile = profile;
    if (!silent) emit(state.copyWith(loading: true, clearError: true));
    try {
      final subjects = await _subjects.getAll(profile.id);
      final tasks = await _tasks.getAll(profile.id);
      final entries = await _timetable.getAll(profile.id);
      final events = await _events.getAll(profile.id);
      final classrooms = await _classrooms.cachedClassrooms(profile.id);
      final assignments = await _assignments.cached(
        profile.id,
        publishedOnly: true,
      );
      final progress = await _assignments.progressFor(profile.id);

      final todayKey = AcademicClock.todayKey(
        timezoneName: profile.academicTimezone,
      );
      final weekday = DateTime.parse(todayKey).weekday;
      final subjectsById = {
        for (final subject in subjects) subject.id: subject,
      };

      final todaySchedule =
          entries
              .where((entry) => entry.weekday == weekday)
              .map(
                (entry) => TodayScheduleItem(
                  entry: entry,
                  subject: subjectsById[entry.subjectId],
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.entry.startMinutes.compareTo(b.entry.startMinutes),
            );

      final completedAssignmentIds = {
        for (final entry in progress.entries)
          if (entry.value.isCompleted) entry.key,
      };

      final reminders = ReminderBuilder.build(
        tasks: tasks,
        events: events,
        assignments: assignments,
        completedAssignmentIds: completedAssignmentIds,
        timezone: profile.academicTimezone,
      );

      final pendingTasks = tasks.where((task) => !task.isCompleted).toList()
        ..sort((a, b) {
          final aKey = a.dueDate ?? '9999-12-31';
          final bKey = b.dueDate ?? '9999-12-31';
          return aKey.compareTo(bKey);
        });

      emit(
        HomeState(
          loading: false,
          data: DashboardData(
            subjects: subjects,
            pendingTasks: pendingTasks,
            todaySchedule: todaySchedule,
            deadlines: reminders
                .where((item) => !item.completed)
                .take(5)
                .toList(),
            events: events
                .where((event) => event.eventDate == todayKey)
                .toList(),
            classrooms: classrooms,
            publishedAssignments: assignments,
          ),
          reminders: reminders,
          completedAssignments: completedAssignmentIds,
        ),
      );
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> toggleTask(Task task) async {
    await _tasks.setCompletion(task, completed: !task.isCompleted);
  }

  Future<void> toggleAssignment(
    UserProfile profile,
    Assignment assignment,
    bool completed,
  ) async {
    await _assignments.setProgress(
      accountId: profile.id,
      assignment: assignment,
      completed: completed,
    );
  }

  List<Subject> get subjects => state.data.subjects;

  List<Classroom> get classrooms => state.data.classrooms;

  List<AcademicEvent> get todayEvents => state.data.events;

  @override
  Future<void> close() async {
    _reloadTimer?.cancel();
    await _changes?.cancel();
    return super.close();
  }
}
