import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role.freezed.dart';
part 'user_role.g.dart';

/// Many-to-many junction: [StaffUser] ↔ [Role]. DATA_MODEL §3.27.
@freezed
abstract class UserRole with _$UserRole {
  const factory UserRole({
    required String id,
    required String userId,
    required String roleId,
    required DateTime createdAt,
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
}
