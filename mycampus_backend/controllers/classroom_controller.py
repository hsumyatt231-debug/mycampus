"""Classroom creation, membership and read-scope rules."""

from __future__ import annotations

import secrets
import uuid
from typing import Any

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from controllers.access import (
    classroom_or_404,
    membership_for,
    require_active_membership,
    require_owner,
    require_student,
    require_teacher,
)
from controllers.assignment_controller import assignments_for_classroom, own_progress
from controllers.change_log import record_change
from controllers.planner_support import iso_utc
from models.account import Account
from models.assignment import Assignment
from models.base import utcnow
from models.classroom import Classroom, ClassroomMember, MembershipEvent
from schemas.classroom import (
    BootstrapOut,
    ClassroomCreate,
    JoinCodeOut,
    JoinRequest,
)
from schemas.common import Message
from utils.validation import (
    MembershipEventType,
    MembershipStatus,
    UserRole,
)

_JOIN_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
_JOIN_CODE_LENGTH = 8


def is_owner(account: Account, classroom: Classroom) -> bool:
    return (
        account.role == UserRole.teacher.value
        and classroom.teacher_id == account.id
    )


def member_payload(member: ClassroomMember) -> dict[str, Any]:
    return {
        "id": member.id,
        "classroom_id": member.classroom_id,
        "student_id": member.student_id,
        "student_name": member.student_name,
        "student_email": member.student_email,
        "status": member.status,
        "rejoin_blocked": member.rejoin_blocked,
        "joined_at": iso_utc(member.joined_at),
        "ended_at": iso_utc(member.ended_at),
    }


def event_payload(event: MembershipEvent) -> dict[str, Any]:
    return {
        "id": event.id,
        "classroom_id": event.classroom_id,
        "membership_id": event.membership_id,
        "performed_by": event.performed_by,
        "event_type": event.event_type,
        "student_name": event.student_name,
        "created_at": iso_utc(event.created_at),
    }


def classroom_payload(
    db: Session,
    classroom: Classroom,
    *,
    owner: bool,
    members: list[dict[str, Any]] | None = None,
    events: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    teacher = db.get(Account, classroom.teacher_id)
    return {
        "id": classroom.id,
        "teacher_id": classroom.teacher_id,
        "teacher_name": teacher.full_name if teacher is not None else None,
        "name": classroom.name,
        "subject_name": classroom.subject_name,
        "description": classroom.description,
        "join_code": classroom.join_code if owner else None,
        "timezone": classroom.timezone,
        "archived": classroom.archived,
        "members": members or [],
        "events": events or [],
        "created_at": iso_utc(classroom.created_at),
        "updated_at": iso_utc(classroom.updated_at),
    }


def _classroom_change_payload(db: Session, classroom: Classroom) -> dict[str, Any]:
    """Classroom row for the pull feed; members/events stay online-only."""

    payload = classroom_payload(db, classroom, owner=True)
    payload.pop("members", None)
    payload.pop("events", None)
    return payload


def _revoke_classroom_scope(db: Session, account_id: str, classroom_id: str) -> None:
    """Clear a former member's cached classroom and assignment rows."""

    record_change(
        db,
        owner_account_id=account_id,
        entity="classroom",
        entity_id=classroom_id,
        change_type="delete",
        revision=0,
        classroom_id=classroom_id,
        revoked=True,
    )
    assignments = db.scalars(
        select(Assignment).where(
            Assignment.classroom_id == classroom_id,
            Assignment.deleted_at.is_(None),
        )
    ).all()
    for assignment in assignments:
        record_change(
            db,
            owner_account_id=account_id,
            entity="assignment",
            entity_id=assignment.id,
            change_type="delete",
            revision=assignment.revision,
            classroom_id=classroom_id,
            revoked=True,
        )


def _scope_lists(
    db: Session,
    classroom: Classroom,
    owner: bool,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    if not owner:
        return [], []

    members = db.scalars(
        select(ClassroomMember)
        .where(ClassroomMember.classroom_id == classroom.id)
        .order_by(ClassroomMember.student_name, ClassroomMember.id)
    ).all()
    events = db.scalars(
        select(MembershipEvent)
        .where(MembershipEvent.classroom_id == classroom.id)
        .order_by(MembershipEvent.created_at.desc(), MembershipEvent.id)
    ).all()
    return [member_payload(row) for row in members], [event_payload(row) for row in events]


def list_classrooms(db: Session, account: Account) -> list[dict[str, Any]]:
    if account.role == UserRole.teacher.value:
        classrooms = db.scalars(
            select(Classroom)
            .where(Classroom.teacher_id == account.id)
            .order_by(Classroom.name, Classroom.id)
        ).all()
    else:
        classrooms = db.scalars(
            select(Classroom)
            .join(ClassroomMember, ClassroomMember.classroom_id == Classroom.id)
            .where(
                ClassroomMember.student_id == account.id,
                ClassroomMember.status == MembershipStatus.active.value,
            )
            .order_by(Classroom.name, Classroom.id)
        ).all()

    result: list[dict[str, Any]] = []
    for classroom in classrooms:
        owner = is_owner(account, classroom)
        members, events = _scope_lists(db, classroom, owner)
        result.append(
            classroom_payload(db, classroom, owner=owner, members=members, events=events)
        )
    return result


def _new_join_code(db: Session) -> str:
    while True:
        code = "".join(secrets.choice(_JOIN_ALPHABET) for _ in range(_JOIN_CODE_LENGTH))
        taken = db.scalar(select(Classroom.id).where(Classroom.join_code == code))
        if taken is None:
            return code


def create_classroom(
    db: Session,
    account: Account,
    request: ClassroomCreate,
) -> dict[str, Any]:
    require_teacher(account)
    classroom = Classroom(
        id=str(uuid.uuid4()),
        teacher_id=account.id,
        name=request.name,
        subject_name=request.subject_name,
        description=request.description,
        join_code=_new_join_code(db),
        timezone=account.academic_timezone,
        archived=False,
    )
    db.add(classroom)
    record_change(
        db,
        owner_account_id=account.id,
        entity="classroom",
        entity_id=classroom.id,
        change_type="create",
        revision=0,
        payload=_classroom_change_payload(db, classroom),
        classroom_id=classroom.id,
    )
    db.commit()
    db.refresh(classroom)
    return classroom_payload(db, classroom, owner=True)


def _add_membership_event(
    db: Session,
    *,
    classroom_id: str,
    membership: ClassroomMember,
    performed_by: str,
    event_type: MembershipEventType,
) -> None:
    db.add(
        MembershipEvent(
            id=str(uuid.uuid4()),
            classroom_id=classroom_id,
            membership_id=membership.id,
            performed_by=performed_by,
            event_type=event_type.value,
            student_name=membership.student_name,
        )
    )


def join_classroom(
    db: Session,
    account: Account,
    request: JoinRequest,
) -> dict[str, Any]:
    require_student(account)
    classroom = db.scalar(select(Classroom).where(Classroom.join_code == request.code))
    if classroom is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Invalid join code.",
        )
    if classroom.archived:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Classroom is archived.",
        )

    membership = membership_for(db, classroom.id, account.id)
    now = utcnow()
    if membership is None:
        membership = ClassroomMember(
            id=str(uuid.uuid4()),
            classroom_id=classroom.id,
            student_id=account.id,
            student_name=account.full_name,
            student_email=account.email,
            status=MembershipStatus.active.value,
            rejoin_blocked=False,
            joined_at=now,
        )
        db.add(membership)
        _add_membership_event(
            db,
            classroom_id=classroom.id,
            membership=membership,
            performed_by=account.id,
            event_type=MembershipEventType.joined,
        )
    elif membership.status == MembershipStatus.active.value:
        pass
    elif membership.rejoin_blocked:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not allowed to rejoin this classroom.",
        )
    else:
        membership.status = MembershipStatus.active.value
        membership.rejoin_blocked = False
        membership.joined_at = now
        membership.ended_at = None
        _add_membership_event(
            db,
            classroom_id=classroom.id,
            membership=membership,
            performed_by=account.id,
            event_type=MembershipEventType.joined,
        )

    record_change(
        db,
        owner_account_id=classroom.teacher_id,
        entity="classroom",
        entity_id=classroom.id,
        change_type="update",
        revision=0,
        payload=_classroom_change_payload(db, classroom),
        classroom_id=classroom.id,
    )
    db.commit()
    return classroom_payload(db, classroom, owner=False)


def leave_classroom(
    db: Session,
    account: Account,
    classroom_id: str,
) -> Message:
    require_student(account)
    classroom_or_404(db, classroom_id)
    membership = membership_for(db, classroom_id, account.id)
    if membership is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Membership not found.",
        )
    if membership.status != MembershipStatus.active.value:
        return Message(message="You are not an active member.")

    membership.status = MembershipStatus.left.value
    membership.ended_at = utcnow()
    _add_membership_event(
        db,
        classroom_id=classroom_id,
        membership=membership,
        performed_by=account.id,
        event_type=MembershipEventType.left,
    )
    _revoke_classroom_scope(db, account.id, classroom_id)
    db.commit()
    return Message(message="You left the classroom.")


def classroom_detail(
    db: Session,
    account: Account,
    classroom_id: str,
) -> dict[str, Any]:
    classroom = classroom_or_404(db, classroom_id)
    owner = is_owner(account, classroom)
    if not owner:
        require_active_membership(db, account, classroom)

    members, events = _scope_lists(db, classroom, owner)
    assignments = assignments_for_classroom(db, classroom, owner)
    return {
        "classroom": classroom_payload(
            db,
            classroom,
            owner=owner,
            members=members,
            events=events,
        ),
        "members": members,
        "events": events,
        "assignments": assignments,
        "progress": own_progress(db, account.id, assignments),
    }


def remove_member(
    db: Session,
    account: Account,
    membership_id: str,
) -> Message:
    membership = db.get(ClassroomMember, membership_id)
    if membership is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Membership not found.",
        )
    classroom = classroom_or_404(db, membership.classroom_id)
    require_owner(account, classroom)

    if (
        membership.status == MembershipStatus.removed.value
        and membership.rejoin_blocked
    ):
        return Message(message="Member is already removed.")

    membership.status = MembershipStatus.removed.value
    membership.rejoin_blocked = True
    membership.ended_at = utcnow()
    _add_membership_event(
        db,
        classroom_id=classroom.id,
        membership=membership,
        performed_by=account.id,
        event_type=MembershipEventType.removed,
    )
    _revoke_classroom_scope(db, membership.student_id, classroom.id)
    db.commit()
    return Message(message="Member removed.")


def unblock_member(
    db: Session,
    account: Account,
    membership_id: str,
) -> Message:
    membership = db.get(ClassroomMember, membership_id)
    if membership is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Membership not found.",
        )
    classroom = classroom_or_404(db, membership.classroom_id)
    require_owner(account, classroom)

    if not membership.rejoin_blocked:
        return Message(message="Member is not blocked.")

    membership.rejoin_blocked = False
    _add_membership_event(
        db,
        classroom_id=classroom.id,
        membership=membership,
        performed_by=account.id,
        event_type=MembershipEventType.unblocked,
    )
    db.commit()
    return Message(message="Member may rejoin.")


def reset_join_code(
    db: Session,
    account: Account,
    classroom_id: str,
) -> JoinCodeOut:
    classroom = classroom_or_404(db, classroom_id)
    require_owner(account, classroom)
    classroom.join_code = _new_join_code(db)
    record_change(
        db,
        owner_account_id=account.id,
        entity="classroom",
        entity_id=classroom.id,
        change_type="update",
        revision=0,
        payload=_classroom_change_payload(db, classroom),
        classroom_id=classroom.id,
    )
    db.commit()
    db.refresh(classroom)
    return JoinCodeOut(join_code=classroom.join_code)


def archive_classroom(
    db: Session,
    account: Account,
    classroom_id: str,
) -> dict[str, Any]:
    classroom = classroom_or_404(db, classroom_id)
    require_owner(account, classroom)
    if not classroom.archived:
        classroom.archived = True
        record_change(
            db,
            owner_account_id=account.id,
            entity="classroom",
            entity_id=classroom.id,
            change_type="update",
            revision=0,
            payload=_classroom_change_payload(db, classroom),
            classroom_id=classroom.id,
        )
        db.commit()
        db.refresh(classroom)
    return classroom_payload(db, classroom, owner=True)


def bootstrap_scope(
    db: Session,
    account: Account,
    classroom_id: str,
) -> BootstrapOut:
    classroom = classroom_or_404(db, classroom_id)
    require_active_membership(db, account, classroom)
    assignments = assignments_for_classroom(db, classroom, is_owner=False)
    return BootstrapOut(
        members=[],
        assignments=assignments,
        progress=own_progress(db, account.id, assignments),
        next_cursor=None,
        has_more=False,
    )
