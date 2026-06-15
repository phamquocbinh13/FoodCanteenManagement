import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'authenticated_user.freezed.dart';
part 'authenticated_user.g.dart';

/// Logged-in staff identity for the auth session.
///
/// Distinct from [StaffUser] (persistence/tenant record). This is the
/// presentation-safe authenticated user returned after login.
@freezed
abstract class AuthenticatedUser with _$AuthenticatedUser {
  const factory AuthenticatedUser({
    required String id,
    required String username,
    required String fullName,
    required RoleKey role,
    @Default([]) List<String> permissions,
    @Default(true) bool active,
    required DateTime createdAt,
  }) = _AuthenticatedUser;

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserFromJson(json);
}
