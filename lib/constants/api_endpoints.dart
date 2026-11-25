/// Legacy Supabase table/RPC names kept for reference only.
///
/// The active cloud surface is the SQLite/SQLAlchemy REST API described in
/// `ApiConfig`; this class is no longer used by any gateway. See
/// `lib/constants/api_config.dart` for the live endpoints.
abstract final class ApiEndpoints {
  // Auth (Supabase Auth handles these directly).
  static const String signUp = 'auth/sign-up';
  static const String signIn = 'auth/sign-in';
  static const String resetPassword = 'auth/recover';

  // Personal planner tables (RLS owner-only).
  static const String profiles = 'profiles';
  static const String subjects = 'subjects';
  static const String tasks = 'tasks';
  static const String timetableEntries = 'timetable_entries';
  static const String academicEvents = 'academic_events';

  // Classroom tables.
  static const String classrooms = 'classrooms';
  static const String classroomMembers = 'classroom_members';
  static const String classroomMembershipEvents = 'classroom_membership_events';
  static const String assignments = 'assignments';
  static const String assignmentProgress = 'assignment_progress';

  // Restricted supporting tables.
  static const String classroomJoinCodes = 'classroom_join_codes';
  static const String syncOperations = 'sync_operations';
  static const String syncChangeLog = 'sync_change_log';

  // Security-definer RPCs.
  static const String rpcCreateClassroom = 'rpc_create_classroom';
  static const String rpcJoinClassroom = 'rpc_join_classroom';
  static const String rpcLeaveClassroom = 'rpc_leave_classroom';
  static const String rpcRemoveMember = 'rpc_remove_member';
  static const String rpcUnblockMember = 'rpc_unblock_member';
  static const String rpcResetJoinCode = 'rpc_reset_join_code';
  static const String rpcArchiveClassroom = 'rpc_archive_classroom';
  static const String rpcPublishAssignment = 'rpc_publish_assignment';
  static const String rpcDeleteAssignment = 'rpc_delete_assignment';
  static const String rpcSetAssignmentProgress = 'rpc_set_assignment_progress';
  static const String rpcPullChanges = 'rpc_pull_changes';
  static const String rpcPushOperation = 'rpc_push_operation';
  static const String rpcBootstrapScope = 'rpc_bootstrap_scope';
  static const String rpcChangeAcademicTimezone =
      'rpc_change_academic_timezone';
}
