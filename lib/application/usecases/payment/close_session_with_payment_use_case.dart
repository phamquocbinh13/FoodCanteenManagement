import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/json_key_codec.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_bill_line.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/entities/session_payment.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../use_case.dart';

/// Result of atomic payment close (API contract §8.2).
final class PaymentCloseResult {
  const PaymentCloseResult({
    required this.payment,
    required this.billLines,
    required this.snapshot,
  });

  final SessionPayment payment;
  final List<SessionBillLine> billLines;
  final SessionEngineSnapshot snapshot;
}

/// Staff closes a dine-in session with payment in one backend transaction.
final class CloseSessionWithPaymentUseCase
    implements UseCase<PaymentCloseResult, CloseSessionWithPaymentParams> {
  CloseSessionWithPaymentUseCase({
    required ApiClient apiClient,
    required DomainEventPublisher eventPublisher,
    required IdGenerator idGenerator,
    required Clock clock,
  })  : _api = apiClient,
        _eventPublisher = eventPublisher,
        _idGenerator = idGenerator,
        _clock = clock;

  final ApiClient _api;
  final DomainEventPublisher _eventPublisher;
  final IdGenerator _idGenerator;
  final Clock _clock;

  @override
  Future<Result<PaymentCloseResult>> call(
    CloseSessionWithPaymentParams params,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${params.restaurantId}/sessions/${params.sessionId}/payments',
          method: HttpMethod.post,
          body: {
            'paymentMethod': _paymentMethod(params.paymentMethod),
            'closeType': _closeType(params.closeType),
            if (params.forceCloseReason != null)
              'forceCloseReason': _forceReason(params.forceCloseReason!),
            if (params.forceCloseNote != null)
              'forceCloseNote': params.forceCloseNote,
          },
        ),
      );

      final data = response.data;
      final payment = SessionPayment.fromJson(
        camelCaseKeysToSnake(data['payment'] as Map<String, dynamic>),
      );
      final billLines = (data['billLines'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map((j) => SessionBillLine.fromJson(camelCaseKeysToSnake(j)))
          .toList();
      final snapshot = SessionEngineSnapshot.fromJson(
        camelCaseKeysToSnake(data['snapshot'] as Map<String, dynamic>),
      );

      final now = _clock.now();
      await _eventPublisher.publish(
        PaymentCompleted(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: payment.id,
          sessionId: params.sessionId,
          amountMinor: payment.totalAmount.amountMinor,
        ),
      );
      await _eventPublisher.publish(
        SessionClosedEvent(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: params.sessionId,
          tableId: snapshot.session.tableId,
        ),
      );

      return Success(
        PaymentCloseResult(
          payment: payment,
          billLines: billLines,
          snapshot: snapshot,
        ),
      );
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  String _paymentMethod(PaymentMethod value) => switch (value) {
        PaymentMethod.cash => 'cash',
        PaymentMethod.card => 'card',
        PaymentMethod.bankTransfer => 'bank_transfer',
        PaymentMethod.other => 'other',
      };

  String _closeType(SessionCloseType value) => switch (value) {
        SessionCloseType.payment => 'payment',
        SessionCloseType.forceClosed => 'force_closed',
      };

  String _forceReason(ForceCloseReason value) => switch (value) {
        ForceCloseReason.customerLeft => 'customer_left',
        ForceCloseReason.dispute => 'dispute',
        ForceCloseReason.systemError => 'system_error',
        ForceCloseReason.other => 'other',
      };
}

final class CloseSessionWithPaymentParams {
  const CloseSessionWithPaymentParams({
    required this.restaurantId,
    required this.sessionId,
    this.paymentMethod = PaymentMethod.cash,
    this.closeType = SessionCloseType.payment,
    this.forceCloseReason,
    this.forceCloseNote,
  });

  final String restaurantId;
  final String sessionId;
  final PaymentMethod paymentMethod;
  final SessionCloseType closeType;
  final ForceCloseReason? forceCloseReason;
  final String? forceCloseNote;
}
