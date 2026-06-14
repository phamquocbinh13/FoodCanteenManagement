// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_bill_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionBillLine _$SessionBillLineFromJson(Map<String, dynamic> json) =>
    _SessionBillLine(
      id: json['id'] as String,
      sessionPaymentId: json['session_payment_id'] as String,
      batchItemId: json['batch_item_id'] as String,
      description: json['description'] as String,
      quantity: const QuantityConverter().fromJson(
        (json['quantity'] as num).toInt(),
      ),
      unitPrice: const MoneyConverter().fromJson(
        json['unit_price'] as Map<String, dynamic>,
      ),
      lineTotal: const MoneyConverter().fromJson(
        json['line_total'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionBillLineToJson(_SessionBillLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_payment_id': instance.sessionPaymentId,
      'batch_item_id': instance.batchItemId,
      'description': instance.description,
      'quantity': const QuantityConverter().toJson(instance.quantity),
      'unit_price': const MoneyConverter().toJson(instance.unitPrice),
      'line_total': const MoneyConverter().toJson(instance.lineTotal),
      'created_at': instance.createdAt.toIso8601String(),
    };
