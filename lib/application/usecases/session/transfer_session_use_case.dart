import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../policies/session_policy.dart';
import 'session_snapshot_helpers.dart';
import '../use_case.dart';

/// Session table transfer — architecture prepared, implementation deferred.
final class TransferSessionUseCase
    implements UseCase<SessionEngineSnapshot, TransferSessionParams> {
  TransferSessionUseCase({
    required SessionEngineRepository repository,
    required SessionPolicy policy,
    required Clock clock,
  })  : _repository = repository,
        _policy = policy,
        _clock = clock;

  final SessionEngineRepository _repository;
  final SessionPolicy _policy;
  final Clock _clock;

  @override
  Future<Result<SessionEngineSnapshot>> call(
    TransferSessionParams params,
  ) async {
    final active = await _repository.restoreActiveSessions(params.restaurantId);
    if (active is Success<List<SessionEngineSnapshot>>) {
      final match = findSessionById(active.value, params.sessionId);
      if (match != null) {
        final policyResult =
            _policy.canTransfer(status: match.session.status);
        if (policyResult is Err<void>) {
          return Err(policyResult.failure);
        }
      }
    }

    return _repository.transfer(
      sessionId: params.sessionId,
      restaurantId: params.restaurantId,
      targetTableId: params.targetTableId,
      now: _clock.now(),
    );
  }
}

final class TransferSessionParams {
  const TransferSessionParams({
    required this.sessionId,
    required this.restaurantId,
    required this.targetTableId,
  });

  final String sessionId;
  final String restaurantId;
  final String targetTableId;
}
