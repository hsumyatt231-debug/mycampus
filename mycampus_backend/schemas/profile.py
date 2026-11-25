"""Profile schemas matching Flutter's ``UserProfile.fromJson`` keys."""

from __future__ import annotations

from datetime import datetime

from pydantic import field_validator

from schemas.common import ApiModel
from utils.validation import TimeFormat, UserRole, is_valid_timezone


class ProfileOut(ApiModel):
    id: str
    full_name: str
    email: str
    role: UserRole
    academic_timezone: str
    time_format: TimeFormat
    email_verified: bool
    created_at: datetime | None = None
    updated_at: datetime | None = None


class ProfileUpdate(ApiModel):
    full_name: str | None = None
    time_format: TimeFormat | None = None


class TimezoneUpdate(ApiModel):
    academic_timezone: str

    @field_validator("academic_timezone")
    @classmethod
    def validate_timezone(cls, value: str) -> str:
        if not is_valid_timezone(value):
            raise ValueError("Unknown IANA timezone.")
        return value
