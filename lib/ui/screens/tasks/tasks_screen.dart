import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/tasks/tasks_cubit.dart';
import '../../../models/enums.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../../../repositories/subject_repository.dart';
import '../../../repositories/task_repository.dart';
import '../../../services/academic_clock.dart';
import '../../widgets/common.dart';
import '../../widgets/pickers.dart';
import '../../widgets/tab_header.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId = context.read<AuthBloc>().state.profile?.id;

    return BlocProvider(
      create: (_) => TasksCubit(
        taskRepository: context.read<TaskRepository>(),
        subjectRepository: context.read<SubjectRepository>(),
        accountId: accountId ?? '',
      )..load(),
      child: const _TasksView(),
    );
  }
}

class _TasksView extends StatefulWidget {
  const _TasksView();

  @override
  State<_TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<_TasksView> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openForm(Task? existing) async {
    final cubit = context.read<TasksCubit>();
    final state = cubit.state;
    final timeFormat =
        context.read<AuthBloc>().state.profile?.timeFormat ??
        TimeFormat.twelveHour;
    final draft = await showDialog<_TaskDraft>(
      context: context,
      builder: (_) => _TaskFormDialog(
        existing: existing,
        subjects: state.subjects,
        timeFormat: timeFormat,
      ),
    );
    if (draft == null || !mounted) return;

    final bool ok;
    if (existing == null) {
      ok = await cubit.create(
        title: draft.title,
        description: draft.description,
        subjectId: draft.subjectId,
        dueDate: draft.dueDate,
        dueTime: draft.dueTime,
        hasExplicitTime: draft.hasExplicitTime,
        priority: draft.priority,
        reminderOffsetMinutes: draft.reminderOffsetMinutes,
      );
    } else {
      ok = await cubit.update(
        Task(
          id: existing.id,
          accountId: existing.accountId,
          title: draft.title,
          description: draft.description,
          subjectId: draft.subjectId,
          dueDate: draft.dueDate,
          dueTime: draft.dueTime,
          hasExplicitTime: draft.hasExplicitTime,
          priority: draft.priority,
          status: existing.status,
          completedAt: existing.completedAt,
          reminderOffsetMinutes: draft.reminderOffsetMinutes,
          revision: existing.revision,
          syncStatus: existing.syncStatus,
          deletedAt: existing.deletedAt,
          updatedAt: existing.updatedAt,
        ),
      );
    }

    if (!ok && mounted) {
      showAppSnack(context, cubit.state.error ?? 'Unable to save task.');
    }
  }

  Future<void> _confirmDelete(Task task) async {
    final cubit = context.read<TasksCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete task?',
      message: '"${task.title}" will be removed from your planner.',
      confirmLabel: 'Delete task',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final ok = await cubit.delete(task);
    if (!ok && mounted) {
      showAppSnack(context, cubit.state.error ?? 'Unable to delete task.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();
    final state = context.watch<TasksCubit>().state;
    final profile = context.watch<AuthBloc>().state.profile;
    final timeFormat = profile?.timeFormat ?? TimeFormat.twelveHour;
    final timezone = profile?.academicTimezone ?? 'Asia/Yangon';
    final visible = state.visibleTasks;

    return AppPage(
      maxWidth: 1080,
      child: ListView(
        children: [
          TabHeader(
            title: 'Tasks',
            subtitle: state.tasks.isEmpty
                ? 'Capture everything you need to do'
                : '${state.pendingCount} pending · '
                      '${state.completedCount} completed',
            actions: [
              IconButton(
                tooltip: 'Add task',
                onPressed: () => _openForm(null),
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          if (!state.loading && state.subjects.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ErrorBanner(
                tone: BannerTone.info,
                message:
                    'Add a subject first to group your tasks. You can '
                    'still create general tasks without a subject.',
              ),
            ),
          if (state.error != null) ...[
            ErrorBanner(message: state.error!, onDismiss: () => cubit.load()),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _search,
            onChanged: (value) {
              cubit.search(value);
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search tasks',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _search.clear();
                        cubit.search('');
                        setState(() {});
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final filter in TasksFilter.values)
                ChoiceChip(
                  label: Text(switch (filter) {
                    TasksFilter.all => 'All',
                    TasksFilter.pending => 'Pending',
                    TasksFilter.completed => 'Completed',
                  }),
                  selected: state.filter == filter,
                  onSelected: (_) => cubit.setFilter(filter),
                ),
              const SizedBox(width: 4),
              _SubjectFilter(state: state, cubit: cubit),
              _SortMenu(state: state, cubit: cubit),
            ],
          ),
          const SizedBox(height: 14),
          if (state.loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (visible.isEmpty)
            AppCard(
              child: EmptyState(
                icon: state.tasks.isEmpty
                    ? Icons.task_alt_rounded
                    : Icons.filter_alt_off_outlined,
                title: state.tasks.isEmpty
                    ? 'No tasks yet'
                    : 'Nothing matches these filters',
                message: state.tasks.isEmpty
                    ? 'Tasks keep deadlines, reminders and priorities in one '
                          'place.'
                    : 'Try another status, subject or search keyword.',
                action: state.tasks.isEmpty
                    ? FilledButton.icon(
                        onPressed: () => _openForm(null),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add your first task'),
                      )
                    : null,
              ),
            )
          else
            Column(
              children: [
                for (final task in visible) ...[
                  _TaskCard(
                    task: task,
                    subject: state.subjectFor(task.subjectId),
                    timeFormat: timeFormat,
                    timezone: timezone,
                    onToggle: () => cubit.toggle(task),
                    onEdit: () => _openForm(task),
                    onDelete: () => _confirmDelete(task),
                  ),
                  const SizedBox(height: 9),
                ],
              ],
            ),
          const SizedBox(height: 8),
          const _TaskFooterNote(),
        ],
      ),
    );
  }
}

class _SubjectFilter extends StatelessWidget {
  const _SubjectFilter({required this.state, required this.cubit});

  final TasksState state;
  final TasksCubit cubit;

  @override
  Widget build(BuildContext context) {
    final value = state.subjectFilter ?? '__all__';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 190),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<String>(
            value: value,
            isDense: true,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
            items: [
              const DropdownMenuItem(
                value: '__all__',
                child: Text('All subjects'),
              ),
              const DropdownMenuItem(
                value: '__general__',
                child: Text('General'),
              ),
              for (final subject in state.subjects)
                DropdownMenuItem(value: subject.id, child: Text(subject.name)),
            ],
            onChanged: (next) {
              if (next == null || next == '__all__') {
                cubit.setSubjectFilter(null);
              } else {
                cubit.setSubjectFilter(next);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.state, required this.cubit});

  final TasksState state;
  final TasksCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 175),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<TasksSort>(
            value: state.sort,
            isDense: true,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
            items: const [
              DropdownMenuItem(
                value: TasksSort.dueDate,
                child: Text('Due date'),
              ),
              DropdownMenuItem(
                value: TasksSort.priority,
                child: Text('Priority'),
              ),
              DropdownMenuItem(value: TasksSort.title, child: Text('Title')),
              DropdownMenuItem(
                value: TasksSort.recentlyUpdated,
                child: Text('Recently updated'),
              ),
            ],
            onChanged: (value) {
              if (value != null) cubit.setSort(value);
            },
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.subject,
    required this.timeFormat,
    required this.timezone,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final Subject? subject;
  final TimeFormat timeFormat;
  final String timezone;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final completed = task.isCompleted;
    final due = task.dueDate == null
        ? null
        : AcademicClock.dueInstant(
            date: task.dueDate,
            time: task.hasExplicitTime ? task.dueTime : null,
            timezoneName: timezone,
          );
    final timeParts = AcademicClock.parseTimeParts(task.dueTime);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(6, 8, 4, 8),
      color: completed ? const Color(0xFFF8FBFF) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: completed,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: completed ? AppColors.textMuted : AppColors.navy,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (subject != null)
                        StatusChip(
                          label: subject!.code,
                          color: Color(subject!.colorValue),
                          background: Color(subject!.colorValue)
                              .withValues(alpha: 0.1),
                        )
                      else
                        const StatusChip(
                          label: 'General',
                          color: AppColors.textSecondary,
                          background: Color(0xFFF1F5F9),
                        ),
                      PriorityBadge(priority: task.priority),
                      if (task.dueDate != null)
                        _DueMeta(
                          label: task.hasExplicitTime
                              ? '${dateLabel(task.dueDate)} · '
                                    '${AcademicClock.formatTime(timeParts.$1, timeParts.$2, timeFormat)}'
                              : dateLabel(task.dueDate),
                          overdue:
                              due != null &&
                              due.isBefore(DateTime.now()) &&
                              !completed,
                        ),
                      if (task.reminderOffsetMinutes != null)
                        const _MetaIcon(
                          icon: Icons.notifications_active_outlined,
                          label: 'Reminder',
                        ),
                      if (completed && task.completedAt != null)
                        const _MetaIcon(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Done',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Task actions',
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
              if (value == 'toggle') onToggle();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    completed
                        ? Icons.undo_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 18,
                  ),
                  title: Text(completed ? 'Mark pending' : 'Mark complete'),
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit_outlined, size: 18),
                  title: Text('Edit task'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.danger,
                  ),
                  title: Text(
                    'Delete task',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DueMeta extends StatelessWidget {
  const _DueMeta({required this.label, required this.overdue});

  final String label;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          overdue ? Icons.warning_amber_rounded : Icons.event_outlined,
          size: 13,
          color: overdue ? AppColors.danger : AppColors.textMuted,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: overdue ? FontWeight.w700 : FontWeight.w500,
            color: overdue ? AppColors.danger : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _TaskFooterNote extends StatelessWidget {
  const _TaskFooterNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule_rounded, size: 16, color: AppColors.textMuted),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Deadlines without a time are due at the end of the day in '
              'your academic timezone. Completion is reversible.',
              style: TextStyle(
                fontSize: 11,
                height: 1.45,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskDraft {
  const _TaskDraft({
    required this.title,
    required this.priority,
    this.description,
    this.subjectId,
    this.dueDate,
    this.dueTime,
    this.hasExplicitTime = false,
    this.reminderOffsetMinutes,
  });

  final String title;
  final String? description;
  final String? subjectId;
  final String? dueDate;
  final String? dueTime;
  final bool hasExplicitTime;
  final TaskPriority priority;
  final int? reminderOffsetMinutes;
}

class _TaskFormDialog extends StatefulWidget {
  const _TaskFormDialog({
    required this.subjects,
    required this.timeFormat,
    this.existing,
  });

  final List<Subject> subjects;
  final TimeFormat timeFormat;
  final Task? existing;

  @override
  State<_TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<_TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late String? _subjectId;
  late String? _dueDate;
  late String? _dueTime;
  late bool _hasTime;
  late TaskPriority _priority;
  late int? _reminderOffset;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _subjectId = existing?.subjectId;
    _dueDate = existing?.dueDate;
    _dueTime = existing?.dueTime;
    _hasTime = existing?.hasExplicitTime ?? false;
    _priority = existing?.priority ?? TaskPriority.medium;
    _reminderOffset = existing?.reminderOffsetMinutes;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await pickDateKey(
      context,
      initial: _dueDate,
      helpText: 'Task deadline',
    );
    if (result == null) return;
    setState(() => _dueDate = result);
  }

  Future<void> _pickTime() async {
    final result = await pickTimeString(
      context,
      initial: _dueTime,
      helpText: 'Deadline time',
    );
    if (result == null) return;
    setState(() {
      _dueTime = result;
      _hasTime = true;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final description = _description.text.trim();
    Navigator.of(context).pop(
      _TaskDraft(
        title: _title.text.trim(),
        description: description.isEmpty ? null : description,
        subjectId: _subjectId,
        dueDate: _dueDate,
        dueTime: _hasTime ? _dueTime : null,
        hasExplicitTime: _hasTime && _dueDate != null,
        priority: _priority,
        reminderOffsetMinutes: _dueDate == null ? null : _reminderOffset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: Text(
        widget.existing == null ? 'Add task' : 'Edit task',
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: SizedBox(
        width: appDialogBodyWidth(context),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    hintText: 'e.g. Finish problem set 4',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a task title'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _subjectId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('General task'),
                    ),
                    for (final subject in widget.subjects)
                      DropdownMenuItem<String>(
                        value: subject.id,
                        child: Text('${subject.code} · ${subject.name}'),
                      ),
                  ],
                  onChanged: (value) => setState(() => _subjectId = value),
                ),
                const SizedBox(height: 12),
                AppFieldRow(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Due date',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: _dueDate == null
                              ? null
                              : IconButton(
                                  tooltip: 'Clear date',
                                  onPressed: () => setState(() {
                                    _dueDate = null;
                                    _hasTime = false;
                                    _dueTime = null;
                                    _reminderOffset = null;
                                  }),
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                        child: Text(
                          _dueDate == null
                              ? 'No deadline'
                              : dateLabel(_dueDate),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _dueDate == null
                                ? AppColors.textMuted
                                : AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _dueDate == null || !_hasTime ? null : _pickTime,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Due time',
                          prefixIcon: const Icon(Icons.schedule_outlined),
                        ),
                        child: Text(
                          _dueDate == null || !_hasTime
                              ? 'End of day'
                              : _dueTime == null
                              ? 'Set time'
                              : () {
                                  final parts = AcademicClock.parseTimeParts(
                                    _dueTime,
                                  );
                                  return AcademicClock.formatTime(
                                    parts.$1,
                                    parts.$2,
                                    widget.timeFormat,
                                  );
                                }(),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _dueDate != null && _hasTime
                                ? AppColors.navy
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_dueDate != null) ...[
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _hasTime,
                    onChanged: (value) => setState(() {
                      _hasTime = value;
                      if (!value) _dueTime = null;
                    }),
                    title: const Text(
                      'Set a specific time',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Otherwise the task is due at the end of the day.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      for (final priority in TaskPriority.values)
                        DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    initialValue: _reminderOffset,
                    decoration: const InputDecoration(
                      labelText: 'Reminder',
                      prefixIcon: Icon(Icons.notifications_none_rounded),
                    ),
                    items: const [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('No reminder'),
                      ),
                      DropdownMenuItem<int?>(
                        value: 0,
                        child: Text('At deadline'),
                      ),
                      DropdownMenuItem<int?>(
                        value: 10,
                        child: Text('10 minutes before'),
                      ),
                      DropdownMenuItem<int?>(
                        value: 30,
                        child: Text('30 minutes before'),
                      ),
                      DropdownMenuItem<int?>(
                        value: 60,
                        child: Text('1 hour before'),
                      ),
                      DropdownMenuItem<int?>(
                        value: 1440,
                        child: Text('1 day before'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _reminderOffset = value),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      for (final priority in TaskPriority.values)
                        DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _priority = value);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.existing == null ? 'Add task' : 'Save changes'),
        ),
      ],
    );
  }
}
