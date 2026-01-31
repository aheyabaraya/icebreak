import 'dart:math';

import 'enums.dart';
import 'models.dart';
import 'repository.dart';

class FakeRepo implements ContractRepository {
  FakeRepo({this.currentUserId = 'user_demo'}) {
    _seed();
  }

  final String currentUserId;
  final List<Post> _posts = [];
  final List<CallSession> _sessions = [];
  final List<Photo> _photos = [];
  final List<Memo> _memos = [];

  void _seed() {
    if (_posts.isNotEmpty) return;
    _posts.addAll([
      Post(
        id: _id('post'),
        title: 'Coffee at River Park',
        intro: 'Quick hello by the fountain.',
        hostId: 'host_alex',
        groupId: null,
        pinLat: 37.564,
        pinLng: 126.978,
        isSpecial: false,
        previewPhotoPath: null,
        status: PostStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        expiresAt: DateTime.now().add(const Duration(hours: 6)),
        distanceM: 120,
      ),
      Post(
        id: _id('post'),
        title: 'Gallery walk',
        intro: 'Looking for a +1 for the modern wing.',
        hostId: 'host_jin',
        groupId: null,
        pinLat: 37.565,
        pinLng: 126.976,
        isSpecial: true,
        previewPhotoPath: null,
        status: PostStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
        distanceM: 240,
      ),
    ]);
  }

  String _id(String prefix) => '${prefix}_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}';

  @override
  Future<List<Post>> getNearbyPosts({required double lat, required double lng, int radiusM = 500}) async {
    return _posts.where((post) => post.status == PostStatus.open).toList();
  }

  @override
  Future<Post> createPost(CreatePostInput input) async {
    final post = Post(
      id: _id('post'),
      title: input.title,
      intro: input.intro,
      hostId: currentUserId,
      groupId: input.groupId,
      pinLat: input.pinLat,
      pinLng: input.pinLng,
      isSpecial: input.isSpecial,
      previewPhotoPath: input.previewPhotoPath,
      status: PostStatus.open,
      createdAt: DateTime.now(),
      expiresAt: input.expiresAt ?? DateTime.now().add(const Duration(hours: 6)),
    );
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<CallSession> requestCall(String postId) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    final session = CallSession(
      id: _id('session'),
      postId: post.id,
      hostId: post.hostId,
      joinerId: currentUserId,
      status: CallStatus.ringing,
      ringStartedAt: DateTime.now(),
      connectedAt: null,
      endedAt: null,
      passType: post.isSpecial ? 'special' : 'normal',
      reasonFlags: const {},
      meetDecisionHost: MeetDecision.pending,
      meetDecisionJoiner: MeetDecision.pending,
      arrivalStatus: ArrivalStatus.pending,
      arrivalCountdownStartedAt: null,
      arrivalConfirmedAt: null,
      arrivalTimeoutAt: null,
      outcome: null,
    );
    _sessions.add(session);
    return session;
  }

  @override
  Future<CallSession> acceptCall(String sessionId) async {
    return _updateSession(sessionId, (session) {
      return CallSession(
        id: session.id,
        postId: session.postId,
        hostId: session.hostId,
        joinerId: session.joinerId,
        status: CallStatus.connected,
        ringStartedAt: session.ringStartedAt,
        connectedAt: DateTime.now(),
        endedAt: session.endedAt,
        passType: session.passType,
        reasonFlags: session.reasonFlags,
        meetDecisionHost: session.meetDecisionHost,
        meetDecisionJoiner: session.meetDecisionJoiner,
        arrivalStatus: session.arrivalStatus,
        arrivalCountdownStartedAt: session.arrivalCountdownStartedAt,
        arrivalConfirmedAt: session.arrivalConfirmedAt,
        arrivalTimeoutAt: session.arrivalTimeoutAt,
        outcome: session.outcome,
      );
    });
  }

  @override
  Future<CallSession> endCall(String sessionId, {Map<String, dynamic> reasonFlags = const {}}) async {
    return _updateSession(sessionId, (session) {
      return CallSession(
        id: session.id,
        postId: session.postId,
        hostId: session.hostId,
        joinerId: session.joinerId,
        status: CallStatus.ended,
        ringStartedAt: session.ringStartedAt,
        connectedAt: session.connectedAt,
        endedAt: DateTime.now(),
        passType: session.passType,
        reasonFlags: {...session.reasonFlags, ...reasonFlags},
        meetDecisionHost: session.meetDecisionHost,
        meetDecisionJoiner: session.meetDecisionJoiner,
        arrivalStatus: session.arrivalStatus,
        arrivalCountdownStartedAt: session.arrivalCountdownStartedAt,
        arrivalConfirmedAt: session.arrivalConfirmedAt,
        arrivalTimeoutAt: session.arrivalTimeoutAt,
        outcome: session.outcome,
      );
    });
  }

  @override
  Future<Photo> submitNormalPhoto(String sessionId, String path) async {
    final photo = Photo(
      id: _id('photo'),
      sessionId: sessionId,
      uploaderId: currentUserId,
      storagePath: path,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      viewedAt: null,
    );
    _photos.add(photo);
    return photo;
  }

  @override
  Future<String> viewPhoto(String sessionId) async {
    final photo = _photos.lastWhere((p) => p.sessionId == sessionId);
    final updated = Photo(
      id: photo.id,
      sessionId: photo.sessionId,
      uploaderId: photo.uploaderId,
      storagePath: photo.storagePath,
      expiresAt: photo.expiresAt,
      viewedAt: DateTime.now(),
    );
    _photos[_photos.indexOf(photo)] = updated;
    return updated.storagePath;
  }

  @override
  Future<CallSession> meetDecision(String sessionId, bool decision) async {
    return _updateSession(sessionId, (session) {
      final value = decision ? MeetDecision.yes : MeetDecision.no;
      return CallSession(
        id: session.id,
        postId: session.postId,
        hostId: session.hostId,
        joinerId: session.joinerId,
        status: session.status,
        ringStartedAt: session.ringStartedAt,
        connectedAt: session.connectedAt,
        endedAt: session.endedAt,
        passType: session.passType,
        reasonFlags: session.reasonFlags,
        meetDecisionHost: value,
        meetDecisionJoiner: value,
        arrivalStatus: session.arrivalStatus,
        arrivalCountdownStartedAt: session.arrivalCountdownStartedAt,
        arrivalConfirmedAt: session.arrivalConfirmedAt,
        arrivalTimeoutAt: session.arrivalTimeoutAt,
        outcome: session.outcome,
      );
    });
  }

  @override
  Future<CallSession> startCountdown(String sessionId) async {
    return _updateSession(sessionId, (session) {
      return CallSession(
        id: session.id,
        postId: session.postId,
        hostId: session.hostId,
        joinerId: session.joinerId,
        status: session.status,
        ringStartedAt: session.ringStartedAt,
        connectedAt: session.connectedAt,
        endedAt: session.endedAt,
        passType: session.passType,
        reasonFlags: session.reasonFlags,
        meetDecisionHost: session.meetDecisionHost,
        meetDecisionJoiner: session.meetDecisionJoiner,
        arrivalStatus: ArrivalStatus.pending,
        arrivalCountdownStartedAt: DateTime.now(),
        arrivalConfirmedAt: session.arrivalConfirmedAt,
        arrivalTimeoutAt: session.arrivalTimeoutAt,
        outcome: session.outcome,
      );
    });
  }

  @override
  Future<CallSession> recordOutcome(String sessionId, String outcome) async {
    return _updateSession(sessionId, (session) {
      return CallSession(
        id: session.id,
        postId: session.postId,
        hostId: session.hostId,
        joinerId: session.joinerId,
        status: session.status,
        ringStartedAt: session.ringStartedAt,
        connectedAt: session.connectedAt,
        endedAt: session.endedAt,
        passType: session.passType,
        reasonFlags: session.reasonFlags,
        meetDecisionHost: session.meetDecisionHost,
        meetDecisionJoiner: session.meetDecisionJoiner,
        arrivalStatus: session.arrivalStatus,
        arrivalCountdownStartedAt: session.arrivalCountdownStartedAt,
        arrivalConfirmedAt: session.arrivalConfirmedAt,
        arrivalTimeoutAt: session.arrivalTimeoutAt,
        outcome: outcome,
      );
    });
  }

  @override
  Future<Memo> sendMissedCallMemo(String sessionId, String text) async {
    final memo = Memo(
      id: _id('memo'),
      sessionId: sessionId,
      authorId: currentUserId,
      targetId: 'target_user',
      text: text,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
    _memos.add(memo);
    return memo;
  }

  CallSession _updateSession(String sessionId, CallSession Function(CallSession) mapper) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index == -1) {
      throw StateError('Session not found');
    }
    final updated = mapper(_sessions[index]);
    _sessions[index] = updated;
    return updated;
  }
}
