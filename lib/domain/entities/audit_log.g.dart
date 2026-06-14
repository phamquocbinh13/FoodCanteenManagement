// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  actorType: $enumDecode(_$ActorTypeEnumMap, json['actor_type']),
  actorId: json['actor_id'] as String?,
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String,
  action: $enumDecode(_$AuditActionEnumMap, json['action']),
  beforeJson: json['before_json'] as Map<String, dynamic>?,
  afterJson: json['after_json'] as Map<String, dynamic>?,
  metadataJson: json['metadata_json'] as Map<String, dynamic>? ?? const {},
  occurredAt: DateTime.parse(json['occurred_at'] as String),
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurantId,
  'actor_type': _$ActorTypeEnumMap[instance.actorType]!,
  'actor_id': instance.actorId,
  'entity_type': instance.entityType,
  'entity_id': instance.entityId,
  'action': _$AuditActionEnumMap[instance.action]!,
  'before_json': instance.beforeJson,
  'after_json': instance.afterJson,
  'metadata_json': instance.metadataJson,
  'occurred_at': instance.occurredAt.toIso8601String(),
};

const _$ActorTypeEnumMap = {
  ActorType.user: 'user',
  ActorType.customerSession: 'customer_session',
  ActorType.system: 'system',
};

const _$AuditActionEnumMap = {
  AuditAction.create: 'create',
  AuditAction.update: 'update',
  AuditAction.delete: 'delete',
  AuditAction.statusChange: 'status_change',
  AuditAction.close: 'close',
  AuditAction.claim: 'claim',
  AuditAction.reassign: 'reassign',
  AuditAction.forceClose: 'force_close',
};
