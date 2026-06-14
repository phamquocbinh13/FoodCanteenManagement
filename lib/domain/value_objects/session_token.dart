import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'session_token.freezed.dart';

/// Opaque bearer token presented by customer after QR join.
///
/// Distinct from QR join token. Maps to hashed storage in [SessionAuthToken].
/// Spec: "Customer only works with Session Token."
@Freezed(fromJson: false, toJson: false)
abstract class SessionToken with _$SessionToken {
  const SessionToken._();

  const factory SessionToken(String value) = _SessionToken;

  factory SessionToken.fromJson(String json) => SessionToken(_validate(json));

  String toJson() => value;

  static String _validate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < 32) {
      throw const ValueObjectException(
        'Session token must be at least 32 characters',
        code: 'INVALID_SESSION_TOKEN',
      );
    }
    return trimmed;
  }
}
