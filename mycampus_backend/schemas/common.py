"""Shared Pydantic configuration and small response helpers."""

from __future__ import annotations

from pydantic import BaseModel, ConfigDict


class ApiModel(BaseModel):
    """Base for all request/response models.

    ORM objects can be returned directly (``from_attributes``) and unknown
    keys from older clients are ignored rather than rejected.
    """

    model_config = ConfigDict(
        from_attributes=True,
        populate_by_name=True,
        extra="ignore",
    )


class Message(ApiModel):
    message: str
