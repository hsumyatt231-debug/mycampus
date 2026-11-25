"""Central API router.

Every module router is registered here under ``settings.api_prefix``. Route
handlers added in later phases must delegate to controllers.
"""

from __future__ import annotations

from fastapi import APIRouter

from config.settings import settings
from routes import (
    assignment_routes,
    auth_routes,
    classroom_routes,
    event_routes,
    profile_routes,
    subject_routes,
    sync_routes,
    task_routes,
    timetable_routes,
)

_MODULES = (
    (auth_routes, "auth"),
    (profile_routes, "profile"),
    (subject_routes, "subjects"),
    (task_routes, "tasks"),
    (timetable_routes, "timetable"),
    (event_routes, "events"),
    (classroom_routes, "classrooms"),
    (assignment_routes, "assignments"),
    (sync_routes, "sync"),
)

api_router = APIRouter(prefix=settings.api_prefix)

for module, tag in _MODULES:
    api_router.include_router(module.router, tags=[tag])
