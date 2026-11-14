import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';
import '../models/enums.dart';

/// Academic wall-clock helpers.
///
/// Date-only deadlines are end-of-day in the applicable academic timezone
/// (FR-TASK-006). Timezone changes preserve wall-clock values and only
/// recalculate derived instants (DET-TZ-003).
///
/// DST policy (TV-05, deterministic):
/// * Non-existent local times move forward by the DST gap.
/// * Ambiguous local times resolve to the earlier (pre-transition) offset.
abstract final class AcademicClock {
  static bool _initialised = false;

  static void initialize() {
    if (_initialised) return;
    tz_data.initializeTimeZones();
    _initialised = true;
  }

  static tz.Location location(String timezoneName) {
    initialize();
    try {
      return tz.getLocation(timezoneName);
    } catch (_) {
      return tz.getLocation(AppConstants.defaultAcademicTimezone);
    }
  }

  /// Today's `yyyy-MM-dd` key in [timezoneName].
  static String todayKey({
    String timezoneName = AppConstants.defaultAcademicTimezone,
  }) {
    return dateKey(nowIn(timezoneName));
  }

  static DateTime nowIn(String timezoneName) {
    final zone = location(timezoneName);
    final now = tz.TZDateTime.now(zone);
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
    );
  }

  static String dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? parseDateKey(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Builds the UTC instant for a wall-clock date/time in [timezoneName].
  ///
  /// Missing time means academic end of day (23:59:59.999).
  static DateTime? dueInstant({
    required String? date,
    String? time,
    required String timezoneName,
  }) {
    final parsed = parseDateKey(date);
    if (parsed == null) return null;

    final zone = location(timezoneName);
    final parts = _parseTime(time);

    int hour = parts.$1;
    int minute = parts.$2;
    int second = 59;
    int millisecond = 999;

    if (parts.$3) {
      second = 0;
      millisecond = 0;
    } else {
      hour = 23;
      minute = 59;
    }

    var local = tz.TZDateTime(
      zone,
      parsed.year,
      parsed.month,
      parsed.day,
      hour,
      minute,
      second,
      millisecond,
    );

    // Non-existent wall-clock time: TZDateTime shifts into the DST gap, which
    // is the documented deterministic policy. Ambiguous times keep the offset
    // selected by the tz database (earlier occurrence).
    local = local;
    return local.toUtc();
  }

  /// Minutes-from-midnight wall clock to a formatter-friendly [TimeOfDay]-like
  /// (hour, minute) pair.
  static (int, int) splitMinutes(int minutes) {
    final safe = minutes.clamp(0, 24 * 60 - 1);
    return (safe ~/ 60, safe % 60);
  }

  static int toMinutes(int hour, int minute) => hour * 60 + minute;

  static String formatMinutes(int minutes, TimeFormat format) {
    final (hour, minute) = splitMinutes(minutes);
    return formatTime(hour, minute, format);
  }

  static String formatTime(int hour, int minute, TimeFormat format) {
    if (format == TimeFormat.twentyFourHour) {
      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}';
    }
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
  }

  static String formatInstant(DateTime instant, TimeFormat format) {
    final local = instant.toLocal();
    return '${DateFormat('MMM d, yyyy').format(local)} · '
        '${formatTime(local.hour, local.minute, format)}';
  }

  static String formatDateKey(String key, {String pattern = 'MMM d, yyyy'}) {
    final parsed = parseDateKey(key);
    if (parsed == null) return key;
    return DateFormat(pattern).format(parsed);
  }

  static String formatMinutesRange(int start, int end, TimeFormat format) {
    return '${formatMinutes(start, format)} – ${formatMinutes(end, format)}';
  }

  static int isoWeekday(DateTime date) => date.weekday; // 1 = Monday.

  static (int, int, bool) _parseTime(String? time) {
    if (time == null || time.isEmpty) return (23, 59, false);
    final pieces = time.split(':');
    if (pieces.length < 2) return (23, 59, false);
    final hour = int.tryParse(pieces[0]);
    final minute = int.tryParse(pieces[1]);
    if (hour == null || minute == null) return (23, 59, false);
    return (hour.clamp(0, 23), minute.clamp(0, 59), true);
  }

  static String normalizeTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  static (int, int) parseTimeParts(String? time) {
    final (hour, minute, hasTime) = _parseTime(time);
    return hasTime ? (hour, minute) : (9, 0);
  }

  static String monthLabel(DateTime month) {
    return DateFormat('MMMM yyyy').format(month);
  }
}
