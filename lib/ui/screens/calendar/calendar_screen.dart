import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/calendar/calendar_cubit.dart';
import '../../../models/academic_event.dart';
import '../../../models/assignment.dart';
import '../../../models/dashboard_data.dart';
import '../../../models/enums.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../../../models/timetable_entry.dart';
import '../../../repositories/assignment_repository.dart';
import '../../../repositories/event_repository.dart';
import '../../../repositories/subject_repository.dart';
import '../../../repositories/task_repository.dart';
import '../../../repositories/timetable_repository.dart';
import '../../../services/academic_clock.dart';
import '../../widgets/common.dart';
import '../../widgets/pickers.dart';
import '../../widgets/tab_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId = context.read<AuthBloc>().state.profile?.id;

    return BlocProvider(
      create: (_) => CalendarCubit(
        taskRepository: context.read<TaskRepository>(),
        eventRepository: context.read<EventRepository>(),
        timetableRepository: context.read<TimetableRepository>(),
        subjectRepository: context.read<SubjectRepository>(),
        assignmentRepository: context.read<AssignmentRepository>(),
        accountId: accountId ?? '',
      )..load(),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  Future<void> _openEventForm(
    BuildContext context,
    AcademicEvent? existing,
  ) async {
    final cubit = context.read<CalendarCubit>();
    final state = cubit.state;
    final draft = await showDialog<_EventDraft>(
      context: context,
      builder: (_) => _EventFormDialog(
        existing: existing,
        initialDate: state.activeDateKey,
      ),
    );
    if (draft == null || !context.mounted) return;

    final bool ok;
    if (existing == null) {
      ok = await cubit.createEvent(
        title: draft.title,
        type: draft.type,
        eventDate: draft.eventDate,
        startTime: draft.startTime,
        endTime: draft.endTime,
        description: draft.description,
        location: draft.location,
        reminderOffsetMinutes: draft.reminderOffsetMinutes,
      );
    } else {
      ok = await cubit.updateEvent(
        AcademicEvent(
          id: existing.id,
          accountId: existing.accountId,
          title: draft.title,
          type: draft.type,
          eventDate: draft.eventDate,
          startTime: draft.startTime,
          endTime: draft.endTime,
          description: draft.description,
          location: draft.location,
          reminderOffsetMinutes: draft.reminderOffsetMinutes,
          revision: existing.revision,
          syncStatus: existing.syncStatus,
          deletedAt: existing.deletedAt,
          updatedAt: existing.updatedAt,
        ),
      );
    }

    if (!ok && context.mounted) {
      showAppSnack(context, cubit.state.error ?? 'Unable to save event.');
    }
  }

  Future<void> _openTimetableForm(
    BuildContext context,
    TimetableEntry? existing,
  ) async {
    final cubit = context.read<CalendarCubit>();
    final state = cubit.state;
    if (state.subjects.isEmpty) {
      showAppSnack(context, 'Add a subject before adding a timetable class.');
      return;
    }

    final selectedWeekday = DateTime.parse(state.activeDateKey).weekday;
    final draft = await showDialog<_TimetableDraft>(
      context: context,
      builder: (_) => _TimetableFormDialog(
        existing: existing,
        subjects: state.subjects,
        defaultWeekday: selectedWeekday >= 1 && selectedWeekday <= 5
            ? selectedWeekday
            : 1,
        timeFormat:
            context.read<AuthBloc>().state.profile?.timeFormat ??
            TimeFormat.twelveHour,
      ),
    );
    if (draft == null || !context.mounted) return;

    final candidate = TimetableEntry(
      id: existing?.id ?? 'preview',
      accountId: existing?.accountId ?? '',
      subjectId: draft.subjectId,
      weekday: draft.weekday,
      startMinutes: draft.startMinutes,
      endMinutes: draft.endMinutes,
      room: draft.room,
    );
    final overlaps = await cubit.overlapping(candidate);
    if (overlaps.isNotEmpty && context.mounted) {
      final names = overlaps
          .map((entry) => state.subjectFor(entry.subjectId)?.name ?? 'Class')
          .toSet()
          .join(', ');
      final proceed = await showConfirmDialog(
        context,
        title: 'Time conflict',
        message: 'This class overlaps with $names. Save the entry anyway?',
        confirmLabel: 'Save anyway',
      );
      if (!proceed) return;
    }

    final bool ok;
    if (existing == null) {
      ok = await cubit.createTimetableEntry(
        subjectId: draft.subjectId,
        weekday: draft.weekday,
        startMinutes: draft.startMinutes,
        endMinutes: draft.endMinutes,
        room: draft.room,
      );
    } else {
      ok = await cubit.updateTimetableEntry(
        TimetableEntry(
          id: existing.id,
          accountId: existing.accountId,
          subjectId: draft.subjectId,
          weekday: draft.weekday,
          startMinutes: draft.startMinutes,
          endMinutes: draft.endMinutes,
          room: draft.room,
          revision: existing.revision,
          syncStatus: existing.syncStatus,
          deletedAt: existing.deletedAt,
          updatedAt: existing.updatedAt,
        ),
      );
    }

    if (!ok && context.mounted) {
      showAppSnack(
        context,
        cubit.state.error ?? 'Unable to save timetable entry.',
      );
    }
  }

  Future<void> _deleteEvent(BuildContext context, AcademicEvent event) async {
    final cubit = context.read<CalendarCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete event?',
      message: '"${event.title}" will be removed from your calendar.',
      confirmLabel: 'Delete event',
      destructive: true,
    );
    if (!confirmed) return;
    await cubit.deleteEvent(event);
  }

  Future<void> _deleteTimetableEntry(
    BuildContext context,
    TimetableEntry entry,
  ) async {
    final cubit = context.read<CalendarCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove class?',
      message:
          'This timetable entry will be removed from every matching '
          'weekday.',
      confirmLabel: 'Remove class',
      destructive: true,
    );
    if (!confirmed) return;
    await cubit.deleteTimetableEntry(entry);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CalendarCubit>().state;
    final cubit = context.read<CalendarCubit>();
    final profile = context.watch<AuthBloc>().state.profile;
    final timeFormat = profile?.timeFormat ?? TimeFormat.twelveHour;
    final activeDate = DateTime.parse(state.activeDateKey);
    final weekday = activeDate.weekday;
    final dayItems = state.itemsFor(state.activeDateKey);
    final timetableEntries = state.timetableFor(weekday);

    return AppPage(
      maxWidth: 1080,
      child: ListView(
        children: [
          TabHeader(
            title: 'Calendar',
            subtitle: profile == null
                ? 'Plan classes, events and deadlines'
                : '${profile.academicTimezone} · Sunday–Saturday month view',
            actions: [
              IconButton(
                tooltip: 'Add event',
                onPressed: () => _openEventForm(context, null),
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          if (state.error != null) ...[
            ErrorBanner(message: state.error!, onDismiss: () => cubit.load()),
            const SizedBox(height: 12),
          ],
          _MonthCard(state: state, cubit: cubit, timeFormat: timeFormat),
          const SizedBox(height: 12),
          _DayCard(
            state: state,
            timeFormat: timeFormat,
            onAddEvent: () => _openEventForm(context, null),
            onEditEvent: (event) => _openEventForm(context, event),
            onDeleteEvent: (event) => _deleteEvent(context, event),
            dayItems: dayItems,
          ),
          const SizedBox(height: 12),
          _TimetableCard(
            state: state,
            entries: timetableEntries,
            weekday: weekday,
            timeFormat: timeFormat,
            onToggle: cubit.toggleTimetable,
            onAdd: () => _openTimetableForm(context, null),
            onEdit: (entry) => _openTimetableForm(context, entry),
            onDelete: (entry) => _deleteTimetableEntry(context, entry),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({
    required this.state,
    required this.cubit,
    required this.timeFormat,
  });

  final CalendarState state;
  final CalendarCubit cubit;
  final TimeFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    final month = state.activeMonth;
    final first = DateTime(month.year, month.month, 1);
    final leading = first.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = ((leading + daysInMonth + 6) ~/ 7) * 7;
    final todayKey = AcademicClock.dateKey(DateTime.now());
    final selected = state.activeDateKey;
    // The month header pairs two icon buttons and the Today action; on the
    // narrowest phones the label needs a smaller size to stay on one line.
    final narrow = MediaQuery.sizeOf(context).width < 380;
    // Keep day cells a sensible height at every width: tiny on phones, but
    // not 100px+ tall when the card stretches across a desktop window.
    final gridWidth = (MediaQuery.sizeOf(context).width - 24).clamp(
      0.0,
      1056.0,
    );
    final cellRatio = (gridWidth / 7 / 46).clamp(0.95, 2.0);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => cubit.changeMonth(-1),
                icon: const Icon(Icons.chevron_left_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.infoSoft,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AcademicClock.monthLabel(month),
                    style: TextStyle(
                      fontSize: narrow ? 15 : 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final now = DateTime.now();
                  cubit.selectDate(AcademicClock.dateKey(now));
                },
                child: const Text('Today'),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () => cubit.changeMonth(1),
                icon: const Icon(Icons.chevron_right_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.infoSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: cellRatio,
            ),
            itemBuilder: (context, index) {
              final date = first
                  .subtract(Duration(days: leading))
                  .add(Duration(days: index));
              final key = AcademicClock.dateKey(date);
              final inMonth = date.month == month.month;
              final count = state.countFor(key);

              return _DayCell(
                day: date.day,
                inMonth: inMonth,
                isToday: key == todayKey,
                isSelected: key == selected,
                count: count,
                onTap: () => cubit.selectDate(key),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.count,
    required this.onTap,
  });

  final int day;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Colors.white
        : inMonth
        ? AppColors.navy
        : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: isSelected ? AppColors.primaryBright : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isToday && !isSelected
                    ? AppColors.primaryBright
                    : Colors.transparent,
                width: 1.3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday || isSelected
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 5,
                  child: count == 0
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < (count > 3 ? 3 : count); i++)
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryBright,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.state,
    required this.timeFormat,
    required this.onAddEvent,
    required this.onEditEvent,
    required this.onDeleteEvent,
    required this.dayItems,
  });

  final CalendarState state;
  final TimeFormat timeFormat;
  final VoidCallback onAddEvent;
  final ValueChanged<AcademicEvent> onEditEvent;
  final ValueChanged<AcademicEvent> onDeleteEvent;
  final CalendarDayItems dayItems;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    final date = DateTime.parse(state.activeDateKey);
    final isToday =
        state.activeDateKey == AcademicClock.dateKey(DateTime.now());
    final weekdayIndex = date.weekday - 1;
    const weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday
                          ? 'Today · ${weekdayNames[weekdayIndex]}'
                          : weekdayNames[weekdayIndex],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AcademicClock.formatDateKey(
                        state.activeDateKey,
                        pattern: 'MMMM d, yyyy',
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onAddEvent,
                icon: const Icon(Icons.add_rounded, size: 17),
                label: const Text('Event'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (dayItems.total == 0)
            const EmptyState(
              compact: true,
              icon: Icons.event_available_outlined,
              title: 'Nothing planned',
              message: 'Add an event or a task deadline for this day.',
            )
          else ...[
            for (final task in dayItems.tasks) ...[
              _TaskRow(task: task, timeFormat: timeFormat),
              if (task != dayItems.tasks.last ||
                  dayItems.assignments.isNotEmpty ||
                  dayItems.events.isNotEmpty)
                const Divider(height: 14, color: AppColors.border),
            ],
            for (final assignment in dayItems.assignments) ...[
              _AssignmentRow(
                assignment: assignment,
                completed: state.completedAssignments.contains(assignment.id),
                timeFormat: timeFormat,
                onToggle: () => cubit.toggleAssignment(assignment),
              ),
              if (assignment != dayItems.assignments.last ||
                  dayItems.events.isNotEmpty)
                const Divider(height: 14, color: AppColors.border),
            ],
            for (final event in dayItems.events) ...[
              _EventRow(
                event: event,
                timeFormat: timeFormat,
                onEdit: () => onEditEvent(event),
                onDelete: () => onDeleteEvent(event),
              ),
              if (event != dayItems.events.last)
                const Divider(height: 14, color: AppColors.border),
            ],
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.timeFormat});

  final Task task;
  final TimeFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    return Row(
      children: [
        Icon(
          task.isCompleted
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 18,
          color: task.isCompleted ? AppColors.success : AppColors.textSecondary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              Text(
                'Task${task.hasExplicitTime ? ' · ${_time(task.dueTime)}' : ' · end of day'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Checkbox(
          value: task.isCompleted,
          onChanged: (_) => cubit.toggleTask(task),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  String _time(String? value) {
    final parts = AcademicClock.parseTimeParts(value);
    return AcademicClock.formatTime(parts.$1, parts.$2, timeFormat);
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.assignment,
    required this.completed,
    required this.timeFormat,
    required this.onToggle,
  });

  final Assignment assignment;
  final bool completed;
  final TimeFormat timeFormat;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final parts = AcademicClock.parseTimeParts(assignment.dueTime);
    return Row(
      children: [
        const Icon(
          Icons.assignment_outlined,
          size: 18,
          color: AppColors.warning,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                '${assignment.classroomName ?? 'Assignment'} · '
                '${assignment.hasExplicitTime ? AcademicClock.formatTime(parts.$1, parts.$2, timeFormat) : 'end of day'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Checkbox(
          value: completed,
          onChanged: (_) => onToggle(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.timeFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final AcademicEvent event;
  final TimeFormat timeFormat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final start = event.startTime == null
        ? null
        : AcademicClock.parseTimeParts(event.startTime);
    final end = event.endTime == null
        ? null
        : AcademicClock.parseTimeParts(event.endTime);
    final timeLabel = start == null
        ? 'All day'
        : '${AcademicClock.formatTime(start.$1, start.$2, timeFormat)}'
              '${end == null ? '' : ' – ${AcademicClock.formatTime(end.$1, end.$2, timeFormat)}'}';

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.event_rounded,
            size: 18,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                '${event.type.label} · $timeLabel'
                '${event.location == null ? '' : ' · ${event.location}'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Event actions',
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit event')),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete event',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimetableCard extends StatelessWidget {
  const _TimetableCard({
    required this.state,
    required this.entries,
    required this.weekday,
    required this.timeFormat,
    required this.onToggle,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final CalendarState state;
  final List<TimetableEntry> entries;
  final int weekday;
  final TimeFormat timeFormat;
  final VoidCallback onToggle;
  final VoidCallback onAdd;
  final ValueChanged<TimetableEntry> onEdit;
  final ValueChanged<TimetableEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    final isWeekend = weekday > 5;
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(
                  title: 'Weekly timetable',
                  subtitle: state.showTimetable
                      ? 'Recurring classes for '
                            '${isWeekend ? 'weekdays' : names[weekday - 1]}'
                      : 'Hidden on the calendar',
                ),
              ),
              Switch(value: state.showTimetable, onChanged: (_) => onToggle()),
            ],
          ),
          if (state.showTimetable) ...[
            const SizedBox(height: 4),
            if (isWeekend)
              const EmptyState(
                compact: true,
                icon: Icons.weekend_outlined,
                title: 'Weekend',
                message:
                    'Timetable classes run Monday to Friday. Select a weekday '
                    'to see its schedule.',
              )
            else if (state.subjects.isEmpty)
              EmptyState(
                compact: true,
                icon: Icons.menu_book_outlined,
                title: 'Add a subject first',
                message: 'Timetable entries need a subject to belong to.',
                action: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add class'),
                ),
              )
            else if (entries.isEmpty)
              EmptyState(
                compact: true,
                icon: Icons.schedule_outlined,
                title: 'No classes on ${names[weekday - 1]}',
                message: 'Add a recurring class to build your weekly schedule.',
                action: OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add class'),
                ),
              )
            else ...[
              for (final entry in entries) ...[
                _TimetableRow(
                  entry: entry,
                  subject: state.subjectFor(entry.subjectId),
                  timeFormat: timeFormat,
                  onEdit: () => onEdit(entry),
                  onDelete: () => onDelete(entry),
                ),
                if (entry != entries.last)
                  const Divider(height: 14, color: AppColors.border),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add class'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TimetableRow extends StatelessWidget {
  const _TimetableRow({
    required this.entry,
    required this.subject,
    required this.timeFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final TimetableEntry entry;
  final Subject? subject;
  final TimeFormat timeFormat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = Color(subject?.colorValue ?? 0xFF0865D8);
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject?.name ?? 'Class',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                '${AcademicClock.formatMinutesRange(entry.startMinutes, entry.endMinutes, timeFormat)}'
                '${entry.room == null ? '' : ' · ${entry.room}'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Class actions',
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit class')),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Remove class',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EventDraft {
  const _EventDraft({
    required this.title,
    required this.type,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.description,
    this.location,
    this.reminderOffsetMinutes,
  });

  final String title;
  final AcademicEventType type;
  final String eventDate;
  final String? startTime;
  final String? endTime;
  final String? description;
  final String? location;
  final int? reminderOffsetMinutes;
}

class _EventFormDialog extends StatefulWidget {
  const _EventFormDialog({required this.initialDate, this.existing});

  final String initialDate;
  final AcademicEvent? existing;

  @override
  State<_EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<_EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _location;
  late AcademicEventType _type;
  late String _date;
  String? _startTime;
  String? _endTime;
  bool _timed = false;
  int? _reminderOffset;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _location = TextEditingController(text: existing?.location ?? '');
    _type = existing?.type ?? AcademicEventType.other;
    _date = existing?.eventDate ?? widget.initialDate;
    _startTime = existing?.startTime;
    _endTime = existing?.endTime;
    _timed = existing?.startTime != null;
    _reminderOffset = existing?.reminderOffsetMinutes;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await pickDateKey(
      context,
      initial: _date,
      helpText: 'Event date',
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickStart() async {
    final result = await pickTimeString(
      context,
      initial: _startTime ?? '09:00',
      helpText: 'Start time',
    );
    if (result == null) return;
    setState(() {
      _startTime = result;
      _timed = true;
      if (_endTime == null || _endTime!.compareTo(result) <= 0) {
        final parts = AcademicClock.parseTimeParts(result);
        _endTime = AcademicClock.normalizeTime(
          (parts.$1 + 1).clamp(0, 23),
          parts.$2,
        );
      }
    });
  }

  Future<void> _pickEnd() async {
    final result = await pickTimeString(
      context,
      initial: _endTime ?? '10:00',
      helpText: 'End time',
    );
    if (result != null) setState(() => _endTime = result);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_timed && _startTime == null) {
      showAppSnack(context, 'Choose a start time or turn off timed event.');
      return;
    }
    if (_timed &&
        _startTime != null &&
        _endTime != null &&
        _endTime!.compareTo(_startTime!) <= 0) {
      showAppSnack(context, 'End time must be after start time.');
      return;
    }

    final description = _description.text.trim();
    final location = _location.text.trim();
    Navigator.of(context).pop(
      _EventDraft(
        title: _title.text.trim(),
        type: _type,
        eventDate: _date,
        startTime: _timed ? _startTime : null,
        endTime: _timed ? _endTime : null,
        description: description.isEmpty ? null : description,
        location: location.isEmpty ? null : location,
        reminderOffsetMinutes: _timed ? _reminderOffset : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat =
        context.read<AuthBloc>().state.profile?.timeFormat ??
        TimeFormat.twelveHour;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: Text(
        widget.existing == null ? 'Add event' : 'Edit event',
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
                    labelText: 'Event title',
                    hintText: 'e.g. Midterm exam',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter an event title'
                      : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<AcademicEventType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Event type'),
                  items: [
                    for (final type in AcademicEventType.values)
                      DropdownMenuItem(value: type, child: Text(type.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _type = value);
                  },
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      dateLabel(_date),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _timed,
                  onChanged: (value) => setState(() {
                    _timed = value;
                    if (!value) {
                      _startTime = null;
                      _endTime = null;
                      _reminderOffset = null;
                    }
                  }),
                  title: const Text(
                    'Timed event',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Turn off for all-day events.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                if (_timed) ...[
                  AppFieldRow(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _pickStart,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Starts',
                            prefixIcon: Icon(Icons.schedule_outlined),
                          ),
                          child: Text(
                            _startTime == null
                                ? 'Set time'
                                : _format(_startTime!, timeFormat),
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _pickEnd,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Ends',
                            prefixIcon: Icon(Icons.schedule_outlined),
                          ),
                          child: Text(
                            _endTime == null
                                ? 'Optional'
                                : _format(_endTime!, timeFormat),
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _location,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Location (optional)',
                      prefixIcon: Icon(Icons.place_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      DropdownMenuItem<int?>(value: 0, child: Text('At start')),
                      DropdownMenuItem<int?>(
                        value: 15,
                        child: Text('15 minutes before'),
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _location,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Location (optional)',
                      prefixIcon: Icon(Icons.place_outlined),
                    ),
                  ),
                ],
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
          child: Text(widget.existing == null ? 'Add event' : 'Save changes'),
        ),
      ],
    );
  }

  String _format(String value, TimeFormat format) {
    final parts = AcademicClock.parseTimeParts(value);
    return AcademicClock.formatTime(parts.$1, parts.$2, format);
  }
}

class _TimetableDraft {
  const _TimetableDraft({
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.room,
  });

  final String subjectId;
  final int weekday;
  final int startMinutes;
  final int endMinutes;
  final String? room;
}

class _TimetableFormDialog extends StatefulWidget {
  const _TimetableFormDialog({
    required this.subjects,
    required this.defaultWeekday,
    required this.timeFormat,
    this.existing,
  });

  final List<Subject> subjects;
  final int defaultWeekday;
  final TimeFormat timeFormat;
  final TimetableEntry? existing;

  @override
  State<_TimetableFormDialog> createState() => _TimetableFormDialogState();
}

class _TimetableFormDialogState extends State<_TimetableFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _room = TextEditingController();
  late String? _subjectId;
  late int _weekday;
  late int _startMinutes;
  late int _endMinutes;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _subjectId =
        existing?.subjectId ??
        (widget.subjects.isEmpty ? null : widget.subjects.first.id);
    _weekday = existing?.weekday ?? widget.defaultWeekday;
    _startMinutes = existing?.startMinutes ?? 9 * 60;
    _endMinutes = existing?.endMinutes ?? 10 * 60;
    _room.text = existing?.room ?? '';
  }

  @override
  void dispose() {
    _room.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool start}) async {
    final minutes = start ? _startMinutes : _endMinutes;
    final result = await pickTimeString(
      context,
      initial: AcademicClock.normalizeTime(minutes ~/ 60, minutes % 60),
      helpText: start ? 'Class start' : 'Class end',
    );
    if (result == null) return;
    final parts = AcademicClock.parseTimeParts(result);
    setState(() {
      final value = AcademicClock.toMinutes(parts.$1, parts.$2);
      if (start) {
        _startMinutes = value;
        if (_endMinutes <= value) {
          _endMinutes = (value + 60).clamp(0, 24 * 60 - 1);
        }
      } else {
        _endMinutes = value;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_subjectId == null) {
      showAppSnack(context, 'Choose a subject.');
      return;
    }
    if (_endMinutes <= _startMinutes) {
      showAppSnack(context, 'End time must be after start time.');
      return;
    }
    Navigator.of(context).pop(
      _TimetableDraft(
        subjectId: _subjectId!,
        weekday: _weekday,
        startMinutes: _startMinutes,
        endMinutes: _endMinutes,
        room: _room.text.trim().isEmpty ? null : _room.text.trim(),
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
        widget.existing == null ? 'Add class' : 'Edit class',
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: SizedBox(
        width: appDialogBodyWidth(context, max: 480),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _subjectId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  items: [
                    for (final subject in widget.subjects)
                      DropdownMenuItem(
                        value: subject.id,
                        child: Text('${subject.code} · ${subject.name}'),
                      ),
                  ],
                  onChanged: (value) => setState(() => _subjectId = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  initialValue: _weekday,
                  decoration: const InputDecoration(labelText: 'Weekday'),
                  items: [
                    for (var day = 1; day <= 5; day++)
                      DropdownMenuItem(
                        value: day,
                        child: Text(
                          const [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                          ][day - 1],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _weekday = value);
                  },
                ),
                const SizedBox(height: 10),
                AppFieldRow(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _pickTime(start: true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Starts',
                          prefixIcon: Icon(Icons.schedule_outlined),
                        ),
                        child: Text(
                          AcademicClock.formatMinutes(
                            _startMinutes,
                            widget.timeFormat,
                          ),
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _pickTime(start: false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Ends',
                          prefixIcon: Icon(Icons.schedule_outlined),
                        ),
                        child: Text(
                          AcademicClock.formatMinutes(
                            _endMinutes,
                            widget.timeFormat,
                          ),
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _room,
                  decoration: const InputDecoration(
                    labelText: 'Room (optional)',
                    prefixIcon: Icon(Icons.meeting_room_outlined),
                  ),
                ),
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
          child: Text(widget.existing == null ? 'Add class' : 'Save changes'),
        ),
      ],
    );
  }
}
