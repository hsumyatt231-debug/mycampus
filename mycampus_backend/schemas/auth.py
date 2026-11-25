"""Authentication request/response schemas."""

from __future__ import annotations

from pydantic import Field

from schemas.common import ApiModel
from schemas.profile import ProfileOut
from utils.validation import UserRole


class RegisterRequest(ApiModel):
    # The device generates the UUID so existing local ownership stays valid.
    id: str = Field(min_length=1, max_length=36)
    full_name: str = Field(min_length=2, max_length=120)
    email: str = Field(pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$", max_length=255)
    password: str = Field(min_length=8, max_length=128)
    role: UserRole


class AdoptLocalRequest(RegisterRequest):
    """Links an account created by an older offline-only build."""


class LoginRequest(ApiModel):
    email: str = Field(pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$", max_length=255)
    password: str = Field(min_length=1, max_length=128)


class ChangePasswordRequest(ApiModel):
    current_password: str = Field(min_length=1, max_length=128)
    new_password: str = Field(min_length=8, max_length=128)


class ResetPasswordRequest(ApiModel):
    email: str = Field(pattern=r"^[^@\s]+@[^@\s]+\.[^@\s]+$", max_length=255)
    new_password: str = Field(min_length=8, max_length=128)


class AuthResponse(ApiModel):
    profile: ProfileOut
    token: str
    message: str
