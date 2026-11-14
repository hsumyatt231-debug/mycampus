import '../../models/academic_event.dart';
import '../../models/assignment.dart';
import '../../models/enums.dart';
import '../../models/reminder_item.dart';
import '../../models/task.dart';
import '../../services/academic_clock.dart';

/// Builds the unified reminder set used by Home and the Reminder Center
/// (FR-NAV-005, FR-REM-002).
abstract final class ReminderBuilder {
  static const Duration dueSoonWindow = Duration(hours: 48);

  static List<ReminderItem> build({
    required List<Task> tasks,
    required List<AcademicEvent> events,
    required List<Assignment> assignments,
    required Set<String> completedAssignmentIds,
    required String timezone,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now().toUtc();
    final items = <ReminderItem>[];

    for (final task in tasks) {
      final due = AcademicClock.dueInstant(
        date: task.dueDate,
        time: task.hasExplicitTime ? task.dueTime : null,
        timezoneName: timezone,
      );
      if (due == null) continue;

      items.add(
        ReminderItem(
          id: task.id,
          title: task.title,
          subtitle: task.subjectId == null
              ? 'Personal task'
              : 'Task · ${task.priority.label} priority',
          dueAt: due,
          bucket: _bucket(due, current, task.isCompleted),
          source: 'task',
          subjectId: task.subjectId,
          completed: task.isCompleted,
          hasExplicitTime: task.hasExplicitTime,
        ),
      );
    }

    for (final event in events) {
      final due = AcademicClock.dueInstant(
        date: event.eventDate,
        time: event.startTime,
        timezoneName: timezone,
      );
      if (due == null) continue;

      items.add(
        ReminderItem(
          id: event.id,
          title: event.title,
          subtitle: '${event.type.label} · event',
          dueAt: due,
          bucket: _bucket(due, current, false),
          source: 'event',
          hasExplicitTime: event.startTime != null,
        ),
      );
    }

    for (final assignment in assignments) {
      if (!assignment.isVisibleToStudents) continue;
      final due = AcademicClock.dueInstant(
        date: assignment.dueDate,
        time: assignment.hasExplicitTime ? assignment.dueTime : null,
        timezoneName: timezone,
      );
      if (due == null) continue;
      final completed = completedAssignmentIds.contains(assignment.id);

      items.add(
        ReminderItem(
          id: assignment.id,
          title: assignment.title,
          subtitle: assignment.classroomName == null
              ? 'Assignment'
              : 'Assignment · ${assignment.classroomName}',
          dueAt: due,
          bucket: _bucket(due, current, completed),
          source: 'assignment',
          completed: completed,
          hasExplicitTime: assignment.hasExplicitTime,
        ),
      );
    }

    items.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return items;
  }

  static ReminderBucket _bucket(DateTime due, DateTime now, bool completed) {
    if (completed) return ReminderBucket.upcoming;
    if (due.isBefore(now)) return ReminderBucket.overdue;
    if (due.difference(now) <= dueSoonWindow) return ReminderBucket.dueSoon;
    return ReminderBucket.upcoming;
  }
}
