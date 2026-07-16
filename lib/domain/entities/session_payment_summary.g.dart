// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_payment_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionPaymentSummary _$SessionPaymentSummaryFromJson(
  Map<String, dynamic> json,
) => _SessionPaymentSummary(
  subtotalMinor: (json['subtotal_minor'] as num?)?.toInt() ?? 0,
  discountMinor: (json['discount_minor'] as num?)?.toInt() ?? 0,
  taxMinor: (json['tax_minor'] as num?)?.toInt() ?? 0,
  serviceChargeMinor: (json['service_charge_minor'] as num?)?.toInt() ?? 0,
  totalMinor: (json['total_minor'] as num?)?.toInt() ?? 0,
  paidMinor: (json['paid_minor'] as num?)?.toInt() ?? 0,
  outstandingMinor: (json['outstanding_minor'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SessionPaymentSummaryToJson(
  _SessionPaymentSummary instance,
) => <String, dynamic>{
  'subtotal_minor': instance.subtotalMinor,
  'discount_minor': instance.discountMinor,
  'tax_minor': instance.taxMinor,
  'service_charge_minor': instance.serviceChargeMinor,
  'total_minor': instance.totalMinor,
  'paid_minor': instance.paidMinor,
  'outstanding_minor': instance.outstandingMinor,
};
