import 'enums.dart';

class ClassroomMember {
  const ClassroomMember({
    required this.id,
    required this.classroomId,
    required this.studentId,
    required this.status,
    this.studentName,
    this.studentEmail,
    this.rejoinBlocked = false,
    this.joinedAt,
    this.endedAt,
  });

  final String id;
  final String classroomId;
  final String studentId;
  final MembershipStatus status;
  final String? studentName;
  final String? studentEmail;
  final bool rejoinBlocked;
  final DateTime? joinedAt;
  final DateTime? endedAt;

  bool get isActive => status == MembershipStatus.active;

  ClassroomMember copyWith({
    MembershipStatus? status,
    bool? rejoinBlocked,
    DateTime? endedAt,
  }) {
    return ClassroomMember(
      id: id,
      classroomId: classroomId,
      studentId: studentId,
      status: status ?? this.status,
      studentName: studentName,
      studentEmail: studentEmail,
      rejoinBlocked: rejoinBlocked ?? this.rejoinBlocked,
      joinedAt: joinedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }
}

class MembershipEvent {
  const MembershipEvent({
    required this.id,
    required this.classroomId,
    required this.membershipId,
    required this.performedBy,
    required this.type,
    required this.createdAt,
    this.studentName,
  });

  final String id;
  final String classroomId;
  final String membershipId;
  final String performedBy;
  final MembershipEventType type;
  final DateTime createdAt;
  final String? studentName;
}
