import 'enums.dart';

class AcademicEvent {
  const AcademicEvent({
    required this.id,
    required this.accountId,
    required this.title,
    required this.type,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.description,
    this.location,
    this.reminderOffsetMinutes,
    this.revision = 0,
    this.syncStatus = SyncStatus.pending,
    this.deletedAt,
    this.updatedAt,
  });

  final String id;
  final String accountId;
  final String title;
  final AcademicEventType type;

  /// yyyy-MM-dd wall-clock date.
  final String eventDate;

  /// HH:mm wall-clock start/end (optional).
  final String? startTime;
  final String? endTime;
  final String? description;
  final String? location;
  final int? reminderOffsetMinutes;
  final int revision;
  final SyncStatus syncStatus;
  final DateTime? deletedAt;
  final DateTime? updatedAt;

  bool get isDeleted => deletedAt != null;

  AcademicEvent copyWith({
    String? title,
    AcademicEventType? type,
    String? eventDate,
    String? startTime,
    bool clearStartTime = false,
    String? endTime,
    bool clearEndTime = false,
    String? description,
    String? location,
    int? reminderOffsetMinutes,
    bool clearReminder = false,
    int? revision,
    SyncStatus? syncStatus,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return AcademicEvent(
      id: id,
      accountId: accountId,
      title: title ?? this.title,
      type: type ?? this.type,
      eventDate: eventDate ?? this.eventDate,
      startTime: clearStartTime ? null : startTime ?? this.startTime,
      endTime: clearEndTime ? null : endTime ?? this.endTime,
      description: description ?? this.description,
      location: location ?? this.location,
      reminderOffsetMinutes: clearReminder
          ? null
          : reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.code,
    'event_date': eventDate,
    'start_time': startTime,
    'end_time': endTime,
    'description': description,
    'location': location,
    'reminder_offset': reminderOffsetMinutes,
    'revision': revision,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
    'updated_at': updatedAt?.toUtc().toIso8601String(),
  };

  factory AcademicEvent.fromJson(Map<String, dynamic> json) {
    return AcademicEvent(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: AcademicEventType.fromCode(json['type'] as String?),
      eventDate: json['event_date'] as String? ?? '',
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      reminderOffsetMinutes: (json['reminder_offset'] as num?)?.toInt(),
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }
}
