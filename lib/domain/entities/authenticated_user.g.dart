// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticated_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticatedUser _$AuthenticatedUserFromJson(Map<String, dynamic> json) =>
    _AuthenticatedUser(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      role: $enumDecode(_$RoleKeyEnumMap, json['role']),
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AuthenticatedUserToJson(_AuthenticatedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'full_name': instance.fullName,
      'role': _$RoleKeyEnumMap[instance.role]!,
      'permissions': instance.permissions,
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$RoleKeyEnumMap = {
  RoleKey.admin: 'admin',
  RoleKey.manager: 'manager',
  RoleKey.cashier: 'cashier',
  RoleKey.kitchen: 'kitchen',
  RoleKey.shipper: 'shipper',
};
