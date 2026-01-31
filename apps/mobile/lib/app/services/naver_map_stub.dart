import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:logger/logger.dart';

class NaverMapService {
  static final Logger _log = Logger();
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize({required String clientId}) async {
    if (clientId.trim().isEmpty) {
      _log.w('Naver Map not initialized: NAVER_MAP_CLIENT_ID is missing.');
      return;
    }

    if (_initialized) return;
    await FlutterNaverMap().init(clientId: clientId);
    _initialized = true;
    _log.i('Naver Map SDK initialized (stub).');
  }
}

class NaverMapStub extends StatelessWidget {
  const NaverMapStub({super.key});

  @override
  Widget build(BuildContext context) {
    if (!NaverMapService.isInitialized) {
      return const Center(
        child: Text('Naver Map not initialized (set NAVER_MAP_CLIENT_ID).'),
      );
    }

    // TODO: replace with real map screen configuration.
    return const NaverMap();
  }
}
