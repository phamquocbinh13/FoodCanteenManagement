import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_user.freezed.dart';
part 'staff_user.g.dart';

/// Staff account. Entity name: `User` in DATA_MODEL §3.25.
///
/// Customers never have staff user rows. Scoped to [restaurantId].
@freezed
abstract class StaffUser with _$StaffUser {
  const factory StaffUser({
    required String id,
    required String restaurantId,
    required String email,
    required String displayName,
    required String passwordHash,
    @Default(true) bool isActive,
    DateTime? lastLoginAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StaffUser;

  factory StaffUser.fromJson(Map<String, dynamic> json) =>
      _$StaffUserFromJson(json);
}
