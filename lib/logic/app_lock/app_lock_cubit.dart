import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_profile.dart';
import '../../repositories/account_repository.dart';

/// Runtime lock state for the current session.
///
/// The SRS requires a lock on cold start, after 60 seconds in the background,
/// and whenever the device locks (DET-SEC-005/006). This build implements the
/// app-level shield and password re-entry; biometric device authentication is
/// a documented open verification item (TV-01/TV-02).
enum AppLockStatus { unlocked, locked, shielded }

class AppLockState extends Equatable {
  const AppLockState({
    this.status = AppLockStatus.unlocked,
    this.busy = false,
    this.error,
    this.unlockRequired = false,
  });

  final AppLockStatus status;
  final bool busy;
  final String? error;
  final bool unlockRequired;

  bool get isLocked => status == AppLockStatus.locked;

  AppLockState copyWith({
    AppLockStatus? status,
    bool? busy,
    String? error,
    bool? unlockRequired,
    bool clearError = false,
  }) {
    return AppLockState(
      status: status ?? this.status,
      busy: busy ?? this.busy,
      error: clearError ? null : error ?? this.error,
      unlockRequired: unlockRequired ?? this.unlockRequired,
    );
  }

  @override
  List<Object?> get props => [status, busy, error, unlockRequired];
}

/// Monotonic background timer. Wall-clock changes cannot bypass the lock.
class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit({
    required AccountRepository accountRepository,
    this.threshold = const Duration(seconds: 60),
  }) : _accounts = accountRepository,
       super(const AppLockState());

  final AccountRepository _accounts;
  final Duration threshold;
  final Stopwatch _background = Stopwatch();

  /// Called once the session is restored: cold start always requires unlock.
  void onSessionRestored(UserProfile? profile) {
    if (profile == null) {
      _background.reset();
      emit(const AppLockState());
      return;
    }
    emit(
      const AppLockState(status: AppLockStatus.locked, unlockRequired: true),
    );
  }

  void onSessionCleared() {
    _background.reset();
    emit(const AppLockState());
  }

  /// Hides sensitive content while the app is not foregrounded.
  void shield() {
    if (state.isLocked) return;
    emit(state.copyWith(status: AppLockStatus.shielded));
  }

  void background() {
    if (state.isLocked) return;
    _background
      ..reset()
      ..start();
    emit(state.copyWith(status: AppLockStatus.shielded));
  }

  void foreground() {
    if (state.isLocked) {
      _background.reset();
      return;
    }
    final elapsed = _background.elapsed;
    _background.reset();
    if (elapsed >= threshold) {
      emit(
        const AppLockState(status: AppLockStatus.locked, unlockRequired: true),
      );
    } else {
      emit(state.copyWith(status: AppLockStatus.unlocked));
    }
  }

  void lockNow() {
    emit(
      state.copyWith(
        status: AppLockStatus.locked,
        unlockRequired: true,
        clearError: true,
      ),
    );
  }

  Future<bool> unlock({
    required String accountId,
    required String password,
  }) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      final ok = await _accounts.verifyPassword(accountId, password);
      if (!ok) {
        emit(state.copyWith(busy: false, error: 'Incorrect password.'));
        return false;
      }
      await _accounts.refreshCloudToken(accountId, password);
      emit(const AppLockState(status: AppLockStatus.unlocked));
      return true;
    } catch (_) {
      emit(state.copyWith(busy: false, error: 'Unable to unlock.'));
      return false;
    }
  }
}
