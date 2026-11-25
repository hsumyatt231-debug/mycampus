"""Wire codes and shared validation helpers, mirroring Flutter's enums."""

from __future__ import annotations

from enum import StrEnum
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError


class UserRole(StrEnum):
    student = "student"
    teacher = "teacher"


class TimeFormat(StrEnum):
    twelve = "12"
    twenty_four = "24"


class TaskPriority(StrEnum):
    low = "low"
    medium = "medium"
    high = "high"


class TaskStatus(StrEnum):
    pending = "pending"
    completed = "completed"


class AcademicEventType(StrEnum):
    exam = "exam"
    meeting = "meeting"
    seminar = "seminar"
    study_session = "study_session"
    other = "other"


class MembershipStatus(StrEnum):
    active = "active"
    left = "left"
    removed = "removed"


class MembershipEventType(StrEnum):
    joined = "joined"
    left = "left"
    removed = "removed"
    unblocked = "unblocked"


class AssignmentStatus(StrEnum):
    draft = "draft"
    published = "published"
    archived = "archived"


class SyncEntity(StrEnum):
    profile = "profile"
    subject = "subject"
    task = "task"
    timetable_entry = "timetable_entry"
    academic_event = "academic_event"
    assignment_progress = "assignment_progress"


class SyncOperationType(StrEnum):
    create = "create"
    update = "update"
    delete = "delete"


class ChangeType(StrEnum):
    create = "create"
    update = "update"
    delete = "delete"
    revoke = "revoke"


def is_valid_timezone(name: str) -> bool:
    try:
        ZoneInfo(name)
    except (ZoneInfoNotFoundError, ValueError, TypeError):
        return False
    return True
