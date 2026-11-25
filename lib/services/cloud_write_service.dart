import '../models/sync_models.dart';
import '../repositories/settings_repository.dart';
import '../repositories/sync_repository.dart';
import 'cloud_gateway.dart';

/// Online-first delivery for a queued planner operation.
///
/// The local row and its queue entry are already committed by the caller.
/// When the API is configured, authenticated and reachable, this service
/// pushes that exact operation immediately and clears the queue entry on
/// success. Otherwise the queue entry stays exactly as it was for offline
/// use, and the Sync screen can drain it later.
class CloudWriteService {
  CloudWriteService(this._gateway, this._settings, this._sync);

  final CloudGateway _gateway;
  final SettingsRepository _settings;
  final SyncRepository _sync;

  /// Returns the acknowledged server revision when delivered online, or
  /// `null` when the operation remains queued for a later sync run.
  Future<int?> deliverNow(PendingOperation operation) async {
    // Callers deliver operations in local commit order. The sync engine still
    // honours dependsOn for older offline rows; a newer direct push that lands
    // out of order is reported as a conflict instead of overwriting cloud data.
    if (!_gateway.isConfigured) return null;

    final token = await _settings.cloudToken();
    if (token == null || token.isEmpty) return null;

    try {
      final outcome = await _gateway.pushOperation(operation);
      switch (outcome) {
        case PushApplied():
          await _sync.markPushed(operation, outcome);
          await _sync.recordPushSuccess(operation.accountId);
          return outcome.newRevision;
        case PushConflict():
          // Keep the local edit and let the conflict stay visible in Sync.
          await _sync.markConflict(operation, outcome);
          return null;
        case PushPermanentFailure():
          await _sync.markFailed(
            operation,
            error: outcome.reason,
            permanent: true,
            nextAttemptAt: null,
          );
          return null;
      }
    } on CloudUnavailableException {
      // Network is down: the committed queue entry is the offline fallback.
      return null;
    } on CloudRejectedException catch (error) {
      await _sync.markFailed(
        operation,
        error: error.message,
        permanent: true,
        nextAttemptAt: null,
      );
      return null;
    }
  }
}
