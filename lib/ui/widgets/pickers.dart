import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/academic_clock.dart';

Future<String?> pickDateKey(
  BuildContext context, {
  String? initial,
  DateTime? firstDate,
  DateTime? lastDate,
  String helpText = 'Select date',
}) async {
  final now = DateTime.now();
  final parsed = AcademicClock.parseDateKey(initial) ?? now;
  final result = await showDatePicker(
    context: context,
    initialDate: parsed,
    firstDate: firstDate ?? DateTime(now.year - 2),
    lastDate: lastDate ?? DateTime(now.year + 5),
    helpText: helpText,
  );
  if (result == null) return null;
  return AcademicClock.dateKey(result);
}

Future<String?> pickTimeString(
  BuildContext context, {
  String? initial,
  String helpText = 'Select time',
}) async {
  final (hour, minute) = AcademicClock.parseTimeParts(initial);
  final result = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: hour, minute: minute),
    helpText: helpText,
  );
  if (result == null) return null;
  return AcademicClock.normalizeTime(result.hour, result.minute);
}

String dateLabel(String? key) {
  if (key == null || key.isEmpty) return 'No date';
  return AcademicClock.formatDateKey(key);
}

String dueLabel(DateTime dueAt, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final difference = dueAt.difference(current);
  if (difference.isNegative) {
    final overdue = current.difference(dueAt);
    if (overdue.inDays >= 1) return 'Overdue by ${overdue.inDays}d';
    if (overdue.inHours >= 1) return 'Overdue by ${overdue.inHours}h';
    return 'Overdue';
  }
  if (difference.inMinutes < 60) {
    return 'Due in ${difference.inMinutes.clamp(1, 59)}m';
  }
  if (difference.inHours < 24) {
    return 'Due in ${difference.inHours}h';
  }
  if (difference.inDays == 1) return 'Due tomorrow';
  if (difference.inDays < 7) return 'Due in ${difference.inDays}d';
  return DateFormat('MMM d').format(dueAt.toLocal());
}
