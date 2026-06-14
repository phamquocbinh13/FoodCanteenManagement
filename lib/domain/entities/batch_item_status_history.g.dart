// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_item_status_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchItemStatusHistory _$BatchItemStatusHistoryFromJson(
  Map<String, dynamic> json,
) => _BatchItemStatusHistory(
  id: json['id'] as String,
  batchItemId: json['batch_item_id'] as String,
  fromStatus: $enumDecodeNullable(
    _$BatchItemStatusEnumMap,
    json['from_status'],
  ),
  toStatus: $enumDecode(_$BatchItemStatusEnumMap, json['to_status']),
  changedByUserId: json['changed_by_user_id'] as String?,
  occurredAt: DateTime.parse(json['occurred_at'] as String),
);

Map<String, dynamic> _$BatchItemStatusHistoryToJson(
  _BatchItemStatusHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'batch_item_id': instance.batchItemId,
  'from_status': _$BatchItemStatusEnumMap[instance.fromStatus],
  'to_status': _$BatchItemStatusEnumMap[instance.toStatus]!,
  'changed_by_user_id': instance.changedByUserId,
  'occurred_at': instance.occurredAt.toIso8601String(),
};

const _$BatchItemStatusEnumMap = {
  BatchItemStatus.preparing: 'preparing',
  BatchItemStatus.completed: 'completed',
  BatchItemStatus.served: 'served',
};
