"""Account registration, adoption, sign-in and password rules."""

from __future__ import annotations

from fastapi import HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from config.security import (
    create_access_token,
    hash_password,
    normalize_email,
    verify_password,
)
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

_EMAIL_TAKEN = "Email already registered."
_ID_TAKEN = "Account id already registered."
_INVALID_LOGIN = "Invalid email or password."


def _by_email(db: Session, email: str) -> Account | None:
    normalized = normalize_email(email)
    return db.scalar(select(Account).where(func.lower(Account.email) == normalized))


def _auth_response(account: Account, message: str) -> AuthResponse:
    return AuthResponse(
        profile=ProfileOut.model_validate(account),
        token=create_access_token(account.id),
        message=message,
    )


def _register_or_adopt(
    db: Session,
    request: RegisterRequest,
    message: str,
) -> AuthResponse:
    """Create an account, or idempotently restore an identical one.

    The Flutter client may retry registration/adoption after a network failure,
    so a matching id + email + password + role is a success, not a conflict.
    """

    role = request.role.value if hasattr(request.role, "value") else str(request.role)
    by_id = db.get(Account, request.id)
    by_email = _by_email(db, request.email)

    if by_id is not None:
        identical = (
            by_email is not None
            and by_email.id == by_id.id
            and by_id.full_name == request.full_name
            and by_id.role == role
            and verify_password(request.password, by_id.password_hash, by_id.password_salt)
        )
        if identical:
            return _auth_response(by_id, message)
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=_ID_TAKEN)

    if by_email is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=_EMAIL_TAKEN)

    password_hash, password_salt = hash_password(request.password)
    account = Account(
        id=request.id,
        email=normalize_email(request.email),
        password_hash=password_hash,
        password_salt=password_salt,
        full_name=request.full_name,
        role=role,
    )
    db.add(account)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        # A concurrent request may have won the unique-email race.
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=_EMAIL_TAKEN) from None
    db.refresh(account)
    return _auth_response(account, message)


def register(db: Session, request: RegisterRequest) -> AuthResponse:
    return _register_or_adopt(db, request, "Account created. Welcome to MyCampus.")


def adopt_local(db: Session, request: AdoptLocalRequest) -> AuthResponse:
    return _register_or_adopt(db, request, "Local account linked to the MyCampus API.")


def login(db: Session, request: LoginRequest) -> AuthResponse:
    account = _by_email(db, request.email)
    if account is None or not verify_password(
        request.password, account.password_hash, account.password_salt
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_LOGIN,
            headers={"WWW-Authenticate": "Bearer"},
        )
    return _auth_response(account, "Signed in successfully.")


def read_profile(account: Account) -> ProfileOut:
    return ProfileOut.model_validate(account)


def change_password(
    db: Session,
    account: Account,
    request: ChangePasswordRequest,
) -> Message:
    if not verify_password(
        request.current_password, account.password_hash, account.password_salt
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect.",
        )
    password_hash, password_salt = hash_password(request.new_password)
    account.password_hash = password_hash
    account.password_salt = password_salt
    db.commit()
    db.refresh(account)
    return Message(message="Password updated.")


def reset_password(db: Session, request: ResetPasswordRequest) -> Message:
    account = _by_email(db, request.email)
    if account is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No account found for this email.",
        )
    password_hash, password_salt = hash_password(request.new_password)
    account.password_hash = password_hash
    account.password_salt = password_salt
    db.commit()
    db.refresh(account)
    return Message(message="Password updated. Sign in with your new password.")
