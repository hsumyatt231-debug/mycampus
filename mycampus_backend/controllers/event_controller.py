"""Academic event normalization, ownership and revision rules."""

from __future__ import annotations

from typing import Any

from pydantic import ValidationError
from sqlalchemy.orm import Session

from controllers.planner_support import (
    Applied,
    PlannerRejected,
    assert_writable,
    commit,
    enum_value,
    iso_utc,
    parse_datetime,
    tombstone_time,
)
from models.base import utcnow
from models.planner import AcademicEvent
from schemas.planner import EventSyncIn
from utils.validation import SyncOperationType


def payload(event: AcademicEvent) -> dict[str, Any]:
    return {
        "id": event.id,
        "account_id": event.account_id,
        "title": event.title,
        "type": event.type,
        "event_date": event.event_date,
        "start_time": event.start_time,
        "end_time": event.end_time,
        "description": event.description,
        "location": event.location,
        "reminder_offset": event.reminder_offset,
        "revision": event.revision,
        "deleted_at": iso_utc(event.deleted_at),
        "updated_at": iso_utc(event.updated_at),
    }


def apply_operation(
    db: Session,
    account_id: str,
    entity_id: str,
    operation_type: SyncOperationType,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    existing = db.get(AcademicEvent, entity_id)
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
        raise PlannerRejected("Unknown academic event.")

    is_new = existing is None
    if is_new:
        existing = AcademicEvent(
            id=entity_id,
            account_id=account_id,
            title="",
            event_date="2000-01-01",
            revision=base_revision,
        )

    if operation == SyncOperationType.delete.value:
        existing.deleted_at = tombstone_time(data)
        existing.updated_at = now
    else:
        try:
            parsed = EventSyncIn.model_validate(data)
        except ValidationError as exc:
            raise PlannerRejected("Invalid academic event payload.") from exc
        if parsed.id != entity_id:
            raise PlannerRejected("Event id does not match the operation.")

        has_start = bool(parsed.start_time)
        existing.title = parsed.title
        existing.type = enum_value(parsed.type)
        existing.event_date = parsed.event_date
        existing.start_time = parsed.start_time if has_start else None
        existing.end_time = parsed.end_time if has_start else None
        existing.description = parsed.description
        existing.location = parsed.location
        existing.reminder_offset = parsed.reminder_offset if has_start else None
        existing.deleted_at = parse_datetime(parsed.deleted_at)
        existing.updated_at = parse_datetime(parsed.updated_at) or now

    existing.revision = new_revision
    if is_new:
        db.add(existing)
    commit(db, "Academic event could not be saved.")
    db.refresh(existing)
    return Applied(new_revision, payload(existing))
