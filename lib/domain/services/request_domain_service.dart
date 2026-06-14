import '../entities/dine_in_session.dart';
import '../entities/staff_request.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Call-staff request queue business rules.
///
/// Payment request is a queue entry — not payment itself. Cashier handles.
class RequestDomainService {
  const RequestDomainService();

  /// Customer can create requests only on open sessions.
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

  /// Builds a new pending staff request.
  StaffRequest createRequest({
    required String id,
    required String restaurantId,
    required String sessionId,
    required RequestType requestType,
    String? note,
  }) {
    return StaffRequest(
      id: id,
      restaurantId: restaurantId,
      sessionId: sessionId,
      requestType: requestType,
      status: RequestStatus.pending,
      note: note,
      requestedAt: DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
    );
  }

  /// Cashier marks request handled.
  StaffRequest markHandled({
    required StaffRequest request,
    required String handledByUserId,
  }) {
    if (request.status != RequestStatus.pending) {
      throw const RequestRuleException(
        'Only pending requests can be handled',
        code: 'REQUEST_NOT_PENDING',
      );
    }
    final now = DateTime.now().toUtc();
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
