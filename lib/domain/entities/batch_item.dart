import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';
import '../value_objects/quantity.dart';

part 'batch_item.freezed.dart';
part 'batch_item.g.dart';

/// Kitchen-trackable line item. DATA_MODEL §3.13.
///
/// Snapshots freeze catalog at confirmation. Only [status] and
/// [statusUpdatedAt] may change post-insert (kitchen progress).
@freezed
abstract class BatchItem with _$BatchItem {
  const factory BatchItem({
    required String id,
    required String batchId,
    required String menuItemId,
    required String menuItemNameSnapshot,
    @MoneyConverter() required Money unitPriceSnapshot,
    @QuantityConverter() required Quantity quantity,
    @MoneyConverter() required Money lineTotal,
    required String kitchenNotesRendered,
    @Default(BatchItemStatus.preparing) BatchItemStatus status,
    required DateTime statusUpdatedAt,
    required DateTime createdAt,
  }) = _BatchItem;

  factory BatchItem.fromJson(Map<String, dynamic> json) =>
      _$BatchItemFromJson(json);
}
