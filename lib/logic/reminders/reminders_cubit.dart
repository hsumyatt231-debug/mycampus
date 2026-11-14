import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/assignment.dart';
import '../../models/enums.dart';
import '../../models/reminder_item.dart';
import '../../models/user_profile.dart';
import '../../repositories/assignment_repository.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/task_repository.dart';
import '../reminders/reminder_builder.dart';

class RemindersState extends Equatable {
  const RemindersState({
    this.loading = true,
    this.items = const [],
    this.selected = ReminderBucket.upcoming,
    this.error,
  });

  final bool loading;
  final List<ReminderItem> items;
  final ReminderBucket selected;
  final String? error;

  RemindersState copyWith({
    bool? loading,
    List<ReminderItem>? items,
    ReminderBucket? selected,
    String? error,
    bool clearError = false,
  }) {
    return RemindersState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      selected: selected ?? this.selected,
      error: clearError ? null : error ?? this.error,
    );
  }

  List<ReminderItem> forBucket(ReminderBucket bucket) =>
      items.where((item) => item.bucket == bucket).toList();

  int countFor(ReminderBucket bucket) =>
      items.where((item) => item.bucket == bucket).length;

  @override
  List<Object?> get props => [loading, items, selected, error];
}

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required this._tasks,
    required this._events,
    required this._assignments,
  }) : super(const RemindersState());

  final TaskRepository _tasks;
  final EventRepository _events;
  final AssignmentRepository _assignments;

  Future<void> load(UserProfile profile) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final tasks = await _tasks.getAll(profile.id);
      final events = await _events.getAll(profile.id);
      final assignments = await _assignments.cached(
        profile.id,
        publishedOnly: true,
      );
      final progress = await _assignments.progressFor(profile.id);
      final completed = {
        for (final entry in progress.entries)
          if (entry.value.isCompleted) entry.key,
      };

      final items = ReminderBuilder.build(
        tasks: tasks,
        events: events,
        assignments: assignments,
        completedAssignmentIds: completed,
        timezone: profile.academicTimezone,
      );

      // Keep the chosen bucket unless it is empty; otherwise land on the first
      // bucket that actually has reminders so the list is not blank while the
      // header shows a non-zero count.
      var selected = state.selected;
      if (!items.any((item) => item.bucket == selected) && items.isNotEmpty) {
        selected = ReminderBucket.values.firstWhere(
          (bucket) => items.any((item) => item.bucket == bucket),
          orElse: () => selected,
        );
      }

      emit(state.copyWith(loading: false, items: items, selected: selected));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  void select(ReminderBucket bucket) => emit(state.copyWith(selected: bucket));

  /// Marks a task or assignment reminder complete (or reopens it) and
  /// rebuilds the unified list. Events are not completable.
  Future<bool> toggle(UserProfile profile, ReminderItem item) async {
    try {
      if (item.source == 'task') {
        final task = await _tasks.getById(profile.id, item.id);
        if (task != null) {
          await _tasks.setCompletion(task, completed: !task.isCompleted);
        }
      } else if (item.source == 'assignment') {
        Assignment? match;
        final assignments = await _assignments.cached(profile.id);
        for (final assignment in assignments) {
          if (assignment.id == item.id) {
            match = assignment;
            break;
          }
        }
        if (match != null) {
          await _assignments.setProgress(
            accountId: profile.id,
            assignment: match,
            completed: !item.completed,
          );
        }
      }
      await load(profile);
      return true;
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      return false;
    }
  }
}
