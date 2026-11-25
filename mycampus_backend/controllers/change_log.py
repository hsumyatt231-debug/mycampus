"""Append authorized rows to the server-side pull feed.

Every record change that another device (or another member) must observe is
written here. Revoked rows carry no payload and are addressed to one account
so former classroom members can still clear their local cache.
"""

from __future__ import annotations

import json
import uuid
from typing import Any

from sqlalchemy.orm import Session

from models.sync import SyncChange


def record_change(
    db: Session,
    *,
    owner_account_id: str,
    entity: str,
    entity_id: str,
    change_type: str,
    revision: int,
    payload: dict[str, Any] | None = None,
    classroom_id: str | None = None,
    revoked: bool = False,
) -> SyncChange:
    change = SyncChange(
        change_id=str(uuid.uuid4()),
        owner_account_id=owner_account_id,
        entity=entity,
        entity_id=entity_id,
        change_type=change_type,
        revision=revision,
        payload_json=(
            None
            if revoked or payload is None
            else json.dumps(payload, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
        ),
        classroom_id=classroom_id,
        revoked=revoked,
    )
    db.add(change)
    return change
