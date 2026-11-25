"""Authentication endpoints matching Flutter's ``ApiConfig`` paths."""

from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from config.database import get_db
from controllers import auth_controller
from middleware.auth import get_current_account
from models.account import Account
from schemas.auth import (
    AdoptLocalRequest,
    AuthResponse,
    ChangePasswordRequest,
    LoginRequest,
    RegisterRequest,
    ResetPasswordRequest,
)
from schemas.common import Message
from schemas.profile import ProfileOut

router = APIRouter()


@router.post("/auth/register", response_model=AuthResponse)
def register(request: RegisterRequest, db: Session = Depends(get_db)) -> AuthResponse:
    return auth_controller.register(db, request)


@router.post("/auth/adopt-local", response_model=AuthResponse)
def adopt_local(request: AdoptLocalRequest, db: Session = Depends(get_db)) -> AuthResponse:
    return auth_controller.adopt_local(db, request)


@router.post("/auth/login", response_model=AuthResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)) -> AuthResponse:
    return auth_controller.login(db, request)


@router.get("/auth/me", response_model=ProfileOut)
def me(account: Account = Depends(get_current_account)) -> ProfileOut:
    return auth_controller.read_profile(account)


@router.post("/auth/change-password", response_model=Message)
def change_password(
    request: ChangePasswordRequest,
    account: Account = Depends(get_current_account),
    db: Session = Depends(get_db),
) -> Message:
    return auth_controller.change_password(db, account, request)


@router.post("/auth/reset-password", response_model=Message)
def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db),
) -> Message:
    return auth_controller.reset_password(db, request)
