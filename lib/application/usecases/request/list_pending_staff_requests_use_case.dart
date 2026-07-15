import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../request/staff_request_view_models.dart';
import '../use_case.dart';

/// Lists pending call-staff requests for the cashier queue.
final class ListPendingStaffRequestsUseCase
    implements
        UseCase<List<StaffRequestQueueItemView>, ListPendingStaffRequestsParams> {
  ListPendingStaffRequestsUseCase({
    required RequestRepository requestRepository,
    required SessionEngineRepository sessionEngineRepository,
  })  : _requestRepository = requestRepository,
        _sessionEngine = sessionEngineRepository;

  final RequestRepository _requestRepository;
  final SessionEngineRepository _sessionEngine;

  @override
  Future<Result<List<StaffRequestQueueItemView>>> call(
    ListPendingStaffRequestsParams params,
  ) async {
    final pending = await _requestRepository.listPendingByRestaurant(
      params.restaurantId,
    );

    final items = <StaffRequestQueueItemView>[];
    for (final request in pending) {
      final sessionResult = await _sessionEngine.findById(
        sessionId: request.sessionId,
        restaurantId: params.restaurantId,
      );
      final snapshot = sessionResult is Success<SessionEngineSnapshot>
          ? sessionResult.value
          : null;
      items.add(
        StaffRequestQueueItemView(
          request: request,
          tableLabel: snapshot?.tableLabel ?? 'Table',
          sessionDisplayNumber: snapshot?.session.displayNumber ?? '—',
        ),
      );
    }

    return Success(items);
  }
}

final class ListPendingStaffRequestsParams {
  const ListPendingStaffRequestsParams({required this.restaurantId});

  final String restaurantId;
}
