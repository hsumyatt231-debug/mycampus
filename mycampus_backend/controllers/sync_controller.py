"""Server-side reconciliation for Flutter's local-first sync queue."""

from __future__ import annotations

import hashlib
import json
from typing import Any

from fastapi import HTTPException, status as http_status
from sqlalchemy import and_, func, or_, select
from sqlalchemy.orm import Session

from controllers import (
    assignment_controller,
    event_controller,
    subject_controller,
    task_controller,
    timetable_controller,
)
from controllers.change_log import record_change
from controllers.planner_support import (
    Applied,
    PlannerConflict,
    PlannerOwnershipError,
    PlannerRejected,
)
from models.account import Account
from models.base import utcnow
from models.classroom import Classroom, ClassroomMember
from models.sync import SyncChange, SyncCursor, SyncOperation
from schemas.sync import PullPageOut, SyncOperationIn, SyncStatusOut
from utils.validation import (
    AssignmentStatus,
    MembershipStatus,
    SyncEntity,
    SyncOperationType,
    UserRole,
    is_valid_timezone,
)

_PERSONAL_ENTITIES = {
    SyncEntity.subject.value,
    SyncEntity.task.value,
    SyncEntity.timetable_entry.value,
    SyncEntity.academic_event.value,
    SyncEntity.assignment_progress.value,
}
_CLASSROOM_ENTITIES = {"classroom", "assignment"}
_STATUS_ENTITIES = sorted(_PERSONAL_ENTITIES | _CLASSROOM_ENTITIES)


def _canonical_fingerprint(request: SyncOperationIn) -> str:
    """Match Flutter's ``HashService.fingerprint`` exactly."""

    payload = {
        "operation_id": request.operation_id,
        "account_id": request.account_id,
        "entity": request.entity.value,
        "entity_id": request.entity_id,
        "type": request.type.value,
        "base_revision": request.base_revision,
        "data": request.data,
    }
    canonical = json.dumps(
        payload,
        sort_keys=True,
        separators=(",", ":"),
        ensure_ascii=False,
    )
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def _json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def _stored_result(row: SyncOperation) -> dict[str, Any]:
    stored = json.loads(row.result_payload_json) if row.result_payload_json else {}
    if row.result_status == "applied":
        return {
            "status": "applied",
            "new_revision": row.new_revision,
            "payload": stored.get("payload"),
        }
    if row.result_status == "conflict":
        return {"status": "conflict", "payload": stored.get("payload", {})}
    return {"status": "failed", "reason": stored.get("reason", "Operation rejected.")}


def _upsert_cursor(
    db: Session,
    account_id: str,
    *,
    cursor: str | None = None,
    last_pull_at: Any = None,
    last_push_at: Any = None,
) -> None:
    row = db.get(SyncCursor, account_id)
    if row is None:
        row = SyncCursor(account_id=account_id)
        db.add(row)
    if cursor is not None:
        row.cursor = cursor
    if last_pull_at is not None:
        row.last_pull_at = last_pull_at
    if last_push_at is not None:
        row.last_push_at = last_push_at


def _apply_profile(
    db: Session,
    account: Account,
    entity_id: str,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    """Profile edits are store-backed; there is no separate revision column."""

    if entity_id != account.id or data.get("id") not in (None, account.id):
        raise PlannerRejected("Profile id does not match this account.")

    full_name = data.get("full_name")
    if full_name is not None:
        if not isinstance(full_name, str) or len(full_name.strip()) < 2:
            raise PlannerRejected("Enter your full name.")
        account.full_name = full_name.strip()

    timezone = data.get("academic_timezone")
    if timezone is not None:
        if not isinstance(timezone, str) or not is_valid_timezone(timezone):
            raise PlannerRejected("Unknown IANA timezone.")
        account.academic_timezone = timezone

    time_format = data.get("time_format")
    if time_format is not None:
        if time_format not in ("12", "24"):
            raise PlannerRejected("Invalid time format.")
        account.time_format = time_format

    db.commit()
    db.refresh(account)
    new_revision = base_revision + 1
    return Applied(
        new_revision,
        {
            "id": account.id,
            "full_name": account.full_name,
            "academic_timezone": account.academic_timezone,
            "time_format": account.time_format,
        },
    )


def _dispatch(
    db: Session,
    account: Account,
    request: SyncOperationIn,
) -> Applied:
    if request.entity == SyncEntity.profile:
        if request.type != SyncOperationType.update:
            raise PlannerRejected("Profile operations must be updates.")
        return _apply_profile(
            db,
            account,
            request.entity_id,
            request.base_revision,
            request.data,
        )

    if request.entity == SyncEntity.assignment_progress:
        if request.type == SyncOperationType.delete:
            raise PlannerRejected("Progress cannot be deleted.")
        return assignment_controller.apply_progress_operation(
            db,
            account.id,
            request.entity_id,
            request.base_revision,
            request.data,
        )

    controllers = {
        SyncEntity.subject: subject_controller.apply_operation,
        SyncEntity.task: task_controller.apply_operation,
        SyncEntity.timetable_entry: timetable_controller.apply_operation,
        SyncEntity.academic_event: event_controller.apply_operation,
    }
    controller = controllers.get(request.entity)
    if controller is None:
        raise PlannerRejected("Unsupported sync entity.")
    return controller(
        db,
        account.id,
        request.entity_id,
        request.type,
        request.base_revision,
        request.data,
    )


def _write_failure(
    db: Session,
    account: Account,
    request: SyncOperationIn,
    result_status: str,
    detail: dict[str, Any],
) -> dict[str, Any]:
    db.rollback()
    db.add(
        SyncOperation(
            operation_id=request.operation_id,
            account_id=account.id,
            fingerprint=request.fingerprint,
            result_status=result_status,
            new_revision=0,
            result_payload_json=_json(detail),
        )
    )
    _upsert_cursor(db, account.id, last_push_at=utcnow())
    db.commit()
    if result_status == "conflict":
        return {"status": "conflict", "payload": detail["payload"]}
    return {"status": "failed", "reason": detail["reason"]}


def apply_operation(
    db: Session,
    account: Account,
    request: SyncOperationIn,
) -> dict[str, Any]:
    """Apply one queued operation, returning Flutter's push-outcome shape."""

    if request.account_id != account.id:
        raise HTTPException(
            status_code=http_status.HTTP_403_FORBIDDEN,
            detail="Operation account does not match the signed-in account.",
        )

    processed = db.get(SyncOperation, request.operation_id)
    if processed is not None:
        if processed.account_id != account.id or processed.fingerprint != request.fingerprint:
            raise HTTPException(
                status_code=http_status.HTTP_409_CONFLICT,
                detail="Operation id has already been used for another payload.",
            )
        return _stored_result(processed)

    if _canonical_fingerprint(request) != request.fingerprint:
        return _write_failure(
            db,
            account,
            request,
            "failed",
            {"reason": "Fingerprint does not match the operation payload."},
        )

    try:
        applied = _dispatch(db, account, request)
    except PlannerConflict as exc:
        return _write_failure(
            db,
            account,
            request,
            "conflict",
            {"payload": exc.payload},
        )
    except PlannerOwnershipError:
        return _write_failure(
            db,
            account,
            request,
            "failed",
            {"reason": "This record belongs to another account."},
        )
    except PlannerRejected as exc:
        return _write_failure(
            db,
            account,
            request,
            "failed",
            {"reason": str(exc) or "The operation was rejected."},
        )

    db.add(
        SyncOperation(
            operation_id=request.operation_id,
            account_id=account.id,
            fingerprint=request.fingerprint,
            result_status="applied",
            new_revision=applied.new_revision,
            result_payload_json=_json({"payload": applied.payload}),
        )
    )
    if request.entity != SyncEntity.profile:
        record_change(
            db,
            owner_account_id=account.id,
            entity=request.entity.value,
            entity_id=request.entity_id,
            change_type=request.type.value,
            revision=applied.new_revision,
            payload=applied.payload,
        )
    _upsert_cursor(db, account.id, last_push_at=utcnow())
    db.commit()
    return {
        "status": "applied",
        "new_revision": applied.new_revision,
        "payload": applied.payload,
    }


def _cursor_seq(cursor: str | None) -> int:
    if cursor is None or cursor.strip() == "":
        return 0
    try:
        value = int(cursor)
    except ValueError as exc:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail="Invalid sync cursor.",
        ) from exc
    if value < 0:
        raise HTTPException(
            status_code=http_status.HTTP_400_BAD_REQUEST,
            detail="Invalid sync cursor.",
        )
    return value


def _authorized_classroom_ids(db: Session, account: Account):
    if account.role == UserRole.teacher.value:
        return select(Classroom.id).where(Classroom.teacher_id == account.id)
    return select(ClassroomMember.classroom_id).where(
        ClassroomMember.student_id == account.id,
        ClassroomMember.status == MembershipStatus.active.value,
    )


def _visibility_clause(db: Session, account: Account):
    personal = and_(
        SyncChange.owner_account_id == account.id,
        SyncChange.entity.in_(list(_PERSONAL_ENTITIES)),
        SyncChange.revoked.is_(False),
    )
    revoked_to_owner = and_(
        SyncChange.owner_account_id == account.id,
        SyncChange.revoked.is_(True),
    )
    classroom = and_(
        SyncChange.classroom_id.isnot(None),
        SyncChange.entity.in_(list(_CLASSROOM_ENTITIES)),
        SyncChange.revoked.is_(False),
        SyncChange.classroom_id.in_(_authorized_classroom_ids(db, account)),
    )
    return or_(personal, revoked_to_owner, classroom)


def _is_classroom_owner(db: Session, account: Account, classroom_id: str | None) -> bool:
    if account.role != UserRole.teacher.value or not classroom_id:
        return False
    classroom = db.get(Classroom, classroom_id)
    return classroom is not None and classroom.teacher_id == account.id


def _cloud_change(
    db: Session,
    account: Account,
    row: SyncChange,
) -> dict[str, Any]:
    revoked = row.revoked
    payload = json.loads(row.payload_json) if row.payload_json else None

    if payload is not None and not revoked:
        payload = dict(payload)
        if row.entity == "classroom":
            if not _is_classroom_owner(db, account, row.classroom_id):
                payload.pop("join_code", None)
        elif row.entity == "assignment":
            owner = _is_classroom_owner(db, account, row.classroom_id)
            if not owner and (
                payload.get("status") != AssignmentStatus.published.value
                or payload.get("deleted_at") is not None
            ):
                revoked = True
                payload = None

    return {
        "change_id": row.change_id,
        "entity": row.entity,
        "entity_id": row.entity_id,
        "change_type": row.change_type,
        "revision": row.revision,
        "payload": None if revoked else payload,
        "owner_account_id": row.owner_account_id,
        "classroom_id": row.classroom_id,
        "revoked": revoked,
    }


def pull(
    db: Session,
    account: Account,
    cursor: str | None,
    page_size: int,
) -> PullPageOut:
    """Return one authorized, cursor-ordered page of the pull feed."""

    last_seq = _cursor_seq(cursor)
    rows = db.scalars(
        select(SyncChange)
        .where(
            SyncChange.seq > last_seq,
            _visibility_clause(db, account),
        )
        .order_by(SyncChange.seq)
        .limit(page_size + 1)
    ).all()

    has_more = len(rows) > page_size
    page = rows[:page_size]
    changes = [_cloud_change(db, account, row) for row in page]

    consumed = page[-1].seq if page else last_seq
    next_cursor = str(consumed) if has_more else None
    _upsert_cursor(db, account.id, cursor=str(consumed), last_pull_at=utcnow())
    db.commit()

    return PullPageOut(
        changes=changes,
        next_cursor=next_cursor,
        has_more=has_more,
    )


def status(db: Session, account: Account) -> SyncStatusOut:
    """Report the account's cursor and visible feed counts by entity."""

    counts = {entity: 0 for entity in _STATUS_ENTITIES}
    rows = db.execute(
        select(SyncChange.entity, func.count(SyncChange.seq))
        .where(_visibility_clause(db, account))
        .group_by(SyncChange.entity)
    ).all()
    for entity, count in rows:
        counts[entity] = count

    cursor = db.get(SyncCursor, account.id)
    return SyncStatusOut(
        account_id=account.id,
        cursor=cursor.cursor if cursor is not None else None,
        server_time=utcnow(),
        entities=counts,
    )
