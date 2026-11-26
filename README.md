# MyCampus

Online-first student planner and classroom companion for Flutter, implemented
against the MyCampus SRS v1.0 (09 Nov 2026). The approved blue/white visual
language is preserved. Writes go straight to a FastAPI/SQLite REST backend;
when the API cannot be reached, the write stays in the local Drift queue and is
delivered by the Sync screen later.

## Feature coverage

| Area | Implemented |
| --- | --- |
| Auth | Register, sign in, sign out, password reset, session restore |
| Home | Today, upcoming work, timetable snapshot, reminders, classrooms |
| Subjects | Create/edit/delete, colour palette, deletion impact preview |
| Tasks | Deadlines (date-only or timed), priorities, status, subject links |
| Calendar | Month/week views, events, timetable, assignment deadlines |
| Reminders | In-app Reminder Center for tasks, events and assignments |
| Profile | Name, 12/24-hour format, academic timezone, password, lock now |
| Sync | Online-first writes, offline queue fallback, retry, conflicts, cursor metadata, manual sync |
| Classrooms | Teacher creation, join codes, members, assignments, publishing |
| Security | Local account hashing, bearer-token API auth, app-lifecycle lock, 60s background shield |
| Backend | FastAPI + SQLite REST API, 9 modules, 24 OpenAPI paths |

## Architecture

```
lib/
  constants/     design tokens, app constants, live REST endpoints (api_config.dart)
  models/        pure domain models and enums
  services/      Drift database, sync engine, HTTP gateway, online-first write service
  repositories/  account, subject, task, event, timetable, sync, classroom
  logic/         BLoC (auth) and Cubits (lock, sync, screens)
  ui/            theme, router, shell, screens, widgets
  main.dart      app entry point

mycampus_backend/
  main.py, routes/, controllers/, models/, schemas/, config/, middleware/
```

- **State management:** `flutter_bloc`. `AuthBloc` is the only classic Bloc;
  screen logic uses Cubits.
- **Navigation:** `go_router` with a `StatefulShellRoute.indexedStack` and five
  persistent tabs. Secondary pages (reminders, sync, classroom detail) sit
  outside the shell.
- **Composition root:** `lib/services/app_dependencies.dart` builds the database,
  settings, `HttpCloudGateway`, `CloudWriteService` and repositories.
- **Persistence:** Drift over SQLite with 15 tables. Every write commits the
  record and its pending operation in one transaction. Online delivery then
  pushes that exact operation through `POST /api/v1/sync/operation` and clears
  the queue entry on acknowledgement.
- **Cloud contract:** `MYCAMPUS_API_BASE_URL` selects the REST base URL
  (default `http://127.0.0.1:8001/api/v1`). Register/login issue a bearer token
  that `HttpCloudGateway` attaches to every protected request.
- **Sync contract:** preflight pull → ordered push → final pull, stable
  operation IDs and payload fingerprints, optimistic revision checks, atomic
  cursor updates and explicit Local/Cloud conflict resolution. Server deletions
  and classroom revocations always win.
- **Time:** deadlines without a time are due at the academic end-of-day in the
  profile timezone. Nonexistent DST times shift forward; ambiguous times use the
  earlier offset.

## Getting started

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # regenerate Drift code
flutter run -d windows --dart-define=MYCAMPUS_API_BASE_URL=http://127.0.0.1:8001/api/v1
```

Start the backend first:

```powershell
cd C:\hsu\mycampus\mycampus_backend
python -m pip install -r requirements.txt
Copy-Item .env.example .env
python -m uvicorn main:app --host 127.0.0.1 --port 8001
```

For an Android emulator use `http://10.0.2.2:8001/api/v1` instead of
`127.0.0.1`.

Quality checks:

```powershell
flutter analyze
flutter test
python -m compileall -q .
```

## Online-first writes

- When the API is configured, authenticated and reachable, each planner write
  is delivered immediately through the existing `/sync/operation` endpoint.
  The local row is marked `synced` with the server revision and the queue stays
  empty.
- When delivery fails (offline, timeout or missing token), the local record and
  its `pending_operations` entry remain exactly as before; the Sync screen can
  drain them later. `ConnectivityService` is not used to decide online state —
  successful delivery is the signal.
- `conflict` and permanent `failed` results stay visible in Sync; local data is
  never overwritten by a failed push.
- Registration and password changes are cloud-first: the API accepts the
  change before the local credential is updated. A network failure keeps the
  local-only fallback; a server rejection aborts the change.
- Classrooms and assignments are online-only and use their dedicated REST
  endpoints; their local Drift tables are caches.
- The backend contains no seed, demo, mock or hardcoded application records.

## Offline fallback

The app still works without the API:

- Accounts and passwords are stored locally. Passwords are salted with a
  per-account salt and hashed with SHA-256; the plaintext is never written or
  logged. Email verification is treated as complete.
- Every planner mutation is saved locally and appended to the pending
  operation queue. Queue entries stay pending until the Sync screen can reach
  the API.
- Reminders are surfaced in the in-app Reminder Center. Native OS notification
  scheduling is not enabled.

`lib/constants/api_endpoints.dart` holds legacy Supabase names for reference
only; it is not used by any gateway. The live endpoints are in
`lib/constants/api_config.dart`.

## Documented deviations and open verification

| Item | Status in this build |
| --- | --- |
| **TV-01** SQLCipher-compatible Drift integration | Not verified. Drift uses the standard SQLite implementation; `EncryptionKeyService` generates and stores an account key but the database file itself is not encrypted. |
| **TV-02** Windows Hello / DPAPI key binding | Not verified. Device unlock is a password re-entry shield, not a native cryptographic prompt. |
| **TV-03** Android device credential / Keystore policy | Not verified. No native Keystore-backed key release. |
| **TV-04** Snapshot + change-log bootstrap RPC | Implemented as REST endpoints (`/sync/pull`, `/sync/operation`, `/sync/status`, classroom bootstrap) and verified with real SQLite + HTTP against the FastAPI backend; no separate stored-procedure RPC layer. |
| **TV-05** DST ambiguous/nonexistent handling | Deterministic policy implemented (shift forward / earlier offset) but not covered by device-level tests. |
| **TV-06** Academic timezone default | `Asia/Yangon` is the default, per the SRS proposal, and is editable online-only. |
| **TV-07** Numeric performance targets | Not measured; no acceptance thresholds defined. |
| **TV-08** Offline recovery after revocation or lost key | Revocation paths are modelled and verified against the backend; end-to-end recovery after a lost key remains untested. |
| **TV-09** Final screen layouts | Existing approved blue/white screens are preserved. |

Additional intentional differences:

- Signing out clears the session but keeps planner data on the device so it can
  be reopened. With pending operations the profile screen offers Sync / Cancel /
  Discard before signing out.
- The app lock uses an app-lifecycle shield with a 60-second background
  threshold and password unlock. Native biometric/device-credential prompts are
  deferred with TV-02/TV-03.
- No admin role, submissions, grading, chat, attendance, recurring events,
  profile photo or email editing, or teacher progress analytics — matching the
  SRS MVP exclusions.
