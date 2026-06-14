// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionDevice _$SessionDeviceFromJson(Map<String, dynamic> json) =>
    _SessionDevice(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      deviceFingerprint: json['device_fingerprint'] as String,
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionDeviceToJson(_SessionDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'device_fingerprint': instance.deviceFingerprint,
      'last_seen_at': instance.lastSeenAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
