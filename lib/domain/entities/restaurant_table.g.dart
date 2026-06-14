// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantTable _$RestaurantTableFromJson(Map<String, dynamic> json) =>
    _RestaurantTable(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      label: json['label'] as String,
      capacity: (json['capacity'] as num?)?.toInt() ?? 4,
      status:
          $enumDecodeNullable(_$TableStatusEnumMap, json['status']) ??
          TableStatus.available,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RestaurantTableToJson(_RestaurantTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'label': instance.label,
      'capacity': instance.capacity,
      'status': _$TableStatusEnumMap[instance.status]!,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
  TableStatus.reserved: 'reserved',
};
