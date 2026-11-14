import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'MyCampus',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your Academic Companion',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: AppColors.primaryBright,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
