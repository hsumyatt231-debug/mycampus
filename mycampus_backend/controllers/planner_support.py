"""Shared error types and helpers for local-first planner controllers."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from models.base import utcnow


class PlannerConflict(Exception):
    """The client's ``base_revision`` is stale.

    ``payload`` is the current server record returned to Flutter so it can
    resolve the conflict locally.
    """

    def __init__(self, payload: dict[str, Any]) -> None:
        super().__init__("Revision conflict.")
        self.payload = payload


class PlannerOwnershipError(Exception):
    """The target record belongs to another account."""


class PlannerRejected(Exception):
    """A permanent, non-conflict rejection (for example a unique-code clash)."""


@dataclass(frozen=True)
class Applied:
    new_revision: int
    payload: dict[str, Any]

    def as_dict(self) -> dict[str, Any]:
        return {"new_revision": self.new_revision, "payload": self.payload}


def parse_datetime(value: Any) -> datetime | None:
    if value is None or value == "":
        return None
    if isinstance(value, datetime):
        parsed = value
    else:
        text = str(value).strip().replace("Z", "+00:00")
        try:
            parsed = datetime.fromisoformat(text)
        except ValueError:
            return None
    if parsed.tzinfo is not None:
        parsed = parsed.astimezone(timezone.utc).replace(tzinfo=None)
    return parsed


def iso_utc(value: datetime | None) -> str | None:
    if value is None:
        return None
    aware = value if value.tzinfo is not None else value.replace(tzinfo=timezone.utc)
    return aware.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")


def enum_value(value: Any) -> Any:
    return value.value if hasattr(value, "value") else value


def assert_writable(
    existing: Any,
    account_id: str,
    base_revision: int,
    current_payload: dict[str, Any],
) -> None:
    if existing is not None and existing.account_id != account_id:
        raise PlannerOwnershipError()
    if existing is not None and existing.revision != base_revision:
        raise PlannerConflict(current_payload)


def commit(db: Session, reason: str) -> None:
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise PlannerRejected(reason) from None


def tombstone_time(data: dict[str, Any]) -> datetime:
    return parse_datetime(data.get("deleted_at")) or utcnow()
