"""Shared authorization helpers for classroom and assignment controllers."""

from __future__ import annotations

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from models.account import Account
from models.classroom import Classroom, ClassroomMember
from utils.validation import MembershipStatus, UserRole


def require_teacher(account: Account) -> None:
    if account.role != UserRole.teacher.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only teachers can perform this action.",
        )


def require_student(account: Account) -> None:
    if account.role != UserRole.student.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only students can perform this action.",
        )


def classroom_or_404(db: Session, classroom_id: str) -> Classroom:
    classroom = db.get(Classroom, classroom_id)
    if classroom is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Classroom not found.",
        )
    return classroom


def require_owner(account: Account, classroom: Classroom) -> None:
    require_teacher(account)
    if classroom.teacher_id != account.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not teach this classroom.",
        )


def membership_for(
    db: Session,
    classroom_id: str,
    account_id: str,
) -> ClassroomMember | None:
    return db.scalar(
        select(ClassroomMember).where(
            ClassroomMember.classroom_id == classroom_id,
            ClassroomMember.student_id == account_id,
        )
    )


def require_active_membership(
    db: Session,
    account: Account,
    classroom: Classroom,
) -> ClassroomMember:
    require_student(account)
    membership = membership_for(db, classroom.id, account.id)
    if membership is None or membership.status != MembershipStatus.active.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not an active member of this classroom.",
        )
    return membership
