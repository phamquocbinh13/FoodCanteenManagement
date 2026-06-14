import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'customization_group.freezed.dart';
part 'customization_group.g.dart';

/// Customization question group on a [MenuItem]. DATA_MODEL §3.21.
@freezed
abstract class CustomizationGroup with _$CustomizationGroup {
  const factory CustomizationGroup({
    required String id,
    required String menuItemId,
    required String key,
    required String name,
    required CustomizationSelectionType selectionType,
    @Default(false) bool isRequired,
    @Default(0) int minSelections,
    @Default(1) int maxSelections,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CustomizationGroup;

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomizationGroupFromJson(json);
}
