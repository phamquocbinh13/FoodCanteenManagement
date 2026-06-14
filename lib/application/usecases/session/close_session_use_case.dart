import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../../domain/repositories/session_repository.dart';
import '../use_case.dart';

/// Closes session with payment snapshot. Sprint 9.
final class CloseSessionUseCase implements UseCase<Object?, CloseSessionParams> {
  CloseSessionUseCase({
    required SessionRepository sessionRepository,
    required PaymentRepository paymentRepository,
  })  : _sessionRepository = sessionRepository,
        _paymentRepository = paymentRepository;

  // ignore: unused_field
  final SessionRepository _sessionRepository;
  // ignore: unused_field
  final PaymentRepository _paymentRepository;

  @override
  Future<Result<Object?>> call(CloseSessionParams params) async {
    return const Err(UnknownFailure('CloseSessionUseCase not implemented'));
  }
}

final class CloseSessionParams {
  const CloseSessionParams({
    required this.sessionId,
    required this.restaurantId,
  });

  final String sessionId;
  final String restaurantId;
}
