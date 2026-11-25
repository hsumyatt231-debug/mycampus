"""Profile endpoints exposed by Flutter."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from config.database import get_db
from controllers import profile_controller
from middleware.auth import get_current_account
from models.account import Account
from schemas.profile import ProfileOut, TimezoneUpdate

router = APIRouter()


@router.post("/profile/timezone", response_model=ProfileOut)
def change_timezone(
    request: TimezoneUpdate,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> ProfileOut:
    return profile_controller.change_timezone(db, account, request)
