// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KitchenBatch _$KitchenBatchFromJson(Map<String, dynamic> json) =>
    _KitchenBatch(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      sessionId: json['session_id'] as String?,
      orderId: json['order_id'] as String?,
      batchNumber: (json['batch_number'] as num).toInt(),
      confirmedAt: DateTime.parse(json['confirmed_at'] as String),
      confirmedByActorType: $enumDecode(
        _$ActorTypeEnumMap,
        json['confirmed_by_actor_type'],
      ),
      confirmedByActorId: json['confirmed_by_actor_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$KitchenBatchToJson(
  _KitchenBatch instance,
) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurantId,
  'session_id': instance.sessionId,
  'order_id': instance.orderId,
  'batch_number': instance.batchNumber,
  'confirmed_at': instance.confirmedAt.toIso8601String(),
  'confirmed_by_actor_type': _$ActorTypeEnumMap[instance.confirmedByActorType]!,
  'confirmed_by_actor_id': instance.confirmedByActorId,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$ActorTypeEnumMap = {
  ActorType.user: 'user',
  ActorType.customerSession: 'customer_session',
  ActorType.system: 'system',
};
