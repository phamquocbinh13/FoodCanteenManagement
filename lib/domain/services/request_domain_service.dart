import '../entities/dine_in_session.dart';
import '../entities/staff_request.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Call-staff request queue business rules.
///
/// Payment request is a queue entry — not payment itself. Cashier handles.
class RequestDomainService {
  const RequestDomainService();

  /// Customer can create requests only on open / payment-pending sessions.
  void validateCanCreateRequest({
    required DineInSession session,
    required RequestType requestType,
  }) {
    if (session.status == SessionStatus.closed) {
      throw const RequestRuleException(
        'Cannot create request on closed session',
        code: 'SESSION_CLOSED',
      );
    }
  }

  /// Rejects a second pending payment request for the same session.
  void validateNoDuplicatePendingPayment({
    required RequestType requestType,
    required Iterable<StaffRequest> existingForSession,
  }) {
    if (requestType != RequestType.payment) return;
    final hasPendingPayment = existingForSession.any(
      (r) =>
          r.requestType == RequestType.payment &&
          r.status == RequestStatus.pending,
    );
    if (hasPendingPayment) {
      throw const RequestRuleException(
        'Payment already requested. Staff will assist shortly.',
        code: 'PAYMENT_REQUEST_PENDING',
      );
    }
  }

  /// Builds a new pending staff request.
  StaffRequest createRequest({
    required String id,
    required String restaurantId,
    required String sessionId,
    required RequestType requestType,
    required DateTime now,
    String? note,
  }) {
    return StaffRequest(
      id: id,
      restaurantId: restaurantId,
      sessionId: sessionId,
      requestType: requestType,
      status: RequestStatus.pending,
      note: note,
      requestedAt: now,
      createdAt: now,
    );
  }

  /// Cashier marks request handled.
  StaffRequest markHandled({
    required StaffRequest request,
    required String handledByUserId,
    required DateTime now,
  }) {
    if (request.status != RequestStatus.pending) {
      throw const RequestRuleException(
        'Only pending requests can be handled',
        code: 'REQUEST_NOT_PENDING',
      );
    }
    return request.copyWith(
      status: RequestStatus.handled,
      handledAt: now,
      handledByUserId: handledByUserId,
    );
  }

  /// Whether request type triggers session payment-pending state.
  bool triggersPaymentPending(RequestType type) =>
      type == RequestType.payment;
}
