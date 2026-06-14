import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'session_timeline_event.freezed.dart';
part 'session_timeline_event.g.dart';

/// Append-only operational timeline on a [DineInSession]. DATA_MODEL §3.10.
@freezed
abstract class SessionTimelineEvent with _$SessionTimelineEvent {
  const factory SessionTimelineEvent({
    required String id,
    required String sessionId,
    required SessionTimelineEventType eventType,
    @Default({}) Map<String, dynamic> payloadJson,
    required ActorType actorType,
    String? actorId,
    required DateTime occurredAt,
  }) = _SessionTimelineEvent;

  factory SessionTimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$SessionTimelineEventFromJson(json);
}
