"""Account entity — one profile per device identity, with a role code."""

from __future__ import annotations

from sqlalchemy import Boolean, CheckConstraint, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from models.base import Base, TimestampMixin
from utils.validation import UserRole


class Account(Base, TimestampMixin):
    __tablename__ = "accounts"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    email: Mapped[str] = mapped_column(String(255), nullable=False, unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    password_salt: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str] = mapped_column(String(120), nullable=False)
    role: Mapped[str] = mapped_column(
        String(16), nullable=False, default=UserRole.student.value
    )
    academic_timezone: Mapped[str] = mapped_column(
        String(64), nullable=False, default="Asia/Yangon"
    )
    time_format: Mapped[str] = mapped_column(String(2), nullable=False, default="12")
    email_verified: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)

    __table_args__ = (
        CheckConstraint("role IN ('student', 'teacher')", name="ck_accounts_role"),
        CheckConstraint("time_format IN ('12', '24')", name="ck_accounts_time_format"),
    )
