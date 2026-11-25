"""Assignment visibility, teacher editing and private student progress."""

from __future__ import annotations

import hashlib
import uuid
from typing import Any

from fastapi import HTTPException, status
from pydantic import ValidationError
from sqlalchemy import select
from sqlalchemy.orm import Session

from controllers.access import (
    classroom_or_404,
    require_active_membership,
    require_owner,
    require_student,
)
from controllers.change_log import record_change
from controllers.planner_support import (
    Applied,
    PlannerConflict,
    PlannerOwnershipError,
    PlannerRejected,
    commit,
    enum_value,
    iso_utc,
    parse_datetime,
)
from models.account import Account
from models.assignment import Assignment, AssignmentProgress
from models.base import utcnow
from models.classroom import Classroom, ClassroomMember
from models.sync import SyncOperation
from schemas.assignment import (
    AssignmentCreate,
    AssignmentProgressSyncIn,
    AssignmentUpdate,
    ProgressIn,
)
from schemas.common import Message
from utils.validation import AssignmentStatus, MembershipStatus, UserRole


def progress_payload(progress: AssignmentProgress) -> dict[str, Any]:
    return {
        "id": progress.id,
        "account_id": progress.account_id,
        "assignment_id": progress.assignment_id,
        "is_completed": progress.is_completed,
        "completed_at": iso_utc(progress.completed_at),
        "revision": progress.revision,
    }


def assignment_payload(
    assignment: Assignment,
    classroom_name: str | None,
) -> dict[str, Any]:
    return {
        "id": assignment.id,
        "classroom_id": assignment.classroom_id,
        "classroom_name": classroom_name,
        "title": assignment.title,
        "description": assignment.description,
        "due_date": assignment.due_date,
        "due_time": assignment.due_time,
        "has_explicit_time": assignment.has_explicit_time,
        "status": assignment.status,
        "published_at": iso_utc(assignment.published_at),
        "deleted_at": iso_utc(assignment.deleted_at),
        "revision": assignment.revision,
    }


def _classroom_name(db: Session, classroom_id: str) -> str | None:
    classroom = db.get(Classroom, classroom_id)
    return classroom.name if classroom is not None else None


def _require_not_archived(classroom: Classroom) -> None:
    if classroom.archived:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Archived classrooms are read-only.",
        )


def assignments_for_classroom(
    db: Session,
    classroom: Classroom,
    is_owner: bool,
) -> list[dict[str, Any]]:
    statement = select(Assignment).where(
        Assignment.classroom_id == classroom.id,
        Assignment.deleted_at.is_(None),
    )
    if not is_owner:
        statement = statement.where(Assignment.status == AssignmentStatus.published.value)
    rows = db.scalars(statement.order_by(Assignment.due_date, Assignment.id)).all()
    return [assignment_payload(row, classroom.name) for row in rows]


def own_progress(
    db: Session,
    account_id: str,
    assignments: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    ids = [item["id"] for item in assignments]
    if not ids:
        return []
    rows = db.scalars(
        select(AssignmentProgress).where(
            AssignmentProgress.account_id == account_id,
            AssignmentProgress.assignment_id.in_(ids),
        )
    ).all()
    return [progress_payload(row) for row in rows]


def list_my_assignments(db: Session, account: Account) -> list[dict[str, Any]]:
    if account.role == UserRole.teacher.value:
        rows = db.scalars(
            select(Assignment)
            .join(Classroom, Classroom.id == Assignment.classroom_id)
            .where(
                Assignment.deleted_at.is_(None),
                Classroom.teacher_id == account.id,
            )
            .order_by(Assignment.due_date, Assignment.id)
        ).all()
    else:
        rows = db.scalars(
            select(Assignment)
            .join(
                ClassroomMember,
                ClassroomMember.classroom_id == Assignment.classroom_id,
            )
            .where(
                Assignment.deleted_at.is_(None),
                Assignment.status == AssignmentStatus.published.value,
                ClassroomMember.student_id == account.id,
                ClassroomMember.status == MembershipStatus.active.value,
            )
            .order_by(Assignment.due_date, Assignment.id)
        ).all()
    return [assignment_payload(row, _classroom_name(db, row.classroom_id)) for row in rows]


def create_assignment(
    db: Session,
    account: Account,
    classroom_id: str,
    request: AssignmentCreate,
) -> dict[str, Any]:
    classroom = classroom_or_404(db, classroom_id)
    require_owner(account, classroom)
    _require_not_archived(classroom)

    published = request.publish
    assignment = Assignment(
        id=str(uuid.uuid4()),
        classroom_id=classroom.id,
        title=request.title,
        description=request.description,
        due_date=request.due_date,
        due_time=request.due_time,
        has_explicit_time=bool(request.due_time),
        status=(
            AssignmentStatus.published.value
            if published
            else AssignmentStatus.draft.value
        ),
        published_at=utcnow() if published else None,
        revision=0,
    )
    db.add(assignment)
    payload = assignment_payload(assignment, classroom.name)
    record_change(
        db,
        owner_account_id=account.id,
        entity="assignment",
        entity_id=assignment.id,
        change_type="create",
        revision=assignment.revision,
        payload=payload,
        classroom_id=classroom.id,
    )
    db.commit()
    db.refresh(assignment)
    return payload


def update_assignment(
    db: Session,
    account: Account,
    assignment_id: str,
    request: AssignmentUpdate,
) -> dict[str, Any]:
    assignment = db.get(Assignment, assignment_id)
    if assignment is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Assignment not found.",
        )
    classroom = classroom_or_404(db, assignment.classroom_id)
    require_owner(account, classroom)
    _require_not_archived(classroom)

    fields = request.model_fields_set
    if "title" in fields and request.title is not None:
        assignment.title = request.title
    if "due_date" in fields and request.due_date is not None:
        assignment.due_date = request.due_date
    if "description" in fields:
        assignment.description = request.description
    if "due_time" in fields:
        assignment.due_time = request.due_time
        assignment.has_explicit_time = bool(request.due_time)
    if "status" in fields and request.status is not None:
        new_status = enum_value(request.status)
        if (
            new_status == AssignmentStatus.published.value
            and assignment.status != AssignmentStatus.published.value
            and assignment.published_at is None
        ):
            assignment.published_at = utcnow()
        assignment.status = new_status

    assignment.revision += 1
    payload = assignment_payload(assignment, classroom.name)
    record_change(
        db,
        owner_account_id=account.id,
        entity="assignment",
        entity_id=assignment.id,
        change_type="update",
        revision=assignment.revision,
        payload=payload,
        classroom_id=classroom.id,
    )
    db.commit()
    db.refresh(assignment)
    return payload


def delete_assignment(
    db: Session,
    account: Account,
    assignment_id: str,
) -> Message:
    assignment = db.get(Assignment, assignment_id)
    if assignment is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Assignment not found.",
        )
    classroom = classroom_or_404(db, assignment.classroom_id)
    require_owner(account, classroom)
    _require_not_archived(classroom)

    assignment.deleted_at = utcnow()
    assignment.revision += 1

    recipients = {account.id}
    active_members = db.scalars(
        select(ClassroomMember.student_id).where(
            ClassroomMember.classroom_id == classroom.id,
            ClassroomMember.status == MembershipStatus.active.value,
        )
    ).all()
    recipients.update(active_members)
    for recipient in recipients:
        record_change(
            db,
            owner_account_id=recipient,
            entity="assignment",
            entity_id=assignment.id,
            change_type="delete",
            revision=assignment.revision,
            classroom_id=classroom.id,
            revoked=True,
        )

    db.commit()
    return Message(message="Assignment deleted.")


def _progress_fingerprint(assignment_id: str, completed: bool) -> str:
    raw = f"{assignment_id}|{int(completed)}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


def set_progress(
    db: Session,
    account: Account,
    assignment_id: str,
    request: ProgressIn,
) -> Message:
    require_student(account)
    fingerprint = _progress_fingerprint(assignment_id, request.completed)

    processed = db.get(SyncOperation, request.operation_id)
    if processed is not None:
        if processed.account_id != account.id or processed.fingerprint != fingerprint:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Operation id has already been used.",
            )
        return Message(message="Progress already saved.")

    assignment = db.get(Assignment, assignment_id)
    if assignment is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Assignment not found.",
        )
    if (
        assignment.deleted_at is not None
        or assignment.status != AssignmentStatus.published.value
    ):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Assignment is not available for progress.",
        )
    classroom = classroom_or_404(db, assignment.classroom_id)
    require_active_membership(db, account, classroom)

    progress = db.scalar(
        select(AssignmentProgress).where(
            AssignmentProgress.account_id == account.id,
            AssignmentProgress.assignment_id == assignment.id,
        )
    )
    is_new = progress is None
    if is_new:
        progress = AssignmentProgress(
            id=str(uuid.uuid4()),
            account_id=account.id,
            assignment_id=assignment.id,
            revision=1,
        )
        db.add(progress)
    else:
        progress.revision += 1

    progress.is_completed = request.completed
    progress.completed_at = utcnow() if request.completed else None

    db.add(
        SyncOperation(
            operation_id=request.operation_id,
            account_id=account.id,
            fingerprint=fingerprint,
            result_status="applied",
            new_revision=progress.revision,
        )
    )
    record_change(
        db,
        owner_account_id=account.id,
        entity="assignment_progress",
        entity_id=progress.id,
        change_type="update",
        revision=progress.revision,
        payload=progress_payload(progress),
        classroom_id=classroom.id,
    )
    db.commit()
    return Message(message="Progress saved.")


def apply_progress_operation(
    db: Session,
    account_id: str,
    entity_id: str,
    base_revision: int,
    data: dict[str, Any],
) -> Applied:
    """Apply a queued ``assignment_progress`` operation during sync."""

    try:
        parsed = AssignmentProgressSyncIn.model_validate(data)
    except ValidationError as exc:
        raise PlannerRejected("Invalid assignment progress payload.") from exc

    existing = db.get(AssignmentProgress, entity_id)
    if existing is not None and existing.account_id != account_id:
        raise PlannerOwnershipError()
    if existing is not None and existing.revision != base_revision:
        raise PlannerConflict(progress_payload(existing))

    account = db.get(Account, account_id)
    assignment = db.get(Assignment, parsed.assignment_id)
    if account is None or assignment is None:
        raise PlannerRejected("Unknown account or assignment.")
    if (
        assignment.deleted_at is not None
        or assignment.status != AssignmentStatus.published.value
    ):
        raise PlannerRejected("Assignment is not available for progress.")
    classroom = classroom_or_404(db, assignment.classroom_id)
    require_active_membership(db, account, classroom)

    is_new = existing is None
    if is_new:
        existing = AssignmentProgress(
            id=entity_id,
            account_id=account_id,
            assignment_id=parsed.assignment_id,
            revision=base_revision,
        )

    existing.is_completed = parsed.is_completed
    existing.completed_at = parse_datetime(parsed.completed_at)
    existing.revision = base_revision + 1
    existing.updated_at = parse_datetime(parsed.updated_at) or utcnow()

    if is_new:
        db.add(existing)
    record_change(
        db,
        owner_account_id=account_id,
        entity="assignment_progress",
        entity_id=existing.id,
        change_type="update",
        revision=existing.revision,
        payload=progress_payload(existing),
        classroom_id=classroom.id,
    )
    commit(db, "Assignment progress could not be saved.")
    db.refresh(existing)
    return Applied(existing.revision, progress_payload(existing))
