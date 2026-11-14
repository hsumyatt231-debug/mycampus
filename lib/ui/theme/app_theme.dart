import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';

/// Approved blue/white visual system (UI-001). The SRS purple accent remains
/// available for subject colour tokens but does not restyle approved flows.
ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.primaryBright,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.background,
    visualDensity: VisualDensity.standard,
  );

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
    borderSide: const BorderSide(color: AppColors.border),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.navy,
      displayColor: AppColors.navy,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.navy,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.navy,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(
          color: AppColors.primaryBright,
          width: 1.6,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.minTouchTarget),
        backgroundColor: AppColors.primaryBright,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.minTouchTarget),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.borderStrong),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBright,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.infoSoft,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11.5,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.infoSoft,
      selectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
      selectedLabelTextStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.infoSoft,
      side: BorderSide.none,
      labelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.navy,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
