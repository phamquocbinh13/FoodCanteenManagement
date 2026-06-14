import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';

part 'session_payment.freezed.dart';
part 'session_payment.g.dart';

/// Terminal payment snapshot closing a [DineInSession]. DATA_MODEL §3.23.
///
/// No split bill — exactly one per session. Immutable after creation.
@freezed
abstract class SessionPayment with _$SessionPayment {
  const factory SessionPayment({
    required String id,
    required String sessionId,
    required PaymentMethod paymentMethod,
    @Default(SessionCloseType.payment) SessionCloseType closeType,
    ForceCloseReason? forceCloseReason,
    String? forceCloseNote,
    @MoneyConverter() required Money subtotal,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money taxAmount,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money serviceChargeAmount,
    @MoneyConverter() required Money totalAmount,
    required String closedByUserId,
    required DateTime paidAt,
    required DateTime createdAt,
  }) = _SessionPayment;

  factory SessionPayment.fromJson(Map<String, dynamic> json) =>
      _$SessionPaymentFromJson(json);
}
