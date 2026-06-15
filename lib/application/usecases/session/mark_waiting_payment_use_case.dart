import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../policies/session_policy.dart';
import 'session_snapshot_helpers.dart';
import '../use_case.dart';

/// Transitions session to waiting-for-payment. Extension point for payment flow.
final class MarkWaitingPaymentUseCase
    implements UseCase<SessionEngineSnapshot, MarkWaitingPaymentParams> {
  MarkWaitingPaymentUseCase({
    required SessionEngineRepository repository,
    required SessionPolicy policy,
    required Clock clock,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
  })  : _repository = repository,
        _policy = policy,
        _clock = clock,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher;

  final SessionEngineRepository _repository;
  final SessionPolicy _policy;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;

  @override
  Future<Result<SessionEngineSnapshot>> call(
    MarkWaitingPaymentParams params,
  ) async {
    final active = await _repository.restoreActiveSessions(params.restaurantId);
    if (active is Success<List<SessionEngineSnapshot>>) {
      final match = findSessionById(active.value, params.sessionId);
      if (match != null) {
        final policyResult =
            _policy.canRequestPayment(status: match.session.status);
        if (policyResult is Err<void>) {
          return Err(policyResult.failure);
        }
      }
    }

    final now = _clock.now();
    final result = await _repository.markWaitingPayment(
      sessionId: params.sessionId,
      restaurantId: params.restaurantId,
      now: now,
    );

    if (result is Success<SessionEngineSnapshot>) {
      await _eventPublisher.publish(
        WaitingPaymentEntered(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: params.sessionId,
        ),
      );
      await _eventPublisher.publish(
        PaymentRequested(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: params.sessionId,
        ),
      );
    }

    return result;
  }
}

final class MarkWaitingPaymentParams {
  const MarkWaitingPaymentParams({
    required this.sessionId,
    required this.restaurantId,
  });

  final String sessionId;
  final String restaurantId;
}
