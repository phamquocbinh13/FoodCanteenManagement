// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionPayment _$SessionPaymentFromJson(Map<String, dynamic> json) =>
    _SessionPayment(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      paymentMethod: $enumDecode(
        _$PaymentMethodEnumMap,
        json['payment_method'],
      ),
      closeType:
          $enumDecodeNullable(_$SessionCloseTypeEnumMap, json['close_type']) ??
          SessionCloseType.payment,
      forceCloseReason: $enumDecodeNullable(
        _$ForceCloseReasonEnumMap,
        json['force_close_reason'],
      ),
      forceCloseNote: json['force_close_note'] as String?,
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
      closedByUserId: json['closed_by_user_id'] as String,
      paidAt: DateTime.parse(json['paid_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionPaymentToJson(
  _SessionPayment instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'close_type': _$SessionCloseTypeEnumMap[instance.closeType]!,
  'force_close_reason': _$ForceCloseReasonEnumMap[instance.forceCloseReason],
  'force_close_note': instance.forceCloseNote,
  'subtotal': const MoneyConverter().toJson(instance.subtotal),
  'tax_amount': const MoneyConverter().toJson(instance.taxAmount),
  'service_charge_amount': const MoneyConverter().toJson(
    instance.serviceChargeAmount,
  ),
  'total_amount': const MoneyConverter().toJson(instance.totalAmount),
  'closed_by_user_id': instance.closedByUserId,
  'paid_at': instance.paidAt.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.other: 'other',
};

const _$SessionCloseTypeEnumMap = {
  SessionCloseType.payment: 'payment',
  SessionCloseType.forceClosed: 'force_closed',
};

const _$ForceCloseReasonEnumMap = {
  ForceCloseReason.customerLeft: 'customer_left',
  ForceCloseReason.dispute: 'dispute',
  ForceCloseReason.systemError: 'system_error',
  ForceCloseReason.other: 'other',
};
