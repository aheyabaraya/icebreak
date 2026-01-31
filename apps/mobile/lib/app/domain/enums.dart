// Domain enums for state machine.

enum PostStatus { open, closed }

enum CallStatus { ringing, connected, ended, missed, declined }

enum PhotoStatus { pending, done }

enum MeetDecision { pending, yes, no }

enum ArrivalStatus { pending, confirmed, timeout }

String enumToApiValue(Object value) => value.toString().split('.').last;

T enumFromApiValue<T>(List<T> values, String raw) {
  return values.firstWhere((value) => enumToApiValue(value as Object) == raw);
}
