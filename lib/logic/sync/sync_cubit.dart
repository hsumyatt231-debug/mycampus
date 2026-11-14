import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/sync_models.dart';
import '../../repositories/sync_repository.dart';
import '../../services/sync_engine.dart';

class SyncState extends Equatable {
  const SyncState({
    this.loading = false,
    this.running = false,
    this.configured = false,
    this.pending = 0,
    this.conflicts = 0,
    this.queue = const [],
    this.conflictItems = const [],
    this.metadata,
    this.message,
    this.lastRunAt,
    this.bound = false,
  });

  final bool loading;
  final bool running;
  final bool configured;
  final int pending;
  final int conflicts;
  final List<PendingOperation> queue;
  final List<SyncConflict> conflictItems;
  final SyncMetadata? metadata;
  final String? message;
  final DateTime? lastRunAt;
  final bool bound;

  SyncState copyWith({
    bool? loading,
    bool? running,
    bool? configured,
    int? pending,
    int? conflicts,
    List<PendingOperation>? queue,
    List<SyncConflict>? conflictItems,
    SyncMetadata? metadata,
    String? message,
    DateTime? lastRunAt,
    bool? bound,
    bool clearMessage = false,
  }) {
    return SyncState(
      loading: loading ?? this.loading,
      running: running ?? this.running,
      configured: configured ?? this.configured,
      pending: pending ?? this.pending,
      conflicts: conflicts ?? this.conflicts,
      queue: queue ?? this.queue,
      conflictItems: conflictItems ?? this.conflictItems,
      metadata: metadata ?? this.metadata,
      message: clearMessage ? null : message ?? this.message,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      bound: bound ?? this.bound,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    running,
    configured,
    pending,
    conflicts,
    queue,
    conflictItems,
    metadata,
    message,
    lastRunAt,
    bound,
  ];
}

class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required this._engine,
    required this._repository,
    required Stream<void> changes,
  }) : super(const SyncState()) {
    _changes = changes.listen((_) => _scheduleReload());
  }

  final SyncEngine _engine;
  final SyncRepository _repository;

  StreamSubscription<void>? _changes;
  Timer? _reloadTimer;
  bool _reloading = false;

  String? _accountId;

  String? get accountId => _accountId;

  /// Refreshes the queue counters when another repository writes a record and
  /// its pending operation, so the header badge stays accurate without a
  /// manual sync visit. Debounced because a single user action writes several
  /// rows (record, outbox, metadata).
  void _scheduleReload() {
    _reloadTimer?.cancel();
    _reloadTimer = Timer(const Duration(milliseconds: 250), () {
      if (_accountId == null || state.running || _reloading) return;
      unawaited(_refresh());
    });
  }

  Future<void> _refresh() async {
    _reloading = true;
    try {
      await load();
    } finally {
      _reloading = false;
    }
  }

  @override
  Future<void> close() async {
    _reloadTimer?.cancel();
    await _changes?.cancel();
    return super.close();
  }

  Future<void> bind(String accountId) async {
    if (_accountId == accountId && state.bound) {
      await load();
      return;
    }
    _accountId = accountId;
    emit(state.copyWith(bound: true));
    await load();
  }

  Future<void> unbind() async {
    _accountId = null;
    emit(const SyncState());
  }

  Future<void> load() async {
    final id = _accountId;
    if (id == null) return;

    emit(state.copyWith(loading: true));
    final metadata = await _repository.metadata(id);
    final pending = await _repository.queueCount(id);
    final conflicts = await _repository.conflictCount(id);
    final queue = await _repository.queue(id);
    final conflictItems = await _repository.conflicts(id);

    emit(
      state.copyWith(
        loading: false,
        bound: true,
        configured: _engine.isConfigured,
        pending: pending,
        conflicts: conflicts,
        queue: queue,
        conflictItems: conflictItems,
        metadata: metadata,
      ),
    );
  }

  Future<SyncRunResult?> syncNow() async {
    final id = _accountId;
    if (id == null) return null;

    emit(state.copyWith(running: true, clearMessage: true));
    final result = await _engine.run(id);
    await load();
    emit(
      state.copyWith(
        running: false,
        message: result.message,
        lastRunAt: DateTime.now(),
      ),
    );
    return result;
  }

  Future<void> retryFailed() async {
    final id = _accountId;
    if (id == null) return;

    emit(state.copyWith(running: true, clearMessage: true));
    final result = await _engine.retryNow(id);
    await load();
    emit(
      state.copyWith(
        running: false,
        message: result.message,
        lastRunAt: DateTime.now(),
      ),
    );
  }

  Future<void> resolve(SyncConflict conflict, String resolution) async {
    final id = _accountId;
    if (id == null) return;

    await _repository.resolveConflict(
      conflict,
      resolution: resolution,
      accountId: id,
    );
    await load();
  }

  void clearMessage() {
    emit(state.copyWith(clearMessage: true));
  }

  String labelFor(PendingOperation operation) {
    final action = operation.type.label;
    return '$action ${operation.entity.label.toLowerCase()}';
  }
}
