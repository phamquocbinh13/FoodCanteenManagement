// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Role _$RoleFromJson(Map<String, dynamic> json) => _Role(
  id: json['id'] as String,
  key: $enumDecode(_$RoleKeyEnumMap, json['key']),
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RoleToJson(_Role instance) => <String, dynamic>{
  'id': instance.id,
  'key': _$RoleKeyEnumMap[instance.key]!,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$RoleKeyEnumMap = {
  RoleKey.admin: 'admin',
  RoleKey.manager: 'manager',
  RoleKey.cashier: 'cashier',
  RoleKey.kitchen: 'kitchen',
  RoleKey.shipper: 'shipper',
};
