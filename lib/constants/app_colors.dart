import 'package:flutter/material.dart';

/// Approved MyCampus blue/white visual system.
///
/// Tokens are sampled from the UI design gallery in the SRS appendix
/// (UI 01 - UI 10): onboarding screens use the deep blue `#0050C4`, in-app
/// screens use the brighter `#0166F0`, and every screen sits on the pale
/// `#F3F8FE` background with white cards.
abstract final class AppColors {
  static const Color primary = Color(0xFF0050C4);
  static const Color primaryBright = Color(0xFF0166F0);
  static const Color primarySoft = Color(0xFF3E86EA);
  static const Color navy = Color(0xFF0B1B33);
  static const Color navyDeep = Color(0xFF07152B);
  static const Color background = Color(0xFFF3F8FE);
  static const Color backgroundAlt = Color(0xFFF7FAFF);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE3EEFB);
  static const Color borderStrong = Color(0xFFC9DCF3);
  static const Color textSecondary = Color(0xFF5B6B82);
  static const Color textMuted = Color(0xFF93A1B5);
  static const Color success = Color(0xFF16B978);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSoft = Color(0xFFFFE8E8);
  static const Color infoSoft = Color(0xFFE7F1FE);

  /// Violet accent used by the calendar/classroom mockups (UI 09 - UI 10).
  static const Color accent = Color(0xFF6236F5);

  /// Dashboard reference palette sampled from the approved Student/Teacher
  /// dashboard mock-up: a deep-blue gradient greeting header, white cards
  /// with soft blue shadows, light-blue badges, green completion accents
  /// and light-red deadline badges.
  static const Color headerDeep = Color(0xFF064DA8);
  static const Color primaryBlue = Color(0xFF0866D9);
  static const Color accentBlue = Color(0xFF0875F5);
  static const Color skySoft = Color(0xFFE5F2FF);
  static const Color greenAccent = Color(0xFF12BE64);
  static const Color greenSoft = Color(0xFFE5F9EF);
  static const Color deadlineRed = Color(0xFFC62828);
  static const Color deadlineSoft = Color(0xFFFDE8E8);
  static const Color navInactive = Color(0xFF52647D);

  static const List<Color> subjectPalette = [
    Color(0xFF6236F5),
    Color(0xFF0865D8),
    Color(0xFF16B978),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF0EA5E9),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];
}
