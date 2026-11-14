import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../logic/app_lock/app_lock_cubit.dart';
import '../../logic/sync/sync_cubit.dart';

/// Shared header for the five tabs. Exposes reminders, sync status and the
/// manual lock action without adding a global app bar.
class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showUtilities = true,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showUtilities;

  @override
  Widget build(BuildContext context) {
    final sync = context.watch<SyncCubit>().state;
    final narrow = MediaQuery.sizeOf(context).width < 360;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: narrow ? 22 : 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                    color: AppColors.navy,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...?actions,
          if (showUtilities) ...[
            _UtilityButton(
              tooltip: sync.configured
                  ? 'Sync center'
                  : 'Sync center · local-only',
              icon: sync.running
                  ? Icons.sync_rounded
                  : sync.pending > 0
                  ? Icons.cloud_upload_outlined
                  : sync.configured
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
              badge: sync.pending > 0 ? '${sync.pending}' : null,
              badgeColor: sync.pending > 0
                  ? AppColors.warning
                  : AppColors.primary,
              onTap: () => context.push('/app/sync'),
            ),
            const SizedBox(width: 4),
            _UtilityButton(
              tooltip: 'Reminder Center',
              icon: Icons.notifications_none_rounded,
              onTap: () => context.push('/app/reminders'),
            ),
            const SizedBox(width: 4),
            _UtilityButton(
              tooltip: 'Lock now',
              icon: Icons.lock_outline_rounded,
              onTap: () => context.read<AppLockCubit>().lockNow(),
            ),
          ],
        ],
      ),
    );
  }
}

class _UtilityButton extends StatelessWidget {
  const _UtilityButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.badge,
    this.badgeColor = AppColors.danger,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 20, color: AppColors.navy),
              if (badge != null)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    constraints: const BoxConstraints(minWidth: 12),
                    child: Text(
                      badge!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
