import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:logger/logger.dart';

class AgoraStub {
  AgoraStub({Logger? logger}) : _log = logger ?? Logger();

  final Logger _log;
  RtcEngine? _engine;

  Future<void> initialize({required String appId}) async {
    if (appId.trim().isEmpty) {
      _log.w('Agora not initialized: AGORA_APP_ID is missing. (stub no-op)');
      return;
    }

    _engine ??= createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));

    // TODO: join channel / request permissions / set event handlers.
    _log.i('Agora initialized (stub).');
  }

  Future<void> dispose() async {
    await _engine?.release();
    _engine = null;
  }
}

