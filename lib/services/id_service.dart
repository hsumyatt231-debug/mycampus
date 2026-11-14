import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

abstract final class IdService {
  static String newId() => _uuid.v4();
}

abstract final class HashService {
  /// Salted password digest for local-only accounts. Production deployments
  /// use Supabase Auth; this never leaves the device and is never logged.
  static String hashPassword(String password, String salt) {
    return sha256.convert(utf8.encode('$salt::$password')).toString();
  }

  static String newSalt() => _uuid.v4() + _uuid.v4();

  /// Stable payload fingerprint used for push idempotency (FR-SYNC-002).
  static String fingerprint(Map<String, dynamic> payload) {
    return sha256.convert(utf8.encode(canonicalJson(payload))).toString();
  }

  /// Deterministic JSON with sorted keys.
  static String canonicalJson(Object? value) {
    return jsonEncode(_canonical(value));
  }

  static Object? _canonical(Object? value) {
    if (value is Map) {
      final keys = value.keys.map((key) => key.toString()).toList()..sort();
      return {for (final key in keys) key: _canonical(value[key])};
    }
    if (value is Iterable) {
      return value.map(_canonical).toList();
    }
    return value;
  }
}
