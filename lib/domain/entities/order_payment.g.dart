// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) =>
    _OrderPayment(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      paymentMethod: $enumDecode(
        _$PaymentMethodEnumMap,
        json['payment_method'],
      ),
      subtotal: const MoneyConverter().fromJson(
        json['subtotal'] as Map<String, dynamic>,
      ),
      taxAmount: json['tax_amount'] == null
          ? const Money(amountMinor: 0, currencyCode: 'USD')
          : const MoneyConverter().fromJson(
              json['tax_amount'] as Map<String, dynamic>,
            ),
      serviceChargeAmount: json['service_charge_amount'] == null
          ? const Money(amountMinor: 0, currencyCode: 'USD')
          : const MoneyConverter().fromJson(
              json['service_charge_amount'] as Map<String, dynamic>,
            ),
      totalAmount: const MoneyConverter().fromJson(
        json['total_amount'] as Map<String, dynamic>,
      ),
      paidAt: DateTime.parse(json['paid_at'] as String),
      recordedByUserId: json['recorded_by_user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OrderPaymentToJson(_OrderPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'subtotal': const MoneyConverter().toJson(instance.subtotal),
      'tax_amount': const MoneyConverter().toJson(instance.taxAmount),
      'service_charge_amount': const MoneyConverter().toJson(
        instance.serviceChargeAmount,
      ),
      'total_amount': const MoneyConverter().toJson(instance.totalAmount),
      'paid_at': instance.paidAt.toIso8601String(),
      'recorded_by_user_id': instance.recordedByUserId,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.other: 'other',
};
