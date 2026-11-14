# MyCampus

Offline-first student planner and classroom companion for Flutter, implemented
against the MyCampus SRS v1.0 (09 Nov 2026). The app keeps the approved
blue/white visual language and runs entirely on a local encrypted-at-rest
database by default, with Supabase sync wiring left in place for later.

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
| Sync | Offline queue, retry, conflicts, cursor metadata, manual sync |
| Classrooms | Teacher creation, join codes, members, assignments, publishing |
| Security | Local account hashing, app-lifecycle lock, 60s background shield |

## Architecture

```
lib/
  constants/     design tokens, app constants, API endpoints
  models/        pure domain models and enums
  services/      Drift database, academic clock, sync engine, gateways
  repositories/  account, subject, task, event, timetable, sync, classroom
  logic/         BLoC (auth) and Cubits (lock, sync, screens)
  ui/            theme, router, shell, screens, widgets
  main.dart      composition root
```

- **State management:** `flutter_bloc`. `AuthBloc` is the only classic Bloc;
  screen logic uses Cubits.
- **Navigation:** `go_router` with a `StatefulShellRoute.indexedStack` and five
  persistent tabs. Secondary pages (reminders, sync, classroom detail) sit
  outside the shell.
- **Persistence:** Drift over SQLite with 15 tables. Writes commit the record
  and its pending operation in one transaction.
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
flutter run -d windows
```

Quality checks:

```powershell
flutter analyze
flutter test
```

## Local-only mode

This build is intentionally backend-less so the SRS flows can be exercised
without live Supabase credentials:

- Accounts and passwords are stored locally. Passwords are salted with a
  per-account salt and hashed with SHA-256; the plaintext is never written or
  logged. Email verification is treated as complete.
- Every planner mutation is saved locally **and** appended to the pending
  operation queue. Because no gateway is configured, queue entries remain
  pending by design and the Sync center explains why.
- Classrooms and assignments are online-only in the SRS. Their screens, models,
  cache tables and repository contracts are complete, but creation, joining,
  publishing and live refresh show an "online required" state until a
  `CloudGateway` is configured.
- Reminders are surfaced in the in-app Reminder Center. Native OS notification
  scheduling is not enabled.

To connect a backend, provide a `CloudGateway` with `isConfigured == true` in
`lib/services/app_dependencies.dart` and replace `OfflineCloudGateway` with the
Supabase implementation using `lib/constants/api_endpoints.dart`.

## Documented deviations and open verification

These are deliberate for the local prototype and tracked against the SRS
technical verification register:

| Item | Status in this build |
| --- | --- |
| **TV-01** SQLCipher-compatible Drift integration | Not verified. Drift uses the standard SQLite implementation; `EncryptionKeyService` generates and stores an account key but the database file itself is not encrypted. |
| **TV-02** Windows Hello / DPAPI key binding | Not verified. Device unlock is a password re-entry shield, not a native cryptographic prompt. |
| **TV-03** Android device credential / Keystore policy | Not verified. No native Keystore-backed key release. |
| **TV-04** Snapshot + change-log bootstrap RPC | Contracts and cursor model are defined; precise transactional server RPCs are not exercised locally. |
| **TV-05** DST ambiguous/nonexistent handling | Deterministic policy implemented (shift forward / earlier offset) but not covered by device-level tests. |
| **TV-06** Academic timezone default | `Asia/Yangon` is the default, per the SRS proposal, and is editable online-only. |
| **TV-07** Numeric performance targets | Not measured; no acceptance thresholds defined. |
| **TV-08** Offline recovery after revocation or lost key | Revocation paths are modelled; end-to-end recovery is untested without a backend. |
| **TV-09** Final screen layouts | Existing approved blue/white screens are preserved. |

Additional intentional differences:

- Signing out in local-only mode clears the session but keeps planner data on
  the device so it can be reopened. With pending operations the profile screen
  offers Sync / Cancel / Discard before signing out.
- The app lock uses an app-lifecycle shield with a 60-second background
  threshold and password unlock. Native biometric/device-credential prompts are
  deferred with TV-02/TV-03.
- No admin role, submissions, grading, chat, attendance, recurring events,
  profile photo or email editing, or teacher progress analytics — matching the
  SRS MVP exclusions.
