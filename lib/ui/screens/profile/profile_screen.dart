import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/app_lock/app_lock_cubit.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/profile/profile_cubit.dart';
import '../../../logic/sync/sync_cubit.dart';
import '../../../models/enums.dart';
import '../../../models/user_profile.dart';
import '../../../repositories/account_repository.dart';
import '../../widgets/common.dart';
import '../../widgets/tab_header.dart';

/// Fallback timezone choices for the local-only build. Production lists the
/// complete IANA catalog supplied by the backend (FR-PROFILE-002).
const List<String> _timezoneChoices = [
  'Asia/Yangon',
  'Asia/Bangkok',
  'Asia/Singapore',
  'Asia/Kolkata',
  'Asia/Dubai',
  'Asia/Tokyo',
  'Asia/Seoul',
  'Australia/Sydney',
  'Europe/London',
  'Europe/Paris',
  'America/New_York',
  'America/Chicago',
  'America/Los_Angeles',
  'UTC',
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(context.read<AccountRepository>()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    if (profile == null) return const SizedBox.shrink();

    final auth = context.watch<AuthBloc>().state;
    final sync = context.watch<SyncCubit>().state;
    final profileState = context.watch<ProfileCubit>().state;

    return AppPage(
      maxWidth: 900,
      child: ListView(
        children: [
          const TabHeader(
            title: 'Profile',
            subtitle: 'Account, security and academic preferences',
          ),
          if (profileState.error != null) ...[
            ErrorBanner(
              message: profileState.error!,
              onDismiss: () => context.read<ProfileCubit>().clearMessages(),
            ),
            const SizedBox(height: 12),
          ],
          if (profileState.busy) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 12),
          ],
          _IdentityCard(profile: profile, pending: auth.pendingOperations),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Personal details',
            subtitle: 'Your name appears across the planner.',
            children: [
              _SettingsTile(
                icon: Icons.badge_outlined,
                title: 'Full name',
                value: profile.fullName,
                onTap: profileState.busy
                    ? null
                    : () => _editName(context, profile),
              ),
              _SettingsTile(
                icon: Icons.mail_outline_rounded,
                title: 'Email',
                value: profile.email,
                trailing: const StatusChip(
                  label: 'Verified',
                  color: AppColors.success,
                  background: Color(0xFFE7F9F1),
                ),
                onTap: null,
              ),
              _SettingsTile(
                icon: Icons.school_outlined,
                title: 'Role',
                value: profile.role.label,
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Academic preferences',
            subtitle: 'Used for deadlines and timetable display.',
            children: [
              _TimeFormatTile(profile: profile),
              _SettingsTile(
                icon: Icons.public_rounded,
                title: 'Academic timezone',
                value: profile.academicTimezone,
                subtitle: 'Online-only · sync pending edits first',
                onTap: profileState.busy
                    ? null
                    : () => _editTimezone(context, profile),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Security',
            subtitle: 'The planner locks when the app leaves the foreground.',
            children: [
              _SettingsTile(
                icon: Icons.password_rounded,
                title: 'Change password',
                value: 'Requires your current password',
                onTap: () => _changePassword(context, profile),
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'Lock now',
                value: 'Hide planner content immediately',
                onTap: () => context.read<AppLockCubit>().lockNow(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Connections',
            subtitle: sync.configured
                ? 'Cloud sync is configured.'
                : 'Local-only mode is active on this device.',
            children: [
              _SettingsTile(
                icon: Icons.groups_outlined,
                title: 'Classrooms',
                value: profile.role == UserRole.teacher
                    ? 'Create and manage classrooms'
                    : 'Joined classrooms and assignments',
                onTap: () => context.push('/app/classrooms'),
              ),
              _SettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'Reminder Center',
                value: 'Deadlines that need attention',
                onTap: () => context.push('/app/reminders'),
              ),
              _SettingsTile(
                icon: Icons.sync_rounded,
                title: 'Sync center',
                value: sync.pending == 0
                    ? 'No pending changes'
                    : '${sync.pending} change'
                          '${sync.pending == 1 ? '' : 's'} waiting',
                trailing: sync.conflicts > 0
                    ? StatusChip(
                        label: '${sync.conflicts} conflicts',
                        color: AppColors.danger,
                        background: AppColors.dangerSoft,
                      )
                    : null,
                onTap: () => context.push('/app/sync'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader(
                  title: 'Session',
                  subtitle:
                      'Signing out keeps planner data on this device in '
                      'local-only mode.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: auth.busy ? null : () => _logout(context, profile),
                  icon: auth.busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded, size: 18),
                  label: Text(auth.busy ? 'Signing out…' : 'Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.dangerSoft),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _PrivacyNote(),
        ],
      ),
    );
  }

  Future<void> _editName(BuildContext context, UserProfile profile) async {
    final controller = TextEditingController(text: profile.fullName);
    final formKey = GlobalKey<FormState>();
    ModalRoute<dynamic>? dialogRoute;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        dialogRoute = ModalRoute.of(dialogContext);
        return AlertDialog(
          backgroundColor: Colors.white,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          title: const Text(
            'Edit full name',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'Enter your full name';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(controller.text.trim());
                }
              },
              child: const Text('Save name'),
            ),
          ],
        );
      },
    );
    // Let the dialog finish its exit animation before disposing the
    // controller; the field rebuilds while the route animates out.
    await dialogRoute?.completed;
    controller.dispose();
    if (name == null || !context.mounted) return;

    final cubit = context.read<ProfileCubit>();
    final updated = await cubit.updateName(profile, name);
    if (updated == null) {
      if (context.mounted) {
        showAppSnack(context, cubit.state.error ?? 'Unable to update name.');
      }
      return;
    }
    if (!context.mounted) return;
    context.read<AuthBloc>().add(AuthProfileUpdated(profile: updated));
    showAppSnack(context, 'Name updated.');
  }

  Future<void> _editTimezone(BuildContext context, UserProfile profile) async {
    var selected = _timezoneChoices.contains(profile.academicTimezone)
        ? profile.academicTimezone
        : _timezoneChoices.first;

    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          title: const Text(
            'Academic timezone',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SizedBox(
            width: appDialogBodyWidth(context, max: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deadlines without a time use the end of the day in this '
                    'timezone. Changing it requires a configured backend and '
                    'no pending edits. Wall-clock values are preserved.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: selected,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Timezone',
                      prefixIcon: Icon(Icons.public_rounded),
                    ),
                    items: [
                      for (final zone in _timezoneChoices)
                        DropdownMenuItem(value: zone, child: Text(zone)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selected = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(selected),
              child: const Text('Update timezone'),
            ),
          ],
        ),
      ),
    );
    if (choice == null || choice == profile.academicTimezone) return;
    if (!context.mounted) return;

    final cubit = context.read<ProfileCubit>();
    final updated = await cubit.changeTimezone(profile, choice);
    if (!context.mounted) return;
    if (updated == null) {
      showAppSnack(
        context,
        cubit.state.error ?? 'Unable to update academic timezone.',
      );
      return;
    }
    context.read<AuthBloc>().add(AuthProfileUpdated(profile: updated));
    showAppSnack(context, 'Academic timezone updated.');
  }

  Future<void> _changePassword(
    BuildContext context,
    UserProfile profile,
  ) async {
    final accounts = context.read<AccountRepository>();
    final current = TextEditingController();
    final next = TextEditingController();
    final confirm = TextEditingController();
    final formKey = GlobalKey<FormState>();
    ModalRoute<dynamic>? dialogRoute;

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        dialogRoute = ModalRoute.of(dialogContext);
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          title: const Text(
            'Change password',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SizedBox(
            width: appDialogBodyWidth(context, max: 420),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: current,
                      obscureText: true,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Current password',
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Enter your current password'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: next,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New password',
                      ),
                      validator: (value) => (value == null || value.length < 8)
                          ? 'Use at least 8 characters'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirm,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm new password',
                      ),
                      validator: (value) =>
                          value != next.text ? 'Passwords do not match' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              child: const Text('Update password'),
            ),
          ],
        );
      },
    );

    final currentValue = current.text;
    final nextValue = next.text;
    // Dispose only after the dialog route finishes its exit animation.
    await dialogRoute?.completed;
    current.dispose();
    next.dispose();
    confirm.dispose();
    if (submitted != true || !context.mounted) return;

    try {
      final valid = await accounts.verifyPassword(profile.id, currentValue);
      if (!context.mounted) return;
      if (!valid) {
        showAppSnack(context, 'Current password is incorrect.');
        return;
      }
      await accounts.resetPassword(
        email: profile.email,
        newPassword: nextValue,
      );
      if (context.mounted) showAppSnack(context, 'Password updated.');
    } catch (error) {
      if (context.mounted) {
        showAppSnack(context, error.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _logout(BuildContext context, UserProfile profile) async {
    final accounts = context.read<AccountRepository>();
    final auth = context.read<AuthBloc>();
    final syncCubit = context.read<SyncCubit>();
    final pending = await accounts.pendingOperationCount(profile.id);
    if (!context.mounted) return;

    if (pending == 0) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Sign out?',
        message:
            'Your planner stays on this device and can be reopened by '
            'signing in again.',
        confirmLabel: 'Sign out',
      );
      if (!confirmed) return;
      auth.add(const AuthLogoutRequested());
      return;
    }

    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: const Text(
          'Unsynchronized changes',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        content: Text(
          '$pending local change${pending == 1 ? '' : 's'} have not reached '
          'the cloud. Synchronize first, or discard them and sign out. '
          'Discarding removes the queued operations but keeps your local '
          'planner data in this build.',
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('discard'),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Discard & sign out'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop('sync'),
            child: const Text('Sync & sign out'),
          ),
        ],
      ),
    );
    if (choice == null || choice == 'cancel' || !context.mounted) return;

    if (choice == 'discard') {
      auth.add(const AuthLogoutRequested(discardPending: true));
      return;
    }

    final result = await syncCubit.syncNow();
    if (!context.mounted) return;
    final remaining = await accounts.pendingOperationCount(profile.id);
    if (!context.mounted) return;
    if (remaining == 0) {
      auth.add(const AuthLogoutRequested());
    } else {
      showAppSnack(
        context,
        result?.message ??
            'Sync did not complete. Choose Discard & sign out to continue.',
      );
    }
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.profile, required this.pending});

  final UserProfile profile;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppImages.forRole(profile.role),
              width: 62,
              height: 62,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      label: profile.role.label,
                      icon: profile.role == UserRole.teacher
                          ? Icons.co_present_rounded
                          : Icons.school_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (pending > 0)
                      StatusChip(
                        label: '$pending pending',
                        color: AppColors.warning,
                        background: const Color(0xFFFFF4E0),
                      ),
                    const StatusChip(
                      label: 'Local-only mode',
                      color: AppColors.textSecondary,
                      background: Color(0xFFF1F5F9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeFormatTile extends StatelessWidget {
  const _TimeFormatTile({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const _TileIcon(icon: Icons.schedule_outlined),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time format',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Applies to timetables and timed deadlines.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SegmentedButton<TimeFormat>(
            segments: const [
              ButtonSegment(value: TimeFormat.twelveHour, label: Text('12h')),
              ButtonSegment(
                value: TimeFormat.twentyFourHour,
                label: Text('24h'),
              ),
            ],
            selected: {profile.timeFormat},
            onSelectionChanged: (selection) async {
              final format = selection.first;
              if (format == profile.timeFormat) return;
              final updated = await cubit.updateTimeFormat(profile, format);
              if (updated == null || !context.mounted) return;
              context.read<AuthBloc>().add(
                AuthProfileUpdated(profile: updated),
              );
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _TileIcon(icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle ?? value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: AppColors.primary),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

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
              'MyCampus never shares student task, event or completion data '
              'with teachers. Classrooms are online-only and appear in '
              'read-only cached form when the backend is unavailable.',
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
