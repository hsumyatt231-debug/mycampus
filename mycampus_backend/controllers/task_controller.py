"""Task normalization, ownership and revision rules."""

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
from models.planner import Subject, Task
from schemas.planner import TaskSyncIn
from utils.validation import SyncOperationType, TaskStatus


def payload(task: Task) -> dict[str, Any]:
    return {
        "id": task.id,
        "account_id": task.account_id,
        "title": task.title,
        "description": task.description,
        "subject_id": task.subject_id,
        "due_date": task.due_date,
        "due_time": task.due_time,
        "has_explicit_time": task.has_explicit_time,
        "priority": task.priority,
        "status": task.status,
        "completed_at": iso_utc(task.completed_at),
        "reminder_offset": task.reminder_offset,
        "revision": task.revision,
        "deleted_at": iso_utc(task.deleted_at),
        "updated_at": iso_utc(task.updated_at),
    }


def apply_operation(
    db: Session,
    account_id: str,
    entity_id: str,
    operation_type: SyncOperationType,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    existing = db.get(Task, entity_id)
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

    is_new = existing is None
    if is_new:
        existing = Task(id=entity_id, account_id=account_id, title="", revision=base_revision)

    if operation == SyncOperationType.delete.value:
        existing.deleted_at = tombstone_time(data)
        existing.updated_at = now
    else:
        try:
            parsed = TaskSyncIn.model_validate(data)
        except ValidationError as exc:
            raise PlannerRejected("Invalid task payload.") from exc
        if parsed.id != entity_id:
            raise PlannerRejected("Task id does not match the operation.")

        status = enum_value(parsed.status)
        has_due_date = bool(parsed.due_date)
        has_explicit_time = bool(has_due_date and parsed.due_time and parsed.has_explicit_time)

        if parsed.subject_id:
            subject = db.get(Subject, parsed.subject_id)
            if subject is None or subject.account_id != account_id or subject.deleted_at:
                raise PlannerRejected("Unknown subject for this account.")

        existing.title = parsed.title
        existing.description = parsed.description
        existing.subject_id = parsed.subject_id
        existing.due_date = parsed.due_date if has_due_date else None
        existing.due_time = parsed.due_time if has_explicit_time else None
        existing.has_explicit_time = has_explicit_time
        existing.priority = enum_value(parsed.priority)
        existing.status = status
        existing.completed_at = (
            parse_datetime(parsed.completed_at) or now
            if status == TaskStatus.completed.value
            else None
        )
        existing.reminder_offset = parsed.reminder_offset if has_due_date else None
        existing.deleted_at = parse_datetime(parsed.deleted_at)
        existing.updated_at = parse_datetime(parsed.updated_at) or now

    existing.revision = new_revision
    if is_new:
        db.add(existing)
    commit(db, "Task could not be saved.")
    db.refresh(existing)
    return Applied(new_revision, payload(existing))
