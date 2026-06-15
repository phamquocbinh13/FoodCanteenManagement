import 'package:freezed_annotation/freezed_annotation.dart';

import 'authenticated_user.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

/// Active authentication session including tokens.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AuthenticatedUser user,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
