import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/assignment.dart';
import '../../models/classroom.dart';
import '../../models/classroom_member.dart';
import '../../repositories/assignment_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../services/cloud_gateway.dart';

class ClassroomsState extends Equatable {
  const ClassroomsState({
    this.classrooms = const [],
    this.loading = true,
    this.busy = false,
    this.configured = false,
    this.error,
    this.notice,
    this.detail,
    this.members = const [],
    this.events = const [],
    this.assignments = const [],
    this.progress = const {},
    this.selectedId,
  });

  final List<Classroom> classrooms;
  final bool loading;
  final bool busy;
  final bool configured;
  final String? error;
  final String? notice;
  final Classroom? detail;
  final List<ClassroomMember> members;
  final List<MembershipEvent> events;
  final List<Assignment> assignments;
  final Map<String, AssignmentProgress> progress;
  final String? selectedId;

  ClassroomsState copyWith({
    List<Classroom>? classrooms,
    bool? loading,
    bool? busy,
    bool? configured,
    String? error,
    String? notice,
    Classroom? detail,
    bool clearDetail = false,
    List<ClassroomMember>? members,
    List<MembershipEvent>? events,
    List<Assignment>? assignments,
    Map<String, AssignmentProgress>? progress,
    String? selectedId,
    bool clearError = false,
    bool clearNotice = false,
  }) {
    return ClassroomsState(
      classrooms: classrooms ?? this.classrooms,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      configured: configured ?? this.configured,
      error: clearError ? null : error ?? this.error,
      notice: clearNotice ? null : notice ?? this.notice,
      detail: clearDetail ? null : detail ?? this.detail,
      members: members ?? this.members,
      events: events ?? this.events,
      assignments: assignments ?? this.assignments,
      progress: progress ?? this.progress,
      selectedId: selectedId ?? this.selectedId,
    );
  }

  bool isCompleted(String assignmentId) =>
      progress[assignmentId]?.isCompleted ?? false;

  List<ClassroomMember> get activeMembers =>
      members.where((member) => member.isActive).toList()..sort(
        (a, b) => (a.studentName ?? '').toLowerCase().compareTo(
          (b.studentName ?? '').toLowerCase(),
        ),
      );

  List<ClassroomMember> get inactiveMembers =>
      members.where((member) => !member.isActive).toList();

  List<Assignment> get publishedAssignments => assignments
      .where((assignment) => assignment.isVisibleToStudents)
      .toList();

  @override
  List<Object?> get props => [
    classrooms,
    loading,
    busy,
    configured,
    error,
    notice,
    detail,
    members,
    events,
    assignments,
    progress,
    selectedId,
  ];
}

class ClassroomsCubit extends Cubit<ClassroomsState> {
  ClassroomsCubit({
    required this._repository,
    required this._assignments,
    required this._accountId,
  }) : super(const ClassroomsState());

  final ClassroomRepository _repository;
  final AssignmentRepository _assignments;
  final String _accountId;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final classrooms = await _repository.cachedClassrooms(_accountId);
      final progress = await _assignments.progressFor(_accountId);
      emit(
        state.copyWith(
          classrooms: classrooms,
          progress: progress,
          loading: false,
          configured: _repository.isCloudConfigured,
        ),
      );
    } catch (error) {
      emit(state.copyWith(loading: false, error: _clean(error)));
    }
  }

  Future<void> refresh() async {
    if (!_repository.isCloudConfigured) {
      emit(
        state.copyWith(
          error:
              'Classrooms need a connection to refresh. Showing the last '
              'saved data.',
          configured: false,
        ),
      );
      return;
    }

    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final classrooms = await _repository.refreshMyClassrooms(_accountId);
      emit(
        state.copyWith(classrooms: classrooms, busy: false, configured: true),
      );
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
    }
  }

  Future<bool> create({
    required String name,
    required String subjectName,
    String? description,
  }) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      await _repository.createClassroom(
        accountId: _accountId,
        name: name,
        subjectName: subjectName,
        description: description,
      );
      await refresh();
      emit(state.copyWith(busy: false, notice: 'Classroom created.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> join(String code) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final classroom = await _repository.joinClassroom(
        accountId: _accountId,
        code: code,
      );
      await load();
      emit(state.copyWith(busy: false, notice: 'Joined ${classroom.name}.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> leave(String classroomId) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.leaveClassroom(_accountId, classroomId);
      await load();
      emit(state.copyWith(busy: false, notice: 'You left the classroom.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<void> openDetail(String classroomId) async {
    emit(state.copyWith(selectedId: classroomId, busy: true, clearError: true));

    if (!_repository.isCloudConfigured) {
      final classroom = await _repository.cachedClassroom(
        _accountId,
        classroomId,
      );
      final members = await _repository.cachedMembers(_accountId, classroomId);
      final events = await _repository.cachedEvents(_accountId, classroomId);
      final assignments = await _assignments.cached(
        _accountId,
        classroomId: classroomId,
      );
      final progress = await _assignments.progressFor(_accountId);

      emit(
        state.copyWith(
          busy: false,
          detail: classroom,
          members: members,
          events: events,
          assignments: assignments,
          progress: progress,
          error: classroom == null
              ? 'Classroom details are not cached on this device.'
              : null,
        ),
      );
      return;
    }

    try {
      final detail = await _repository.refreshDetail(_accountId, classroomId);
      final progress = await _assignments.progressFor(_accountId);
      emit(
        state.copyWith(
          busy: false,
          detail: detail.classroom,
          members: detail.members,
          events: detail.events,
          assignments: detail.assignments,
          progress: progress,
          configured: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
    }
  }

  Future<bool> removeMember(String membershipId) async {
    final classroomId = state.selectedId;
    if (classroomId == null) return false;
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.removeMember(
        accountId: _accountId,
        classroomId: classroomId,
        membershipId: membershipId,
      );
      await openDetail(classroomId);
      emit(state.copyWith(busy: false, notice: 'Member removed.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> unblockMember(String membershipId) async {
    final classroomId = state.selectedId;
    if (classroomId == null) return false;
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.unblockMember(
        accountId: _accountId,
        classroomId: classroomId,
        membershipId: membershipId,
      );
      await openDetail(classroomId);
      emit(state.copyWith(busy: false, notice: 'Member may rejoin.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<String?> resetJoinCode() async {
    final classroomId = state.selectedId;
    if (classroomId == null) return null;
    emit(state.copyWith(busy: true, clearError: true));
    try {
      final code = await _repository.resetJoinCode(_accountId, classroomId);
      await openDetail(classroomId);
      emit(state.copyWith(busy: false, notice: 'Join code reset.'));
      return code;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return null;
    }
  }

  Future<bool> archive() async {
    final classroomId = state.selectedId;
    if (classroomId == null) return false;
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _repository.archiveClassroom(_accountId, classroomId);
      await load();
      await openDetail(classroomId);
      emit(
        state.copyWith(
          busy: false,
          notice: 'Classroom archived. It is now read-only.',
        ),
      );
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> createAssignment({
    required String classroomId,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    required bool publish,
  }) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      await _assignments.createAssignment(
        accountId: _accountId,
        classroomId: classroomId,
        title: title,
        dueDate: dueDate,
        description: description,
        dueTime: dueTime,
        publish: publish,
      );
      await openDetail(classroomId);
      emit(
        state.copyWith(
          busy: false,
          notice: publish ? 'Assignment published.' : 'Draft saved.',
        ),
      );
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> updateAssignment({
    required Assignment assignment,
    required String title,
    required String dueDate,
    String? description,
    String? dueTime,
    String? status,
  }) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      await _assignments.updateAssignment(
        accountId: _accountId,
        assignmentId: assignment.id,
        title: title,
        dueDate: dueDate,
        description: description,
        dueTime: dueTime,
        status: status,
      );
      await openDetail(assignment.classroomId);
      emit(state.copyWith(busy: false, notice: 'Assignment updated.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> deleteAssignment(Assignment assignment) async {
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      await _assignments.deleteAssignment(_accountId, assignment.id);
      await openDetail(assignment.classroomId);
      emit(state.copyWith(busy: false, notice: 'Assignment deleted.'));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> toggleProgress(Assignment assignment) async {
    emit(state.copyWith(clearError: true));
    try {
      await _assignments.setProgress(
        accountId: _accountId,
        assignment: assignment,
        completed: !state.isCompleted(assignment.id),
      );
      final progress = await _assignments.progressFor(_accountId);
      emit(state.copyWith(progress: progress));
      return true;
    } catch (error) {
      emit(state.copyWith(error: _clean(error)));
      return false;
    }
  }

  void dismissMessage() {
    emit(state.copyWith(clearError: true, clearNotice: true));
  }

  String _clean(Object error) {
    if (error is CloudUnavailableException) return error.message;
    return error.toString().replaceFirst('Exception: ', '');
  }
}
