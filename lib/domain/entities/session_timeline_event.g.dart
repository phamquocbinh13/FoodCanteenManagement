// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_timeline_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionTimelineEvent _$SessionTimelineEventFromJson(
  Map<String, dynamic> json,
) => _SessionTimelineEvent(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  eventType: $enumDecode(_$SessionTimelineEventTypeEnumMap, json['event_type']),
  payloadJson: json['payload_json'] as Map<String, dynamic>? ?? const {},
  actorType: $enumDecode(_$ActorTypeEnumMap, json['actor_type']),
  actorId: json['actor_id'] as String?,
  occurredAt: DateTime.parse(json['occurred_at'] as String),
);

Map<String, dynamic> _$SessionTimelineEventToJson(
  _SessionTimelineEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'event_type': _$SessionTimelineEventTypeEnumMap[instance.eventType]!,
  'payload_json': instance.payloadJson,
  'actor_type': _$ActorTypeEnumMap[instance.actorType]!,
  'actor_id': instance.actorId,
  'occurred_at': instance.occurredAt.toIso8601String(),
};

const _$SessionTimelineEventTypeEnumMap = {
  SessionTimelineEventType.sessionOpened: 'session_opened',
  SessionTimelineEventType.deviceJoined: 'device_joined',
  SessionTimelineEventType.cartItemAdded: 'cart_item_added',
  SessionTimelineEventType.cartItemRemoved: 'cart_item_removed',
  SessionTimelineEventType.batchConfirmed: 'batch_confirmed',
  SessionTimelineEventType.staffRequestCreated: 'staff_request_created',
  SessionTimelineEventType.staffRequestHandled: 'staff_request_handled',
  SessionTimelineEventType.paymentRequested: 'payment_requested',
  SessionTimelineEventType.paymentClosed: 'payment_closed',
  SessionTimelineEventType.sessionForceClosed: 'session_force_closed',
};

const _$ActorTypeEnumMap = {
  ActorType.user: 'user',
  ActorType.customerSession: 'customer_session',
  ActorType.system: 'system',
};
