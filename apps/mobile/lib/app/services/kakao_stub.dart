import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';

class KakaoStub {
  KakaoStub({Logger? logger}) : _log = logger ?? Logger();

  final Logger _log;
  bool _initialized = false;

  void initialize({required String nativeAppKey}) {
    if (nativeAppKey.trim().isEmpty) {
      _log.w('Kakao not initialized: KAKAO_CLIENT_ID is missing. (stub no-op)');
      return;
    }

    // TODO: set real native app key from Kakao developer console.
    KakaoSdk.init(nativeAppKey: nativeAppKey);
    _initialized = true;
    _log.i('Kakao SDK initialized (stub).');
  }

  Future<void> login() async {
    if (!_initialized) {
      _log.w('Kakao login skipped: SDK not initialized.');
      return;
    }

    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      _log.i('Kakao login succeeded (stub).');
    } catch (e, st) {
      _log.e('Kakao login failed (stub).', error: e, stackTrace: st);
    }
  }
}

