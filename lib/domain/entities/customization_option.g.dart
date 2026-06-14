// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customization_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomizationOption _$CustomizationOptionFromJson(Map<String, dynamic> json) =>
    _CustomizationOption(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      kitchenLabel: json['kitchen_label'] as String,
      priceDelta: json['price_delta'] == null
          ? const Money(amountMinor: 0, currencyCode: 'USD')
          : const MoneyConverter().fromJson(
              json['price_delta'] as Map<String, dynamic>,
            ),
      isDefault: json['is_default'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CustomizationOptionToJson(
  _CustomizationOption instance,
) => <String, dynamic>{
  'id': instance.id,
  'group_id': instance.groupId,
  'key': instance.key,
  'name': instance.name,
  'kitchen_label': instance.kitchenLabel,
  'price_delta': const MoneyConverter().toJson(instance.priceDelta),
  'is_default': instance.isDefault,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
