// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffRequest _$StaffRequestFromJson(Map<String, dynamic> json) =>
    _StaffRequest(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      sessionId: json['session_id'] as String,
      requestType: $enumDecode(_$RequestTypeEnumMap, json['request_type']),
      status:
          $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.pending,
      note: json['note'] as String?,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      handledAt: json['handled_at'] == null
          ? null
          : DateTime.parse(json['handled_at'] as String),
      handledByUserId: json['handled_by_user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StaffRequestToJson(_StaffRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'session_id': instance.sessionId,
      'request_type': _$RequestTypeEnumMap[instance.requestType]!,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'note': instance.note,
      'requested_at': instance.requestedAt.toIso8601String(),
      'handled_at': instance.handledAt?.toIso8601String(),
      'handled_by_user_id': instance.handledByUserId,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$RequestTypeEnumMap = {
  RequestType.payment: 'payment',
  RequestType.staffAssistance: 'staff_assistance',
  RequestType.extraWater: 'extra_water',
  RequestType.extraBowl: 'extra_bowl',
  RequestType.extraSpoon: 'extra_spoon',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.handled: 'handled',
  RequestStatus.cancelled: 'cancelled',
};
