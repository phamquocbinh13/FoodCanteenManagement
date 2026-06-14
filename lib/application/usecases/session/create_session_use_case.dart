import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/session_repository.dart';
import '../use_case.dart';

/// Opens a new dine-in session. Implementation deferred to Sprint 3.
final class CreateSessionUseCase implements UseCase<Object?, CreateSessionParams> {
  CreateSessionUseCase({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository;

  // ignore: unused_field
  final SessionRepository _sessionRepository;

  @override
  Future<Result<Object?>> call(CreateSessionParams params) async {
    return const Err(UnknownFailure('CreateSessionUseCase not implemented'));
  }
}

final class CreateSessionParams {
  const CreateSessionParams({
    required this.restaurantId,
    required this.tableId,
    required this.openedVia,
  });

  final String restaurantId;
  final String tableId;
  final String openedVia;
}
