import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'restaurant_table.freezed.dart';
part 'restaurant_table.g.dart';

/// Physical dine-in table. Entity name: `Table` in DATA_MODEL §3.3.
///
/// At most one active [DineInSession] per table. Status transitions enforced
/// by [TableDomainService].
@freezed
abstract class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required String id,
    required String restaurantId,
    required String label,
    @Default(4) int capacity,
    @Default(TableStatus.available) TableStatus status,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(json);
}
