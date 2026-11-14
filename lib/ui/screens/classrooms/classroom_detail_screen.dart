import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/classrooms/classrooms_cubit.dart';
import '../../../models/assignment.dart';
import '../../../models/classroom.dart';
import '../../../models/classroom_member.dart';
import '../../../models/enums.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/assignment_repository.dart';
import '../../../repositories/classroom_repository.dart';
import '../../../services/academic_clock.dart';
import '../../widgets/common.dart';
import '../../widgets/pickers.dart';

class ClassroomDetailScreen extends StatelessWidget {
  const ClassroomDetailScreen({super.key, required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context) {
    final profile = context.read<AuthBloc>().state.profile;
    if (profile == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider(
      create: (_) => ClassroomsCubit(
        repository: context.read<ClassroomRepository>(),
        assignments: context.read<AssignmentRepository>(),
        accountId: profile.id,
      )..openDetail(classroomId),
      child: _ClassroomDetailView(classroomId: classroomId),
    );
  }
}

class _ClassroomDetailView extends StatelessWidget {
  const _ClassroomDetailView({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    if (profile == null) return const SizedBox.shrink();

    final state = context.watch<ClassroomsCubit>().state;
    final cubit = context.read<ClassroomsCubit>();
    final classroom = state.detail;
    final isOwner = classroom != null && classroom.teacherId == profile.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(classroom?.name ?? 'Classroom'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.busy ? null : () => cubit.openDetail(classroomId),
            icon: const Icon(Icons.refresh_rounded),
          ),
          if (isOwner)
            PopupMenuButton<String>(
              tooltip: 'Classroom actions',
              onSelected: (value) {
                if (value == 'code') _resetCode(context, cubit);
                if (value == 'archive') _archive(context, cubit);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'code',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.key_rounded, size: 18),
                    title: Text('Reset join code'),
                  ),
                ),
                PopupMenuItem(
                  value: 'archive',
                  enabled: !classroom.archived,
                  child: const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.archive_outlined, size: 18),
                    title: Text('Archive classroom'),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: AppPage(
          maxWidth: 940,
          child: ListView(
            children: [
              if (state.busy) ...[
                const LinearProgressIndicator(minHeight: 2),
                const SizedBox(height: 12),
              ],
              if (state.error != null) ...[
                ErrorBanner(
                  message: state.error!,
                  onDismiss: cubit.dismissMessage,
                ),
                const SizedBox(height: 12),
              ],
              if (state.notice != null) ...[
                ErrorBanner(
                  tone: BannerTone.info,
                  message: state.notice!,
                  onDismiss: cubit.dismissMessage,
                ),
                const SizedBox(height: 12),
              ],
              if (classroom == null)
                _MissingClassroom(
                  busy: state.busy,
                  onRetry: () => cubit.openDetail(classroomId),
                )
              else ...[
                if (!state.configured)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ErrorBanner(
                      tone: BannerTone.info,
                      message:
                          'Online-only classroom. Live refresh, join-code '
                          'changes and assignment administration require a '
                          'configured Supabase backend. Cached details are '
                          'shown below.',
                    ),
                  ),
                _ClassroomHeader(
                  classroom: classroom,
                  profile: profile,
                  isOwner: isOwner,
                  onResetCode: isOwner
                      ? () => _resetCode(context, cubit)
                      : null,
                ),
                const SizedBox(height: 12),
                if (classroom.archived) ...[
                  const ErrorBanner(
                    tone: BannerTone.info,
                    message:
                        'This classroom is archived and read-only. '
                        'Assignments can no longer be published.',
                  ),
                  const SizedBox(height: 12),
                ],
                _AssignmentsCard(
                  state: state,
                  profile: profile,
                  classroom: classroom,
                  isOwner: isOwner,
                  onAdd: isOwner && !classroom.archived
                      ? () => _openAssignmentForm(context, cubit, null)
                      : null,
                  onEdit: (assignment) =>
                      _openAssignmentForm(context, cubit, assignment),
                  onDelete: (assignment) =>
                      _deleteAssignment(context, cubit, assignment),
                  onToggle: (assignment) => cubit.toggleProgress(assignment),
                ),
                const SizedBox(height: 12),
                _MembersCard(
                  state: state,
                  isOwner: isOwner,
                  onRemove: (member) => _removeMember(context, cubit, member),
                  onUnblock: (member) => _unblockMember(context, cubit, member),
                ),
                if (isOwner) ...[
                  const SizedBox(height: 12),
                  _ActivityCard(events: state.events),
                ],
                const SizedBox(height: 10),
                const _TeacherPrivacyNote(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAssignmentForm(
    BuildContext context,
    ClassroomsCubit cubit,
    Assignment? existing,
  ) async {
    final draft = await showDialog<_AssignmentDraft>(
      context: context,
      builder: (_) => _AssignmentFormDialog(existing: existing),
    );
    if (draft == null || !context.mounted) return;

    final bool ok;
    if (existing == null) {
      ok = await cubit.createAssignment(
        classroomId: classroomId,
        title: draft.title,
        dueDate: draft.dueDate,
        description: draft.description,
        dueTime: draft.hasTime ? draft.dueTime : null,
        publish: draft.publish,
      );
    } else {
      ok = await cubit.updateAssignment(
        assignment: existing,
        title: draft.title,
        dueDate: draft.dueDate,
        description: draft.description,
        dueTime: draft.hasTime ? draft.dueTime : null,
        status: existing.status == AssignmentStatus.archived
            ? AssignmentStatus.archived.code
            : draft.publish
            ? AssignmentStatus.published.code
            : AssignmentStatus.draft.code,
      );
    }

    if (!context.mounted) return;
    if (ok) {
      showAppSnack(
        context,
        cubit.state.notice ??
            (draft.publish ? 'Assignment published.' : 'Draft saved.'),
      );
    } else {
      showAppSnack(context, cubit.state.error ?? 'Unable to save assignment.');
    }
  }

  Future<void> _deleteAssignment(
    BuildContext context,
    ClassroomsCubit cubit,
    Assignment assignment,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete assignment?',
      message: '"${assignment.title}" will be removed for every student.',
      confirmLabel: 'Delete assignment',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await cubit.deleteAssignment(assignment);
    if (!context.mounted) return;
    if (!ok) {
      showAppSnack(
        context,
        cubit.state.error ?? 'Unable to delete assignment.',
      );
    }
  }

  Future<void> _resetCode(BuildContext context, ClassroomsCubit cubit) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset join code?',
      message:
          'The previous code stops working immediately. Students who '
          'already joined keep their membership.',
      confirmLabel: 'Reset code',
    );
    if (!confirmed || !context.mounted) return;

    final code = await cubit.resetJoinCode();
    if (!context.mounted) return;
    if (code == null) {
      showAppSnack(
        context,
        cubit.state.error ?? 'Unable to reset the join code.',
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: const Text(
          'New join code',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              code,
              style: const TextStyle(
                fontSize: 26,
                letterSpacing: 3,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Share this code with your students. It is generated by the '
              'server and cannot be edited.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (dialogContext.mounted) {
                showAppSnack(dialogContext, 'Join code copied.');
              }
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _archive(BuildContext context, ClassroomsCubit cubit) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Archive classroom?',
      message:
          'Archived classrooms become read-only. Published assignments '
          'stay available to students and members are retained.',
      confirmLabel: 'Archive classroom',
    );
    if (!confirmed || !context.mounted) return;
    final ok = await cubit.archive();
    if (!context.mounted) return;
    if (!ok) {
      showAppSnack(
        context,
        cubit.state.error ?? 'Unable to archive classroom.',
      );
    }
  }

  Future<void> _removeMember(
    BuildContext context,
    ClassroomsCubit cubit,
    ClassroomMember member,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove member?',
      message:
          '${member.studentName ?? 'This student'} loses access to the '
          'classroom and its assignments.',
      confirmLabel: 'Remove member',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await cubit.removeMember(member.id);
    if (!context.mounted) return;
    if (!ok) {
      showAppSnack(context, cubit.state.error ?? 'Unable to remove member.');
    }
  }

  Future<void> _unblockMember(
    BuildContext context,
    ClassroomsCubit cubit,
    ClassroomMember member,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Allow rejoin?',
      message:
          '${member.studentName ?? 'This student'} may join this '
          'classroom again with a valid join code.',
      confirmLabel: 'Allow rejoin',
    );
    if (!confirmed || !context.mounted) return;
    final ok = await cubit.unblockMember(member.id);
    if (!context.mounted) return;
    if (!ok) {
      showAppSnack(context, cubit.state.error ?? 'Unable to unblock member.');
    }
  }
}

class _MissingClassroom extends StatelessWidget {
  const _MissingClassroom({required this.busy, required this.onRetry});

  final bool busy;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Classroom not cached',
        message:
            'A configured backend is required to load this classroom. '
            'If it was previously cached, refresh to try again.',
        action: OutlinedButton.icon(
          onPressed: busy ? null : onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
        ),
      ),
    );
  }
}

class _ClassroomHeader extends StatelessWidget {
  const _ClassroomHeader({
    required this.classroom,
    required this.profile,
    required this.isOwner,
    required this.onResetCode,
  });

  final Classroom classroom;
  final UserProfile profile;
  final bool isOwner;
  final VoidCallback? onResetCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            classroom.name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (classroom.archived)
                          const StatusChip(
                            label: 'Archived',
                            color: AppColors.textSecondary,
                            background: Color(0xFFF1F5F9),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      classroom.subjectName,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (classroom.teacherName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Taught by ${classroom.teacherName}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (classroom.description != null &&
              classroom.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              classroom.description!,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusChip(
                label: classroom.timezone,
                icon: Icons.public_rounded,
                maxWidth: 220,
              ),
              if (isOwner && classroom.joinCode != null)
                _JoinCodeChip(
                  code: classroom.joinCode!,
                  onCopy: () async {
                    await Clipboard.setData(
                      ClipboardData(text: classroom.joinCode!),
                    );
                    if (context.mounted) {
                      showAppSnack(context, 'Join code copied.');
                    }
                  },
                ),
              if (isOwner && onResetCode != null)
                TextButton.icon(
                  onPressed: onResetCode,
                  icon: const Icon(Icons.autorenew_rounded, size: 17),
                  label: const Text('Reset code'),
                ),
            ],
          ),
          if (isOwner) ...[
            const SizedBox(height: 8),
            const Text(
              'Join codes are system-generated. Share them only with your '
              'students.',
              style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _JoinCodeChip extends StatelessWidget {
  const _JoinCodeChip({required this.code, required this.onCopy});

  final String code;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 2, 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.key_rounded, size: 13, color: AppColors.warning),
          const SizedBox(width: 5),
          Text(
            code,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColors.warning,
            ),
          ),
          IconButton(
            tooltip: 'Copy join code',
            visualDensity: VisualDensity.compact,
            onPressed: onCopy,
            icon: const Icon(
              Icons.copy_rounded,
              size: 14,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentsCard extends StatelessWidget {
  const _AssignmentsCard({
    required this.state,
    required this.profile,
    required this.classroom,
    required this.isOwner,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final ClassroomsState state;
  final UserProfile profile;
  final Classroom classroom;
  final bool isOwner;
  final VoidCallback? onAdd;
  final ValueChanged<Assignment> onEdit;
  final ValueChanged<Assignment> onDelete;
  final ValueChanged<Assignment> onToggle;

  @override
  Widget build(BuildContext context) {
    final assignments = isOwner
        ? state.assignments
        : state.publishedAssignments;
    final timeFormat = profile.timeFormat;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(
                  title: 'Assignments',
                  subtitle: isOwner
                      ? '${assignments.length} total · drafts are hidden from '
                            'students'
                      : '${assignments.length} published',
                ),
              ),
              if (onAdd != null)
                OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (assignments.isEmpty)
            EmptyState(
              compact: true,
              icon: Icons.assignment_outlined,
              title: isOwner ? 'No assignments yet' : 'No assignments yet',
              message: isOwner
                  ? 'Create a draft, then publish it when it is ready.'
                  : 'Published assignments from your teacher appear here.',
            )
          else
            for (final assignment in assignments) ...[
              _AssignmentRow(
                assignment: assignment,
                timezone: classroom.timezone,
                timeFormat: timeFormat,
                isOwner: isOwner,
                completed: state.isCompleted(assignment.id),
                onToggle: () => onToggle(assignment),
                onEdit: () => onEdit(assignment),
                onDelete: () => onDelete(assignment),
              ),
              if (assignment != assignments.last)
                const Divider(height: 16, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.assignment,
    required this.timezone,
    required this.timeFormat,
    required this.isOwner,
    required this.completed,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Assignment assignment;
  final String timezone;
  final TimeFormat timeFormat;
  final bool isOwner;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final due = AcademicClock.dueInstant(
      date: assignment.dueDate,
      time: assignment.hasExplicitTime ? assignment.dueTime : null,
      timezoneName: timezone,
    );
    final overdue = !completed && due != null && due.isBefore(DateTime.now());
    final timeParts = AcademicClock.parseTimeParts(assignment.dueTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwner)
            Checkbox(
              value: completed,
              onChanged: (_) => onToggle(),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            )
          else
            Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 17,
                color: AppColors.warning,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: completed ? AppColors.textMuted : AppColors.navy,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (assignment.description != null &&
                    assignment.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    assignment.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Wrap(
                  spacing: 7,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (isOwner)
                      StatusChip(
                        label: assignment.status.label,
                        color: switch (assignment.status) {
                          AssignmentStatus.draft => AppColors.textSecondary,
                          AssignmentStatus.published => AppColors.success,
                          AssignmentStatus.archived => AppColors.textMuted,
                        },
                        background: switch (assignment.status) {
                          AssignmentStatus.draft => const Color(0xFFF1F5F9),
                          AssignmentStatus.published => const Color(0xFFE7F9F1),
                          AssignmentStatus.archived => const Color(0xFFF1F5F9),
                        },
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          overdue
                              ? Icons.warning_amber_rounded
                              : Icons.event_outlined,
                          size: 13,
                          color: overdue
                              ? AppColors.danger
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${dateLabel(assignment.dueDate)}'
                          '${assignment.hasExplicitTime ? ' · ${AcademicClock.formatTime(timeParts.$1, timeParts.$2, timeFormat)}' : ' · end of day'}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: overdue
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: overdue
                                ? AppColors.danger
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (!isOwner && completed)
                      const StatusChip(
                        label: 'Done',
                        color: AppColors.success,
                        background: Color(0xFFE7F9F1),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isOwner)
            PopupMenuButton<String>(
              tooltip: 'Assignment actions',
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.edit_outlined, size: 18),
                    title: Text('Edit assignment'),
                  ),
                ),
                PopupMenuItem(
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
                      'Delete assignment',
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

class _MembersCard extends StatelessWidget {
  const _MembersCard({
    required this.state,
    required this.isOwner,
    required this.onRemove,
    required this.onUnblock,
  });

  final ClassroomsState state;
  final bool isOwner;
  final ValueChanged<ClassroomMember> onRemove;
  final ValueChanged<ClassroomMember> onUnblock;

  @override
  Widget build(BuildContext context) {
    final active = state.activeMembers;
    final inactive = state.inactiveMembers;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Members',
            subtitle: isOwner
                ? '${active.length} active · remove access without deleting '
                      'history'
                : '${active.length} active member'
                      '${active.length == 1 ? '' : 's'}',
          ),
          const SizedBox(height: 8),
          if (active.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.person_outline_rounded,
              title: 'No active members',
              message: 'Students appear here after joining with the code.',
            )
          else
            for (final member in active) ...[
              _MemberRow(
                member: member,
                actionLabel: isOwner ? 'Remove' : null,
                actionIcon: Icons.person_remove_outlined,
                onAction: isOwner ? () => onRemove(member) : null,
              ),
              if (member != active.last)
                const Divider(height: 12, color: AppColors.border),
            ],
          if (isOwner && inactive.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Former members',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            for (final member in inactive) ...[
              _MemberRow(
                member: member,
                actionLabel: member.rejoinBlocked ? 'Allow rejoin' : null,
                actionIcon: Icons.lock_open_rounded,
                onAction: member.rejoinBlocked ? () => onUnblock(member) : null,
              ),
              if (member != inactive.last)
                const Divider(height: 12, color: AppColors.border),
            ],
          ],
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  final ClassroomMember member;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final name = member.studentName ?? member.studentEmail ?? 'Student';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.infoSoft,
            child: Text(
              initialsOf(name),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  member.isActive
                      ? 'Active'
                      : '${member.status.label}'
                            '${member.rejoinBlocked ? ' · rejoin blocked' : ''}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (onAction != null && actionLabel != null)
            TextButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon, size: 15),
              label: Text(actionLabel!, style: const TextStyle(fontSize: 11.5)),
            ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.events});

  final List<MembershipEvent> events;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Membership activity',
            subtitle: 'Join, leave, removal and unblock history',
          ),
          const SizedBox(height: 8),
          if (events.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.history_rounded,
              title: 'No activity yet',
              message: 'Membership changes are recorded here.',
            )
          else
            for (final event in events) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    switch (event.type) {
                      MembershipEventType.joined => Icons.login_rounded,
                      MembershipEventType.left => Icons.logout_rounded,
                      MembershipEventType.removed =>
                        Icons.person_remove_outlined,
                      MembershipEventType.unblocked => Icons.lock_open_rounded,
                    },
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${event.studentName ?? 'Student'} · ${event.type.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, HH:mm')
                        .format(event.createdAt.toLocal()),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (event != events.last)
                const Divider(height: 14, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _TeacherPrivacyNote extends StatelessWidget {
  const _TeacherPrivacyNote();

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
          Icon(Icons.shield_outlined, size: 16, color: AppColors.textMuted),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Assignment completion is private to each student. Teachers '
              'cannot see student tasks, events, reminders or progress in '
              'this build.',
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

class _AssignmentDraft {
  const _AssignmentDraft({
    required this.title,
    required this.dueDate,
    required this.hasTime,
    required this.publish,
    this.description,
    this.dueTime,
  });

  final String title;
  final String? description;
  final String dueDate;
  final String? dueTime;
  final bool hasTime;
  final bool publish;
}

class _AssignmentFormDialog extends StatefulWidget {
  const _AssignmentFormDialog({this.existing});

  final Assignment? existing;

  @override
  State<_AssignmentFormDialog> createState() => _AssignmentFormDialogState();
}

class _AssignmentFormDialogState extends State<_AssignmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late String _dueDate;
  String? _dueTime;
  late bool _hasTime;
  late bool _publish;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _dueDate = existing?.dueDate ?? AcademicClock.todayKey();
    _dueTime = existing?.dueTime;
    _hasTime = existing?.hasExplicitTime ?? false;
    _publish = existing == null
        ? false
        : existing.status == AssignmentStatus.published;
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
      helpText: 'Assignment due date',
    );
    if (result != null) setState(() => _dueDate = result);
  }

  Future<void> _pickTime() async {
    final result = await pickTimeString(
      context,
      initial: _dueTime ?? '23:59',
      helpText: 'Assignment due time',
    );
    if (result == null) return;
    setState(() {
      _dueTime = result;
      _hasTime = true;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_hasTime && _dueTime == null) {
      showAppSnack(context, 'Choose a due time or turn it off.');
      return;
    }
    final description = _description.text.trim();
    Navigator.of(context).pop(
      _AssignmentDraft(
        title: _title.text.trim(),
        description: description.isEmpty ? null : description,
        dueDate: _dueDate,
        dueTime: _hasTime ? _dueTime : null,
        hasTime: _hasTime,
        publish: _publish,
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
        widget.existing == null ? 'New assignment' : 'Edit assignment',
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
                    labelText: 'Assignment title',
                    hintText: 'e.g. Problem set 4',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter an assignment title'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Instructions (optional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      dateLabel(_dueDate),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _hasTime,
                  onChanged: (value) => setState(() {
                    _hasTime = value;
                    if (!value) _dueTime = null;
                  }),
                  title: const Text(
                    'Specific due time',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Otherwise the assignment is due at the end of the day.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                if (_hasTime) ...[
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due time',
                        prefixIcon: Icon(Icons.schedule_outlined),
                      ),
                      child: Text(
                        _dueTime == null
                            ? 'Set time'
                            : () {
                                final parts = AcademicClock.parseTimeParts(
                                  _dueTime,
                                );
                                return AcademicClock.formatTime(
                                  parts.$1,
                                  parts.$2,
                                  timeFormat,
                                );
                              }(),
                        style: const TextStyle(fontSize: 13.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _publish,
                  onChanged: (value) => setState(() => _publish = value),
                  title: const Text(
                    'Publish to students',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Drafts stay private until published.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Publishing and updates require an online classroom. '
                  'Deadlines are date-only unless you set a time.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: AppColors.textMuted,
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
          child: Text(widget.existing == null ? 'Save' : 'Save changes'),
        ),
      ],
    );
  }
}
