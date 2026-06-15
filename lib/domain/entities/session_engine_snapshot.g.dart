// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_engine_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionEngineSnapshot _$SessionEngineSnapshotFromJson(
  Map<String, dynamic> json,
) => _SessionEngineSnapshot(
  session: DineInSession.fromJson(json['session'] as Map<String, dynamic>),
  activeToken: json['active_token'] == null
      ? null
      : SessionAuthToken.fromJson(json['active_token'] as Map<String, dynamic>),
  tableLabel: json['table_label'] as String,
  batchIds:
      (json['batch_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  requestIds:
      (json['request_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$SessionEngineSnapshotToJson(
  _SessionEngineSnapshot instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'active_token': instance.activeToken?.toJson(),
  'table_label': instance.tableLabel,
  'batch_ids': instance.batchIds,
  'request_ids': instance.requestIds,
};
