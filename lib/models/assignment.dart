import 'enums.dart';

class Assignment {
  const Assignment({
    required this.id,
    required this.classroomId,
    required this.title,
    required this.dueDate,
    this.description,
    this.dueTime,
    this.hasExplicitTime = false,
    this.status = AssignmentStatus.draft,
    this.classroomName,
    this.publishedAt,
    this.deletedAt,
    this.revision = 0,
    this.cachedAt,
  });

  final String id;
  final String classroomId;
  final String title;
  final String? description;

  /// yyyy-MM-dd wall-clock due date.
  final String dueDate;
  final String? dueTime;
  final bool hasExplicitTime;
  final AssignmentStatus status;
  final String? classroomName;
  final DateTime? publishedAt;
  final DateTime? deletedAt;
  final int revision;
  final DateTime? cachedAt;

  bool get isDeleted => deletedAt != null;
  bool get isVisibleToStudents =>
      status == AssignmentStatus.published && !isDeleted;

  Assignment copyWith({
    String? title,
    String? description,
    String? dueDate,
    String? dueTime,
    bool clearDueTime = false,
    bool? hasExplicitTime,
    AssignmentStatus? status,
    String? classroomName,
    DateTime? publishedAt,
    DateTime? deletedAt,
    int? revision,
    DateTime? cachedAt,
  }) {
    return Assignment(
      id: id,
      classroomId: classroomId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: clearDueTime ? null : dueTime ?? this.dueTime,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      status: status ?? this.status,
      classroomName: classroomName ?? this.classroomName,
      publishedAt: publishedAt ?? this.publishedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      revision: revision ?? this.revision,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}

class AssignmentProgress {
  const AssignmentProgress({
    required this.id,
    required this.accountId,
    required this.assignmentId,
    this.isCompleted = false,
    this.completedAt,
    this.revision = 0,
    this.syncStatus = SyncStatus.pending,
    this.updatedAt,
  });

  final String id;
  final String accountId;
  final String assignmentId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int revision;
  final SyncStatus syncStatus;
  final DateTime? updatedAt;

  AssignmentProgress copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    int? revision,
    SyncStatus? syncStatus,
    DateTime? updatedAt,
  }) {
    return AssignmentProgress(
      id: id,
      accountId: accountId,
      assignmentId: assignmentId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
