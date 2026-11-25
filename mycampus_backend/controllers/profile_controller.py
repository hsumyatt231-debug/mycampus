"""Profile rules that are reachable outside the sync queue."""

from __future__ import annotations

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from models.account import Account
from schemas.profile import ProfileOut, TimezoneUpdate
from utils.validation import is_valid_timezone


def change_timezone(
    db: Session,
    account: Account,
    request: TimezoneUpdate,
) -> ProfileOut:
    """Update the academic timezone without changing wall-clock values."""

    if not is_valid_timezone(request.academic_timezone):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Unknown IANA timezone.",
        )
    account.academic_timezone = request.academic_timezone
    db.commit()
    db.refresh(account)
    return ProfileOut.model_validate(account)
