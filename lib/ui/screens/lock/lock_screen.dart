import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_spacing.dart';
import '../../../logic/app_lock/app_lock_cubit.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../widgets/common.dart';

/// Full-screen re-entry gate. It covers the app after cold start, after the
/// 60-second background threshold, or when the user locks manually
/// (DET-SEC-005/006). Biometric device authentication is a documented open
/// verification item; password unlock is the guaranteed fallback.
///
/// Visual: approved Blue & White reference. Soft blue corner curves are
/// painted in code, the existing campus photo blends into the foot of the
/// screen, and a frosted unlock card carries the initials avatar and the
/// gradient unlock button. Presentation only - the unlock flow, timers and
/// state transitions are unchanged.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _password = TextEditingController();
  final _focus = FocusNode();
  bool _hide = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _password.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final profile = context.read<AuthBloc>().state.profile;
    if (profile == null) return;
    final ok = await context.read<AppLockCubit>().unlock(
      accountId: profile.id,
      password: _password.text,
    );
    if (!ok) {
      _password.clear();
      _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthBloc>().state.profile;
    final lock = context.watch<AppLockCubit>().state;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Material(
      color: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Existing campus photo strip hugging the foot of the screen.
          final campusHeight = (constraints.maxHeight * 0.32).clamp(
            160.0,
            360.0,
          );

          return Stack(
            children: [
              const Positioned.fill(child: _LockBackdrop()),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: campusHeight,
                child: const _CampusFooter(),
              ),
              Positioned.fill(
                child: Padding(
                  // Keeps the card reachable above the on-screen keyboard.
                  padding: EdgeInsets.only(bottom: keyboard),
                  child: SafeArea(
                    minimum: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const _BrandHeader(),
                                    const SizedBox(height: 28),
                                    _UnlockCard(
                                      name: profile?.fullName,
                                      busy: lock.busy,
                                      error: lock.error,
                                      controller: _password,
                                      focusNode: _focus,
                                      obscure: _hide,
                                      onToggleObscure: () =>
                                          setState(() => _hide = !_hide),
                                      onUnlock: _unlock,
                                    ),
                                    const SizedBox(height: 18),
                                    const _LockFootnote(),
                                    const SizedBox(height: 6),
                                    TextButton.icon(
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                          const AuthLogoutRequested(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Sign out instead'),
                                    ),
                                    if (context.watch<AuthBloc>().state.error !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: ErrorBanner(
                                          message: context
                                              .watch<AuthBloc>()
                                              .state
                                              .error!,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// MyCampus brand block matching the Welcome screen (UI 01): white logo
/// tile with the blue graduation cap, bold navy wordmark and tagline.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.14),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 40,
            color: AppColors.primaryBright,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'MyCampus',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            color: AppColors.navyDeep,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your Academic Companion',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Frosted unlock card with the blue initials avatar and lock badge
/// overlapping the top edge (approved Blue & White reference).
class _UnlockCard extends StatelessWidget {
  const _UnlockCard({
    required this.name,
    required this.busy,
    required this.error,
    required this.controller,
    required this.focusNode,
    required this.obscure,
    required this.onToggleObscure,
    required this.onUnlock,
  });

  final String? name;
  final bool busy;
  final String? error;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onUnlock;

  static const double _avatarSize = 92;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          // The avatar's centre sits exactly on the card's top edge.
          padding: const EdgeInsets.only(top: _avatarSize / 2),
          child: AppCard(
            radius: 26,
            shadow: true,
            color: Colors.white.withValues(alpha: 0.92),
            borderColor: Colors.white.withValues(alpha: 0.9),
            padding: EdgeInsets.fromLTRB(22, _avatarSize / 2 + 14, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name == null ? 'Welcome Back,' : 'Welcome Back, $name',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter your password to unlock',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onUnlock(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: AppColors.navy,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 21,
                      color: AppColors.primaryBlue,
                    ),
                    suffixIcon: IconButton(
                      onPressed: onToggleObscure,
                      tooltip: obscure ? 'Show password' : 'Hide password',
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 21,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.borderStrong,
                        width: 1.4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  ErrorBanner(message: error!),
                ],
                const SizedBox(height: 14),
                _GradientUnlockButton(busy: busy, onUnlock: onUnlock),
              ],
            ),
          ),
        ),
        _AvatarWithBadge(name: name ?? 'MyCampus'),
      ],
    );
  }
}

/// Blue circular initials avatar with a small lock badge attached at the
/// lower right. Initials come from the authenticated profile.
class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _UnlockCard._avatarSize,
      height: _UnlockCard._avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentBlue,
                    AppColors.primaryBlue,
                    AppColors.headerDeep,
                  ],
                ),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.headerDeep.withValues(alpha: 0.30),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                initialsOf(name),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.headerDeep.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width gradient unlock button, bright blue to deep royal blue, with
/// the busy spinner kept from the original implementation.
class _GradientUnlockButton extends StatelessWidget {
  const _GradientUnlockButton({required this.busy, required this.onUnlock});

  final bool busy;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.accentBlue,
            AppColors.primaryBlue,
            AppColors.headerDeep,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: busy ? 0.12 : 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: busy ? null : onUnlock,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.10),
          child: SizedBox(
            height: AppSpacing.minTouchTarget + 4,
            child: Center(
              child: busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_open_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Unlock',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Retained security note from the original implementation, restyled for the
/// veiled campus backdrop.
class _LockFootnote extends StatelessWidget {
  const _LockFootnote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Locked after 60 seconds in the background. Sensitive content is '
      'shielded while the app is inactive.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// Existing campus photo blended into the bottom of the screen with a soft
/// white/light-blue gradient veil (asset reused, not replaced).
class _CampusFooter extends StatelessWidget {
  const _CampusFooter();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.campus,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFDFEFF), Color(0xE6F7FBFF), Color(0x66EBF4FF)],
              stops: [0, 0.45, 1],
            ),
          ),
        ),
      ],
    );
  }
}

/// Light blue-to-white base with the blue corner curves painted in code.
class _LockBackdrop extends StatelessWidget {
  const _LockBackdrop();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: CustomPaint(
        painter: _LockCurvePainter(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEAF4FF), Color(0xFFF4F9FE), Color(0xFFFFFFFF)],
              stops: [0, 0.5, 1],
            ),
          ),
        ),
      ),
    );
  }
}

/// Blue curved decorations from the approved reference: large soft arcs in
/// the top-left corner and subtle accents along the right edge. All radii
/// scale with the shortest screen side so the shapes hold on phones,
/// tablets and desktop windows. No decoration images are used.
class _LockCurvePainter extends CustomPainter {
  const _LockCurvePainter();

  void _arc(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double alpha,
    double startAngle,
    double sweepAngle,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryBlue.withValues(alpha: alpha);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final scale = size.shortestSide;
    final hairline = math.max(1.2, scale * 0.004);

    // Top-left corner: large soft quarter-circle washes anchored off-canvas.
    final corner = Offset(-width * 0.10, -height * 0.14);
    final wash = Paint()..color = AppColors.primaryBlue.withValues(alpha: 0.08);
    canvas.drawCircle(corner, scale * 0.44, wash);
    wash.color = AppColors.accentBlue.withValues(alpha: 0.05);
    canvas.drawCircle(corner, scale * 0.62, wash);

    // Top-left corner: echoing arc strokes hugging the same curve.
    _arc(
      canvas,
      corner,
      scale * 0.72,
      math.max(hairline, scale * 0.012),
      0.16,
      0.06,
      1.02,
    );
    _arc(canvas, corner, scale * 0.86, hairline * 1.2, 0.09, 0.03, 1.16);

    // Right edge: subtle curved accents.
    final right = Offset(width + scale * 0.12, height * 0.30);
    _arc(
      canvas,
      right,
      scale * 0.34,
      math.max(hairline, scale * 0.008),
      0.11,
      math.pi * 0.90,
      0.5,
    );
    _arc(canvas, right, scale * 0.46, hairline, 0.07, math.pi * 0.87, 0.62);
  }

  @override
  bool shouldRepaint(covariant _LockCurvePainter oldDelegate) => false;
}
