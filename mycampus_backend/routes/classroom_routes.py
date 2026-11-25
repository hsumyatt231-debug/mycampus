"""Classroom endpoints used by Flutter's online-only flows."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from config.database import get_db
from controllers import classroom_controller
from middleware.auth import get_current_account
from models.account import Account
from schemas.classroom import (
    BootstrapOut,
    ClassroomCreate,
    ClassroomDetailOut,
    ClassroomOut,
    JoinCodeOut,
    JoinRequest,
)
from schemas.common import Message

router = APIRouter()


@router.get("/classrooms", response_model=list[ClassroomOut])
def list_classrooms(
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> list[dict]:
    return classroom_controller.list_classrooms(db, account)


@router.post("/classrooms", response_model=ClassroomOut)
def create_classroom(
    request: ClassroomCreate,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return classroom_controller.create_classroom(db, account, request)


@router.post("/classrooms/join", response_model=ClassroomOut)
def join_classroom(
    request: JoinRequest,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return classroom_controller.join_classroom(db, account, request)


@router.delete("/classrooms/members/{membership_id}", response_model=Message)
def remove_member(
    membership_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return classroom_controller.remove_member(db, account, membership_id)


@router.post("/classrooms/members/{membership_id}/unblock", response_model=Message)
def unblock_member(
    membership_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return classroom_controller.unblock_member(db, account, membership_id)


@router.get("/classrooms/{classroom_id}/bootstrap", response_model=BootstrapOut)
def bootstrap_scope(
    classroom_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> BootstrapOut:
    return classroom_controller.bootstrap_scope(db, account, classroom_id)


@router.post("/classrooms/{classroom_id}/leave", response_model=Message)
def leave_classroom(
    classroom_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return classroom_controller.leave_classroom(db, account, classroom_id)


@router.post("/classrooms/{classroom_id}/join-code/reset", response_model=JoinCodeOut)
def reset_join_code(
    classroom_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> JoinCodeOut:
    return classroom_controller.reset_join_code(db, account, classroom_id)


@router.post("/classrooms/{classroom_id}/archive", response_model=ClassroomOut)
def archive_classroom(
    classroom_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return classroom_controller.archive_classroom(db, account, classroom_id)


@router.get("/classrooms/{classroom_id}", response_model=ClassroomDetailOut)
def classroom_detail(
    classroom_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return classroom_controller.classroom_detail(db, account, classroom_id)
