"""Schemas for subjects, tasks, timetable entries and academic events.

Wire keys mirror Flutter's ``toJson()``/``fromJson()`` implementations exactly.
"""

from __future__ import annotations

import re
from datetime import datetime

from pydantic import Field, field_validator

from schemas.common import ApiModel
from utils.validation import AcademicEventType, TaskPriority, TaskStatus

_DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
_TIME_RE = re.compile(r"^([01]\d|2[0-3]):[0-5]\d$")


def _required_text(value: str) -> str:
    trimmed = value.strip()
    if not trimmed:
        raise ValueError("This field is required.")
    return trimmed


def _optional_text(value: str | None) -> str | None:
    if value is None:
        return None
    trimmed = value.strip()
    return trimmed or None


def _date(value: str | None) -> str | None:
    if value is None:
        return None
    if not _DATE_RE.fullmatch(value):
        raise ValueError("Use yyyy-MM-dd.")
    try:
        datetime.strptime(value, "%Y-%m-%d")
    except ValueError as exc:
        raise ValueError("Invalid calendar date.") from exc
    return value


def _time(value: str | None) -> str | None:
    if value is None:
        return None
    if not _TIME_RE.fullmatch(value):
        raise ValueError("Use HH:mm.")
    return value


class SubjectIn(ApiModel):
    name: str = Field(min_length=1, max_length=120)
    code: str = Field(min_length=1, max_length=24)
    color: int = Field(default=0xFF6236F5, ge=0, le=0xFFFFFFFF)
    teacher_name: str | None = None
    room: str | None = None

    @field_validator("name", "code")
    @classmethod
    def normalize_required(cls, value: str) -> str:
        return _required_text(value)

    @field_validator("teacher_name", "room")
    @classmethod
    def normalize_optional(cls, value: str | None) -> str | None:
        return _optional_text(value)


class SubjectOut(SubjectIn):
    id: str
    account_id: str
    revision: int
    deleted_at: datetime | None = None
    updated_at: datetime


class SubjectSyncIn(SubjectIn):
    id: str = Field(min_length=1, max_length=36)
    revision: int = 0
    deleted_at: datetime | None = None
    updated_at: datetime | None = None


class TaskIn(ApiModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = None
    subject_id: str | None = None
    due_date: str | None = None
    due_time: str | None = None
    has_explicit_time: bool = False
    priority: TaskPriority = TaskPriority.medium
    status: TaskStatus = TaskStatus.pending
    completed_at: datetime | None = None
    reminder_offset: int | None = Field(default=None, ge=0)

    @field_validator("title")
    @classmethod
    def normalize_title(cls, value: str) -> str:
        return _required_text(value)

    @field_validator("description", "subject_id")
    @classmethod
    def normalize_optional(cls, value: str | None) -> str | None:
        return _optional_text(value)

    @field_validator("due_date")
    @classmethod
    def normalize_due_date(cls, value: str | None) -> str | None:
        return _date(value)

    @field_validator("due_time")
    @classmethod
    def normalize_due_time(cls, value: str | None) -> str | None:
        return _time(value)


class TaskOut(TaskIn):
    id: str
    account_id: str
    revision: int
    deleted_at: datetime | None = None
    updated_at: datetime


class TaskSyncIn(TaskIn):
    id: str = Field(min_length=1, max_length=36)
    revision: int = 0
    deleted_at: datetime | None = None
    updated_at: datetime | None = None


class TimetableIn(ApiModel):
    subject_id: str = Field(min_length=1, max_length=36)
    weekday: int = Field(ge=1, le=5)
    start_minutes: int = Field(ge=0, le=1439)
    end_minutes: int = Field(ge=1, le=1440)
    room: str | None = None

    @field_validator("subject_id")
    @classmethod
    def normalize_subject(cls, value: str) -> str:
        return _required_text(value)

    @field_validator("room")
    @classmethod
    def normalize_room(cls, value: str | None) -> str | None:
        return _optional_text(value)

    @field_validator("end_minutes")
    @classmethod
    def end_after_start(cls, value: int, info) -> int:  # noqa: ANN001
        start = info.data.get("start_minutes")
        if start is not None and value <= start:
            raise ValueError("end_minutes must be greater than start_minutes.")
        return value


class TimetableOut(TimetableIn):
    id: str
    account_id: str
    revision: int
    deleted_at: datetime | None = None
    updated_at: datetime


class TimetableSyncIn(TimetableIn):
    id: str = Field(min_length=1, max_length=36)
    revision: int = 0
    deleted_at: datetime | None = None
    updated_at: datetime | None = None


class EventIn(ApiModel):
    title: str = Field(min_length=1, max_length=200)
    type: AcademicEventType = AcademicEventType.other
    event_date: str = Field(min_length=10, max_length=10)
    start_time: str | None = None
    end_time: str | None = None
    description: str | None = None
    location: str | None = None
    reminder_offset: int | None = Field(default=None, ge=0)

    @field_validator("title")
    @classmethod
    def normalize_title(cls, value: str) -> str:
        return _required_text(value)

    @field_validator("event_date")
    @classmethod
    def normalize_date(cls, value: str) -> str:
        parsed = _date(value)
        if parsed is None:
            raise ValueError("event_date is required.")
        return parsed

    @field_validator("start_time", "end_time")
    @classmethod
    def normalize_time(cls, value: str | None) -> str | None:
        return _time(value)

    @field_validator("end_time")
    @classmethod
    def end_after_start(cls, value: str | None, info) -> str | None:  # noqa: ANN001
        start = info.data.get("start_time")
        if start is not None and value is not None and value <= start:
            raise ValueError("end_time must be after start_time.")
        return value

    @field_validator("description", "location")
    @classmethod
    def normalize_optional(cls, value: str | None) -> str | None:
        return _optional_text(value)


class EventOut(EventIn):
    id: str
    account_id: str
    revision: int
    deleted_at: datetime | None = None
    updated_at: datetime


class EventSyncIn(EventIn):
    id: str = Field(min_length=1, max_length=36)
    revision: int = 0
    deleted_at: datetime | None = None
    updated_at: datetime | None = None
