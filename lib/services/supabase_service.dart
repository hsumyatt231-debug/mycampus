import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper that initializes Supabase only when both environment values
/// are supplied. The publishable (anon) key is the only client credential;
/// the service-role key is never shipped (SEC-012).
class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  SupabaseClient? _client;

  bool get isConfigured => _client != null;

  String? get currentUserId => _client?.auth.currentUser?.id;

  SupabaseClient get client {
    final value = _client;
    if (value == null) {
      throw const CloudNotConfiguredException();
    }
    return value;
  }

  Future<void> initialize() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

    if (url.isEmpty || key.isEmpty) return;
    if (_client != null) return;

    await Supabase.initialize(url: url, publishableKey: key);
    _client = Supabase.instance.client;
  }
}

class CloudNotConfiguredException implements Exception {
  const CloudNotConfiguredException([
    this.message = 'Supabase is not configured for this build.',
  ]);

  final String message;

  @override
  String toString() => message;
}
