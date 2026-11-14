import 'enums.dart';

class Subject {
  const Subject({
    required this.id,
    required this.accountId,
    required this.name,
    required this.code,
    this.colorValue = 0xFF6236F5,
    this.teacherName,
    this.room,
    this.revision = 0,
    this.syncStatus = SyncStatus.pending,
    this.deletedAt,
    this.updatedAt,
  });

  final String id;
  final String accountId;
  final String name;
  final String code;

  /// ARGB colour value; defaults to the SRS purple baseline.
  final int colorValue;
  final String? teacherName;
  final String? room;
  final int revision;
  final SyncStatus syncStatus;
  final DateTime? deletedAt;
  final DateTime? updatedAt;

  bool get isDeleted => deletedAt != null;

  Subject copyWith({
    String? name,
    String? code,
    int? colorValue,
    String? teacherName,
    String? room,
    int? revision,
    SyncStatus? syncStatus,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id,
      accountId: accountId,
      name: name ?? this.name,
      code: code ?? this.code,
      colorValue: colorValue ?? this.colorValue,
      teacherName: teacherName ?? this.teacherName,
      room: room ?? this.room,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'color': colorValue,
    'teacher_name': teacherName,
    'room': room,
    'revision': revision,
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
    'updated_at': updatedAt?.toUtc().toIso8601String(),
  };

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      colorValue: (json['color'] as num?)?.toInt() ?? 0xFF6236F5,
      teacherName: json['teacher_name'] as String?,
      room: json['room'] as String?,
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }
}
