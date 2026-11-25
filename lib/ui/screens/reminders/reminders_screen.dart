import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/reminders/reminders_cubit.dart';
import '../../../models/enums.dart';
import '../../../models/reminder_item.dart';
import '../../../repositories/assignment_repository.dart';
import '../../../repositories/event_repository.dart';
import '../../../repositories/task_repository.dart';
import '../../widgets/common.dart';
import '../../widgets/pickers.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<AuthBloc>().state.profile;
    if (profile == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider(
      create: (_) => RemindersCubit(
        tasks: context.read<TaskRepository>(),
        events: context.read<EventRepository>(),
        assignments: context.read<AssignmentRepository>(),
      )..load(profile),
      child: const _RemindersView(),
    );
  }
}

class _RemindersView extends StatelessWidget {
  const _RemindersView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    final state = context.watch<RemindersCubit>().state;
    final cubit = context.read<RemindersCubit>();
    final items = state.forBucket(state.selected);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Reminder Center'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              if (profile != null) cubit.load(profile);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: AppPage(
          maxWidth: 820,
          child: ListView(
            children: [
              const Text(
                'One place for tasks, events and assignments that need '
                'attention.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final bucket in ReminderBucket.values) ...[
                    Expanded(
                      child: _BucketButton(
                        bucket: bucket,
                        count: state.countFor(bucket),
                        selected: state.selected == bucket,
                        onTap: () => cubit.select(bucket),
                      ),
                    ),
                    if (bucket != ReminderBucket.values.last)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (state.error != null) ...[
                ErrorBanner(message: state.error!),
                const SizedBox(height: 12),
              ],
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (items.isEmpty)
                AppCard(
                  child: EmptyState(
                    icon: switch (state.selected) {
                      ReminderBucket.overdue => Icons.done_all_rounded,
                      ReminderBucket.dueSoon =>
                        Icons.notifications_none_rounded,
                      ReminderBucket.upcoming => Icons.event_available_outlined,
                    },
                    title: switch (state.selected) {
                      ReminderBucket.overdue => 'Nothing overdue',
                      ReminderBucket.dueSoon => 'Nothing due soon',
                      ReminderBucket.upcoming => 'No upcoming reminders',
                    },
                    message: state.selected == ReminderBucket.overdue
                        ? 'You are on top of your deadlines.'
                        : 'New reminders appear here automatically.',
                  ),
                )
              else
                Column(
                  children: [
                    for (final item in items) ...[
                      _ReminderCard(
                        item: item,
                        onToggle: profile == null
                            ? null
                            : () => cubit.toggle(profile, item),
                      ),
                      const SizedBox(height: 9),
                    ],
                  ],
                ),
              const SizedBox(height: 12),
              const _ReminderNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BucketButton extends StatelessWidget {
  const _BucketButton({
    required this.bucket,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final ReminderBucket bucket;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBright : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? AppColors.primaryBright : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppColors.navy,
              ),
            ),
            Text(
              bucket.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.item, this.onToggle});

  final ReminderItem item;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (item.source) {
      'task' => (Icons.task_alt_rounded, AppColors.primaryBright),
      'event' => (Icons.event_rounded, AppColors.accent),
      'assignment' => (Icons.assignment_outlined, AppColors.warning),
      _ => (Icons.circle_outlined, AppColors.textSecondary),
    };
    final canToggle = item.source != 'event' && onToggle != null;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                switch (item.source) {
                  case 'task':
                    context.go('/app/tasks');
                  case 'event':
                    context.go('/app/calendar');
                  case 'assignment':
                    context.push('/app/classrooms');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: item.completed
                          ? AppColors.textMuted
                          : AppColors.navy,
                      decoration: item.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        dueLabel(item.dueAt),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: item.isOverdue
                              ? AppColors.danger
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (!item.hasExplicitTime) ...[
                        const Text(
                          ' · end of day',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (canToggle)
            Checkbox(
              value: item.completed,
              onChanged: (_) => onToggle!(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ReminderNote extends StatelessWidget {
  const _ReminderNote();

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
          Icon(
            Icons.notifications_active_outlined,
            size: 16,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reminders are shown in-app. Task and assignment completion is '
              'saved on this device and synced when you are connected. Timed '
              'reminders are calculated from your deadlines.',
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
