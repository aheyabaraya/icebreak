import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app/env.dart';
import 'app/services/agora_stub.dart';
import 'app/services/iap_stub.dart';
import 'app/services/kakao_stub.dart';
import 'app/services/naver_map_stub.dart';
import 'app/services/supabase_stub.dart';

final _log = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.load();
  await SupabaseStub.initialize();

  // Optional vendor SDK init (safe no-op if keys are missing).
  await NaverMapService.initialize(clientId: Env.naverMapClientId);
  final kakao = KakaoStub(logger: _log)..initialize(nativeAppKey: Env.kakaoClientId);
  await AgoraStub(logger: _log).initialize(appId: Env.agoraAppId);
  await IapStub(logger: _log).queryProducts(const {});
  await kakao.login();

  runApp(const IcebreakApp());
}

class IcebreakApp extends StatelessWidget {
  const IcebreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icebreak',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final missing = <String>[];
    if (Env.agoraAppId.isEmpty) missing.add('AGORA_APP_ID');
    if (Env.naverMapClientId.isEmpty) missing.add('NAVER_MAP_CLIENT_ID');
    if (Env.kakaoClientId.isEmpty) missing.add('KAKAO_CLIENT_ID');
    if (Env.supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (Env.supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');

    return Scaffold(
      appBar: AppBar(title: const Text('Icebreak Mobile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Setup status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(missing.isEmpty ? 'All env vars present.' : 'Missing env vars: ${missing.join(', ')}'),
            const SizedBox(height: 24),
            const Expanded(child: NaverMapStub()),
          ],
        ),
      ),
    );
  }
}
