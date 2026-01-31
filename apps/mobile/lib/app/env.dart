import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    // Safe default: assets/.env is optional and should not be committed.
    // We fall back to assets/.env.example (committed, no secrets).
    try {
      await dotenv.load(fileName: 'assets/.env');
      return;
    } catch (_) {
      // ignore
    }

    try {
      await dotenv.load(fileName: 'assets/.env.example');
    } catch (_) {
      // ignore
    }
  }

  static String get agoraAppId => dotenv.env['AGORA_APP_ID'] ?? '';
  static String get naverMapClientId => dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '';
  static String get kakaoClientId => dotenv.env['KAKAO_CLIENT_ID'] ?? '';
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}

