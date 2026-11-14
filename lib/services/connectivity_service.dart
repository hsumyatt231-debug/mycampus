import 'dart:async';

/// Connectivity state used to drive sync eligibility UI.
///
/// The local-only build reports "offline" until a cloud gateway is configured.
/// Reconnection triggers a sync attempt through [SyncCoordinator]; background
/// delivery is explicitly not guaranteed (FR-SYNC-017).
class ConnectivityService {
  ConnectivityService({bool initiallyOnline = false})
    : _online = initiallyOnline;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _online;

  bool get isOnline => _online;

  Stream<bool> get onChanged => _controller.stream;

  void setOnline(bool value) {
    if (_online == value) return;
    _online = value;
    _controller.add(value);
  }

  Future<void> dispose() => _controller.close();
}
