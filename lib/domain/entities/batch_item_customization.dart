import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';

part 'batch_item_customization.freezed.dart';
part 'batch_item_customization.g.dart';

/// Structured customization snapshot on a [BatchItem]. DATA_MODEL §3.14.
///
/// Spec forbids free-text storage. [kitchenLabelRendered] is derived plain text
/// for kitchen display (e.g. `+ Extra Chicken`).
@freezed
abstract class BatchItemCustomization with _$BatchItemCustomization {
  const factory BatchItemCustomization({
    required String id,
    required String batchItemId,
    required String groupKey,
    required String groupNameSnapshot,
    String? optionKey,
    String? optionNameSnapshot,
    @Default({}) Map<String, dynamic> valueJson,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money priceDeltaSnapshot,
    required String kitchenLabelRendered,
    required DateTime createdAt,
  }) = _BatchItemCustomization;

  factory BatchItemCustomization.fromJson(Map<String, dynamic> json) =>
      _$BatchItemCustomizationFromJson(json);
}
