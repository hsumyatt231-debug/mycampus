import 'dart:async';

/// Platform reminder scheduling abstraction.
///
/// Android local notifications (FR-REM-001) require `flutter_local_notifications`
/// and OS permission handling, which is a platform verification item. Windows
/// has no guaranteed OS delivery, so the in-app Reminder Center
/// (FR-REM-002) is the authoritative fallback. This implementation records
/// reminder state and exposes scheduling hooks without claiming delivery.
abstract interface class NotificationService {
  Future<void> initialize();

  Future<void> schedule({
    required String id,
    required DateTime at,
    required String title,
    required String body,
  });

  Future<void> cancel(String id);

  Future<void> cancelAll(Iterable<String> ids);
}

class InAppNotificationService implements NotificationService {
  final Map<String, DateTime> _scheduled = {};

  @override
  Future<void> initialize() async {}

  @override
  Future<void> schedule({
    required String id,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    _scheduled[id] = at;
  }

  @override
  Future<void> cancel(String id) async {
    _scheduled.remove(id);
  }

  @override
  Future<void> cancelAll(Iterable<String> ids) async {
    for (final id in ids) {
      _scheduled.remove(id);
    }
  }
}
