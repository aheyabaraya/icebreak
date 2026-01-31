import 'models.dart';

abstract class ContractRepository {
  Future<List<Post>> getNearbyPosts({required double lat, required double lng, int radiusM = 500});
  Future<Post> createPost(CreatePostInput input);
  Future<CallSession> requestCall(String postId);
  Future<CallSession> acceptCall(String sessionId);
  Future<CallSession> endCall(String sessionId, {Map<String, dynamic> reasonFlags = const {}});
  Future<Photo> submitNormalPhoto(String sessionId, String path);
  Future<String> viewPhoto(String sessionId);
  Future<CallSession> meetDecision(String sessionId, bool decision);
  Future<CallSession> startCountdown(String sessionId);
  Future<CallSession> recordOutcome(String sessionId, String outcome);
  Future<Memo> sendMissedCallMemo(String sessionId, String text);
}
