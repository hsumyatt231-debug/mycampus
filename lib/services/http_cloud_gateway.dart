import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_config.dart';
import '../models/sync_models.dart' show PendingOperation;
import 'cloud_gateway.dart';

/// REST implementation of [CloudGateway] backed by the SQLite/SQLAlchemy API.
///
/// A bearer token (returned by register/login and stored in settings) is
/// attached to protected calls so the API resolves the signed-in account.
/// Pushes keep the original local Drift account id so the payload fingerprint
/// matches the one computed when the operation was enqueued.
class HttpCloudGateway implements CloudGateway {
  HttpCloudGateway({
    http.Client? client,
    this.tokenProvider,
    this._timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Future<String?> Function()? tokenProvider;
  final Duration _timeout;

  @override
  bool get isConfigured => ApiConfig.isConfigured;

  @override
  Future<Map<String, dynamic>> cloudLogin({
    required String email,
    required String password,
  }) async {
    return _object(
      await _sendRaw(
        'POST',
        ApiConfig.authLogin,
        authenticated: false,
        body: {'email': email, 'password': password},
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> cloudRegister({
    required String id,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    return _object(
      await _sendRaw(
        'POST',
        ApiConfig.authRegister,
        authenticated: false,
        body: <String, dynamic>{
          'id': id,
          'full_name': fullName,
          'email': email,
          'password': password,
          'role': role,
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> cloudAdoptLocal({
    required String id,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    return _object(
      await _sendRaw(
        'POST',
        ApiConfig.authAdoptLocal,
        authenticated: false,
        body: <String, dynamic>{
          'id': id,
          'full_name': fullName,
          'email': email,
          'password': password,
          'role': role,
        },
      ),
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _sendRaw(
      'POST',
      ApiConfig.authChangePassword,
      body: <String, dynamic>{
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await _sendRaw(
      'POST',
      ApiConfig.authResetPassword,
      authenticated: false,
      body: <String, dynamic>{'email': email, 'new_password': newPassword},
    );
  }

  Future<http.Response> _sendRaw(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?> query = const {},
    bool authenticated = true,
  }) async {
    final uri = ApiConfig.uri(path, query: query);
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (authenticated) {
      final token = await tokenProvider?.call();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);

    late http.Response response;
    try {
      final streamed = await _client.send(request).timeout(_timeout);
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw CloudUnavailableException(
        'The MyCampus API at ${ApiConfig.baseUrl} did not respond in time.',
      );
    } catch (error) {
      throw CloudUnavailableException(
        'Cannot reach the MyCampus API at ${ApiConfig.baseUrl}: $error',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw CloudRejectedException(
      _errorMessage(response.statusCode, response.body),
    );
  }

  static String _errorMessage(int status, String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final error = decoded['error'];
        if (error is Map) {
          final message = error['message']?.toString();
          if (message != null && message.isNotEmpty) return '$status: $message';
        }
        final detail = decoded['detail']?.toString();
        if (detail != null && detail.isNotEmpty) return '$status: $detail';
      }
    } catch (_) {
      // Fall through to the raw body below.
    }
    final snippet = body.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (snippet.isEmpty) return 'The API returned $status.';
    return '$status: ${snippet.length > 240 ? snippet.substring(0, 240) : snippet}';
  }

  static Map<String, dynamic>? _mapOrNull(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static Map<String, dynamic> _object(http.Response response) {
    if (response.body.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      // Handled below with a stable exception type.
    }
    throw const CloudRejectedException(
      'The API returned an unexpected JSON object response.',
    );
  }

  static List<Map<String, dynamic>> _objects(http.Response response) {
    if (response.body.trim().isEmpty) return const <Map<String, dynamic>>[];
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } on FormatException {
      // Handled below with a stable exception type.
    }
    throw const CloudRejectedException(
      'The API returned an unexpected JSON list response.',
    );
  }

  // ---------------------------------------------------------------------------
  // Sync
  // ---------------------------------------------------------------------------

  @override
  Future<PushOutcome> pushOperation(PendingOperation operation) async {
    // PendingOperation.payload is the whole envelope written by
    // PendingOperationWriter. The API expects the inner domain object in
    // `data`, and the fingerprint was computed over that inner object plus
    // the original local account id. Send both unchanged so the server can
    // recompute the same fingerprint (FR-SYNC-002).
    final envelope = operation.payload;
    final inner = envelope['data'];
    final data = inner is Map ? Map<String, dynamic>.from(inner) : envelope;

    final response = await _sendRaw(
      'POST',
      ApiConfig.syncOperation,
      body: <String, dynamic>{
        'operation_id': operation.operationId,
        'account_id': operation.accountId,
        'entity': operation.entity.code,
        'entity_id': operation.entityId,
        'type': operation.type.code,
        'base_revision': operation.baseRevision,
        'fingerprint': operation.fingerprint,
        'data': data,
      },
    );
    final result = _object(response);
    switch (result['status']) {
      case 'applied':
        return PushApplied(
          newRevision: (result['new_revision'] as num?)?.toInt() ?? 0,
          payload: _mapOrNull(result['payload']),
        );
      case 'conflict':
        final cloud = _mapOrNull(result['payload']);
        if (cloud == null) {
          throw const CloudRejectedException(
            'The conflict response did not include the cloud payload.',
          );
        }
        return PushConflict(cloudPayload: cloud);
      case 'failed':
        return PushPermanentFailure(
          result['reason']?.toString() ?? 'The server rejected the operation.',
        );
      default:
        throw CloudRejectedException(
          'Unknown push status: ${result['status']}.',
        );
    }
  }

  @override
  Future<PullPage> pullChanges({
    required String accountId,
    String? cursor,
    int pageSize = 200,
  }) async {
    // Ownership comes from the bearer token; the local account id stays part
    // of the gateway interface only for the local-first engine.
    final response = await _sendRaw(
      'GET',
      ApiConfig.syncPull,
      query: {'cursor': cursor, 'page_size': pageSize.toString()},
    );
    final data = _object(response);
    final rawChanges = data['changes'];
    final changes = <CloudChange>[];
    if (rawChanges is List) {
      for (final item in rawChanges.whereType<Map>()) {
        final change = Map<String, dynamic>.from(item);
        changes.add(
          CloudChange(
            changeId: change['change_id']?.toString() ?? '',
            entity: change['entity']?.toString() ?? '',
            entityId: change['entity_id']?.toString() ?? '',
            changeType: change['change_type']?.toString() ?? 'update',
            revision: (change['revision'] as num?)?.toInt() ?? 0,
            payload: _mapOrNull(change['payload']),
            ownerAccountId: change['owner_account_id']?.toString(),
            classroomId: change['classroom_id']?.toString(),
            revoked: change['revoked'] as bool? ?? false,
          ),
        );
      }
    }
    return PullPage(
      changes: changes,
      nextCursor: data['next_cursor']?.toString(),
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  @override
  Future<void> changeAcademicTimezone({
    required String accountId,
    required String timezone,
  }) async {
    await _sendRaw(
      'POST',
      ApiConfig.profileTimezone,
      body: {'academic_timezone': timezone},
    );
  }

  // ---------------------------------------------------------------------------
  // Classrooms
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> fetchClassrooms() async =>
      _objects(await _sendRaw('GET', ApiConfig.classrooms));

  @override
  Future<Map<String, dynamic>> createClassroom({
    required String name,
    required String subjectName,
    String? description,
  }) async {
    return _object(
      await _sendRaw(
        'POST',
        ApiConfig.classrooms,
        body: <String, dynamic>{
          'name': name,
          'subject_name': subjectName,
          'description': ?description,
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> joinClassroom(String code) async {
    return _object(
      await _sendRaw('POST', ApiConfig.classroomJoin, body: {'code': code}),
    );
  }

  @override
  Future<void> leaveClassroom(String classroomId) async {
    await _sendRaw('POST', ApiConfig.classroomLeave(classroomId));
  }

  @override
  Future<Map<String, dynamic>> fetchClassroomDetail(String classroomId) async =>
      _object(await _sendRaw('GET', ApiConfig.classroom(classroomId)));

  @override
  Future<void> removeMember(String membershipId) async {
    await _sendRaw('DELETE', ApiConfig.classroomMember(membershipId));
  }

  @override
  Future<void> unblockMember(String membershipId) async {
    await _sendRaw('POST', ApiConfig.classroomMemberUnblock(membershipId));
  }

  @override
  Future<String> resetJoinCode(String classroomId) async {
    final data = _object(
      await _sendRaw('POST', ApiConfig.classroomJoinCodeReset(classroomId)),
    );
    final code = data['join_code']?.toString() ?? '';
    if (code.isEmpty) {
      throw const CloudRejectedException('The API did not return a join code.');
    }
    return code;
  }

  @override
  Future<void> archiveClassroom(String classroomId) async {
    await _sendRaw('POST', ApiConfig.classroomArchive(classroomId));
  }

  @override
  Future<Map<String, dynamic>> bootstrapScope({
    required String classroomId,
    String? cursor,
  }) async {
    return _object(
      await _sendRaw(
        'GET',
        ApiConfig.classroomBootstrap(classroomId),
        query: {'cursor': cursor},
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Assignments
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> fetchMyAssignments() async =>
      _objects(await _sendRaw('GET', ApiConfig.assignments));

  @override
  Future<Map<String, dynamic>> createAssignment({
    required String classroomId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    bool publish = false,
  }) async {
    return _object(
      await _sendRaw(
        'POST',
        ApiConfig.classroomAssignments(classroomId),
        body: <String, dynamic>{
          'title': title,
          'due_date': dueDate,
          'publish': publish,
          'description': ?description,
          'due_time': ?dueTime,
        },
      ),
    );
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
    return _object(
      await _sendRaw(
        'PATCH',
        ApiConfig.assignment(assignmentId),
        body: <String, dynamic>{
          'title': title,
          'due_date': dueDate,
          'description': ?description,
          'due_time': ?dueTime,
          'status': ?status,
        },
      ),
    );
  }

  @override
  Future<void> deleteAssignment(String assignmentId) async {
    await _sendRaw('DELETE', ApiConfig.assignment(assignmentId));
  }

  @override
  Future<void> setAssignmentProgress({
    required String assignmentId,
    required bool completed,
    required String operationId,
  }) async {
    await _sendRaw(
      'POST',
      ApiConfig.assignmentProgress(assignmentId),
      body: {'completed': completed, 'operation_id': operationId},
    );
  }
}
