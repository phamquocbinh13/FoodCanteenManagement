import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';
import '../value_objects/quantity.dart';

part 'session_cart_item.freezed.dart';
part 'session_cart_item.g.dart';

/// Draft cart line before confirmation. DATA_MODEL §3.9.
///
/// [selectionsJson] holds structured customization draft; normalized into
/// [BatchItemCustomization] on confirm. Not yet a [BatchItem].
@freezed
abstract class SessionCartItem with _$SessionCartItem {
  const factory SessionCartItem({
    required String id,
    required String sessionCartId,
    required String menuItemId,
    @QuantityConverter() required Quantity quantity,
    @Default({}) Map<String, dynamic> selectionsJson,
    @MoneyConverter() required Money unitPriceSnapshot,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SessionCartItem;

  factory SessionCartItem.fromJson(Map<String, dynamic> json) =>
      _$SessionCartItemFromJson(json);
}
