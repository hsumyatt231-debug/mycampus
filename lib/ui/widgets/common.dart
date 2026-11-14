import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../models/enums.dart';

/// White surface card used across the five tabs.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius,
    this.shadow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  /// Corner radius; defaults to [AppSpacing.cardRadius].
  final double? radius;

  /// Soft blue-tinted elevation used by the dashboard redesign.
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? AppSpacing.cardRadius);
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: borderRadius, child: content),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 18 : 36,
        horizontal: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 44 : 56,
            height: compact ? 44 : 56,
            decoration: const BoxDecoration(
              color: AppColors.infoSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: compact ? 22 : 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.tone = BannerTone.error,
  });

  final String message;
  final VoidCallback? onDismiss;
  final BannerTone tone;

  @override
  Widget build(BuildContext context) {
    final isError = tone == BannerTone.error;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: isError ? AppColors.dangerSoft : AppColors.infoSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? AppColors.danger.withValues(alpha: 0.25)
              : AppColors.primaryBright.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            size: 18,
            color: isError ? AppColors.danger : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: isError ? AppColors.danger : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                size: 16,
                color: isError ? AppColors.danger : AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

enum BannerTone { error, info }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.color = AppColors.primary,
    this.background = AppColors.infoSoft,
    this.icon,
    this.maxWidth,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  /// Optional width cap for user-generated labels so a long value (for
  /// example a classroom name) can never overflow its parent on small
  /// screens. When omitted the chip keeps its intrinsic width.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
    );

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          if (maxWidth == null) labelText else Flexible(child: labelText),
        ],
      ),
    );

    if (maxWidth == null) return chip;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: chip,
    );
  }
}

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key, required this.status, this.showSynced = false});

  final SyncStatus status;
  final bool showSynced;

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced && !showSynced) {
      return const SizedBox.shrink();
    }

    final (label, color, background) = switch (status) {
      SyncStatus.synced => (
        'Synced',
        AppColors.success,
        const Color(0xFFE7F9F1),
      ),
      SyncStatus.pending => (
        'Saved locally',
        AppColors.warning,
        const Color(0xFFFFF4E0),
      ),
      SyncStatus.sending => ('Syncing', AppColors.primary, AppColors.infoSoft),
      SyncStatus.failed => (
        'Sync failed',
        AppColors.danger,
        AppColors.dangerSoft,
      ),
      SyncStatus.conflict => (
        'Conflict',
        AppColors.danger,
        AppColors.dangerSoft,
      ),
    };

    return StatusChip(label: label, color: color, background: background);
  }
}

class SubjectDot extends StatelessWidget {
  const SubjectDot({super.key, required this.colorValue, this.size = 10});

  final int colorValue;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(colorValue),
        shape: BoxShape.circle,
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final (color, background) = switch (priority) {
      TaskPriority.high => (AppColors.danger, AppColors.dangerSoft),
      TaskPriority.medium => (AppColors.warning, const Color(0xFFFFF4E0)),
      TaskPriority.low => (AppColors.success, const Color(0xFFE7F9F1)),
    };

    return StatusChip(
      label: priority.label,
      color: color,
      background: background,
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.child,
    this.maxWidth = 980,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Keep a little more breathing room on wide desktop windows while
    // tightening the gutter on very narrow phones so content keeps its width.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final resolvedPadding = padding is EdgeInsets
        ? (padding as EdgeInsets).copyWith(
            left: screenWidth < 360 ? 12 : (padding as EdgeInsets).left,
            right: screenWidth < 360 ? 12 : (padding as EdgeInsets).right,
          )
        : padding;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: resolvedPadding, child: child),
      ),
    );
  }
}

/// Maximum body width for a dialog that must stay inside the viewport on
/// small phones while keeping a comfortable reading width on desktop.
///
/// [AlertDialog] reserves 40px of inset padding on each side plus 24px of
/// content padding, so the usable body width is the screen width minus
/// ~128px. Never returns a width above [max].
double appDialogBodyWidth(BuildContext context, {double max = 500}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final available = screenWidth - 128;
  if (available <= 0) return screenWidth;
  return available < max ? available : max;
}

/// Lays [children] out side by side when there is enough horizontal room and
/// stacks them vertically on narrow layouts (small phones, split screen).
///
/// Used by forms that pair two related fields (start/end time, first/last
/// name) so a 320px-wide screen never forces an overflowing [Row].
class AppFieldRow extends StatelessWidget {
  const AppFieldRow({
    super.key,
    required this.children,
    this.spacing = 10,
    this.breakpoint = 340,
  }) : assert(children.length > 0);

  final List<Widget> children;
  final double spacing;

  /// Minimum available width before the children are placed side by side.
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'M';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
