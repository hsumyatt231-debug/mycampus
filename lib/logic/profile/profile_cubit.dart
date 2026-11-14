import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/user_profile.dart';
import '../../repositories/account_repository.dart';

class ProfileState extends Equatable {
  const ProfileState({this.busy = false, this.error, this.notice});

  final bool busy;
  final String? error;
  final String? notice;

  ProfileState copyWith({
    bool? busy,
    String? error,
    String? notice,
    bool clearError = false,
    bool clearNotice = false,
  }) {
    return ProfileState(
      busy: busy ?? this.busy,
      error: clearError ? null : error ?? this.error,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [busy, error, notice];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._accounts) : super(const ProfileState());

  final AccountRepository _accounts;

  Future<UserProfile?> updateName(UserProfile profile, String name) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final updated = await _accounts.updateFullName(profile, name);
      emit(state.copyWith(busy: false, notice: 'Name updated.'));
      return updated;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return null;
    }
  }

  Future<UserProfile?> updateTimeFormat(
    UserProfile profile,
    TimeFormat format,
  ) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final updated = await _accounts.updateTimeFormat(profile, format);
      emit(
        state.copyWith(
          busy: false,
          notice: 'Time format set to ${format.label}.',
        ),
      );
      return updated;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return null;
    }
  }

  /// Online-only and blocked while edits are queued (FR-PROFILE-002).
  Future<UserProfile?> changeTimezone(
    UserProfile profile,
    String timezone,
  ) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final updated = await _accounts.changeAcademicTimezone(profile, timezone);
      emit(
        state.copyWith(
          busy: false,
          notice: 'Academic timezone updated to $timezone.',
        ),
      );
      return updated;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return null;
    }
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearNotice: true));
  }

  String _clean(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
