// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => _MenuItem(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  categoryId: json['category_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  basePrice: const MoneyConverter().fromJson(
    json['base_price'] as Map<String, dynamic>,
  ),
  availability:
      $enumDecodeNullable(_$MenuAvailabilityEnumMap, json['availability']) ??
      MenuAvailability.available,
  imageUrl: json['image_url'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MenuItemToJson(_MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurantId,
  'category_id': instance.categoryId,
  'name': instance.name,
  'description': instance.description,
  'base_price': const MoneyConverter().toJson(instance.basePrice),
  'availability': _$MenuAvailabilityEnumMap[instance.availability]!,
  'image_url': instance.imageUrl,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$MenuAvailabilityEnumMap = {
  MenuAvailability.available: 'available',
  MenuAvailability.outOfStock: 'out_of_stock',
};
