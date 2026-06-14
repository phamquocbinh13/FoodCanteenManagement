// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roms_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RomsOrder _$RomsOrderFromJson(Map<String, dynamic> json) => _RomsOrder(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  orderNumber: (json['order_number'] as num).toInt(),
  orderType: $enumDecode(_$OrderTypeEnumMap, json['order_type']),
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.draft,
  customerName: json['customer_name'] as String?,
  customerPhone: _$JsonConverterFromJson<String, PhoneNumber>(
    json['customer_phone'],
    const PhoneNumberConverter().fromJson,
  ),
  notes: json['notes'] as String?,
  createdByUserId: json['created_by_user_id'] as String,
  submittedAt: json['submitted_at'] == null
      ? null
      : DateTime.parse(json['submitted_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RomsOrderToJson(_RomsOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'order_number': instance.orderNumber,
      'order_type': _$OrderTypeEnumMap[instance.orderType]!,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'customer_name': instance.customerName,
      'customer_phone': _$JsonConverterToJson<String, PhoneNumber>(
        instance.customerPhone,
        const PhoneNumberConverter().toJson,
      ),
      'notes': instance.notes,
      'created_by_user_id': instance.createdByUserId,
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$OrderTypeEnumMap = {
  OrderType.takeaway: 'takeaway',
  OrderType.delivery: 'delivery',
};

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.submitted: 'submitted',
  OrderStatus.inProgress: 'in_progress',
  OrderStatus.ready: 'ready',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
