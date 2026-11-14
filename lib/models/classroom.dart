class Classroom {
  const Classroom({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.subjectName,
    this.description,
    this.joinCode,
    this.timezone = 'Asia/Yangon',
    this.archived = false,
    this.teacherName,
    this.cachedAt,
  });

  final String id;
  final String teacherId;
  final String name;
  final String subjectName;
  final String? description;

  /// System-generated join code (never user-editable).
  final String? joinCode;

  /// Immutable timezone inherited from the teacher at creation.
  final String timezone;
  final bool archived;
  final String? teacherName;
  final DateTime? cachedAt;

  Classroom copyWith({
    String? name,
    String? subjectName,
    String? description,
    String? joinCode,
    bool? archived,
    String? teacherName,
    DateTime? cachedAt,
  }) {
    return Classroom(
      id: id,
      teacherId: teacherId,
      name: name ?? this.name,
      subjectName: subjectName ?? this.subjectName,
      description: description ?? this.description,
      joinCode: joinCode ?? this.joinCode,
      timezone: timezone,
      archived: archived ?? this.archived,
      teacherName: teacherName ?? this.teacherName,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
