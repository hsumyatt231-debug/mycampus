import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tight = constraints.maxWidth < 400;
            final minHeight = constraints.maxHeight > 32
                ? constraints.maxHeight - 32
                : 0.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Stack(
                  children: [
                    const Positioned.fill(child: _RoleBackdrop()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        tight ? 18 : 24,
                        10,
                        tight ? 18 : 24,
                        28,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _Header(),
                              SizedBox(height: tight ? 26 : 32),
                              Text(
                                'Create Your Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: tight ? 27 : 31,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Choose your role to get started',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: tight ? 24 : 30),
                              _RoleCard(
                                image: AppImages.student,
                                title: 'Student',
                                description:
                                    'Manage your classes, schedule, tasks, '
                                    'and study plans.',
                                onTap: () => context.push('/register/student'),
                              ),
                              const SizedBox(height: 16),
                              _RoleCard(
                                image: AppImages.teacher,
                                title: 'Teacher',
                                description:
                                    'Organize your teaching schedule, '
                                    'subjects, and tasks.',
                                onTap: () => context.push('/register/teacher'),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  16,
                                  10,
                                  4,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x4DFFFFFF),
                                      Color(0xF2FFFFFF),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Your role controls classroom '
                                      'permissions. It can only be changed '
                                      'by creating a new account.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        height: 1.45,
                                        color: Color.fromARGB(255, 17, 21, 26),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextButton(
                                      onPressed: () => context.push('/login'),
                                      child: const Text(
                                        'I already have an account',
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
              tooltip: 'Back',
            ),
          ),
          const _Wordmark(),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEAF4FF), Colors.white],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 30,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'MyCampus',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

/// Role card from the approved Role Selection mockup (UI 02): illustration on
/// the left, role copy in the middle and a chevron action on the right.
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String image;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF3F9FF)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 340;
                final roomy = constraints.maxWidth >= 500;
                final imageWidth = compact ? 82.0 : (roomy ? 120.0 : 104.0);
                final imageHeight = compact ? 110.0 : (roomy ? 138.0 : 128.0);
                final titleSize = compact ? 20.0 : (roomy ? 24.0 : 22.0);
                final chevronSize = compact ? 32.0 : 38.0;

                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        image,
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: compact ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: chevronSize,
                      height: chevronSize,
                      decoration: const BoxDecoration(
                        color: AppColors.infoSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: compact ? 21 : 25,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Decorative background: pale-blue page wash, soft upper waves, the campus
/// photo rising from the bottom and layered blue waves along the bottom edge.
class _RoleBackdrop extends StatelessWidget {
  const _RoleBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF3F8FE)],
                stops: [0, 0.62],
              ),
            ),
          ),
          const CustomPaint(painter: _SoftWavesPainter()),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.38,
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
          const Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 170,
              child: CustomPaint(painter: _BottomWavesPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle light-blue curves behind the header and cards.
class _SoftWavesPainter extends CustomPainter {
  const _SoftWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final width = size.width;
    final rawHeight = size.height * 0.46;
    final height = rawHeight > 360 ? 360.0 : rawHeight;
    if (height <= 0) return;

    final bounds = Rect.fromLTWH(0, 0, width, height);

    void layer(Path path, List<Color> colors) {
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
      ..lineTo(width * 0.96, 0)
      ..cubicTo(
        width * 0.86,
        height * 0.17,
        width * 0.58,
        height * 0.09,
        width * 0.45,
        height * 0.27,
      )
      ..cubicTo(
        width * 0.30,
        height * 0.46,
        width * 0.12,
        height * 0.34,
        0,
        height * 0.50,
      )
      ..close();
    layer(back, const [Color(0x248FC8F8), Color(0x078FC8F8)]);

    final middle = Path()
      ..moveTo(0, 0)
      ..lineTo(width * 0.68, 0)
      ..cubicTo(
        width * 0.64,
        height * 0.09,
        width * 0.40,
        height * 0.06,
        width * 0.29,
        height * 0.19,
      )
      ..cubicTo(
        width * 0.19,
        height * 0.32,
        width * 0.06,
        height * 0.24,
        0,
        height * 0.38,
      )
      ..close();
    layer(middle, const [Color(0x1F9BD0FA), Color(0x009BD0FA)]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Layered blue waves that sit along the bottom edge over the campus photo.
class _BottomWavesPainter extends CustomPainter {
  const _BottomWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final width = size.width;
    final height = size.height;
    if (width <= 0 || height <= 0) return;

    void fill(Path path, List<Color> colors) {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(Rect.fromLTWH(0, 0, width, height));
      canvas.drawPath(path, paint);
    }

    final back = Path()
      ..moveTo(0, height * 0.46)
      ..cubicTo(
        width * 0.24,
        height * 0.26,
        width * 0.46,
        height * 0.66,
        width,
        height * 0.38,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(back, const [Color(0x3D9BD0FA), Color(0x149BD0FA)]);

    final middle = Path()
      ..moveTo(0, height * 0.64)
      ..cubicTo(
        width * 0.22,
        height * 0.46,
        width * 0.52,
        height * 0.82,
        width,
        height * 0.56,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(middle, const [Color(0x4DA8D6FB), Color(0x1AA8D6FB)]);

    final front = Path()
      ..moveTo(0, height * 0.80)
      ..cubicTo(
        width * 0.28,
        height * 0.64,
        width * 0.60,
        height * 0.96,
        width,
        height * 0.74,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    fill(front, const [Color(0x5CC4E3FC), Color(0x24C4E3FC)]);

    final crest = Path()
      ..moveTo(0, height * 0.64)
      ..cubicTo(
        width * 0.22,
        height * 0.46,
        width * 0.52,
        height * 0.82,
        width,
        height * 0.56,
      );
    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = const Color(0x3390C8F5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
