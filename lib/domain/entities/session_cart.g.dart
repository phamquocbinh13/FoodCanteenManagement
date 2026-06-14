// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionCart _$SessionCartFromJson(Map<String, dynamic> json) => _SessionCart(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  version: (json['version'] as num?)?.toInt() ?? 1,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$SessionCartToJson(_SessionCart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'version': instance.version,
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
