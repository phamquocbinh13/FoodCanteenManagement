// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_item_customization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchItemCustomization _$BatchItemCustomizationFromJson(
  Map<String, dynamic> json,
) => _BatchItemCustomization(
  id: json['id'] as String,
  batchItemId: json['batch_item_id'] as String,
  groupKey: json['group_key'] as String,
  groupNameSnapshot: json['group_name_snapshot'] as String,
  optionKey: json['option_key'] as String?,
  optionNameSnapshot: json['option_name_snapshot'] as String?,
  valueJson: json['value_json'] as Map<String, dynamic>? ?? const {},
  priceDeltaSnapshot: json['price_delta_snapshot'] == null
      ? const Money(amountMinor: 0, currencyCode: 'USD')
      : const MoneyConverter().fromJson(
          json['price_delta_snapshot'] as Map<String, dynamic>,
        ),
  kitchenLabelRendered: json['kitchen_label_rendered'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BatchItemCustomizationToJson(
  _BatchItemCustomization instance,
) => <String, dynamic>{
  'id': instance.id,
  'batch_item_id': instance.batchItemId,
  'group_key': instance.groupKey,
  'group_name_snapshot': instance.groupNameSnapshot,
  'option_key': instance.optionKey,
  'option_name_snapshot': instance.optionNameSnapshot,
  'value_json': instance.valueJson,
  'price_delta_snapshot': const MoneyConverter().toJson(
    instance.priceDeltaSnapshot,
  ),
  'kitchen_label_rendered': instance.kitchenLabelRendered,
  'created_at': instance.createdAt.toIso8601String(),
};
