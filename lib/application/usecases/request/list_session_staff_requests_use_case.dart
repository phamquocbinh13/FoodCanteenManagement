import '../../../core/result/result.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/repositories/request_repository.dart';
import '../use_case.dart';

/// Lists staff requests for a single dine-in session (customer history).
final class ListSessionStaffRequestsUseCase
    implements UseCase<List<StaffRequest>, ListSessionStaffRequestsParams> {
  ListSessionStaffRequestsUseCase({
    required RequestRepository requestRepository,
  }) : _requestRepository = requestRepository;

  final RequestRepository _requestRepository;

  @override
  Future<Result<List<StaffRequest>>> call(
    ListSessionStaffRequestsParams params,
  ) async {
    final requests = await _requestRepository.listBySessionId(params.sessionId);
    return Success(requests);
  }
}

final class ListSessionStaffRequestsParams {
  const ListSessionStaffRequestsParams({required this.sessionId});

  final String sessionId;
}
