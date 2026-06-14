import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';

part 'customization_option.freezed.dart';
part 'customization_option.g.dart';

/// Selectable option within a [CustomizationGroup]. DATA_MODEL §3.22.
@freezed
abstract class CustomizationOption with _$CustomizationOption {
  const factory CustomizationOption({
    required String id,
    required String groupId,
    required String key,
    required String name,
    required String kitchenLabel,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money priceDelta,
    @Default(false) bool isDefault,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CustomizationOption;

  factory CustomizationOption.fromJson(Map<String, dynamic> json) =>
      _$CustomizationOptionFromJson(json);
}
