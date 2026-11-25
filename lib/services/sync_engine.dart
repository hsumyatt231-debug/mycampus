import 'dart:async';
import 'dart:math';

import '../models/enums.dart';
import '../repositories/sync_repository.dart';
import 'cloud_gateway.dart';

enum SyncRunOutcome { success, offline, conflicts, failed, skipped }

class SyncRunResult {
  const SyncRunResult({
    required this.outcome,
    required this.message,
    this.pushed = 0,
    this.conflicts = 0,
    this.pulled = 0,
  });

  final SyncRunOutcome outcome;
  final String message;
  final int pushed;
  final int conflicts;
  final int pulled;

  bool get isSuccess => outcome == SyncRunOutcome.success;
  bool get isOffline => outcome == SyncRunOutcome.offline;
}

class SyncEngineState {
  const SyncEngineState({
    this.running = false,
    this.pending = 0,
    this.conflicts = 0,
    this.lastResult,
    this.lastRunAt,
  });

  final bool running;
  final int pending;
  final int conflicts;
  final SyncRunResult? lastResult;
  final DateTime? lastRunAt;
}

/// Local-first reconciliation pipeline:
/// preflight pull -> ordered push -> final pull (FR-SYNC-004).
class SyncEngine {
  SyncEngine({required this._repository, required this._gateway});

  final SyncRepository _repository;
  final CloudGateway _gateway;
  final Random _random = Random();
  final StreamController<SyncEngineState> _states =
      StreamController<SyncEngineState>.broadcast();

  final Set<String> _runningAccounts = {};

  Stream<SyncEngineState> get states => _states.stream;

  bool get isConfigured => _gateway.isConfigured;

  bool isRunning(String accountId) => _runningAccounts.contains(accountId);

  Future<SyncRunResult> run(String accountId) async {
    if (!_gateway.isConfigured) {
      final pending = await _repository.queueCount(accountId);
      final conflicts = await _repository.conflictCount(accountId);
      final result = SyncRunResult(
        outcome: SyncRunOutcome.offline,
        message: pending == 0
            ? 'Everything is saved on this device.'
            : '$pending change${pending == 1 ? '' : 's'} saved on this device '
                  'and waiting to sync.',
        conflicts: conflicts,
      );
      await _emit(accountId, running: false, result: result);
      return result;
    }

    if (_runningAccounts.contains(accountId)) {
      return const SyncRunResult(
        outcome: SyncRunOutcome.skipped,
        message: 'A sync cycle is already running for this account.',
      );
    }

    _runningAccounts.add(accountId);
    await _emit(accountId, running: true);

    var pushed = 0;
    var conflicts = 0;
    var pulled = 0;

    try {
      // 1. Preflight pull.
      final preflight = await _pull(accountId);
      pulled += preflight;

      // 2. Ordered push with dependency passes.
      for (var pass = 0; pass < 8; pass++) {
        final queue = await _repository.orderedQueue(accountId);
        if (queue.isEmpty) break;

        var progressed = false;

        for (final operation in queue) {
          if (operation.status == SyncStatus.conflict) continue;
          if (operation.nextAttemptAt != null &&
              operation.nextAttemptAt!.isAfter(DateTime.now().toUtc())) {
            continue;
          }

          await _repository.markSending(operation.operationId);

          try {
            final outcome = await _gateway.pushOperation(operation);
            switch (outcome) {
              case PushApplied():
                await _repository.markPushed(operation, outcome);
                pushed++;
                progressed = true;
              case PushConflict():
                await _repository.markConflict(operation, outcome);
                conflicts++;
                progressed = true;
              case PushPermanentFailure():
                await _repository.markFailed(
                  operation,
                  error: outcome.reason,
                  permanent: true,
                  nextAttemptAt: null,
                );
                progressed = true;
            }
          } on CloudUnavailableException catch (error) {
            await _repository.markFailed(
              operation,
              error: error.message,
              permanent: false,
              nextAttemptAt: DateTime.now().toUtc().add(
                _backoff(operation.retryCount, shuffle: false),
              ),
            );
            await _repository.recordSyncError(accountId, error.message);
            return await _finish(
              accountId,
              SyncRunResult(
                outcome: SyncRunOutcome.offline,
                message: 'Connection lost. Local changes remain queued.',
                pushed: pushed,
                conflicts: conflicts,
                pulled: pulled,
              ),
            );
          } catch (error) {
            await _repository.markFailed(
              operation,
              error: error.toString(),
              permanent: false,
              nextAttemptAt: DateTime.now().toUtc().add(
                _backoff(operation.retryCount),
              ),
            );
            await _repository.recordSyncError(accountId, error.toString());
            return await _finish(
              accountId,
              SyncRunResult(
                outcome: SyncRunOutcome.failed,
                message: 'Sync paused: $error',
                pushed: pushed,
                conflicts: conflicts,
                pulled: pulled,
              ),
            );
          }
        }

        if (!progressed) break;
        conflicts = await _repository.conflictCount(accountId);
        if (conflicts > 0) break;
      }

      // 3. Final pull.
      pulled += await _pull(accountId);
      await _repository.recordPushSuccess(accountId);

      conflicts = await _repository.conflictCount(accountId);
      final pending = await _repository.queueCount(accountId);

      final result = SyncRunResult(
        outcome: conflicts > 0
            ? SyncRunOutcome.conflicts
            : pending > 0
            ? SyncRunOutcome.failed
            : SyncRunOutcome.success,
        message: conflicts > 0
            ? '$conflicts conflict${conflicts == 1 ? '' : 's'} need your '
                  'decision.'
            : pending > 0
            ? '$pending change${pending == 1 ? '' : 's'} could not be '
                  'sent.'
            : 'All changes synchronized.',
        pushed: pushed,
        conflicts: conflicts,
        pulled: pulled,
      );
      return await _finish(accountId, result);
    } on CloudUnavailableException catch (error) {
      await _repository.recordSyncError(accountId, error.message);
      return await _finish(
        accountId,
        SyncRunResult(
          outcome: SyncRunOutcome.offline,
          message: error.message,
          pushed: pushed,
          conflicts: conflicts,
          pulled: pulled,
        ),
      );
    } catch (error) {
      await _repository.recordSyncError(accountId, error.toString());
      return _finish(
        accountId,
        SyncRunResult(
          outcome: SyncRunOutcome.failed,
          message: 'Sync failed: $error',
          pushed: pushed,
          conflicts: conflicts,
          pulled: pulled,
        ),
      );
    }
  }

  Future<SyncRunResult> retryNow(String accountId) async {
    await _repository.retryFailed(accountId);
    return run(accountId);
  }

  Future<int> _pull(String accountId) async {
    var pulled = 0;
    var cursor = (await _repository.metadata(accountId)).cursor;

    for (var page = 0; page < 50; page++) {
      final result = await _gateway.pullChanges(
        accountId: accountId,
        cursor: cursor,
        pageSize: 200,
      );

      // Page + cursor commit atomically; a failed apply never advances it.
      await _repository.applyPullPage(
        accountId: accountId,
        changes: result.changes,
        nextCursor: result.nextCursor,
      );

      pulled += result.changes.length;
      cursor = result.nextCursor;

      if (!result.hasMore || cursor == null) break;
    }
    return pulled;
  }

  Duration _backoff(int retryCount, {bool shuffle = true}) {
    final seconds = min(300, pow(2, retryCount.clamp(0, 8)).toInt() * 2);
    final jitter = shuffle ? _random.nextInt(1000) : 0;
    return Duration(seconds: seconds, milliseconds: jitter);
  }

  Future<SyncRunResult> _finish(String accountId, SyncRunResult result) async {
    _runningAccounts.remove(accountId);
    await _emit(accountId, running: false, result: result);
    return result;
  }

  Future<void> _emit(
    String accountId, {
    required bool running,
    SyncRunResult? result,
  }) async {
    final pending = await _repository.queueCount(accountId);
    final conflicts = await _repository.conflictCount(accountId);
    if (_states.isClosed) return;
    _states.add(
      SyncEngineState(
        running: running,
        pending: pending,
        conflicts: conflicts,
        lastResult: result,
        lastRunAt: result == null ? null : DateTime.now(),
      ),
    );
  }

  Future<void> dispose() => _states.close();
}
