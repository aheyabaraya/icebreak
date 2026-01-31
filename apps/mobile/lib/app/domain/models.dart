import 'enums.dart';

class Post {
  Post({
    required this.id,
    required this.title,
    this.intro,
    required this.hostId,
    this.groupId,
    required this.pinLat,
    required this.pinLng,
    required this.isSpecial,
    this.previewPhotoPath,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    this.distanceM,
  });

  final String id;
  final String title;
  final String? intro;
  final String hostId;
  final String? groupId;
  final double pinLat;
  final double pinLng;
  final bool isSpecial;
  final String? previewPhotoPath;
  final PostStatus status;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final double? distanceM;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      intro: json['intro'] as String?,
      hostId: json['host_id'] as String,
      groupId: json['group_id'] as String?,
      pinLat: (json['pin_lat'] as num).toDouble(),
      pinLng: (json['pin_lng'] as num).toDouble(),
      isSpecial: json['is_special'] as bool? ?? false,
      previewPhotoPath: json['preview_photo_path'] as String?,
      status: enumFromApiValue(PostStatus.values, json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] == null ? null : DateTime.parse(json['expires_at'] as String),
      distanceM: json['distance_m'] == null ? null : (json['distance_m'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'intro': intro,
      'host_id': hostId,
      'group_id': groupId,
      'pin_lat': pinLat,
      'pin_lng': pinLng,
      'is_special': isSpecial,
      'preview_photo_path': previewPhotoPath,
      'status': enumToApiValue(status),
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}

class CallSession {
  CallSession({
    required this.id,
    required this.postId,
    required this.hostId,
    required this.joinerId,
    required this.status,
    required this.ringStartedAt,
    this.connectedAt,
    this.endedAt,
    required this.passType,
    required this.reasonFlags,
    required this.meetDecisionHost,
    required this.meetDecisionJoiner,
    required this.arrivalStatus,
    this.arrivalCountdownStartedAt,
    this.arrivalConfirmedAt,
    this.arrivalTimeoutAt,
    this.outcome,
  });

  final String id;
  final String postId;
  final String hostId;
  final String joinerId;
  final CallStatus status;
  final DateTime ringStartedAt;
  final DateTime? connectedAt;
  final DateTime? endedAt;
  final String passType;
  final Map<String, dynamic> reasonFlags;
  final MeetDecision meetDecisionHost;
  final MeetDecision meetDecisionJoiner;
  final ArrivalStatus arrivalStatus;
  final DateTime? arrivalCountdownStartedAt;
  final DateTime? arrivalConfirmedAt;
  final DateTime? arrivalTimeoutAt;
  final String? outcome;

  factory CallSession.fromJson(Map<String, dynamic> json) {
    return CallSession(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      hostId: json['host_id'] as String,
      joinerId: json['joiner_id'] as String,
      status: enumFromApiValue(CallStatus.values, json['status'] as String),
      ringStartedAt: DateTime.parse(json['ring_started_at'] as String),
      connectedAt: json['connected_at'] == null ? null : DateTime.parse(json['connected_at'] as String),
      endedAt: json['ended_at'] == null ? null : DateTime.parse(json['ended_at'] as String),
      passType: json['pass_type'] as String,
      reasonFlags: (json['reason_flags'] as Map?)?.cast<String, dynamic>() ?? {},
      meetDecisionHost: enumFromApiValue(MeetDecision.values, json['meet_decision_host'] as String),
      meetDecisionJoiner: enumFromApiValue(MeetDecision.values, json['meet_decision_joiner'] as String),
      arrivalStatus: enumFromApiValue(ArrivalStatus.values, json['arrival_status'] as String),
      arrivalCountdownStartedAt: json['arrival_countdown_started_at'] == null
          ? null
          : DateTime.parse(json['arrival_countdown_started_at'] as String),
      arrivalConfirmedAt:
          json['arrival_confirmed_at'] == null ? null : DateTime.parse(json['arrival_confirmed_at'] as String),
      arrivalTimeoutAt:
          json['arrival_timeout_at'] == null ? null : DateTime.parse(json['arrival_timeout_at'] as String),
      outcome: json['outcome'] as String?,
    );
  }
}

class Photo {
  Photo({
    required this.id,
    required this.sessionId,
    required this.uploaderId,
    required this.storagePath,
    required this.expiresAt,
    this.viewedAt,
  });

  final String id;
  final String sessionId;
  final String uploaderId;
  final String storagePath;
  final DateTime expiresAt;
  final DateTime? viewedAt;

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      uploaderId: json['uploader_id'] as String,
      storagePath: json['storage_path'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      viewedAt: json['viewed_at'] == null ? null : DateTime.parse(json['viewed_at'] as String),
    );
  }
}

class Memo {
  Memo({
    required this.id,
    required this.sessionId,
    required this.authorId,
    required this.targetId,
    required this.text,
    required this.expiresAt,
  });

  final String id;
  final String sessionId;
  final String authorId;
  final String targetId;
  final String text;
  final DateTime expiresAt;

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      authorId: json['author_id'] as String,
      targetId: json['target_id'] as String,
      text: json['text'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }
}

class CreatePostInput {
  CreatePostInput({
    required this.title,
    this.intro,
    required this.pinLat,
    required this.pinLng,
    this.groupId,
    this.isSpecial = false,
    this.previewPhotoPath,
    this.expiresAt,
  });

  final String title;
  final String? intro;
  final double pinLat;
  final double pinLng;
  final String? groupId;
  final bool isSpecial;
  final String? previewPhotoPath;
  final DateTime? expiresAt;
}
