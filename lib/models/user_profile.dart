import 'enums.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.academicTimezone = 'Asia/Yangon',
    this.timeFormat = TimeFormat.twelveHour,
    this.emailVerified = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String academicTimezone;
  final TimeFormat timeFormat;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? fullName,
    String? academicTimezone,
    TimeFormat? timeFormat,
    bool? emailVerified,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      role: role,
      academicTimezone: academicTimezone ?? this.academicTimezone,
      timeFormat: timeFormat ?? this.timeFormat,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'role': role.code,
    'academic_timezone': academicTimezone,
    'time_format': timeFormat.code,
    'email_verified': emailVerified,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: UserRole.fromCode(json['role'] as String?),
      academicTimezone: json['academic_timezone'] as String? ?? 'Asia/Yangon',
      timeFormat: TimeFormat.fromCode(json['time_format'] as String?),
      emailVerified: json['email_verified'] as bool? ?? true,
    );
  }
}
