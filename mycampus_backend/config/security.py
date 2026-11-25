"""Password hashing and signed access tokens."""

from __future__ import annotations

import hashlib
import hmac
import secrets
from datetime import datetime, timedelta, timezone

import jwt

from config.settings import settings

_PBKDF2_ITERATIONS = 210_000


def normalize_email(email: str) -> str:
    return email.strip().lower()


def hash_password(password: str, salt: str | None = None) -> tuple[str, str]:
    """Return ``(password_hash, salt)`` as hex strings.

    A caller-supplied salt is used for verification; a new one is generated
    when storing a password.
    """

    salt_hex = salt if salt is not None else secrets.token_hex(16)
    try:
        salt_bytes = bytes.fromhex(salt_hex)
    except ValueError as exc:
        raise ValueError("Invalid password salt.") from exc
    digest = hashlib.pbkdf2_hmac(
        "sha256", password.encode("utf-8"), salt_bytes, _PBKDF2_ITERATIONS
    ).hex()
    return digest, salt_hex


def verify_password(password: str, password_hash: str, salt: str) -> bool:
    try:
        candidate, _ = hash_password(password, salt)
    except ValueError:
        return False
    return hmac.compare_digest(candidate, password_hash)


def create_access_token(account_id: str) -> str:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": account_id,
        "iat": now,
        "exp": now + timedelta(minutes=settings.access_token_ttl_minutes),
    }
    return jwt.encode(payload, settings.secret_key, algorithm="HS256")


def decode_access_token(token: str) -> str:
    """Return the account id from a valid token; raise ``jwt.PyJWTError``."""

    payload = jwt.decode(
        token,
        settings.secret_key,
        algorithms=["HS256"],
        options={"require": ["sub", "exp"]},
    )
    account_id = payload.get("sub")
    if not isinstance(account_id, str) or not account_id:
        raise jwt.InvalidTokenError("Token has no account subject.")
    return account_id
