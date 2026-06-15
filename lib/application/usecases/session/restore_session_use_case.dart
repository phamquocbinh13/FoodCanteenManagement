import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../use_case.dart';

/// Restores active sessions for cashier app relaunch.
final class RestoreSessionUseCase
    implements UseCase<List<SessionEngineSnapshot>, RestoreSessionParams> {
  RestoreSessionUseCase({required SessionEngineRepository repository})
      : _repository = repository;

  final SessionEngineRepository _repository;

  @override
  Future<Result<List<SessionEngineSnapshot>>> call(
    RestoreSessionParams params,
  ) {
    return _repository.restoreActiveSessions(params.restaurantId);
  }
}

final class RestoreSessionParams {
  const RestoreSessionParams({required this.restaurantId});

  final String restaurantId;
}
