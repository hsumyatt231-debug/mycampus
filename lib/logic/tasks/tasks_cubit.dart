import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/subject.dart';
import '../../models/task.dart';
import '../../repositories/subject_repository.dart';
import '../../repositories/task_repository.dart';
import '../../services/id_service.dart';

enum TasksFilter { all, pending, completed }

enum TasksSort { dueDate, priority, title, recentlyUpdated }

class TasksState extends Equatable {
  const TasksState({
    this.tasks = const [],
    this.subjects = const [],
    this.loading = true,
    this.busy = false,
    this.error,
    this.query = '',
    this.filter = TasksFilter.all,
    this.subjectFilter,
    this.sort = TasksSort.dueDate,
  });

  final List<Task> tasks;
  final List<Subject> subjects;
  final bool loading;
  final bool busy;
  final String? error;
  final String query;
  final TasksFilter filter;
  final String? subjectFilter;
  final TasksSort sort;

  TasksState copyWith({
    List<Task>? tasks,
    List<Subject>? subjects,
    bool? loading,
    bool? busy,
    String? error,
    String? query,
    TasksFilter? filter,
    String? subjectFilter,
    bool clearSubjectFilter = false,
    TasksSort? sort,
    bool clearError = false,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      subjects: subjects ?? this.subjects,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      error: clearError ? null : error ?? this.error,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      subjectFilter: clearSubjectFilter
          ? null
          : subjectFilter ?? this.subjectFilter,
      sort: sort ?? this.sort,
    );
  }

  List<Task> get visibleTasks {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = tasks.where((task) {
      switch (filter) {
        case TasksFilter.pending:
          if (task.isCompleted) return false;
          break;
        case TasksFilter.completed:
          if (!task.isCompleted) return false;
          break;
        case TasksFilter.all:
          break;
      }

      if (subjectFilter != null) {
        if (subjectFilter == '__general__') {
          if (task.subjectId != null) return false;
        } else if (task.subjectId != subjectFilter) {
          return false;
        }
      }

      if (normalizedQuery.isEmpty) return true;
      return task.title.toLowerCase().contains(normalizedQuery) ||
          (task.description ?? '').toLowerCase().contains(normalizedQuery);
    }).toList();

    filtered.sort(_compare);
    return filtered;
  }

  int _compare(Task a, Task b) {
    switch (sort) {
      case TasksSort.dueDate:
        final aKey = a.dueDate ?? '9999-12-31';
        final bKey = b.dueDate ?? '9999-12-31';
        final byDate = aKey.compareTo(bKey);
        if (byDate != 0) return byDate;
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case TasksSort.priority:
        final byPriority = b.priority.index.compareTo(a.priority.index);
        if (byPriority != 0) return byPriority;
        final aKey = a.dueDate ?? '9999-12-31';
        final bKey = b.dueDate ?? '9999-12-31';
        return aKey.compareTo(bKey);
      case TasksSort.title:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case TasksSort.recentlyUpdated:
        final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
    }
  }

  Subject? subjectFor(String? subjectId) {
    if (subjectId == null) return null;
    for (final subject in subjects) {
      if (subject.id == subjectId) return subject;
    }
    return null;
  }

  int get pendingCount => tasks.where((task) => !task.isCompleted).length;

  int get completedCount => tasks.where((task) => task.isCompleted).length;

  @override
  List<Object?> get props => [
    tasks,
    subjects,
    loading,
    busy,
    error,
    query,
    filter,
    subjectFilter,
    sort,
  ];
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required TaskRepository taskRepository,
    required SubjectRepository subjectRepository,
    required this._accountId,
  }) : _tasks = taskRepository,
       _subjects = subjectRepository,
       super(const TasksState());

  final TaskRepository _tasks;
  final SubjectRepository _subjects;
  final String _accountId;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final tasks = await _tasks.getAll(_accountId);
      final subjects = await _subjects.getAll(_accountId);
      emit(state.copyWith(tasks: tasks, subjects: subjects, loading: false));
    } catch (error) {
      emit(state.copyWith(loading: false, error: _clean(error)));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void setFilter(TasksFilter filter) => emit(state.copyWith(filter: filter));

  void setSort(TasksSort sort) => emit(state.copyWith(sort: sort));

  void setSubjectFilter(String? subjectId) {
    if (subjectId == null) {
      emit(state.copyWith(clearSubjectFilter: true));
    } else {
      emit(state.copyWith(subjectFilter: subjectId));
    }
  }

  Future<bool> create({
    required String title,
    String? description,
    String? subjectId,
    String? dueDate,
    String? dueTime,
    bool hasExplicitTime = false,
    TaskPriority priority = TaskPriority.medium,
    int? reminderOffsetMinutes,
  }) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _tasks.create(
        Task(
          id: IdService.newId(),
          accountId: _accountId,
          title: title,
          description: description,
          subjectId: subjectId,
          dueDate: dueDate,
          dueTime: dueTime,
          hasExplicitTime: hasExplicitTime,
          priority: priority,
          reminderOffsetMinutes: reminderOffsetMinutes,
        ),
      );
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> update(Task task) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _tasks.update(task);
      await load();
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      emit(state.copyWith(busy: false, error: _clean(error)));
      return false;
    }
  }

  Future<bool> toggle(Task task) async {
    emit(state.copyWith(clearError: true));
    try {
      await _tasks.setCompletion(task, completed: !task.isCompleted);
      await load();
      return true;
    } catch (error) {
      emit(state.copyWith(error: _clean(error)));
      return false;
    }
  }

  Future<bool> delete(Task task) async {
    emit(state.copyWith(busy: true, clearError: true));
    try {
      await _tasks.delete(task);
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
