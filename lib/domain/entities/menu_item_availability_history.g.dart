// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_availability_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItemAvailabilityHistory _$MenuItemAvailabilityHistoryFromJson(
  Map<String, dynamic> json,
) => _MenuItemAvailabilityHistory(
  id: json['id'] as String,
  menuItemId: json['menu_item_id'] as String,
  fromAvailability: $enumDecode(
    _$MenuAvailabilityEnumMap,
    json['from_availability'],
  ),
  toAvailability: $enumDecode(
    _$MenuAvailabilityEnumMap,
    json['to_availability'],
  ),
  changedByUserId: json['changed_by_user_id'] as String,
  occurredAt: DateTime.parse(json['occurred_at'] as String),
);

Map<String, dynamic> _$MenuItemAvailabilityHistoryToJson(
  _MenuItemAvailabilityHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'menu_item_id': instance.menuItemId,
  'from_availability': _$MenuAvailabilityEnumMap[instance.fromAvailability]!,
  'to_availability': _$MenuAvailabilityEnumMap[instance.toAvailability]!,
  'changed_by_user_id': instance.changedByUserId,
  'occurred_at': instance.occurredAt.toIso8601String(),
};

const _$MenuAvailabilityEnumMap = {
  MenuAvailability.available: 'available',
  MenuAvailability.outOfStock: 'out_of_stock',
};
