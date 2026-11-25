"""Assignment and private-progress schemas."""

from __future__ import annotations

import re
from datetime import datetime

from pydantic import Field, field_validator

from schemas.common import ApiModel
from utils.validation import AssignmentStatus

_DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
_TIME_RE = re.compile(r"^([01]\d|2[0-3]):[0-5]\d$")


def _required(value: object) -> object:
    if not isinstance(value, str):
        return value
    trimmed = value.strip()
    if not trimmed:
        raise ValueError("This field is required.")
    return trimmed


def _optional(value: object) -> object | None:
    if value is None:
        return None
    if isinstance(value, str):
        return value.strip() or None
    return value


def _date(value: object) -> object:
    if not isinstance(value, str):
        return value
    if not _DATE_RE.fullmatch(value):
        raise ValueError("Use yyyy-MM-dd.")
    try:
        datetime.strptime(value, "%Y-%m-%d")
    except ValueError as exc:
        raise ValueError("Invalid calendar date.") from exc
    return value


def _time(value: object) -> object | None:
    if value is None or value == "":
        return None
    if not isinstance(value, str) or not _TIME_RE.fullmatch(value):
        raise ValueError("Use HH:mm.")
    return value


class AssignmentOut(ApiModel):
    id: str
    classroom_id: str
    classroom_name: str | None = None
    title: str
    description: str | None = None
    due_date: str
    due_time: str | None = None
    has_explicit_time: bool
    status: AssignmentStatus
    published_at: datetime | None = None
    deleted_at: datetime | None = None
    revision: int


class AssignmentCreate(ApiModel):
    title: str = Field(min_length=1, max_length=200)
    due_date: str = Field(min_length=10, max_length=10)
    publish: bool = False
    description: str | None = None
    due_time: str | None = None

    @field_validator("title", mode="before")
    @classmethod
    def normalize_title(cls, value: object) -> object:
        return _required(value)

    @field_validator("due_date", mode="before")
    @classmethod
    def normalize_due_date(cls, value: object) -> object:
        return _date(value)

    @field_validator("due_time", mode="before")
    @classmethod
    def normalize_due_time(cls, value: object) -> object | None:
        return _time(value)

    @field_validator("description", mode="before")
    @classmethod
    def normalize_description(cls, value: object) -> object | None:
        return _optional(value)


class AssignmentUpdate(ApiModel):
    title: str | None = None
    due_date: str | None = None
    description: str | None = None
    due_time: str | None = None
    status: AssignmentStatus | None = None

    @field_validator("title", mode="before")
    @classmethod
    def normalize_title(cls, value: object) -> object | None:
        return _required(value) if value is not None else None

    @field_validator("due_date", mode="before")
    @classmethod
    def normalize_due_date(cls, value: object) -> object | None:
        return _date(value) if value is not None else None

    @field_validator("due_time", mode="before")
    @classmethod
    def normalize_due_time(cls, value: object) -> object | None:
        return _time(value)

    @field_validator("description", mode="before")
    @classmethod
    def normalize_description(cls, value: object) -> object | None:
        return _optional(value)


class AssignmentProgressOut(ApiModel):
    id: str
    account_id: str
    assignment_id: str
    is_completed: bool
    completed_at: datetime | None = None
    revision: int


class AssignmentProgressSyncIn(ApiModel):
    id: str = Field(min_length=1, max_length=36)
    account_id: str = Field(min_length=1, max_length=36)
    assignment_id: str = Field(min_length=1, max_length=36)
    is_completed: bool = False
    completed_at: datetime | None = None
    revision: int = 0
    updated_at: datetime | None = None


class ProgressIn(ApiModel):
    completed: bool
    operation_id: str = Field(min_length=1, max_length=36)
