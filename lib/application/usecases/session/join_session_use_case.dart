import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../policies/session_policy.dart';
import '../use_case.dart';

/// Customer joins an active session using a bearer token (never table number).
final class JoinSessionUseCase
    implements UseCase<SessionEngineSnapshot, JoinSessionParams> {
  JoinSessionUseCase({
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
  Future<Result<SessionEngineSnapshot>> call(JoinSessionParams params) async {
    final now = _clock.now();
    final lookup = await _repository.validateToken(params.sessionToken);
    if (lookup is Err<SessionEngineSnapshot>) {
      return Err(lookup.failure);
    }

    final snapshot = (lookup as Success<SessionEngineSnapshot>).value;
    final policyResult = _policy.canJoin(
      status: snapshot.session.status,
      token: snapshot.activeToken,
      now: now,
    );
    if (policyResult is Err<void>) {
      return Err(policyResult.failure);
    }

    final joinResult = await _repository.join(
      sessionTokenValue: params.sessionToken,
      now: now,
      deviceId: params.deviceId,
    );

    if (joinResult is Success<SessionEngineSnapshot>) {
      await _eventPublisher.publish(
        CustomerJoined(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: joinResult.value.session.id,
          deviceId: params.deviceId,
        ),
      );
    }

    return joinResult;
  }
}

final class JoinSessionParams {
  const JoinSessionParams({
    required this.sessionToken,
    this.deviceId,
  });

  final String sessionToken;
  final String? deviceId;
}
