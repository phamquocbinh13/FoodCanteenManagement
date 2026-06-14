// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionCartItem _$SessionCartItemFromJson(Map<String, dynamic> json) =>
    _SessionCartItem(
      id: json['id'] as String,
      sessionCartId: json['session_cart_id'] as String,
      menuItemId: json['menu_item_id'] as String,
      quantity: const QuantityConverter().fromJson(
        (json['quantity'] as num).toInt(),
      ),
      selectionsJson:
          json['selections_json'] as Map<String, dynamic>? ?? const {},
      unitPriceSnapshot: const MoneyConverter().fromJson(
        json['unit_price_snapshot'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SessionCartItemToJson(_SessionCartItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_cart_id': instance.sessionCartId,
      'menu_item_id': instance.menuItemId,
      'quantity': const QuantityConverter().toJson(instance.quantity),
      'selections_json': instance.selectionsJson,
      'unit_price_snapshot': const MoneyConverter().toJson(
        instance.unitPriceSnapshot,
      ),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
