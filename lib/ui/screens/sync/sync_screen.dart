import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/sync/sync_cubit.dart';
import '../../../models/enums.dart';
import '../../../models/sync_models.dart';
import '../../widgets/common.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SyncCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SyncCubit>().state;
    final cubit = context.read<SyncCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Sync center'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.loading ? null : cubit.load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: AppPage(
          maxWidth: 880,
          child: ListView(
            children: [
              if (!state.configured) ...[
                const ErrorBanner(
                  tone: BannerTone.info,
                  message:
                      'Offline mode: your changes are saved on this device '
                      'and will sync automatically when you are back online.',
                ),
                const SizedBox(height: 12),
              ],
              if (state.message != null) ...[
                ErrorBanner(
                  tone: BannerTone.info,
                  message: state.message!,
                  onDismiss: cubit.clearMessage,
                ),
                const SizedBox(height: 12),
              ],
              _StatusCard(state: state, cubit: cubit),
              const SizedBox(height: 12),
              if (state.conflictItems.isNotEmpty) ...[
                _ConflictsCard(state: state, cubit: cubit),
                const SizedBox(height: 12),
              ],
              _QueueCard(state: state, cubit: cubit),
              const SizedBox(height: 10),
              const _SyncNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state, required this.cubit});

  final SyncState state;
  final SyncCubit cubit;

  @override
  Widget build(BuildContext context) {
    final metadata = state.metadata;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: state.configured
                      ? AppColors.infoSoft
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  state.configured
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_off_outlined,
                  color: state.configured
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.configured
                          ? 'Cloud synchronization'
                          : 'Offline queue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.configured
                          ? 'Preflight pull → ordered push → final pull'
                          : 'Changes are kept safely on this device',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                label: '${state.pending} queued',
                color: state.pending > 0
                    ? AppColors.warning
                    : AppColors.success,
                background: state.pending > 0
                    ? const Color(0xFFFFF4E0)
                    : const Color(0xFFE7F9F1),
              ),
              StatusChip(
                label: '${state.conflicts} conflicts',
                color: state.conflicts > 0
                    ? AppColors.danger
                    : AppColors.textSecondary,
                background: state.conflicts > 0
                    ? AppColors.dangerSoft
                    : const Color(0xFFF1F5F9),
              ),
              StatusChip(
                label: state.configured ? 'Connected' : 'Offline',
                icon: state.configured
                    ? Icons.check_circle_outline_rounded
                    : Icons.cloud_off_outlined,
                color: state.configured
                    ? AppColors.success
                    : AppColors.textSecondary,
                background: state.configured
                    ? const Color(0xFFE7F9F1)
                    : const Color(0xFFF1F5F9),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MetadataRow(
            label: 'Last successful pull',
            value: _when(metadata?.lastPullAt),
          ),
          _MetadataRow(
            label: 'Last push attempt',
            value: _when(metadata?.lastPushAt),
          ),
          _MetadataRow(
            label: 'Cursor',
            value: metadata?.cursor ?? 'Not initialized',
          ),
          if (metadata?.lastError != null)
            _MetadataRow(
              label: 'Last error',
              value: metadata!.lastError!,
              danger: true,
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.running ? null : cubit.syncNow,
                  icon: state.running
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.sync_rounded, size: 18),
                  label: Text(state.running ? 'Syncing…' : 'Sync now'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.running ? null : cubit.retryFailed,
                  icon: const Icon(Icons.replay_rounded, size: 18),
                  label: const Text('Retry failed'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              state.lastRunAt == null
                  ? 'No sync attempted in this session.'
                  : 'Last attempt ${DateFormat.jm().format(state.lastRunAt!)}',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  String _when(DateTime? value) {
    if (value == null) return 'Never';
    return DateFormat('MMM d, yyyy · HH:mm').format(value.toLocal());
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
    this.danger = false,
  });

  final String label;
  final String value;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: danger ? AppColors.danger : AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({required this.state, required this.cubit});

  final SyncState state;
  final SyncCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Pending queue',
            subtitle: state.queue.isEmpty
                ? 'Every local change has been acknowledged.'
                : '${state.queue.length} operation'
                      '${state.queue.length == 1 ? '' : 's'} in order',
          ),
          const SizedBox(height: 8),
          if (state.loading && state.queue.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.queue.isEmpty)
            const EmptyState(
              compact: true,
              icon: Icons.check_circle_outline_rounded,
              title: 'Queue is clear',
              message: 'New edits are added here and retried automatically.',
            )
          else
            for (final operation in state.queue) ...[
              _QueueRow(operation: operation, label: cubit.labelFor(operation)),
              if (operation != state.queue.last)
                const Divider(height: 16, color: AppColors.border),
            ],
        ],
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.operation, required this.label});

  final PendingOperation operation;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (operation.entity) {
      SyncEntity.profile => (Icons.person_outline_rounded, AppColors.primary),
      SyncEntity.subject => (Icons.menu_book_outlined, AppColors.primaryBright),
      SyncEntity.task => (Icons.task_alt_rounded, AppColors.success),
      SyncEntity.timetableEntry => (Icons.schedule_outlined, AppColors.accent),
      SyncEntity.academicEvent => (Icons.event_outlined, AppColors.warning),
      SyncEntity.assignmentProgress => (
        Icons.assignment_turned_in_outlined,
        AppColors.warning,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SyncBadge(status: operation.status),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${operation.entity.label} · rev ${operation.baseRevision}'
                  '${operation.retryCount > 0 ? ' · ${operation.retryCount} retries' : ''}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
                if (operation.lastError != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    operation.lastError!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConflictsCard extends StatelessWidget {
  const _ConflictsCard({required this.state, required this.cubit});

  final SyncState state;
  final SyncCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: AppColors.danger.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Conflicts',
            subtitle:
                'Choose which version to keep. Server deletions and '
                'revocations always win.',
          ),
          const SizedBox(height: 10),
          for (final conflict in state.conflictItems) ...[
            _ConflictRow(conflict: conflict, cubit: cubit),
            if (conflict != state.conflictItems.last)
              const Divider(height: 20, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _ConflictRow extends StatelessWidget {
  const _ConflictRow({required this.conflict, required this.cubit});

  final SyncConflict conflict;
  final SyncCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: AppColors.danger,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${conflict.entity.label} conflict',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PayloadPreview(
                title: 'Local version',
                payload: conflict.localPayload,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PayloadPreview(
                title: 'Cloud version',
                payload: conflict.cloudPayload,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _resolve(context, 'local'),
                child: const Text('Keep local'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () => _resolve(context, 'cloud'),
                child: const Text('Use cloud'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _resolve(BuildContext context, String resolution) async {
    await cubit.resolve(conflict, resolution);
    if (!context.mounted) return;
    showAppSnack(
      context,
      resolution == 'local'
          ? 'Your version will sync shortly.'
          : 'Cloud version applied.',
    );
  }
}

class _PayloadPreview extends StatelessWidget {
  const _PayloadPreview({
    required this.title,
    required this.payload,
    required this.color,
  });

  final String title;
  final Map<String, dynamic> payload;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final entries = payload.entries.take(4).toList();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          if (entries.isEmpty)
            const Text(
              'No fields',
              style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
            )
          else
            for (final entry in entries)
              Text(
                '${entry.key}: ${entry.value}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                ),
              ),
        ],
      ),
    );
  }
}

class _SyncNote extends StatelessWidget {
  const _SyncNote();

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
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your changes are saved on this device first, then synced in '
              'the background when a connection is available. Nothing is '
              'lost if the app restarts.',
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
