import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import '../value_objects/json_converters.dart';
import '../value_objects/money.dart';

part 'order_payment.freezed.dart';
part 'order_payment.g.dart';

/// Immutable payment snapshot for takeaway/delivery. DATA_MODEL §3.18.
@freezed
abstract class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String id,
    required String orderId,
    required PaymentMethod paymentMethod,
    @MoneyConverter() required Money subtotal,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money taxAmount,
    @MoneyConverter() @Default(Money(amountMinor: 0, currencyCode: 'USD'))
    Money serviceChargeAmount,
    @MoneyConverter() required Money totalAmount,
    required DateTime paidAt,
    required String recordedByUserId,
    required DateTime createdAt,
  }) = _OrderPayment;

  factory OrderPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentFromJson(json);
}
