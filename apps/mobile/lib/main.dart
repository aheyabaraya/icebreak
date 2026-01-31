import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app/domain/fake_repo.dart';
import 'app/domain/repo_scope.dart';
import 'app/domain/supabase_repo.dart';
import 'app/env.dart';
import 'app/screens/home_screen.dart';
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
    final repo = SupabaseStub.isInitialized ? SupabaseRepo() : FakeRepo();

    return MaterialApp(
      title: 'Icebreak',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: RepoScope(
        repo: repo,
        child: const HomeScreen(),
      ),
    );
  }
}
