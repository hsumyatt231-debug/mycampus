import '../services/local_database.dart';

/// Small account-scoped key/value store (session marker, UI preferences,
/// recovery flags).
class SettingsRepository {
  SettingsRepository(this._database);

  static const String sessionAccountKey = 'session_account_id';
  static const String lastRouteKey = 'last_route';
  static const String foregroundUnlockKey = 'require_unlock_on_start';

  final LocalDatabase _database;

  Future<String?> read(String key) async {
    final row = await (_database.select(
      _database.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) async {
    await _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> remove(String key) async {
    await (_database.delete(
      _database.appSettings,
    )..where((t) => t.key.equals(key))).go();
  }

  Future<int> getInt(String key, {int fallback = 0}) async {
    final value = await read(key);
    return int.tryParse(value ?? '') ?? fallback;
  }

  Future<void> setInt(String key, int value) => write(key, value.toString());

  Future<bool> getBool(String key, {bool fallback = false}) async {
    final value = await read(key);
    if (value == null) return fallback;
    return value == 'true';
  }

  Future<void> setBool(String key, bool value) => write(key, value.toString());

  Future<void> clearSession() => remove(sessionAccountKey);

  Future<String?> sessionAccountId() => read(sessionAccountKey);

  Future<void> setSessionAccount(String accountId) =>
      write(sessionAccountKey, accountId);
}
