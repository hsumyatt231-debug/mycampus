# MyCampus Backend

Python FastAPI backend for the existing MyCampus Flutter application.

## Status

Phase 11 is complete. Authentication, profile, planner controllers,
classroom/assignment endpoints, sync operation/pull/status, and the Flutter
password-endpoint wiring are implemented phase by phase after each review.
Real SQLite, HTTP, `flutter analyze` and `flutter test` verification passes for
every completed phase.

### Write model (Phase 11)

The Flutter client is online-first: each write is delivered immediately through
the existing `POST /api/v1/sync/operation` endpoint. When that request cannot be
delivered (offline, timeout or missing token), the operation stays in the local
Drift `pending_operations` queue and the Sync screen can drain it later. No new
REST endpoints were added for this phase; the backend is unchanged.

## Design constraints

- The Flutter app is the source of truth for features, roles and workflows.
- SQLite is the only server-side database.
- Layered flow: `main.py` → central router → module routes → controllers →
  models → database → JSON response.
- No business logic or SQL in route handlers.
- No sample, demo, mock or hardcoded application records.
- The Flutter local Drift/SQLite database is not replaced or modified.

## Planned structure

```
main.py
routes/         index.py + one router per module
controllers/    business rules, permissions, ownership, revisions
models/         SQLAlchemy entities and CRUD
schemas/        Pydantic request/response models
config/         settings.py, database.py, security.py
middleware/     authentication and error handling
utils/          validation and shared helpers
tests/          real-database tests
```

## Setup (after implementation phases)

```powershell
cd C:\hsu\mycampus\mycampus_backend
python -m pip install -r requirements.txt
Copy-Item .env.example .env
python -m uvicorn main:app --host 0.0.0.0 --port 8001
```

The Flutter client must use a reachable base URL, for example:

```powershell
flutter run -d emulator-5554 --dart-define=MYCAMPUS_API_BASE_URL=http://192.168.70.96:8001/api/v1
```
