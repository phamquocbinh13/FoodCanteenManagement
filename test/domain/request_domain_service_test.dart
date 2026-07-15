import 'package:flutter_test/flutter_test.dart';
import 'package:food_canteen_management/domain/entities/dine_in_session.dart';
import 'package:food_canteen_management/domain/entities/staff_request.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/exceptions/domain_exception.dart';
import 'package:food_canteen_management/domain/services/request_domain_service.dart';

void main() {
  const service = RequestDomainService();
  final now = DateTime.utc(2026, 7, 15, 10);

  DineInSession openSession() => DineInSession(
        id: 's1',
        restaurantId: 'r1',
        tableId: 't1',
        sessionNumber: 1,
        displayNumber: 'S-001',
        status: SessionStatus.open,
        openedVia: SessionOpenedVia.qrScan,
        openedAt: now,
        createdAt: now,
        updatedAt: now,
      );

  group('RequestDomainService', () {
    test('rejects create on closed session', () {
      final closed = openSession().copyWith(status: SessionStatus.closed);
      expect(
        () => service.validateCanCreateRequest(
          session: closed,
          requestType: RequestType.extraWater,
        ),
        throwsA(isA<RequestRuleException>()),
      );
    });

    test('rejects duplicate pending payment request', () {
      final existing = [
        StaffRequest(
          id: 'req1',
          restaurantId: 'r1',
          sessionId: 's1',
          requestType: RequestType.payment,
          requestedAt: now,
          createdAt: now,
        ),
      ];
      expect(
        () => service.validateNoDuplicatePendingPayment(
          requestType: RequestType.payment,
          existingForSession: existing,
        ),
        throwsA(isA<RequestRuleException>()),
      );
    });

    test('allows assistance when payment already pending', () {
      final existing = [
        StaffRequest(
          id: 'req1',
          restaurantId: 'r1',
          sessionId: 's1',
          requestType: RequestType.payment,
          requestedAt: now,
          createdAt: now,
        ),
      ];
      expect(
        () => service.validateNoDuplicatePendingPayment(
          requestType: RequestType.extraWater,
          existingForSession: existing,
        ),
        returnsNormally,
      );
    });

    test('markHandled transitions pending to handled', () {
      final request = service.createRequest(
        id: 'req1',
        restaurantId: 'r1',
        sessionId: 's1',
        requestType: RequestType.staffAssistance,
        now: now,
      );
      final handled = service.markHandled(
        request: request,
        handledByUserId: 'u1',
        now: now.add(const Duration(minutes: 2)),
      );
      expect(handled.status, RequestStatus.handled);
      expect(handled.handledByUserId, 'u1');
    });

    test('payment type triggers payment pending', () {
      expect(service.triggersPaymentPending(RequestType.payment), isTrue);
      expect(service.triggersPaymentPending(RequestType.extraBowl), isFalse);
    });
  });
}
