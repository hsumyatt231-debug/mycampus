import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/user_profile.dart';
import '../../repositories/account_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.profile,
    this.busy = false,
    this.error,
    this.notice,
    this.pendingOperations = 0,
  });

  final AuthStatus status;
  final UserProfile? profile;
  final bool busy;
  final String? error;
  final String? notice;
  final int pendingOperations;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isTeacher => profile?.role == UserRole.teacher;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? profile,
    bool? busy,
    String? error,
    String? notice,
    int? pendingOperations,
    bool clearError = false,
    bool clearNotice = false,
    bool clearProfile = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      profile: clearProfile ? null : profile ?? this.profile,
      busy: busy ?? this.busy,
      error: clearError ? null : error ?? this.error,
      notice: clearNotice ? null : notice ?? this.notice,
      pendingOperations: pendingOperations ?? this.pendingOperations,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    busy,
    error,
    notice,
    pendingOperations,
  ];
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  final String fullName;
  final String email;
  final String password;
  final UserRole role;

  @override
  List<Object?> get props => [fullName, email, password, role];
}

class AuthPasswordResetRequested extends AuthEvent {
  const AuthPasswordResetRequested({
    required this.email,
    required this.newPassword,
  });

  final String email;
  final String newPassword;

  @override
  List<Object?> get props => [email, newPassword];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested({this.discardPending = false});

  final bool discardPending;
}

class AuthProfileUpdated extends AuthEvent {
  const AuthProfileUpdated({required this.profile});

  final UserProfile profile;
}

class AuthErrorDismissed extends AuthEvent {
  const AuthErrorDismissed();
}

class AuthPendingCountRequested extends AuthEvent {
  const AuthPendingCountRequested();
}

class AuthNoticeDismissed extends AuthEvent {
  const AuthNoticeDismissed();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AccountRepository accountRepository})
    : _accounts = accountRepository,
      super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthPasswordResetRequested>(_onReset);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthProfileUpdated>(_onProfileUpdated);
    on<AuthPendingCountRequested>(_onPendingCount);
    on<AuthErrorDismissed>((_, emit) => emit(state.copyWith(clearError: true)));
    on<AuthNoticeDismissed>(
      (_, emit) => emit(state.copyWith(clearNotice: true)),
    );
  }

  final AccountRepository _accounts;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    try {
      final profile = await _accounts.restoreSession();
      if (profile == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }
      final pending = await _accounts.pendingOperationCount(profile.id);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: profile,
          pendingOperations: pending,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final profile = await _accounts.login(
        email: event.email,
        password: event.password,
      );
      final pending = await _accounts.pendingOperationCount(profile.id);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: profile,
          busy: false,
          pendingOperations: pending,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          busy: false,
          error: _message(error),
          status: AuthStatus.unauthenticated,
        ),
      );
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final profile = await _accounts.register(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        role: event.role,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          profile: profile,
          busy: false,
          pendingOperations: 0,
          notice: 'Account created in local-only mode.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          busy: false,
          error: _message(error),
          status: AuthStatus.unauthenticated,
        ),
      );
    }
  }

  Future<void> _onReset(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      await _accounts.resetPassword(
        email: event.email,
        newPassword: event.newPassword,
      );
      emit(
        state.copyWith(
          busy: false,
          notice: 'Password updated. Sign in with your new password.',
        ),
      );
    } catch (error) {
      emit(state.copyWith(busy: false, error: _message(error)));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) {
      emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearProfile: true),
      );
      return;
    }

    emit(state.copyWith(busy: true, clearError: true));
    try {
      final pending = await _accounts.pendingOperationCount(profile.id);
      if (pending > 0 && !event.discardPending) {
        emit(
          state.copyWith(
            busy: false,
            error:
                '$pending change${pending == 1 ? '' : 's'} still need to '
                'be synchronized. Choose Sync & Logout or Discard & Logout.',
          ),
        );
        return;
      }

      if (event.discardPending) {
        await _accounts.discardAndLogout(profile.id);
      } else {
        await _accounts.performLogout(profile.id);
      }

      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (error) {
      emit(state.copyWith(busy: false, error: _message(error)));
    }
  }

  Future<void> _onProfileUpdated(
    AuthProfileUpdated event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(profile: event.profile, clearError: true));
  }

  Future<void> _onPendingCount(
    AuthPendingCountRequested event,
    Emitter<AuthState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;
    final pending = await _accounts.pendingOperationCount(profile.id);
    emit(state.copyWith(pendingOperations: pending));
  }

  String _message(Object error) {
    final text = error.toString();
    return text.replaceFirst('Exception: ', '');
  }
}
