import 'enums.dart';

/// Weekly Monday-Friday timetable entry (FR-CAL-005/007).
class TimetableEntry {
  const TimetableEntry({
    required this.id,
    required this.accountId,
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.room,
    this.revision = 0,
    this.syncStatus = SyncStatus.pending,
    this.deletedAt,
    this.updatedAt,
  });

  final String id;
  final String accountId;
  final String subjectId;

  /// 1 = Monday ... 5 = Friday.
  final int weekday;

  /// Minutes from midnight in the academic timezone.
  final int startMinutes;
  final int endMinutes;
  final String? room;
  final int revision;
  final SyncStatus syncStatus;
  final DateTime? deletedAt;
  final DateTime? updatedAt;

  bool get isDeleted => deletedAt != null;
  Duration get duration => Duration(minutes: endMinutes - startMinutes);

  bool overlaps(TimetableEntry other) {
    return weekday == other.weekday &&
        startMinutes < other.endMinutes &&
        other.startMinutes < endMinutes;
  }

  TimetableEntry copyWith({
    String? subjectId,
    int? weekday,
    int? startMinutes,
    int? endMinutes,
    String? room,
    int? revision,
    SyncStatus? syncStatus,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return TimetableEntry(
      id: id,
      accountId: accountId,
      subjectId: subjectId ?? this.subjectId,
      weekday: weekday ?? this.weekday,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      room: room ?? this.room,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'weekday': weekday,
    'start_minutes': startMinutes,
    'end_minutes': endMinutes,
    'room': room,
    'revision': revision,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
    'updated_at': updatedAt?.toUtc().toIso8601String(),
  };

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      subjectId: json['subject_id'] as String? ?? '',
      weekday: (json['weekday'] as num?)?.toInt() ?? 1,
      startMinutes: (json['start_minutes'] as num?)?.toInt() ?? 0,
      endMinutes: (json['end_minutes'] as num?)?.toInt() ?? 0,
      room: json['room'] as String?,
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }
}
