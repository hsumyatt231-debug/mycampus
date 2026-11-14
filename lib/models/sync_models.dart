import 'enums.dart';

/// A durable, account-scoped queue entry (FR-SYNC-001/002/013).
class PendingOperation {
  const PendingOperation({
    required this.operationId,
    required this.accountId,
    required this.entity,
    required this.entityId,
    required this.type,
    required this.payload,
    required this.fingerprint,
    this.baseRevision = 0,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
    this.lastError,
    this.dependsOn,
    this.createdAt,
    this.updatedAt,
    this.nextAttemptAt,
  });

  final String operationId;
  final String accountId;
  final SyncEntity entity;
  final String entityId;
  final SyncOperationType type;
  final Map<String, dynamic> payload;

  /// Stable hash of the payload; retries must reuse it (FR-SYNC-002).
  final String fingerprint;
  final int baseRevision;
  final int retryCount;
  final SyncStatus status;
  final String? lastError;

  /// Prior operation that must be acknowledged first.
  final String? dependsOn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? nextAttemptAt;

  PendingOperation copyWith({
    int? retryCount,
    SyncStatus? status,
    String? lastError,
    bool clearLastError = false,
    DateTime? updatedAt,
    DateTime? nextAttemptAt,
  }) {
    return PendingOperation(
      operationId: operationId,
      accountId: accountId,
      entity: entity,
      entityId: entityId,
      type: type,
      payload: payload,
      fingerprint: fingerprint,
      baseRevision: baseRevision,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      lastError: clearLastError ? null : lastError ?? this.lastError,
      dependsOn: dependsOn,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    );
  }
}

/// Conflict between a local edit and an authorized cloud revision.
class SyncConflict {
  const SyncConflict({
    required this.id,
    required this.accountId,
    required this.entity,
    required this.entityId,
    required this.localPayload,
    required this.cloudPayload,
    this.createdAt,
    this.resolvedAt,
    this.resolution,
  });

  final String id;
  final String accountId;
  final SyncEntity entity;
  final String entityId;
  final Map<String, dynamic> localPayload;
  final Map<String, dynamic> cloudPayload;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  /// 'local' or 'cloud'.
  final String? resolution;

  bool get isResolved => resolvedAt != null;
}

class SyncMetadata {
  const SyncMetadata({
    required this.accountId,
    this.cursor,
    this.lastPullAt,
    this.lastPushAt,
    this.lastError,
  });

  final String accountId;
  final String? cursor;
  final DateTime? lastPullAt;
  final DateTime? lastPushAt;
  final String? lastError;

  SyncMetadata copyWith({
    String? cursor,
    DateTime? lastPullAt,
    DateTime? lastPushAt,
    String? lastError,
    bool clearError = false,
  }) {
    return SyncMetadata(
      accountId: accountId,
      cursor: cursor ?? this.cursor,
      lastPullAt: lastPullAt ?? this.lastPullAt,
      lastPushAt: lastPushAt ?? this.lastPushAt,
      lastError: clearError ? null : lastError ?? this.lastError,
    );
  }
}
