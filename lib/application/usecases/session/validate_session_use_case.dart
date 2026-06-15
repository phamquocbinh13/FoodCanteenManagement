import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../policies/session_policy.dart';
import '../use_case.dart';

/// Validates a session bearer token without mutating state.
final class ValidateSessionUseCase
    implements UseCase<SessionEngineSnapshot, ValidateSessionParams> {
  ValidateSessionUseCase({
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
    ValidateSessionParams params,
  ) async {
    final result = await _repository.validateToken(params.sessionToken);
    if (result is Err<SessionEngineSnapshot>) {
      return Err(result.failure);
    }

    final snapshot = (result as Success<SessionEngineSnapshot>).value;
    final policyResult = _policy.canJoin(
      status: snapshot.session.status,
      token: snapshot.activeToken,
      now: _clock.now(),
    );
    if (policyResult is Err<void>) {
      return Err(policyResult.failure);
    }

    return result;
  }
}

final class ValidateSessionParams {
  const ValidateSessionParams({required this.sessionToken});

  final String sessionToken;
}
