"""Local-first synchronization endpoints used by Flutter's SyncEngine."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from config.database import get_db
from controllers import sync_controller
from middleware.auth import get_current_account
from models.account import Account
from schemas.sync import PullPageOut, SyncOperationIn, SyncStatusOut, PushOutcomeOut

router = APIRouter()


@router.post("/sync/operation", response_model=PushOutcomeOut)
def push_operation(
    request: SyncOperationIn,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> dict:
    return sync_controller.apply_operation(db, account, request)


@router.get("/sync/pull", response_model=PullPageOut)
def pull_changes(
    cursor: str | None = Query(default=None),
    page_size: int = Query(default=200, ge=1, le=500),
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> PullPageOut:
    return sync_controller.pull(db, account, cursor, page_size)


@router.get("/sync/status", response_model=SyncStatusOut)
def sync_status(
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> SyncStatusOut:
    return sync_controller.status(db, account)
