// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_qr_token_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableQrTokenRecord _$TableQrTokenRecordFromJson(Map<String, dynamic> json) =>
    _TableQrTokenRecord(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      tableId: json['table_id'] as String,
      tokenHash: json['token_hash'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TableQrTokenRecordToJson(_TableQrTokenRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'table_id': instance.tableId,
      'token_hash': instance.tokenHash,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };
