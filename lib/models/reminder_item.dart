import 'enums.dart';

/// Unified item for the Reminder Center and dashboard deadlines
/// (FR-NAV-005, FR-REM-002).
class ReminderItem {
  const ReminderItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dueAt,
    required this.bucket,
    required this.source,
    this.subjectId,
    this.completed = false,
    this.hasExplicitTime = false,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Derived instant in local time.
  final DateTime dueAt;
  final ReminderBucket bucket;

  /// 'task', 'event' or 'assignment'.
  final String source;
  final String? subjectId;
  final bool completed;
  final bool hasExplicitTime;

  bool get isOverdue => bucket == ReminderBucket.overdue;
}
