import '../models/enums.dart';

/// Requirement photos declared in `pubspec.yaml` and used by the approved
/// UI design gallery (Welcome, Role Selection, Registration and Home).
abstract final class AppImages {
  static const String campus = 'asset/image/campus.jpg';
  static const String student = 'asset/image/student.jpg';
  static const String teacher = 'asset/image/teacher.jpg';
  static const String both = 'asset/image/both.jpg';

  /// Role photo for the signed-in user (UI 05 greeting header).
  static String forRole(UserRole role) =>
      role == UserRole.teacher ? teacher : student;

  /// Role photo for the role-code used before registration.
  static String forRoleCode(String roleCode) =>
      roleCode == 'teacher' ? teacher : student;
}
