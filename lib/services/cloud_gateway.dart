import '../models/sync_models.dart';
import 'id_service.dart';

/// Result of pushing one queued operation to the cloud.
sealed class PushOutcome {
  const PushOutcome();
}

class PushApplied extends PushOutcome {
  const PushApplied({required this.newRevision, this.payload});

  final int newRevision;
  final Map<String, dynamic>? payload;
}

class PushConflict extends PushOutcome {
  const PushConflict({required this.cloudPayload});

  final Map<String, dynamic> cloudPayload;
}

class PushPermanentFailure extends PushOutcome {
  const PushPermanentFailure(this.reason);

  final String reason;
}

class PullPage {
  const PullPage({
    required this.changes,
    required this.nextCursor,
    required this.hasMore,
  });

  final List<CloudChange> changes;
  final String? nextCursor;
  final bool hasMore;
}

class CloudChange {
  const CloudChange({
    required this.changeId,
    required this.entity,
    required this.entityId,
    required this.changeType,
    required this.revision,
    this.payload,
    this.ownerAccountId,
    this.classroomId,
    this.revoked = false,
  });

  final String changeId;
  final String entity;
  final String entityId;

  /// create | update | delete | revoke
  final String changeType;
  final int revision;
  final Map<String, dynamic>? payload;
  final String? ownerAccountId;
  final String? classroomId;

  /// Revocation events reach former members without protected payloads
  /// (FR-SYNC-008).
  final bool revoked;
}

class CloudUnavailableException implements Exception {
  const CloudUnavailableException([
    this.message = 'The cloud backend is not configured on this build.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class CloudRejectedException implements Exception {
  const CloudRejectedException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Cloud surface required by the local-first engine and classroom features.
abstract interface class CloudGateway {
  bool get isConfigured;

  Future<PushOutcome> pushOperation(PendingOperation operation);

  Future<PullPage> pullChanges({
    required String accountId,
    String? cursor,
    int pageSize,
  });

  Future<void> changeAcademicTimezone({
    required String accountId,
    required String timezone,
  });

  // Classroom membership (online-only).
  Future<List<Map<String, dynamic>>> fetchClassrooms();
  Future<Map<String, dynamic>> createClassroom({
    required String name,
    required String subjectName,
    String? description,
  });
  Future<Map<String, dynamic>> joinClassroom(String code);
  Future<void> leaveClassroom(String classroomId);
  Future<Map<String, dynamic>> fetchClassroomDetail(String classroomId);
  Future<void> removeMember(String membershipId);
  Future<void> unblockMember(String membershipId);
  Future<String> resetJoinCode(String classroomId);
  Future<void> archiveClassroom(String classroomId);

  // Assignments.
  Future<List<Map<String, dynamic>>> fetchMyAssignments();
  Future<Map<String, dynamic>> createAssignment({
    required String classroomId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    bool publish = false,
  });
  Future<Map<String, dynamic>> updateAssignment({
    required String assignmentId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    String? status,
  });
  Future<void> deleteAssignment(String assignmentId);
  Future<void> setAssignmentProgress({
    required String assignmentId,
    required bool completed,
    required String operationId,
  });

  Future<Map<String, dynamic>> bootstrapScope({
    required String classroomId,
    String? cursor,
  });
}

/// Local-only gateway. Every cloud operation reports that the backend is
/// unavailable; queued personal operations stay pending and retryable.
class OfflineCloudGateway implements CloudGateway {
  const OfflineCloudGateway();

  @override
  bool get isConfigured => false;

  @override
  Future<PushOutcome> pushOperation(PendingOperation operation) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<PullPage> pullChanges({
    required String accountId,
    String? cursor,
    int pageSize = 200,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> changeAcademicTimezone({
    required String accountId,
    required String timezone,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchClassrooms() async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> createClassroom({
    required String name,
    required String subjectName,
    String? description,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> joinClassroom(String code) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> leaveClassroom(String classroomId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> fetchClassroomDetail(String classroomId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> removeMember(String membershipId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> unblockMember(String membershipId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<String> resetJoinCode(String classroomId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> archiveClassroom(String classroomId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMyAssignments() async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> createAssignment({
    required String classroomId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    bool publish = false,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> updateAssignment({
    required String assignmentId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    String? status,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> deleteAssignment(String assignmentId) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<void> setAssignmentProgress({
    required String assignmentId,
    required bool completed,
    required String operationId,
  }) async {
    throw const CloudUnavailableException();
  }

  @override
  Future<Map<String, dynamic>> bootstrapScope({
    required String classroomId,
    String? cursor,
  }) async {
    throw const CloudUnavailableException();
  }
}

/// Builds a pending-operation payload from a domain JSON map with the stable
/// operation envelope fields the server validates.
Map<String, dynamic> operationPayload({
  required String accountId,
  required String entity,
  required String entityId,
  required String type,
  required Map<String, dynamic> data,
}) {
  return {
    'operation_id': IdService.newId(),
    'account_id': accountId,
    'entity': entity,
    'entity_id': entityId,
    'type': type,
    'data': data,
  };
}
