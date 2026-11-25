import 'package:drift/drift.dart' as d;

import '../constants/app_constants.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';
import '../services/cloud_gateway.dart';
import '../services/cloud_write_service.dart';
import '../services/encryption_key_service.dart';
import '../services/id_service.dart';
import '../services/local_database.dart';
import 'pending_operation_writer.dart';
import 'settings_repository.dart';

/// Local account management with best-effort cloud registration/login.
///
/// Drift remains the source of truth on the device, so an account can always
/// be created and opened offline. When the API is reachable, the same id and
/// credentials are registered there and the returned bearer token is stored
/// for classroom and sync requests.
class AccountRepository {
  AccountRepository({
    required this._database,
    required this._settings,
    required this._writer,
    required this._keyService,
    required this._gateway,
    required this._cloud,
  });

  final LocalDatabase _database;
  final SettingsRepository _settings;
  final PendingOperationWriter _writer;
  final EncryptionKeyService _keyService;
  final CloudGateway _gateway;
  final CloudWriteService _cloud;

  Future<UserProfile?> restoreSession() async {
    final accountId = await _settings.sessionAccountId();
    if (accountId == null) return null;
    final row = await _accountById(accountId);
    if (row == null) {
      await _settings.clearSession();
      return null;
    }
    return _map(row);
  }

  Future<List<UserProfile>> accountsOnDevice() async {
    final rows = await _database.select(_database.accounts).get();
    return rows.map(_map).toList();
  }

  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final name = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();

    if (name.length < 2) {
      throw const AccountValidationException('Enter your full name.');
    }
    if (!_emailPattern.hasMatch(normalizedEmail)) {
      throw const AccountValidationException('Enter a valid email address.');
    }
    if (password.length < 8) {
      throw const AccountValidationException(
        'Password must be at least 8 characters.',
      );
    }

    final existing = await (_database.select(
      _database.accounts,
    )..where((t) => t.email.lower().equals(normalizedEmail))).getSingleOrNull();
    if (existing != null) {
      throw const AccountValidationException(
        'An account with this email already exists on this device.',
      );
    }

    final now = DateTime.now().toUtc();
    final id = IdService.newId();
    final salt = HashService.newSalt();

    // Online-first: the API owns the identity before the local row is written.
    // A network failure keeps the registration local-only; a server rejection
    // (for example an email already taken) aborts without a device account.
    String? cloudToken;
    if (_gateway.isConfigured) {
      try {
        final result = await _gateway.cloudRegister(
          id: id,
          fullName: name,
          email: normalizedEmail,
          password: password,
          role: role.code,
        );
        final token = result['token']?.toString();
        final profile = result['profile'];
        final cloudId = profile is Map ? profile['id']?.toString() : null;
        if (token == null || token.isEmpty || cloudId != id) {
          throw const AccountAuthException(
            'The API returned an invalid account identity.',
          );
        }
        cloudToken = token;
      } on CloudUnavailableException {
        // Offline: keep the local-first fallback so sign-in still works.
      } on CloudRejectedException catch (error) {
        throw AccountAuthException(error.message);
      }
    }

    await _database
        .into(_database.accounts)
        .insert(
          AccountsCompanion.insert(
            id: id,
            email: normalizedEmail,
            fullName: name,
            role: role.code,
            passwordHash: HashService.hashPassword(password, salt),
            passwordSalt: salt,
            academicTimezone: AppConstants.defaultAcademicTimezone,
            emailVerified: const d.Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );

    await _keyService.keyForAccount(id);
    await _keyService.markKeyAvailable(id);
    await _settings.setSessionAccount(id);
    if (cloudToken != null) await _settings.setCloudToken(cloudToken);

    final row = await _accountById(id);
    return _map(row!);
  }

  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final row = await (_database.select(
      _database.accounts,
    )..where((t) => t.email.lower().equals(normalizedEmail))).getSingleOrNull();

    if (row == null) {
      throw const AccountAuthException('No account found for this email.');
    }
    if (!row.emailVerified) {
      throw const AccountAuthException('Verify your email before signing in.');
    }

    final digest = HashService.hashPassword(password, row.passwordSalt);
    if (digest != row.passwordHash) {
      throw const AccountAuthException('Incorrect password.');
    }

    await _settings.setSessionAccount(row.id);
    await _keyService.keyForAccount(row.id);
    await _keyService.markKeyAvailable(row.id);

    await _fetchCloudToken(
      id: row.id,
      fullName: row.fullName,
      email: row.email,
      password: password,
      role: row.role,
    );
    return _map(row);
  }

  /// Signs in through the API to refresh the stored bearer token. Accounts
  /// created by older offline-only builds are adopted with their local id, so
  /// their data and sync ownership keep matching. Local sign-in stays valid
  /// even when the API is offline.
  Future<void> _fetchCloudToken({
    required String id,
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    if (!_gateway.isConfigured) return;
    try {
      final result = await _gateway.cloudLogin(
        email: email,
        password: password,
      );
      final token = result['token']?.toString();
      final profile = result['profile'];
      final cloudId = profile is Map ? profile['id']?.toString() : null;
      if (token != null && token.isNotEmpty && cloudId == id) {
        await _settings.setCloudToken(token);
        return;
      }
      // A same-email cloud account with a different id cannot own this
      // device's sync data — fall through to adopting the local identity.
    } on CloudUnavailableException {
      await _settings.clearCloudToken();
      return;
    } on CloudRejectedException {
      // Not registered on the API yet — try adopting the device account.
    }

    try {
      final result = await _gateway.cloudAdoptLocal(
        id: id,
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      final token = result['token']?.toString();
      if (token != null && token.isNotEmpty) {
        await _settings.setCloudToken(token);
        return;
      }
    } on CloudUnavailableException {
      // Offline: the local session is still valid.
    } on CloudRejectedException {
      // Conflicting cloud account or different password; keep local access.
    }
    await _settings.clearCloudToken();
  }

  /// Refreshes the bearer token with the password just entered at unlock.
  /// Unlock itself must never fail because of a cloud problem.
  Future<void> refreshCloudToken(String accountId, String password) async {
    final row = await _accountById(accountId);
    if (row == null) return;
    try {
      await _fetchCloudToken(
        id: row.id,
        fullName: row.fullName,
        email: row.email,
        password: password,
        role: row.role,
      );
    } catch (_) {
      // Keep the local unlock successful; sync can retry later.
    }
  }

  Future<bool> verifyPassword(String accountId, String password) async {
    final row = await _accountById(accountId);
    if (row == null) return false;
    return HashService.hashPassword(password, row.passwordSalt) ==
        row.passwordHash;
  }

  Future<void> requestPasswordReset(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final row = await (_database.select(
      _database.accounts,
    )..where((t) => t.email.lower().equals(normalizedEmail))).getSingleOrNull();

    if (row == null) {
      throw const AccountAuthException(
        'No account found for this email on this device.',
      );
    }
    // Sample mode cannot send email. The local password reset flow below is
    // the only supported path.
  }

  /// Changes the signed-in account's password on the API first, then mirrors
  /// the new credential into Drift. The local credential is never changed when
  /// the API rejects the current password or cannot be reached, so the next
  /// unlock and token refresh keep working.
  Future<void> changePassword({
    required String accountId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      throw const AccountValidationException(
        'Password must be at least 8 characters.',
      );
    }
    final row = await _accountById(accountId);
    if (row == null) {
      throw const AccountAuthException('No account found for this device.');
    }

    if (_gateway.isConfigured) {
      await _gateway.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    }
    await _writeLocalPassword(row, newPassword);
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      throw const AccountValidationException(
        'Password must be at least 8 characters.',
      );
    }
    final normalizedEmail = email.trim().toLowerCase();
    final row = await (_database.select(
      _database.accounts,
    )..where((t) => t.email.lower().equals(normalizedEmail))).getSingleOrNull();

    if (row == null && !_gateway.isConfigured) {
      throw const AccountAuthException('No account found for this email.');
    }

    if (_gateway.isConfigured) {
      await _gateway.resetPassword(
        email: normalizedEmail,
        newPassword: newPassword,
      );
    }
    if (row != null) await _writeLocalPassword(row, newPassword);
  }

  Future<void> _writeLocalPassword(AccountRow row, String newPassword) async {
    final salt = HashService.newSalt();
    await (_database.update(
      _database.accounts,
    )..where((t) => t.id.equals(row.id))).write(
      AccountsCompanion(
        passwordSalt: d.Value(salt),
        passwordHash: d.Value(HashService.hashPassword(newPassword, salt)),
        updatedAt: d.Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<UserProfile> updateFullName(
    UserProfile profile,
    String fullName,
  ) async {
    final name = fullName.trim();
    if (name.length < 2) {
      throw const AccountValidationException('Enter your full name.');
    }

    final operation = _writer.build(
      accountId: profile.id,
      entity: SyncEntity.profile,
      entityId: profile.id,
      type: SyncOperationType.update,
      data: {
        'id': profile.id,
        'full_name': name,
        'academic_timezone': profile.academicTimezone,
        'time_format': profile.timeFormat.code,
      },
    );

    await _database.transaction(() async {
      await (_database.update(
        _database.accounts,
      )..where((t) => t.id.equals(profile.id))).write(
        AccountsCompanion(
          fullName: d.Value(name),
          updatedAt: d.Value(DateTime.now().toUtc()),
        ),
      );

      await _writer.enqueueBuilt(operation);
    });

    await _cloud.deliverNow(operation);
    return profile.copyWith(fullName: name);
  }

  Future<UserProfile> updateTimeFormat(
    UserProfile profile,
    TimeFormat format,
  ) async {
    final operation = _writer.build(
      accountId: profile.id,
      entity: SyncEntity.profile,
      entityId: profile.id,
      type: SyncOperationType.update,
      data: {
        'id': profile.id,
        'full_name': profile.fullName,
        'academic_timezone': profile.academicTimezone,
        'time_format': format.code,
      },
    );

    await _database.transaction(() async {
      await (_database.update(
        _database.accounts,
      )..where((t) => t.id.equals(profile.id))).write(
        AccountsCompanion(
          timeFormat: d.Value(format.code),
          updatedAt: d.Value(DateTime.now().toUtc()),
        ),
      );

      await _writer.enqueueBuilt(operation);
    });

    await _cloud.deliverNow(operation);
    return profile.copyWith(timeFormat: format);
  }

  /// FR-PROFILE-002: timezone changes are online-only, require every pending
  /// personal edit to be synchronized first, and abort without change on
  /// failure. Wall-clock values are preserved (DET-TZ-003).
  Future<UserProfile> changeAcademicTimezone(
    UserProfile profile,
    String timezone,
  ) async {
    final pending = await pendingOperationCount(profile.id);
    if (pending > 0) {
      throw const AccountSyncRequiredException(
        'Synchronize all pending edits before changing your academic '
        'timezone.',
      );
    }

    if (_gateway.isConfigured) {
      await _gateway.changeAcademicTimezone(
        accountId: profile.id,
        timezone: timezone,
      );
    }

    await _database.transaction(() async {
      await (_database.update(
        _database.accounts,
      )..where((t) => t.id.equals(profile.id))).write(
        AccountsCompanion(
          academicTimezone: d.Value(timezone),
          updatedAt: d.Value(DateTime.now().toUtc()),
        ),
      );

      await _writer.enqueue(
        accountId: profile.id,
        entity: SyncEntity.profile,
        entityId: profile.id,
        type: SyncOperationType.update,
        data: {
          'id': profile.id,
          'full_name': profile.fullName,
          'academic_timezone': timezone,
          'time_format': profile.timeFormat.code,
        },
      );
    });

    return profile.copyWith(academicTimezone: timezone);
  }

  Future<int> pendingOperationCount(String accountId) async {
    final count = _database.pendingOperations.operationId.count();
    final query = _database.selectOnly(_database.pendingOperations)
      ..addColumns([count])
      ..where(_database.pendingOperations.accountId.equals(accountId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> syncAndLogout(
    String accountId, {
    required Future<bool> Function() sync,
  }) async {
    final ok = await sync();
    if (!ok) {
      throw const AccountSyncRequiredException(
        'Sync did not complete. Choose Discard & Logout to continue, or '
        'cancel and retry.',
      );
    }
    await performLogout(accountId);
  }

  Future<void> discardAndLogout(String accountId) async {
    final pending = await (_database.select(
      _database.pendingOperations,
    )..where((t) => t.accountId.equals(accountId))).get();

    for (final op in pending) {
      await _writer.markRecordStatus(
        entity: SyncEntity.values.firstWhere(
          (entity) => entity.code == op.entity,
          orElse: () => SyncEntity.profile,
        ),
        entityId: op.entityId,
        status: SyncStatus.discarded,
      );
    }

    await (_database.delete(
      _database.pendingOperations,
    )..where((t) => t.accountId.equals(accountId))).go();

    await performLogout(accountId);
  }

  /// Clears session credentials. The local-only build retains the planner
  /// records so the account can be reopened; production clears the account
  /// encryption key and managed database files (SEC-013).
  Future<void> performLogout(String accountId) async {
    await _settings.clearSession();
  }

  Future<void> _deleteAccountEverywhere(String accountId) async {
    await _database.clearAccountPersonalData(accountId);
    await _keyService.deleteAllForAccount(accountId);
    await (_database.delete(
      _database.accounts,
    )..where((t) => t.id.equals(accountId))).go();
    await _settings.clearSession();
  }

  Future<void> deleteAccount(String accountId) =>
      _deleteAccountEverywhere(accountId);

  Future<AccountRow?> _accountById(String id) {
    return (_database.select(
      _database.accounts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  UserProfile _map(AccountRow row) {
    return UserProfile(
      id: row.id,
      fullName: row.fullName,
      email: row.email,
      role: UserRole.fromCode(row.role),
      academicTimezone: row.academicTimezone,
      timeFormat: TimeFormat.fromCode(row.timeFormat),
      emailVerified: row.emailVerified,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}

class AccountValidationException implements Exception {
  const AccountValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AccountAuthException implements Exception {
  const AccountAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AccountSyncRequiredException implements Exception {
  const AccountSyncRequiredException(this.message);

  final String message;

  @override
  String toString() => message;
}
