import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/subject.dart';
import '../../repositories/subject_repository.dart';
import '../../services/id_service.dart';

class SubjectsState extends Equatable {
  const SubjectsState({
    this.subjects = const [],
    this.loading = true,
    this.busy = false,
    this.error,
  });

  final List<Subject> subjects;
  final bool loading;
  final bool busy;
  final String? error;

  SubjectsState copyWith({
    List<Subject>? subjects,
    bool? loading,
    bool? busy,
    String? error,
    bool clearError = false,
  }) {
    return SubjectsState(
      subjects: subjects ?? this.subjects,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [subjects, loading, busy, error];
}

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit({required this._repository, required this._accountId})
    : super(const SubjectsState());

  final SubjectRepository _repository;
  final String _accountId;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final subjects = await _repository.getAll(_accountId);
      emit(state.copyWith(subjects: subjects, loading: false));
    } catch (error) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Unable to load subjects: $error',
        ),
      );
    }
  }

  Future<bool> create({
    required String name,
    required String code,
    int? colorValue,
    String? teacherName,
    String? room,
  }) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      final subject = Subject(
        id: IdService.newId(),
        accountId: _accountId,
        name: name,
        code: code,
        colorValue: colorValue ?? 0xFF6236F5,
        teacherName: teacherName,
        room: room,
      );
      await _repository.create(subject);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> update(Subject subject) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.update(subject);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<SubjectImpact?> impact(String subjectId) async {
    try {
      return await _repository.impact(_accountId, subjectId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String subjectId) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.delete(_accountId, subjectId);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  String _clean(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
