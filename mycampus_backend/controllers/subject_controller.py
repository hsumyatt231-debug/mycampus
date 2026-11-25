"""Subject ownership, uniqueness and revision rules."""

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
from models.planner import Subject
from schemas.planner import SubjectSyncIn
from utils.validation import SyncOperationType


def payload(subject: Subject) -> dict[str, Any]:
    return {
        "id": subject.id,
        "account_id": subject.account_id,
        "name": subject.name,
        "code": subject.code,
        "color": subject.color,
        "teacher_name": subject.teacher_name,
        "room": subject.room,
        "revision": subject.revision,
        "deleted_at": iso_utc(subject.deleted_at),
        "updated_at": iso_utc(subject.updated_at),
    }


def apply_operation(
    db: Session,
    account_id: str,
    entity_id: str,
    operation_type: SyncOperationType,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    existing = db.get(Subject, entity_id)
    assert_writable(
        existing,
        account_id,
        base_revision,
        payload(existing) if existing is not None else {},
    )

    new_revision = base_revision + 1
    now = utcnow()
    operation = (
        operation_type.value
        if hasattr(operation_type, "value")
        else str(operation_type)
    )

    is_new = existing is None
    if is_new:
        existing = Subject(
            id=entity_id,
            account_id=account_id,
            name="",
            code="",
            revision=base_revision,
        )

    if operation == SyncOperationType.delete.value:
        existing.deleted_at = tombstone_time(data)
        existing.updated_at = now
    else:
        try:
            parsed = SubjectSyncIn.model_validate(data)
        except ValidationError as exc:
            raise PlannerRejected("Invalid subject payload.") from exc
        if parsed.id != entity_id:
            raise PlannerRejected("Subject id does not match the operation.")

        existing.name = parsed.name
        existing.code = parsed.code
        existing.color = parsed.color
        existing.teacher_name = parsed.teacher_name
        existing.room = parsed.room
        existing.deleted_at = parse_datetime(parsed.deleted_at)
        existing.updated_at = parse_datetime(parsed.updated_at) or now

    existing.revision = new_revision
    if is_new:
        db.add(existing)
    commit(db, "Subject code already exists for this account.")
    db.refresh(existing)
    return Applied(new_revision, payload(existing))
