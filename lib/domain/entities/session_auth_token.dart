import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_auth_token.freezed.dart';
part 'session_auth_token.g.dart';

/// Customer bearer credential record. Entity name: `SessionToken` in DATA_MODEL §3.6.
///
/// Stores hash of [SessionToken] value object. Issued when session is created
/// or joined. Distinct from QR join token.
@freezed
abstract class SessionAuthToken with _$SessionAuthToken {
  const factory SessionAuthToken({
    required String id,
    required String sessionId,
    required String tokenHash,
    required DateTime expiresAt,
    DateTime? revokedAt,
    required DateTime createdAt,
  }) = _SessionAuthToken;

  factory SessionAuthToken.fromJson(Map<String, dynamic> json) =>
      _$SessionAuthTokenFromJson(json);
}
