import 'package:drift/drift.dart' as d;

import '../models/academic_event.dart';
import '../models/assignment.dart';
import '../models/classroom.dart';
import '../models/classroom_member.dart';
import '../models/enums.dart';
import '../services/cloud_gateway.dart';
import '../services/local_database.dart';
import 'assignment_repository.dart';

class ClassroomDetail {
  const ClassroomDetail({
    required this.classroom,
    this.members = const [],
    this.events = const [],
    this.assignments = const [],
  });

  final Classroom classroom;
  final List<ClassroomMember> members;
  final List<MembershipEvent> events;
  final List<Assignment> assignments;
}

/// Classroom features are online-only (FR-CLASS-011); reads come from the
/// account-scoped cache updated by authorized responses.
class ClassroomRepository {
  ClassroomRepository(this._database, this._gateway, this._assignments);

  final LocalDatabase _database;
  final CloudGateway _gateway;
  final AssignmentRepository _assignments;

  bool get isCloudConfigured => _gateway.isConfigured;

  Future<List<Classroom>> cachedClassrooms(String accountId) async {
    final rows =
        await (_database.select(_database.cachedClassrooms)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => d.OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_mapClassroom).toList();
  }

  Future<Classroom?> cachedClassroom(
    String accountId,
    String classroomId,
  ) async {
    final row =
        await (_database.select(_database.cachedClassrooms)..where(
              (t) => t.id.equals(classroomId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    return row == null ? null : _mapClassroom(row);
  }

  Future<List<ClassroomMember>> cachedMembers(
    String accountId,
    String classroomId,
  ) async {
    final rows =
        await (_database.select(_database.cachedClassroomMembers)
              ..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.classroomId.equals(classroomId),
              )
              ..orderBy([(t) => d.OrderingTerm.asc(t.studentName)]))
            .get();
    return rows.map(_mapMember).toList();
  }

  Future<List<MembershipEvent>> cachedEvents(
    String accountId,
    String classroomId,
  ) async {
    final rows =
        await (_database.select(_database.cachedMembershipEvents)
              ..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.classroomId.equals(classroomId),
              )
              ..orderBy([(t) => d.OrderingTerm.desc(t.createdAt)]))
            .get();
    return rows.map(_mapEvent).toList();
  }

  /// Refreshes the classrooms visible to this account (owned or joined).
  Future<List<Classroom>> refreshMyClassrooms(String accountId) async {
    final payload = await _gateway.fetchClassrooms();

    await _database.transaction(() async {
      await (_database.delete(
        _database.cachedClassrooms,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (_database.delete(
        _database.cachedClassroomMembers,
      )..where((t) => t.accountId.equals(accountId))).go();
      await (_database.delete(
        _database.cachedMembershipEvents,
      )..where((t) => t.accountId.equals(accountId))).go();

      for (final item in payload) {
        await _upsertClassroom(accountId, item);
        await _upsertMembersList(accountId, _listAt(item, 'members'));
        await _upsertEventsList(accountId, _listAt(item, 'events'));
      }
    });

    return cachedClassrooms(accountId);
  }

  Future<ClassroomDetail> refreshDetail(
    String accountId,
    String classroomId,
  ) async {
    final payload = await _gateway.fetchClassroomDetail(classroomId);

    final classroomPayload = payload['classroom'] is Map
        ? Map<String, dynamic>.from(payload['classroom'] as Map)
        : payload;

    await _database.transaction(() async {
      await _upsertClassroom(accountId, classroomPayload);
      await _upsertMembersList(accountId, _listAt(payload, 'members'));
      await _upsertEventsList(accountId, _listAt(payload, 'events'));
    });

    final assignmentPayload = _listAt(payload, 'assignments');
    if (assignmentPayload.isNotEmpty) {
      await _assignments.replaceForClassroom(
        accountId,
        classroomId,
        assignmentPayload,
      );
    }

    await _upsertProgressList(accountId, _listAt(payload, 'progress'));

    final classroom = await cachedClassroom(accountId, classroomId);
    if (classroom == null) {
      throw const ClassroomUnavailableException(
        'Classroom is no longer available to this account.',
      );
    }

    return ClassroomDetail(
      classroom: classroom,
      members: await cachedMembers(accountId, classroomId),
      events: await cachedEvents(accountId, classroomId),
      assignments: await _assignments.cached(
        accountId,
        classroomId: classroomId,
      ),
    );
  }

  Future<Classroom> createClassroom({
    required String accountId,
    required String name,
    required String subjectName,
    String? description,
  }) async {
    if (name.trim().isEmpty) {
      throw const ClassroomValidationException('Classroom name is required.');
    }
    if (subjectName.trim().isEmpty) {
      throw const ClassroomValidationException('Subject name is required.');
    }

    final payload = await _gateway.createClassroom(
      name: name.trim(),
      subjectName: subjectName.trim(),
      description: description?.trim(),
    );

    await _upsertClassroom(accountId, payload);
    final classroom = await cachedClassroom(
      accountId,
      payload['id'] as String? ?? '',
    );
    if (classroom == null) {
      throw const ClassroomUnavailableException(
        'Classroom was created but could not be cached.',
      );
    }
    return classroom;
  }

  /// Join is instant online; scope bootstrap fetches pre-existing published
  /// assignments and own progress (FR-SYNC-009, AT-07).
  Future<Classroom> joinClassroom({
    required String accountId,
    required String code,
  }) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      throw const ClassroomValidationException('Enter a join code.');
    }

    final payload = await _gateway.joinClassroom(trimmed);
    await _upsertClassroom(accountId, payload);

    final classroomId = payload['id'] as String? ?? '';
    if (classroomId.isEmpty) {
      throw const ClassroomUnavailableException('Invalid join response.');
    }

    final bootstrap = await _gateway.bootstrapScope(classroomId: classroomId);

    await _upsertMembersList(accountId, _listAt(bootstrap, 'members'));
    await _assignments.replaceForClassroom(
      accountId,
      classroomId,
      _listAt(bootstrap, 'assignments'),
    );
    await _upsertProgressList(accountId, _listAt(bootstrap, 'progress'));

    final classroom = await cachedClassroom(accountId, classroomId);
    if (classroom == null) {
      throw const ClassroomUnavailableException(
        'Joined, but the classroom could not be cached.',
      );
    }
    return classroom;
  }

  Future<void> leaveClassroom(String accountId, String classroomId) async {
    await _gateway.leaveClassroom(classroomId);
    await _database.transaction(() async {
      await (_database.delete(_database.cachedAssignments)..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.classroomId.equals(classroomId),
          ))
          .go();
      await (_database.delete(_database.cachedClassroomMembers)..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.classroomId.equals(classroomId),
          ))
          .go();
      await (_database.delete(_database.cachedClassrooms)..where(
            (t) => t.id.equals(classroomId) & t.accountId.equals(accountId),
          ))
          .go();
    });
  }

  Future<void> removeMember({
    required String accountId,
    required String classroomId,
    required String membershipId,
  }) async {
    await _gateway.removeMember(membershipId);
    await refreshDetail(accountId, classroomId);
  }

  Future<void> unblockMember({
    required String accountId,
    required String classroomId,
    required String membershipId,
  }) async {
    await _gateway.unblockMember(membershipId);
    await refreshDetail(accountId, classroomId);
  }

  Future<String> resetJoinCode(String accountId, String classroomId) async {
    final code = await _gateway.resetJoinCode(classroomId);
    await (_database.update(_database.cachedClassrooms)..where(
          (t) => t.id.equals(classroomId) & t.accountId.equals(accountId),
        ))
        .write(CachedClassroomsCompanion(joinCode: d.Value(code)));
    return code;
  }

  Future<void> archiveClassroom(String accountId, String classroomId) async {
    await _gateway.archiveClassroom(classroomId);
    await (_database.update(_database.cachedClassrooms)..where(
          (t) => t.id.equals(classroomId) & t.accountId.equals(accountId),
        ))
        .write(const CachedClassroomsCompanion(archived: d.Value(true)));
  }

  Future<void> _upsertClassroom(
    String accountId,
    Map<String, dynamic> payload,
  ) async {
    final id = payload['id'] as String?;
    if (id == null || id.isEmpty) return;

    await _database
        .into(_database.cachedClassrooms)
        .insertOnConflictUpdate(
          CachedClassroomsCompanion.insert(
            id: id,
            accountId: accountId,
            teacherId: payload['teacher_id'] as String? ?? '',
            teacherName: d.Value(payload['teacher_name'] as String?),
            name: payload['name'] as String? ?? '',
            subjectName: payload['subject_name'] as String? ?? '',
            description: d.Value(payload['description'] as String?),
            joinCode: d.Value(payload['join_code'] as String?),
            timezone: payload['timezone'] as String? ?? 'Asia/Yangon',
            archived: d.Value(
              payload['archived'] as bool? ??
                  payload['is_archived'] as bool? ??
                  false,
            ),
            cachedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> _upsertMembersList(
    String accountId,
    List<Map<String, dynamic>> members,
  ) async {
    for (final member in members) {
      final id = member['id'] as String?;
      if (id == null || id.isEmpty) continue;

      await _database
          .into(_database.cachedClassroomMembers)
          .insertOnConflictUpdate(
            CachedClassroomMembersCompanion.insert(
              id: id,
              accountId: accountId,
              classroomId: member['classroom_id'] as String? ?? '',
              studentId: member['student_id'] as String? ?? '',
              studentName: d.Value(member['student_name'] as String?),
              studentEmail: d.Value(member['student_email'] as String?),
              status: member['status'] as String? ?? 'left',
              rejoinBlocked: d.Value(
                member['rejoin_blocked'] as bool? ?? false,
              ),
              joinedAt: d.Value(
                DateTime.tryParse(member['joined_at'] as String? ?? ''),
              ),
              endedAt: d.Value(
                DateTime.tryParse(member['ended_at'] as String? ?? ''),
              ),
            ),
          );
    }
  }

  Future<void> _upsertEventsList(
    String accountId,
    List<Map<String, dynamic>> events,
  ) async {
    for (final event in events) {
      final id = event['id'] as String?;
      if (id == null || id.isEmpty) continue;

      await _database
          .into(_database.cachedMembershipEvents)
          .insertOnConflictUpdate(
            CachedMembershipEventsCompanion.insert(
              id: id,
              accountId: accountId,
              classroomId: event['classroom_id'] as String? ?? '',
              membershipId: event['membership_id'] as String? ?? '',
              studentName: d.Value(event['student_name'] as String?),
              performedBy: event['performed_by'] as String? ?? '',
              eventType: event['event_type'] as String? ?? 'joined',
              createdAt:
                  DateTime.tryParse(event['created_at'] as String? ?? '') ??
                  DateTime.now().toUtc(),
            ),
          );
    }
  }

  Future<void> _upsertProgressList(
    String accountId,
    List<Map<String, dynamic>> progress,
  ) async {
    for (final item in progress) {
      final id = item['id'] as String?;
      final assignmentId = item['assignment_id'] as String?;
      if (id == null || assignmentId == null) continue;

      await _database
          .into(_database.localAssignmentProgress)
          .insertOnConflictUpdate(
            LocalAssignmentProgressCompanion.insert(
              id: id,
              accountId: accountId,
              assignmentId: assignmentId,
              isCompleted: d.Value(item['is_completed'] as bool? ?? false),
              completedAt: d.Value(
                DateTime.tryParse(item['completed_at'] as String? ?? ''),
              ),
              revision: d.Value((item['revision'] as num?)?.toInt() ?? 0),
              syncStatus: const d.Value('synced'),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
    }
  }

  List<Map<String, dynamic>> _listAt(Map<String, dynamic> payload, String key) {
    final raw = payload[key];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Classroom _mapClassroom(CachedClassroomRow row) {
    return Classroom(
      id: row.id,
      teacherId: row.teacherId,
      teacherName: row.teacherName,
      name: row.name,
      subjectName: row.subjectName,
      description: row.description,
      joinCode: row.joinCode,
      timezone: row.timezone,
      archived: row.archived,
      cachedAt: row.cachedAt,
    );
  }

  ClassroomMember _mapMember(CachedMemberRow row) {
    return ClassroomMember(
      id: row.id,
      classroomId: row.classroomId,
      studentId: row.studentId,
      studentName: row.studentName,
      studentEmail: row.studentEmail,
      status: MembershipStatus.fromCode(row.status),
      rejoinBlocked: row.rejoinBlocked,
      joinedAt: row.joinedAt,
      endedAt: row.endedAt,
    );
  }

  MembershipEvent _mapEvent(MembershipEventRow row) {
    return MembershipEvent(
      id: row.id,
      classroomId: row.classroomId,
      membershipId: row.membershipId,
      studentName: row.studentName,
      performedBy: row.performedBy,
      type: MembershipEventType.fromCode(row.eventType),
      createdAt: row.createdAt,
    );
  }
}

class ClassroomValidationException implements Exception {
  const ClassroomValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ClassroomUnavailableException implements Exception {
  const ClassroomUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Kept for callers that surface assignment data alongside classroom data.
typedef ClassroomAssignment = Assignment;

/// Kept for callers that surface events alongside classroom data.
typedef ClassroomEvent = AcademicEvent;
