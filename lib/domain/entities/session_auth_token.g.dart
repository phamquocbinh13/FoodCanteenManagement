// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionAuthToken _$SessionAuthTokenFromJson(Map<String, dynamic> json) =>
    _SessionAuthToken(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      tokenHash: json['token_hash'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      revokedAt: json['revoked_at'] == null
          ? null
          : DateTime.parse(json['revoked_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionAuthTokenToJson(_SessionAuthToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'token_hash': instance.tokenHash,
      'expires_at': instance.expiresAt.toIso8601String(),
      'revoked_at': instance.revokedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
