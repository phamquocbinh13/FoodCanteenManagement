import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';
import '../value_objects/quantity.dart';

part 'session_bill_line.freezed.dart';
part 'session_bill_line.g.dart';

/// Frozen itemized bill line at session close. DATA_MODEL §3.24.
@freezed
abstract class SessionBillLine with _$SessionBillLine {
  const factory SessionBillLine({
    required String id,
    required String sessionPaymentId,
    required String batchItemId,
    required String description,
    @QuantityConverter() required Quantity quantity,
    @MoneyConverter() required Money unitPrice,
    @MoneyConverter() required Money lineTotal,
    required DateTime createdAt,
  }) = _SessionBillLine;

  factory SessionBillLine.fromJson(Map<String, dynamic> json) =>
      _$SessionBillLineFromJson(json);
}
