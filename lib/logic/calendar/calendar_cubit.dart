import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/academic_event.dart';
import '../../models/assignment.dart';
import '../../models/dashboard_data.dart';
import '../../models/enums.dart';
import '../../models/subject.dart';
import '../../models/task.dart';
import '../../models/timetable_entry.dart';
import '../../repositories/assignment_repository.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/subject_repository.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/timetable_repository.dart';
import '../../services/academic_clock.dart';
import '../../services/id_service.dart';

class CalendarState extends Equatable {
  const CalendarState({
    this.month,
    this.selectedDateKey,
    this.tasks = const [],
    this.events = const [],
    this.assignments = const [],
    this.timetable = const [],
    this.subjects = const [],
    this.completedAssignments = const {},
    this.loading = true,
    this.busy = false,
    this.showTimetable = true,
    this.error,
  });

  final DateTime? month;
  final String? selectedDateKey;
  final List<Task> tasks;
  final List<AcademicEvent> events;
  final List<Assignment> assignments;
  final List<TimetableEntry> timetable;
  final List<Subject> subjects;
  final Set<String> completedAssignments;
  final bool loading;
  final bool busy;
  final bool showTimetable;
  final String? error;

  DateTime get activeMonth =>
      month ?? DateTime(DateTime.now().year, DateTime.now().month);

  String get activeDateKey =>
      selectedDateKey ?? AcademicClock.dateKey(DateTime.now());

  CalendarState copyWith({
    DateTime? month,
    String? selectedDateKey,
    List<Task>? tasks,
    List<AcademicEvent>? events,
    List<Assignment>? assignments,
    List<TimetableEntry>? timetable,
    List<Subject>? subjects,
    Set<String>? completedAssignments,
    bool? loading,
    bool? busy,
    bool? showTimetable,
    String? error,
    bool clearError = false,
  }) {
    return CalendarState(
      month: month ?? this.month,
      selectedDateKey: selectedDateKey ?? this.selectedDateKey,
      tasks: tasks ?? this.tasks,
      events: events ?? this.events,
      assignments: assignments ?? this.assignments,
      timetable: timetable ?? this.timetable,
      subjects: subjects ?? this.subjects,
      completedAssignments: completedAssignments ?? this.completedAssignments,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      showTimetable: showTimetable ?? this.showTimetable,
      error: clearError ? null : error ?? this.error,
    );
  }

  CalendarDayItems itemsFor(String dateKey) {
    return CalendarDayItems(
      tasks: tasks.where((task) => task.dueDate == dateKey).toList(),
      events: events.where((event) => event.eventDate == dateKey).toList(),
      assignments: assignments
          .where(
            (assignment) =>
                assignment.dueDate == dateKey && assignment.isVisibleToStudents,
          )
          .toList(),
    );
  }

  int countFor(String dateKey) => itemsFor(dateKey).total;

  List<TimetableEntry> timetableFor(int weekday) {
    return timetable.where((entry) => entry.weekday == weekday).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  }

  Subject? subjectFor(String subjectId) {
    for (final subject in subjects) {
      if (subject.id == subjectId) return subject;
    }
    return null;
  }

  List<Task> get selectedTasks => itemsFor(activeDateKey).tasks;

  List<AcademicEvent> get selectedEvents => itemsFor(activeDateKey).events;

  List<Assignment> get selectedAssignments =>
      itemsFor(activeDateKey).assignments;

  @override
  List<Object?> get props => [
    month,
    selectedDateKey,
    tasks,
    events,
    assignments,
    timetable,
    subjects,
    completedAssignments,
    loading,
    busy,
    showTimetable,
    error,
  ];
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required TaskRepository taskRepository,
    required EventRepository eventRepository,
    required TimetableRepository timetableRepository,
    required SubjectRepository subjectRepository,
    required AssignmentRepository assignmentRepository,
    required this._accountId,
  }) : _tasks = taskRepository,
       _events = eventRepository,
       _timetable = timetableRepository,
       _subjects = subjectRepository,
       _assignments = assignmentRepository,
       super(const CalendarState());

  final TaskRepository _tasks;
  final EventRepository _events;
  final TimetableRepository _timetable;
  final SubjectRepository _subjects;
  final AssignmentRepository _assignments;
  final String _accountId;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final tasks = await _tasks.getAll(_accountId);
      final events = await _events.getAll(_accountId);
      final timetable = await _timetable.getAll(_accountId);
      final subjects = await _subjects.getAll(_accountId);
      final assignments = await _assignments.cached(
        _accountId,
        publishedOnly: true,
      );
      final progress = await _assignments.progressFor(_accountId);

      final completed = {
        for (final entry in progress.entries)
          if (entry.value.isCompleted) entry.key,
      };

      emit(
        state.copyWith(
          tasks: tasks,
          events: events,
          timetable: timetable,
          subjects: subjects,
          assignments: assignments,
          completedAssignments: completed,
          loading: false,
          month:
              state.month ??
              DateTime(DateTime.now().year, DateTime.now().month),
          selectedDateKey:
              state.selectedDateKey ?? AcademicClock.dateKey(DateTime.now()),
        ),
      );
    } catch (error) {
      emit(state.copyWith(loading: false, error: _clean(error)));
    }
  }

  void changeMonth(int delta) {
    final base = state.activeMonth;
    final next = DateTime(base.year, base.month + delta);
    emit(state.copyWith(month: next));
  }

  void selectDate(String dateKey) {
    emit(state.copyWith(selectedDateKey: dateKey));
  }

  void toggleTimetable() {
    emit(state.copyWith(showTimetable: !state.showTimetable));
  }

  Future<bool> createEvent({
    required String title,
    required AcademicEventType type,
    required String eventDate,
    String? startTime,
    String? endTime,
    String? description,
    String? location,
    int? reminderOffsetMinutes,
  }) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _events.create(
        AcademicEvent(
          id: IdService.newId(),
          accountId: _accountId,
          title: title,
          type: type,
          eventDate: eventDate,
          startTime: startTime,
          endTime: endTime,
          description: description,
          location: location,
          reminderOffsetMinutes: reminderOffsetMinutes,
        ),
      );
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> updateEvent(AcademicEvent event) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _events.update(event);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> deleteEvent(AcademicEvent event) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _events.delete(event);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> createTimetableEntry({
    required String subjectId,
    required int weekday,
    required int startMinutes,
    required int endMinutes,
    String? room,
  }) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _timetable.create(
        TimetableEntry(
          id: IdService.newId(),
          accountId: _accountId,
          subjectId: subjectId,
          weekday: weekday,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          room: room,
        ),
      );
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> updateTimetableEntry(TimetableEntry entry) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _timetable.update(entry);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> deleteTimetableEntry(TimetableEntry entry) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _timetable.delete(entry);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<List<TimetableEntry>> overlapping(TimetableEntry candidate) {
    return _timetable.overlapping(candidate);
  }

  Future<bool> toggleTask(Task task) async {
    try {
      await _tasks.setCompletion(task, completed: !task.isCompleted);
      await load();
      return true;
    } catch (error) {
      emit(state.copyWith(error: _clean(error)));
      return false;
    }
  }

  Future<bool> toggleAssignment(Assignment assignment) async {
    try {
      await _assignments.setProgress(
        accountId: _accountId,
        assignment: assignment,
        completed: !state.completedAssignments.contains(assignment.id),
      );
      await load();
      return true;
    } catch (error) {
      emit(state.copyWith(error: _clean(error)));
      return false;
    }
  }

  String _clean(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
