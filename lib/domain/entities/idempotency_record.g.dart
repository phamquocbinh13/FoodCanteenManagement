// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idempotency_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IdempotencyRecord _$IdempotencyRecordFromJson(Map<String, dynamic> json) =>
    _IdempotencyRecord(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      idempotencyKey: json['idempotency_key'] as String,
      mutationType: json['mutation_type'] as String,
      responseJson: json['response_json'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$IdempotencyRecordToJson(_IdempotencyRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'idempotency_key': instance.idempotencyKey,
      'mutation_type': instance.mutationType,
      'response_json': instance.responseJson,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };
