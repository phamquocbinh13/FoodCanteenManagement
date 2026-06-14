import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/session_repository.dart';
import '../use_case.dart';

/// Resolves QR join token and attaches customer to session. Sprint 4.
final class JoinSessionUseCase implements UseCase<Object?, JoinSessionParams> {
  JoinSessionUseCase({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository;

  // ignore: unused_field
  final SessionRepository _sessionRepository;

  @override
  Future<Result<Object?>> call(JoinSessionParams params) async {
    return const Err(UnknownFailure('JoinSessionUseCase not implemented'));
  }
}

final class JoinSessionParams {
  const JoinSessionParams({required this.joinToken});

  final String joinToken;
}
