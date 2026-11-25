"""Assignment endpoints used by Flutter's classroom flows."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from config.database import get_db
from controllers import assignment_controller
from middleware.auth import get_current_account
from models.account import Account
from schemas.assignment import AssignmentCreate, AssignmentOut, AssignmentUpdate, ProgressIn
from schemas.common import Message

router = APIRouter()


@router.get("/assignments", response_model=list[AssignmentOut])
def list_my_assignments(
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> list[dict]:
    return assignment_controller.list_my_assignments(db, account)


@router.post("/classrooms/{classroom_id}/assignments", response_model=AssignmentOut)
def create_assignment(
    classroom_id: str,
    request: AssignmentCreate,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return assignment_controller.create_assignment(db, account, classroom_id, request)


@router.patch("/assignments/{assignment_id}", response_model=AssignmentOut)
def update_assignment(
    assignment_id: str,
    request: AssignmentUpdate,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return assignment_controller.update_assignment(db, account, assignment_id, request)


@router.delete("/assignments/{assignment_id}", response_model=Message)
def delete_assignment(
    assignment_id: str,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return assignment_controller.delete_assignment(db, account, assignment_id)


@router.post("/assignments/{assignment_id}/progress", response_model=Message)
def set_progress(
    assignment_id: str,
    request: ProgressIn,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return assignment_controller.set_progress(db, account, assignment_id, request)
