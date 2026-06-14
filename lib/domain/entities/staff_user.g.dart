// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffUser _$StaffUserFromJson(Map<String, dynamic> json) => _StaffUser(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  passwordHash: json['password_hash'] as String,
  isActive: json['is_active'] as bool? ?? true,
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$StaffUserToJson(_StaffUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'email': instance.email,
      'display_name': instance.displayName,
      'password_hash': instance.passwordHash,
      'is_active': instance.isActive,
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
