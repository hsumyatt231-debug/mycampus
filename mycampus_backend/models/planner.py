"""Personal, offline-editable planner entities."""

from __future__ import annotations

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    func,
    text,
)
from sqlalchemy.orm import Mapped, mapped_column

from models.base import Base, SyncableMixin
from utils.validation import AcademicEventType, TaskPriority, TaskStatus


class Subject(Base, SyncableMixin):
    __tablename__ = "subjects"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    account_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("accounts.id", ondelete="CASCADE"),
        index=True,
        nullable=False,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    code: Mapped[str] = mapped_column(String(24), nullable=False)
    # Flutter's JSON key is "color"; the ARGB value is 0xFF6236F5 by default.
    color: Mapped[int] = mapped_column(Integer, nullable=False, default=0xFF6236F5)
    teacher_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    room: Mapped[str | None] = mapped_column(String(64), nullable=True)

    __table_args__ = (
        Index(
            "uq_subjects_account_code",
            "account_id",
            func.lower(code),
            unique=True,
            sqlite_where=text("deleted_at IS NULL"),
        ),
    )


class Task(Base, SyncableMixin):
    __tablename__ = "tasks"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    account_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("accounts.id", ondelete="CASCADE"),
        index=True,
        nullable=False,
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    subject_id: Mapped[str | None] = mapped_column(
        String(36), ForeignKey("subjects.id", ondelete="SET NULL"), nullable=True
    )
    due_date: Mapped[str | None] = mapped_column(String(10), nullable=True)
    due_time: Mapped[str | None] = mapped_column(String(5), nullable=True)
    has_explicit_time: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    priority: Mapped[str] = mapped_column(
        String(10), nullable=False, default=TaskPriority.medium.value
    )
    status: Mapped[str] = mapped_column(
        String(10), nullable=False, default=TaskStatus.pending.value
    )
    completed_at: Mapped[DateTime | None] = mapped_column(DateTime, nullable=True)
    reminder_offset: Mapped[int | None] = mapped_column(Integer, nullable=True)

    __table_args__ = (
        CheckConstraint(
            "priority IN ('low', 'medium', 'high')", name="ck_tasks_priority"
        ),
        CheckConstraint("status IN ('pending', 'completed')", name="ck_tasks_status"),
        Index("ix_tasks_account_due", "account_id", "due_date"),
        Index("ix_tasks_subject", "subject_id"),
    )


class TimetableEntry(Base, SyncableMixin):
    __tablename__ = "timetable_entries"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    account_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("accounts.id", ondelete="CASCADE"),
        index=True,
        nullable=False,
    )
    subject_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("subjects.id", ondelete="CASCADE"), nullable=False
    )
    weekday: Mapped[int] = mapped_column(Integer, nullable=False)
    start_minutes: Mapped[int] = mapped_column(Integer, nullable=False)
    end_minutes: Mapped[int] = mapped_column(Integer, nullable=False)
    room: Mapped[str | None] = mapped_column(String(64), nullable=True)

    __table_args__ = (
        CheckConstraint("weekday BETWEEN 1 AND 5", name="ck_timetable_weekday"),
        CheckConstraint("end_minutes > start_minutes", name="ck_timetable_order"),
        Index("ix_timetable_account_weekday", "account_id", "weekday"),
        Index("ix_timetable_subject", "subject_id"),
    )


class AcademicEvent(Base, SyncableMixin):
    __tablename__ = "academic_events"

    id: Mapped[str] = mapped_column(String(36), primary_key=True)
    account_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("accounts.id", ondelete="CASCADE"),
        index=True,
        nullable=False,
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    type: Mapped[str] = mapped_column(
        String(20), nullable=False, default=AcademicEventType.other.value
    )
    event_date: Mapped[str] = mapped_column(String(10), nullable=False)
    start_time: Mapped[str | None] = mapped_column(String(5), nullable=True)
    end_time: Mapped[str | None] = mapped_column(String(5), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    location: Mapped[str | None] = mapped_column(String(120), nullable=True)
    reminder_offset: Mapped[int | None] = mapped_column(Integer, nullable=True)

    __table_args__ = (
        CheckConstraint(
            "type IN ('exam', 'meeting', 'seminar', 'study_session', 'other')",
            name="ck_events_type",
        ),
        Index("ix_events_account_date", "account_id", "event_date"),
    )
