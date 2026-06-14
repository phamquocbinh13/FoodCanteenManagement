// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dine_in_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DineInSession _$DineInSessionFromJson(Map<String, dynamic> json) =>
    _DineInSession(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      tableId: json['table_id'] as String,
      sessionNumber: (json['session_number'] as num).toInt(),
      status:
          $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
          SessionStatus.open,
      openedVia: $enumDecode(_$SessionOpenedViaEnumMap, json['opened_via']),
      openedByUserId: json['opened_by_user_id'] as String?,
      paymentSoftLock: json['payment_soft_lock'] as bool? ?? false,
      openedAt: DateTime.parse(json['opened_at'] as String),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DineInSessionToJson(_DineInSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'table_id': instance.tableId,
      'session_number': instance.sessionNumber,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'opened_via': _$SessionOpenedViaEnumMap[instance.openedVia]!,
      'opened_by_user_id': instance.openedByUserId,
      'payment_soft_lock': instance.paymentSoftLock,
      'opened_at': instance.openedAt.toIso8601String(),
      'closed_at': instance.closedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$SessionStatusEnumMap = {
  SessionStatus.open: 'open',
  SessionStatus.paymentPending: 'payment_pending',
  SessionStatus.closed: 'closed',
};

const _$SessionOpenedViaEnumMap = {
  SessionOpenedVia.qrScan: 'qr_scan',
  SessionOpenedVia.cashierManual: 'cashier_manual',
};
