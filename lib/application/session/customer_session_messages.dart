import 'session_constants.dart';

/// Customer-facing join error copy for QR and manual code entry.
abstract final class CustomerSessionMessages {
  static const sessionNotFound = 'Session not found.';
  static const sessionExpired =
      'Session expired. Please ask staff for assistance.';
  static const sessionEnded = 'This dining session has ended.';
  static const joinFailed = 'Unable to join session. Please try again.';
  static const paymentRequested =
      'Payment request sent. Staff will assist you shortly.';
  static const staffNotified = 'Staff has been notified.';
  static const demoExitTitle = 'Thoát Demo';
  static const demoExitPrompt =
      'Bạn muốn thoát màn hình gọi món để chuyển vai trò demo?';
  static const demoExitCancel = 'Huỷ';
  static const demoExitConfirm = 'Thoát';
}

String customerSessionFailureMessage(String? code) {
  return switch (code) {
    SessionErrorCodes.invalidToken ||
    SessionErrorCodes.sessionNotFound =>
      CustomerSessionMessages.sessionNotFound,
    SessionErrorCodes.tokenExpired => CustomerSessionMessages.sessionExpired,
    SessionErrorCodes.sessionClosed => CustomerSessionMessages.sessionEnded,
    _ => CustomerSessionMessages.joinFailed,
  };
}
