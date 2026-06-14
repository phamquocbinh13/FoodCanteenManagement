// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryDetail _$DeliveryDetailFromJson(Map<String, dynamic> json) =>
    _DeliveryDetail(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      deliveryStatus:
          $enumDecodeNullable(
            _$DeliveryStatusEnumMap,
            json['delivery_status'],
          ) ??
          DeliveryStatus.pending,
      deliveryAddress: json['delivery_address'] as String,
      deliveryNotes: json['delivery_notes'] as String?,
      shipperUserId: json['shipper_user_id'] as String?,
      readyAt: json['ready_at'] == null
          ? null
          : DateTime.parse(json['ready_at'] as String),
      claimedAt: json['claimed_at'] == null
          ? null
          : DateTime.parse(json['claimed_at'] as String),
      deliveringAt: json['delivering_at'] == null
          ? null
          : DateTime.parse(json['delivering_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DeliveryDetailToJson(_DeliveryDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'delivery_status': _$DeliveryStatusEnumMap[instance.deliveryStatus]!,
      'delivery_address': instance.deliveryAddress,
      'delivery_notes': instance.deliveryNotes,
      'shipper_user_id': instance.shipperUserId,
      'ready_at': instance.readyAt?.toIso8601String(),
      'claimed_at': instance.claimedAt?.toIso8601String(),
      'delivering_at': instance.deliveringAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.ready: 'ready',
  DeliveryStatus.claimed: 'claimed',
  DeliveryStatus.delivering: 'delivering',
  DeliveryStatus.completed: 'completed',
  DeliveryStatus.unassigned: 'unassigned',
};
