"""Server-side idempotency ledger, pull feed and per-account cursor."""

from __future__ import annotations

from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column

from models.base import Base, utcnow


class SyncOperation(Base):
    __tablename__ = "sync_operations"

    operation_id: Mapped[str] = mapped_column(String(36), primary_key=True)
    account_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("accounts.id", ondelete="CASCADE"), nullable=False
    )
    fingerprint: Mapped[str] = mapped_column(String(64), nullable=False)
    result_status: Mapped[str] = mapped_column(String(16), nullable=False)
    new_revision: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    result_payload_json: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[DateTime] = mapped_column(DateTime, nullable=False, default=utcnow)

    __table_args__ = (Index("ix_sync_operations_account", "account_id", "created_at"),)


class SyncChange(Base):
    __tablename__ = "sync_change_log"
    __table_args__ = (
        Index("ix_change_log_owner_seq", "owner_account_id", "seq"),
        Index("ix_change_log_classroom_seq", "classroom_id", "seq"),
        {"sqlite_autoincrement": True},
    )

    seq: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    change_id: Mapped[str] = mapped_column(String(36), nullable=False, unique=True)
    owner_account_id: Mapped[str] = mapped_column(String(36), nullable=False)
    entity: Mapped[str] = mapped_column(String(32), nullable=False)
    entity_id: Mapped[str] = mapped_column(String(36), nullable=False)
    change_type: Mapped[str] = mapped_column(String(10), nullable=False)
    revision: Mapped[int] = mapped_column(Integer, nullable=False)
    payload_json: Mapped[str | None] = mapped_column(Text, nullable=True)
    classroom_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    revoked: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    created_at: Mapped[DateTime] = mapped_column(DateTime, nullable=False, default=utcnow)


class SyncCursor(Base):
    __tablename__ = "sync_cursors"

    account_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("accounts.id", ondelete="CASCADE"), primary_key=True
    )
    cursor: Mapped[str | None] = mapped_column(String(64), nullable=True)
    last_pull_at: Mapped[DateTime | None] = mapped_column(DateTime, nullable=True)
    last_push_at: Mapped[DateTime | None] = mapped_column(DateTime, nullable=True)
    last_error: Mapped[str | None] = mapped_column(Text, nullable=True)
