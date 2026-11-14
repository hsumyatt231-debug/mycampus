import 'academic_event.dart';
import 'assignment.dart';
import 'classroom.dart';
import 'reminder_item.dart';
import 'subject.dart';
import 'task.dart';
import 'timetable_entry.dart';

class TodayScheduleItem {
  const TodayScheduleItem({required this.entry, this.subject});

  final TimetableEntry entry;
  final Subject? subject;

  String get subjectName => subject?.name ?? 'Class';
}

class DashboardData {
  const DashboardData({
    this.subjects = const [],
    this.pendingTasks = const [],
    this.todaySchedule = const [],
    this.deadlines = const [],
    this.events = const [],
    this.classrooms = const [],
    this.publishedAssignments = const [],
  });

  final List<Subject> subjects;
  final List<Task> pendingTasks;
  final List<TodayScheduleItem> todaySchedule;
  final List<ReminderItem> deadlines;
  final List<AcademicEvent> events;
  final List<Classroom> classrooms;
  final List<Assignment> publishedAssignments;

  bool get isEmpty =>
      subjects.isEmpty &&
      pendingTasks.isEmpty &&
      todaySchedule.isEmpty &&
      deadlines.isEmpty;
}

/// A calendar day cell detail combining personal tasks, visible published
/// assignments and academic events (FR-CAL-001).
class CalendarDayItems {
  const CalendarDayItems({
    this.tasks = const [],
    this.events = const [],
    this.assignments = const [],
  });

  final List<Task> tasks;
  final List<AcademicEvent> events;
  final List<Assignment> assignments;

  bool get isEmpty => tasks.isEmpty && events.isEmpty && assignments.isEmpty;
  int get total => tasks.length + events.length + assignments.length;
}
