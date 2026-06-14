// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchItem _$BatchItemFromJson(Map<String, dynamic> json) => _BatchItem(
  id: json['id'] as String,
  batchId: json['batch_id'] as String,
  menuItemId: json['menu_item_id'] as String,
  menuItemNameSnapshot: json['menu_item_name_snapshot'] as String,
  unitPriceSnapshot: const MoneyConverter().fromJson(
    json['unit_price_snapshot'] as Map<String, dynamic>,
  ),
  quantity: const QuantityConverter().fromJson(
    (json['quantity'] as num).toInt(),
  ),
  lineTotal: const MoneyConverter().fromJson(
    json['line_total'] as Map<String, dynamic>,
  ),
  kitchenNotesRendered: json['kitchen_notes_rendered'] as String,
  status:
      $enumDecodeNullable(_$BatchItemStatusEnumMap, json['status']) ??
      BatchItemStatus.preparing,
  statusUpdatedAt: DateTime.parse(json['status_updated_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BatchItemToJson(_BatchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batchId,
      'menu_item_id': instance.menuItemId,
      'menu_item_name_snapshot': instance.menuItemNameSnapshot,
      'unit_price_snapshot': const MoneyConverter().toJson(
        instance.unitPriceSnapshot,
      ),
      'quantity': const QuantityConverter().toJson(instance.quantity),
      'line_total': const MoneyConverter().toJson(instance.lineTotal),
      'kitchen_notes_rendered': instance.kitchenNotesRendered,
      'status': _$BatchItemStatusEnumMap[instance.status]!,
      'status_updated_at': instance.statusUpdatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$BatchItemStatusEnumMap = {
  BatchItemStatus.preparing: 'preparing',
  BatchItemStatus.completed: 'completed',
  BatchItemStatus.served: 'served',
};
