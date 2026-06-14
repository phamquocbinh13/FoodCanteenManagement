import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_category.freezed.dart';
part 'menu_category.g.dart';

/// Menu grouping within a [Restaurant]. DATA_MODEL §3.19.
@freezed
abstract class MenuCategory with _$MenuCategory {
  const factory MenuCategory({
    required String id,
    required String restaurantId,
    required String name,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MenuCategory;

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);
}
