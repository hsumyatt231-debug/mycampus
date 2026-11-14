import 'dart:convert';
import 'dart:math';

import '../services/local_database.dart';

/// Per-account database key handling.
///
/// TV-01/TV-02/TV-03 remain open: SQLCipher-compatible Drift packaging and
/// Android Keystore / Windows DPAPI key release are not verified in this
/// build, so keys are generated and tracked but the database is not yet
/// encrypted at rest. The abstraction keeps call sites stable for the
/// verified native implementation.
class EncryptionKeyService {
  EncryptionKeyService(this._database);

  final LocalDatabase _database;
  final _random = Random.secure();

  static const String _keyPrefix = 'db_key_';

  Future<String> keyForAccount(String accountId) async {
    final existing = await _read(_keyPrefix + accountId);
    if (existing != null && existing.isNotEmpty) return existing;

    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    final key = base64UrlEncode(bytes);
    await _write(_keyPrefix + accountId, key);
    return key;
  }

  Future<void> deleteKeyForAccount(String accountId) async {
    await (_database.delete(
      _database.appSettings,
    )..where((t) => t.key.equals(_keyPrefix + accountId))).go();
  }

  Future<String?> _read(String key) async {
    final row = await (_database.select(
      _database.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> _write(String key, String value) async {
    await _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> persistKeyReference({
    required String accountId,
    required String backend,
  }) async {
    await _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: 'db_key_backend_$accountId',
            value: backend,
          ),
        );
  }

  Future<void> markKeyAvailable(String accountId) async {
    final key = await _read(_keyPrefix + accountId);
    await _write(
      'db_key_state_$accountId',
      key == null ? 'missing' : 'available',
    );
  }

  Future<bool> hasKey(String accountId) async {
    final key = await _read(_keyPrefix + accountId);
    return key != null && key.isNotEmpty;
  }

  /// Explicit recovery state; a missing key must never silently regenerate a
  /// database (SEC-014).
  Future<bool> consumeRecoveryNotice(String accountId) async {
    final flagKey = 'db_key_recovery_$accountId';
    final current = await _read(flagKey);
    if (current == 'pending') {
      await _write(flagKey, 'shown');
      return true;
    }
    return false;
  }

  Future<void> flagRecoveryNotice(String accountId) async {
    await _write('db_key_recovery_$accountId', 'pending');
  }

  Future<void> storeValue(String key, String value) async {
    await _write(key, value);
  }

  Future<String?> readValue(String key) => _read(key);

  Future<void> removeValue(String key) async {
    await (_database.delete(
      _database.appSettings,
    )..where((t) => t.key.equals(key))).go();
  }

  Future<void> putJson(String key, Map<String, dynamic> value) async {
    await storeValue(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    final raw = await readValue(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Kept for API symmetry with the future encrypted store.
  Future<void> deleteAllForAccount(String accountId) async {
    await deleteKeyForAccount(accountId);
    for (final suffix in [
      'db_key_backend_',
      'db_key_state_',
      'db_key_recovery_',
    ]) {
      await removeValue('$suffix$accountId');
    }
  }
}
