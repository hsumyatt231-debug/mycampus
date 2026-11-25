/// Base URL and REST paths for the MyCampus SQLite/SQLAlchemy API.
///
/// The URL is a compile-time environment value so the same code can run on a
/// desktop (`127.0.0.1`), an Android emulator (`10.0.2.2`) or a physical phone
/// on the LAN without editing Dart source:
///
/// ```powershell
/// flutter run -d windows --dart-define=MYCAMPUS_API_BASE_URL=http://127.0.0.1:8001/api/v1
/// flutter run --dart-define=MYCAMPUS_API_BASE_URL=http://10.0.2.2:8001/api/v1
/// ```
///
/// Register/login issue a bearer token that [HttpCloudGateway] attaches to
/// every protected request. The token is kept in the local settings store, so
/// no token/email/password dart-defines are needed.
abstract final class ApiConfig {
  /// Base URL including the `/api/v1` prefix. No trailing slash.
  static const String baseUrl = String.fromEnvironment(
    'MYCAMPUS_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8001/api/v1',
  );

  static bool get isConfigured => baseUrl.trim().isNotEmpty;

  /// Build a URL from an endpoint path, dropping empty query values.
  static Uri uri(String path, {Map<String, String?> query = const {}}) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final parameters = <String, String>{};
    query.forEach((key, value) {
      if (value != null && value.isNotEmpty) parameters[key] = value;
    });
    return Uri.parse('$base$path')
        .replace(queryParameters: parameters.isEmpty ? null : parameters);
  }

  // Auth (real accounts; responses carry a bearer token)
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authAdoptLocal = '/auth/adopt-local';
  static const String authChangePassword = '/auth/change-password';
  static const String authResetPassword = '/auth/reset-password';

  // Profile
  static const String profileTimezone = '/profile/timezone';

  // Sync
  static const String syncOperation = '/sync/operation';
  static const String syncPull = '/sync/pull';
  static const String syncStatus = '/sync/status';

  // Classrooms
  static const String classrooms = '/classrooms';
  static const String classroomJoin = '/classrooms/join';
  static String classroom(String id) =>
      '/classrooms/${Uri.encodeComponent(id)}';
  static String classroomBootstrap(String id) => '${classroom(id)}/bootstrap';
  static String classroomLeave(String id) => '${classroom(id)}/leave';
  static String classroomJoinCodeReset(String id) =>
      '${classroom(id)}/join-code/reset';
  static String classroomArchive(String id) => '${classroom(id)}/archive';
  static String classroomMember(String id) =>
      '/classrooms/members/${Uri.encodeComponent(id)}';
  static String classroomMemberUnblock(String id) =>
      '${classroomMember(id)}/unblock';

  // Assignments
  static const String assignments = '/assignments';
  static String classroomAssignments(String classroomId) =>
      '${classroom(classroomId)}/assignments';
  static String assignment(String id) =>
      '/assignments/${Uri.encodeComponent(id)}';
  static String assignmentProgress(String id) => '${assignment(id)}/progress';
}
