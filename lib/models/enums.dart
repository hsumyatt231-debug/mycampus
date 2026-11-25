enum UserRole {
  student('student', 'Student'),
  teacher('teacher', 'Teacher');

  const UserRole(this.code, this.label);

  final String code;
  final String label;

  static UserRole fromCode(String? code) {
    return UserRole.values.firstWhere(
      (role) => role.code == code,
      orElse: () => UserRole.student,
    );
  }
}

enum TaskPriority {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High');

  const TaskPriority(this.code, this.label);

  final String code;
  final String label;

  static TaskPriority fromCode(String? code) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.code == code,
      orElse: () => TaskPriority.medium,
    );
  }
}

enum TaskStatus {
  pending('pending', 'Pending'),
  completed('completed', 'Completed');

  const TaskStatus(this.code, this.label);

  final String code;
  final String label;

  static TaskStatus fromCode(String? code) {
    return TaskStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => TaskStatus.pending,
    );
  }
}

enum AcademicEventType {
  exam('exam', 'Exam'),
  meeting('meeting', 'Meeting'),
  seminar('seminar', 'Seminar'),
  studySession('study_session', 'Study Session'),
  other('other', 'Other');

  const AcademicEventType(this.code, this.label);

  final String code;
  final String label;

  static AcademicEventType fromCode(String? code) {
    return AcademicEventType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => AcademicEventType.other,
    );
  }
}

enum MembershipStatus {
  active('active', 'Active'),
  left('left', 'Left'),
  removed('removed', 'Removed');

  const MembershipStatus(this.code, this.label);

  final String code;
  final String label;

  static MembershipStatus fromCode(String? code) {
    return MembershipStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => MembershipStatus.left,
    );
  }
}

enum MembershipEventType {
  joined('joined', 'Joined'),
  left('left', 'Left'),
  removed('removed', 'Removed'),
  unblocked('unblocked', 'Unblocked');

  const MembershipEventType(this.code, this.label);

  final String code;
  final String label;

  static MembershipEventType fromCode(String? code) {
    return MembershipEventType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => MembershipEventType.joined,
    );
  }
}

enum AssignmentStatus {
  draft('draft', 'Draft'),
  published('published', 'Published'),
  archived('archived', 'Archived');

  const AssignmentStatus(this.code, this.label);

  final String code;
  final String label;

  static AssignmentStatus fromCode(String? code) {
    return AssignmentStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => AssignmentStatus.draft,
    );
  }
}

/// Local sync state for a record or queued operation.
enum SyncStatus {
  synced('synced', 'Synced'),
  pending('pending', 'Pending sync'),
  sending('sending', 'Syncing'),
  failed('failed', 'Sync failed'),
  conflict('conflict', 'Conflict'),
  discarded('discarded', 'Discarded');

  const SyncStatus(this.code, this.label);

  final String code;
  final String label;

  static SyncStatus fromCode(String? code) {
    return SyncStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => SyncStatus.pending,
    );
  }
}

enum SyncOperationType {
  create('create', 'Create'),
  update('update', 'Update'),
  delete('delete', 'Delete');

  const SyncOperationType(this.code, this.label);

  final String code;
  final String label;

  static SyncOperationType fromCode(String? code) {
    return SyncOperationType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => SyncOperationType.update,
    );
  }
}

enum SyncEntity {
  profile('profile', 'Profile'),
  subject('subject', 'Subject'),
  task('task', 'Task'),
  timetableEntry('timetable_entry', 'Timetable entry'),
  academicEvent('academic_event', 'Academic event'),
  assignmentProgress('assignment_progress', 'Assignment progress');

  const SyncEntity(this.code, this.label);

  final String code;
  final String label;

  static SyncEntity? fromCode(String? code) {
    for (final entity in SyncEntity.values) {
      if (entity.code == code) return entity;
    }
    return null;
  }
}

enum ReminderBucket {
  dueSoon('Due soon'),
  overdue('Overdue'),
  upcoming('Upcoming');

  const ReminderBucket(this.label);

  final String label;
}

enum TimeFormat {
  twelveHour('12', '12-hour'),
  twentyFourHour('24', '24-hour');

  const TimeFormat(this.code, this.label);

  final String code;
  final String label;

  static TimeFormat fromCode(String? code) {
    return code == '24' ? TimeFormat.twentyFourHour : TimeFormat.twelveHour;
  }
}
