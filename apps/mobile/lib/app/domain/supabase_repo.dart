import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';
import 'repository.dart';

class SupabaseRepo implements ContractRepository {
  SupabaseRepo({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Post>> getNearbyPosts({required double lat, required double lng, int radiusM = 500}) async {
    final data = await _client.rpc('get_nearby_posts', params: {
      'in_lat': lat,
      'in_lng': lng,
      'radius_m': radiusM,
    });

    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map(Post.fromJson).toList();
  }

  @override
  Future<Post> createPost(CreatePostInput input) async {
    final data = await _client.rpc('create_post', params: {
      'in_title': input.title,
      'in_intro': input.intro,
      'in_pin_lat': input.pinLat,
      'in_pin_lng': input.pinLng,
      'in_group_id': input.groupId,
      'in_is_special': input.isSpecial,
      'in_preview_photo_path': input.previewPhotoPath,
      'in_expires_at': input.expiresAt?.toIso8601String(),
    });

    return Post.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<CallSession> requestCall(String postId) async {
    final data = await _client.rpc('request_call', params: {
      'in_post_id': postId,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<CallSession> acceptCall(String sessionId) async {
    final data = await _client.rpc('accept_call', params: {
      'in_session_id': sessionId,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<CallSession> endCall(String sessionId, {Map<String, dynamic> reasonFlags = const {}}) async {
    final data = await _client.rpc('end_call', params: {
      'in_session_id': sessionId,
      'in_reason_flags': reasonFlags,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<Photo> submitNormalPhoto(String sessionId, String path) async {
    final data = await _client.rpc('submit_normal_photo', params: {
      'in_session_id': sessionId,
      'in_path': path,
    });
    return Photo.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<String> viewPhoto(String sessionId) async {
    final data = await _client.rpc('view_photo', params: {
      'in_session_id': sessionId,
    });
    return data as String;
  }

  @override
  Future<CallSession> meetDecision(String sessionId, bool decision) async {
    final data = await _client.rpc('meet_decision', params: {
      'in_session_id': sessionId,
      'in_decision': decision,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<CallSession> startCountdown(String sessionId) async {
    final data = await _client.rpc('start_countdown', params: {
      'in_session_id': sessionId,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<CallSession> recordOutcome(String sessionId, String outcome) async {
    final data = await _client.rpc('record_outcome', params: {
      'in_session_id': sessionId,
      'in_outcome': outcome,
    });
    return CallSession.fromJson((data as Map).cast<String, dynamic>());
  }

  @override
  Future<Memo> sendMissedCallMemo(String sessionId, String text) async {
    final data = await _client.rpc('send_missed_call_memo', params: {
      'in_session_id': sessionId,
      'in_text': text,
    });
    return Memo.fromJson((data as Map).cast<String, dynamic>());
  }
}
