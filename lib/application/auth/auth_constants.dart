/// Local storage keys for authentication persistence.
abstract final class AuthStorageKeys {
  static const accessToken = 'auth_access_token';
  static const refreshToken = 'auth_refresh_token';
  static const userId = 'auth_user_id';
  static const role = 'auth_role';
  static const expiresAt = 'auth_expires_at';
  static const sessionJson = 'auth_session_json';
}

/// Friendly error codes mapped to user-visible messages.
abstract final class AuthErrorCodes {
  static const invalidUsername = 'INVALID_USERNAME';
  static const invalidPassword = 'INVALID_PASSWORD';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
  static const sessionExpired = 'SESSION_EXPIRED';
  static const userInactive = 'USER_INACTIVE';
  static const networkUnavailable = 'NETWORK_UNAVAILABLE';
  static const unknown = 'UNKNOWN_ERROR';
}

abstract final class AuthErrorMessages {
  static const invalidUsername = 'Invalid username';
  static const invalidPassword = 'Invalid password';
  static const invalidCredentials = 'Invalid username or password';
  static const sessionExpired = 'Your session has expired. Please log in again.';
  static const userInactive = 'This account is inactive';
  static const networkUnavailable = 'Network unavailable. Please try again.';
  static const unknown = 'Something went wrong. Please try again.';
}

/// Maps auth failure codes to friendly display messages.
String authFailureMessage(String? code, {String? fallback}) {
  return switch (code) {
    AuthErrorCodes.invalidUsername => AuthErrorMessages.invalidUsername,
    AuthErrorCodes.invalidPassword => AuthErrorMessages.invalidPassword,
    AuthErrorCodes.invalidCredentials => AuthErrorMessages.invalidCredentials,
    AuthErrorCodes.sessionExpired => AuthErrorMessages.sessionExpired,
    AuthErrorCodes.userInactive => AuthErrorMessages.userInactive,
    AuthErrorCodes.networkUnavailable => AuthErrorMessages.networkUnavailable,
    _ => fallback ?? AuthErrorMessages.unknown,
  };
}
