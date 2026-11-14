import 'enums.dart';

/// Personal task. Date/time are stored as wall-clock values in the user's
/// academic timezone (FR-TASK-006, DET-TZ-003).
class Task {
  const Task({
    required this.id,
    required this.accountId,
    required this.title,
    this.description,
    this.subjectId,
    this.dueDate,
    this.dueTime,
    this.hasExplicitTime = false,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.completedAt,
    this.reminderOffsetMinutes,
    this.revision = 0,
    this.syncStatus = SyncStatus.pending,
    this.deletedAt,
    this.updatedAt,
  });

  final String id;
  final String accountId;
  final String title;
  final String? description;
  final String? subjectId;

  /// yyyy-MM-dd wall-clock due date.
  final String? dueDate;

  /// HH:mm wall-clock due time; only meaningful when [hasExplicitTime].
  final String? dueTime;
  final bool hasExplicitTime;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? completedAt;

  /// Minutes before the deadline at which a reminder fires.
  final int? reminderOffsetMinutes;
  final int revision;
  final SyncStatus syncStatus;
  final DateTime? deletedAt;
  final DateTime? updatedAt;

  bool get isCompleted => status == TaskStatus.completed;
  bool get isDeleted => deletedAt != null;

  Task copyWith({
    String? title,
    String? description,
    String? subjectId,
    bool clearSubject = false,
    String? dueDate,
    bool clearDueDate = false,
    String? dueTime,
    bool clearDueTime = false,
    bool? hasExplicitTime,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    int? reminderOffsetMinutes,
    bool clearReminder = false,
    int? revision,
    SyncStatus? syncStatus,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      accountId: accountId,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: clearSubject ? null : subjectId ?? this.subjectId,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      dueTime: clearDueTime ? null : dueTime ?? this.dueTime,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      reminderOffsetMinutes: clearReminder
          ? null
          : reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'subject_id': subjectId,
    'due_date': dueDate,
    'due_time': dueTime,
    'has_explicit_time': hasExplicitTime,
    'priority': priority.code,
    'status': status.code,
    'completed_at': completedAt?.toUtc().toIso8601String(),
    'reminder_offset': reminderOffsetMinutes,
    'revision': revision,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
    'updated_at': updatedAt?.toUtc().toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      subjectId: json['subject_id'] as String?,
      dueDate: json['due_date'] as String?,
      dueTime: json['due_time'] as String?,
      hasExplicitTime: json['has_explicit_time'] as bool? ?? false,
      priority: TaskPriority.fromCode(json['priority'] as String?),
      status: TaskStatus.fromCode(json['status'] as String?),
      completedAt: DateTime.tryParse(json['completed_at'] as String? ?? ''),
      reminderOffsetMinutes: (json['reminder_offset'] as num?)?.toInt(),
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }
}
