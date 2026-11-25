import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final wide = width >= 900;
            final compact = height < 760;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: wide
                    ? _WideWelcome(height: height)
                    : _NarrowWelcome(compact: compact),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NarrowWelcome extends StatelessWidget {
  const _NarrowWelcome({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _CampusBackdrop(compact: compact)),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: const _WelcomeWavesPainter()),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, compact ? 20 : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 17,
                        color: AppColors.navy,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'English',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: compact ? 18 : 36),
              Center(
                child: Container(
                  width: compact ? 70 : 88,
                  height: compact ? 70 : 88,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
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
                    size: 46,
                    color: AppColors.primaryBright,
                  ),
                ),
              ),
              SizedBox(height: compact ? 14 : 22),
              const Text(
                'MyCampus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  color: AppColors.navyDeep,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your Academic Companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: compact ? 18 : 32),
              const Row(
                children: [
                  Expanded(
                    child: _FeaturePill(
                      icon: Icons.calendar_month_rounded,
                      label: 'Schedule\nclasses',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _FeaturePill(
                      icon: Icons.task_alt_rounded,
                      label: 'Manage\ntasks',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _FeaturePill(
                      icon: Icons.menu_book_rounded,
                      label: 'Organize\nsubjects',
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 24 : 34),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () => context.push('/roles'),
                child: const Text('Create account'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.white.withValues(alpha: 0.72),
                ),
                onPressed: () => context.push('/login'),
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00FFFFFF), Color(0xE6FFFFFF)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 4),
                  child: Column(
                    children: const [
                      Text(
                        'New to MyCampus? Create an account to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 35, 39, 6),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your planner stays available, even without a connection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color.fromARGB(255, 168, 42, 46),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WideWelcome extends StatelessWidget {
  const _WideWelcome({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            // A minimum height keeps the desktop hero full-bleed while still
            // letting the column grow (and the page scroll) on short windows.
            constraints: BoxConstraints(minHeight: height),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.campus),
                fit: BoxFit.cover,
              ),
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xF2FFFFFF), Color(0xC7EAF4FF)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.primaryBright,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Plan your semester\nwith confidence.',
                      style: TextStyle(
                        fontSize: 38,
                        height: 1.12,
                        letterSpacing: -1.4,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navyDeep,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Subjects, tasks, timetable and deadlines in one calm, '
                      'offline-first workspace for students and teachers.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.55,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _WideFeature(
                          icon: Icons.cloud_done_outlined,
                          label: 'Offline-first',
                        ),
                        _WideFeature(
                          icon: Icons.lock_outline_rounded,
                          label: 'Private by default',
                        ),
                        _WideFeature(
                          icon: Icons.devices_rounded,
                          label: 'Android & Windows',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create an account or sign in to continue.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 26),
                    FilledButton(
                      onPressed: () => context.push('/roles'),
                      child: const Text('Create account'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => context.push('/login'),
                      child: const Text('I already have an account'),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Plan your day offline. Classrooms and shared data sync '
                      'when you are connected.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.infoSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBright, size: 21),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _WideFeature extends StatelessWidget {
  const _WideFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width campus photo that rises from the bottom of the Welcome screen.
///
/// The photo sits behind the content, and a white-to-transparent gradient over
/// its upper half blends it into the page so there is no hard rectangular edge.
class _CampusBackdrop extends StatelessWidget {
  const _CampusBackdrop({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: compact ? 0.48 : 0.54,
          child: Stack(
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
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0x00FFFFFF),
                      Color(0x00FFFFFF),
                    ],
                    stops: [0, 0.55, 1],
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

/// Layered light-blue curved wave shapes anchored to the top-left corner.
class _WelcomeWavesPainter extends CustomPainter {
  const _WelcomeWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final width = size.width;
    final rawHeight = size.height * 0.4;
    final height = rawHeight > 340 ? 340.0 : rawHeight;
    if (height <= 0) return;

    final bounds = Rect.fromLTWH(0, 0, width, height);

    void paintLayer(Path path, List<Color> colors) {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(bounds);
      canvas.drawPath(path, paint);
    }

    final back = Path()
      ..moveTo(0, 0)
      ..lineTo(width * 0.98, 0)
      ..cubicTo(
        width * 0.90,
        height * 0.16,
        width * 0.64,
        height * 0.10,
        width * 0.50,
        height * 0.30,
      )
      ..cubicTo(
        width * 0.36,
        height * 0.50,
        width * 0.14,
        height * 0.38,
        0,
        height * 0.56,
      )
      ..close();
    paintLayer(back, const [Color(0x338FC8F8), Color(0x0D8FC8F8)]);

    final middle = Path()
      ..moveTo(0, 0)
      ..lineTo(width * 0.74, 0)
      ..cubicTo(
        width * 0.70,
        height * 0.10,
        width * 0.46,
        height * 0.07,
        width * 0.35,
        height * 0.22,
      )
      ..cubicTo(
        width * 0.24,
        height * 0.37,
        width * 0.08,
        height * 0.28,
        0,
        height * 0.44,
      )
      ..close();
    paintLayer(middle, const [Color(0x2E9BD0FA), Color(0x0A9BD0FA)]);

    final front = Path()
      ..moveTo(0, 0)
      ..lineTo(width * 0.46, 0)
      ..cubicTo(
        width * 0.43,
        height * 0.08,
        width * 0.29,
        height * 0.05,
        width * 0.20,
        height * 0.16,
      )
      ..cubicTo(
        width * 0.11,
        height * 0.27,
        width * 0.03,
        height * 0.21,
        0,
        height * 0.32,
      )
      ..close();
    paintLayer(front, const [Color(0x2B6FAFF2), Color(0x006FAFF2)]);

    final edge = Path()
      ..moveTo(width * 0.98, 0)
      ..cubicTo(
        width * 0.90,
        height * 0.16,
        width * 0.64,
        height * 0.10,
        width * 0.50,
        height * 0.30,
      )
      ..cubicTo(
        width * 0.36,
        height * 0.50,
        width * 0.14,
        height * 0.38,
        0,
        height * 0.56,
      );
    canvas.drawPath(
      edge,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0x335B9BE8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
