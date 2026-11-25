"""Classroom, membership and bootstrap-response schemas."""

from __future__ import annotations

from datetime import datetime

from pydantic import Field, field_validator

from schemas.assignment import AssignmentOut, AssignmentProgressOut
from schemas.common import ApiModel
from utils.validation import MembershipEventType, MembershipStatus


def _required(value: str) -> str:
    trimmed = value.strip()
    if not trimmed:
        raise ValueError("This field is required.")
    return trimmed


def _optional(value: str | None) -> str | None:
    if value is None:
        return None
    trimmed = value.strip()
    return trimmed or None


class MemberOut(ApiModel):
    id: str
    classroom_id: str
    student_id: str
    student_name: str | None = None
    student_email: str | None = None
    status: MembershipStatus
    rejoin_blocked: bool
    joined_at: datetime | None = None
    ended_at: datetime | None = None


class MembershipEventOut(ApiModel):
    id: str
    classroom_id: str
    membership_id: str
    performed_by: str
    event_type: MembershipEventType
    student_name: str | None = None
    created_at: datetime


class ClassroomOut(ApiModel):
    id: str
    teacher_id: str
    teacher_name: str | None = None
    name: str
    subject_name: str
    description: str | None = None
    # Only the owner receives the join code.
    join_code: str | None = None
    timezone: str
    archived: bool
    members: list[MemberOut] = Field(default_factory=list)
    events: list[MembershipEventOut] = Field(default_factory=list)
    created_at: datetime
    updated_at: datetime


class ClassroomCreate(ApiModel):
    name: str = Field(min_length=1, max_length=120)
    subject_name: str = Field(min_length=1, max_length=120)
    description: str | None = None

    @field_validator("name", "subject_name", mode="before")
    @classmethod
    def normalize_required(cls, value: object) -> object:
        return _required(value) if isinstance(value, str) else value

    @field_validator("description", mode="before")
    @classmethod
    def normalize_optional(cls, value: object) -> object | None:
        return _optional(value) if isinstance(value, str | None) else value


class JoinRequest(ApiModel):
    code: str = Field(min_length=1, max_length=32)

    @field_validator("code", mode="before")
    @classmethod
    def normalize_code(cls, value: object) -> object:
        return value.strip() if isinstance(value, str) else value


class JoinCodeOut(ApiModel):
    join_code: str


class ClassroomDetailOut(ApiModel):
    classroom: ClassroomOut
    members: list[MemberOut]
    events: list[MembershipEventOut]
    assignments: list[AssignmentOut]
    # Contains only the requesting student's own progress.
    progress: list[AssignmentProgressOut]


class BootstrapOut(ApiModel):
    members: list[MemberOut]
    assignments: list[AssignmentOut]
    progress: list[AssignmentProgressOut]
    next_cursor: str | None = None
    has_more: bool = False
