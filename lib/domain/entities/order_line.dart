import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';
import '../value_objects/quantity.dart';

part 'order_line.freezed.dart';
part 'order_line.g.dart';

/// Draft line on a [RomsOrder] before kitchen submission. DATA_MODEL §3.16.
@freezed
abstract class OrderLine with _$OrderLine {
  const factory OrderLine({
    required String id,
    required String orderId,
    required String menuItemId,
    @QuantityConverter() required Quantity quantity,
    @Default({}) Map<String, dynamic> selectionsJson,
    @MoneyConverter() required Money unitPriceSnapshot,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderLine;

  factory OrderLine.fromJson(Map<String, dynamic> json) =>
      _$OrderLineFromJson(json);
}
