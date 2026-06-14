import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

/// Sellable catalog product. DATA_MODEL §3.20.
///
/// [availability] toggled by kitchen; `out_of_stock` hides from customers.
@freezed
abstract class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String restaurantId,
    required String categoryId,
    required String name,
    String? description,
    @MoneyConverter() required Money basePrice,
    @Default(MenuAvailability.available) MenuAvailability availability,
    String? imageUrl,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
