"""Timetable entry ownership and revision rules.

Overlaps are intentionally allowed: Flutter warns the user but permits saving.
"""

from __future__ import annotations

from typing import Any

from pydantic import ValidationError
from sqlalchemy.orm import Session

from controllers.planner_support import (
    Applied,
    PlannerRejected,
    assert_writable,
    commit,
    iso_utc,
    parse_datetime,
    tombstone_time,
)
from models.base import utcnow
from models.planner import Subject, TimetableEntry
from schemas.planner import TimetableSyncIn
from utils.validation import SyncOperationType


def payload(entry: TimetableEntry) -> dict[str, Any]:
    return {
        "id": entry.id,
        "account_id": entry.account_id,
        "subject_id": entry.subject_id,
        "weekday": entry.weekday,
        "start_minutes": entry.start_minutes,
        "end_minutes": entry.end_minutes,
        "room": entry.room,
        "revision": entry.revision,
        "deleted_at": iso_utc(entry.deleted_at),
        "updated_at": iso_utc(entry.updated_at),
    }


def apply_operation(
    db: Session,
    account_id: str,
    entity_id: str,
    operation_type: SyncOperationType,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    existing = db.get(TimetableEntry, entity_id)
    assert_writable(
        existing, account_id, base_revision, payload(existing) if existing else {}
    )

    new_revision = base_revision + 1
    now = utcnow()
    operation = (
        operation_type.value
        if hasattr(operation_type, "value")
        else str(operation_type)
    )

    if existing is None and operation == SyncOperationType.delete.value:
        raise PlannerRejected("Unknown timetable entry.")

    is_new = existing is None
    if is_new:
        existing = TimetableEntry(id=entity_id, account_id=account_id, revision=base_revision)

    if operation == SyncOperationType.delete.value:
        existing.deleted_at = tombstone_time(data)
        existing.updated_at = now
    else:
        try:
            parsed = TimetableSyncIn.model_validate(data)
        except ValidationError as exc:
            raise PlannerRejected("Invalid timetable payload.") from exc
        if parsed.id != entity_id:
            raise PlannerRejected("Timetable id does not match the operation.")

        subject = db.get(Subject, parsed.subject_id)
        if subject is None or subject.account_id != account_id or subject.deleted_at:
            raise PlannerRejected("Unknown subject for this account.")

        existing.subject_id = parsed.subject_id
        existing.weekday = parsed.weekday
        existing.start_minutes = parsed.start_minutes
        existing.end_minutes = parsed.end_minutes
        existing.room = parsed.room
        existing.deleted_at = parse_datetime(parsed.deleted_at)
        existing.updated_at = parse_datetime(parsed.updated_at) or now

    existing.revision = new_revision
    if is_new:
        db.add(existing)
    commit(db, "Timetable entry could not be saved.")
    db.refresh(existing)
    return Applied(new_revision, payload(existing))
