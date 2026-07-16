import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_payment_summary.freezed.dart';
part 'session_payment_summary.g.dart';

/// Prepared payment summary on a session aggregate. Payment engine deferred.
@freezed
abstract class SessionPaymentSummary with _$SessionPaymentSummary {
  const factory SessionPaymentSummary({
    @Default(0) int subtotalMinor,
    @Default(0) int discountMinor,
    @Default(0) int taxMinor,
    @Default(0) int serviceChargeMinor,
    @Default(0) int totalMinor,
    @Default(0) int paidMinor,
    @Default(0) int outstandingMinor,
  }) = _SessionPaymentSummary;

  factory SessionPaymentSummary.fromJson(Map<String, dynamic> json) =>
      _$SessionPaymentSummaryFromJson(json);
}

extension SessionPaymentSummaryCalc on SessionPaymentSummary {
  SessionPaymentSummary recalculateTotal() {
    final computed =
        subtotalMinor - discountMinor + taxMinor + serviceChargeMinor;
    return copyWith(totalMinor: computed < 0 ? 0 : computed);
  }
}
