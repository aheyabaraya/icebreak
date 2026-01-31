import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env.dart';

class SupabaseStub {
  static final Logger _log = Logger();
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;

    final url = Env.supabaseUrl;
    final anonKey = Env.supabaseAnonKey;
    if (url.trim().isEmpty || anonKey.trim().isEmpty) {
      _log.w('Supabase not initialized: SUPABASE_URL / SUPABASE_ANON_KEY missing.');
      return;
    }

    // TODO: configure auth and database usage.
    await Supabase.initialize(url: url, anonKey: anonKey);
    _initialized = true;
    _log.i('Supabase initialized (stub).');
  }
}

