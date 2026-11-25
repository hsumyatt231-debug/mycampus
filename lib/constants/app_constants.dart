/// Cross-cutting product constants derived from the SRS.
abstract final class AppConstants {
  static const String appName = 'MyCampus';
  static const String appTagline = 'Your Academic Companion';

  /// Proposed academic timezone default (TV-06: not universally confirmed).
  static const String defaultAcademicTimezone = 'Asia/Yangon';

  /// Background grace period before re-entry requires unlock (SEC-005).
  static const Duration backgroundLockThreshold = Duration(seconds: 60);

  static const List<String> weekdayLabels = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static const List<String> timeFormats = ['12-hour', '24-hour'];
}
