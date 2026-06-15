/// Demo restaurant identifier for mock session engine.
abstract final class SessionEngineConstants {
  static const demoRestaurantId = 'demo-restaurant';
  static const demoTable1Id = 'table-1';
  static const tokenTtl = Duration(hours: 8);
  static const displayNumberPrefix = 'S';
}

abstract final class SessionErrorCodes {
  static const tableNotFound = 'TABLE_NOT_FOUND';
  static const activeSessionExists = 'ACTIVE_SESSION_EXISTS';
  static const sessionNotFound = 'SESSION_NOT_FOUND';
  static const invalidToken = 'INVALID_SESSION_TOKEN';
  static const tokenExpired = 'SESSION_TOKEN_EXPIRED';
  static const sessionClosed = 'SESSION_CLOSED';
  static const invalidTransition = 'INVALID_SESSION_TRANSITION';
  static const transferUnsupported = 'SESSION_TRANSFER_UNSUPPORTED';
  static const tableOccupied = 'TABLE_OCCUPIED';
}

abstract final class SessionErrorMessages {
  static const tableNotFound = 'Table not found';
  static const activeSessionExists = 'Table already has an active session';
  static const sessionNotFound = 'Session not found';
  static const invalidToken = 'Invalid session token';
  static const tokenExpired = 'Session token has expired';
  static const sessionClosed = 'Session is closed';
  static const invalidTransition = 'Invalid session state transition';
  static const transferUnsupported = 'Session transfer is not supported yet';
}

String sessionFailureMessage(String? code) {
  return switch (code) {
    SessionErrorCodes.tableNotFound => SessionErrorMessages.tableNotFound,
    SessionErrorCodes.activeSessionExists =>
      SessionErrorMessages.activeSessionExists,
    SessionErrorCodes.sessionNotFound => SessionErrorMessages.sessionNotFound,
    SessionErrorCodes.invalidToken => SessionErrorMessages.invalidToken,
    SessionErrorCodes.tokenExpired => SessionErrorMessages.tokenExpired,
    SessionErrorCodes.sessionClosed => SessionErrorMessages.sessionClosed,
    SessionErrorCodes.invalidTransition =>
      SessionErrorMessages.invalidTransition,
    SessionErrorCodes.transferUnsupported =>
      SessionErrorMessages.transferUnsupported,
    _ => 'Session operation failed',
  };
}
