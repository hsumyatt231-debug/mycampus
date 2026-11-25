"""Local-first push/pull wire contracts."""

from __future__ import annotations

from datetime import datetime
from typing import Annotated, Any, Literal, Union

from pydantic import Field

from schemas.common import ApiModel
from utils.validation import ChangeType, SyncEntity, SyncOperationType


class SyncOperationIn(ApiModel):
    operation_id: str = Field(min_length=1, max_length=36)
    account_id: str = Field(min_length=1, max_length=36)
    entity: SyncEntity
    entity_id: str = Field(min_length=1, max_length=36)
    type: SyncOperationType
    base_revision: int = Field(ge=0)
    fingerprint: str = Field(min_length=1, max_length=64)
    data: dict[str, Any]


class PushAppliedOut(ApiModel):
    status: Literal["applied"] = "applied"
    new_revision: int
    payload: dict[str, Any] | None = None


class PushConflictOut(ApiModel):
    status: Literal["conflict"] = "conflict"
    payload: dict[str, Any]


class PushFailedOut(ApiModel):
    status: Literal["failed"] = "failed"
    reason: str


PushOutcomeOut = Annotated[
    Union[PushAppliedOut, PushConflictOut, PushFailedOut],
    Field(discriminator="status"),
]


class CloudChangeOut(ApiModel):
    change_id: str
    # Flutter's CloudChange.entity is a plain String: the pull feed also emits
    # server-owned classroom/assignment entities that are not push SyncEntity codes.
    entity: str
    entity_id: str
    change_type: ChangeType
    revision: int
    payload: dict[str, Any] | None = None
    owner_account_id: str
    classroom_id: str | None = None
    revoked: bool = False


class PullPageOut(ApiModel):
    changes: list[CloudChangeOut]
    next_cursor: str | None = None
    has_more: bool = False


class SyncStatusOut(ApiModel):
    account_id: str
    cursor: str | None = None
    server_time: datetime
    entities: dict[str, int]
