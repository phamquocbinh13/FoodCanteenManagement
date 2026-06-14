// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRole _$UserRoleFromJson(Map<String, dynamic> json) => _UserRole(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  roleId: json['role_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserRoleToJson(_UserRole instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'role_id': instance.roleId,
  'created_at': instance.createdAt.toIso8601String(),
};
