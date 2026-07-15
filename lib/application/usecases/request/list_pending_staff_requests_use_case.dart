import '../../../core/result/result.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../request/staff_request_view_models.dart';
import '../use_case.dart';

/// Lists pending call-staff requests for the cashier queue.
final class ListPendingStaffRequestsUseCase
    implements
        UseCase<List<StaffRequestQueueItemView>, ListPendingStaffRequestsParams> {
  ListPendingStaffRequestsUseCase({
    required RequestRepository requestRepository,
    required SessionEngineDataSource sessionDataSource,
  })  : _requestRepository = requestRepository,
        _sessionDataSource = sessionDataSource;

  final RequestRepository _requestRepository;
  final SessionEngineDataSource _sessionDataSource;

  @override
  Future<Result<List<StaffRequestQueueItemView>>> call(
    ListPendingStaffRequestsParams params,
  ) async {
    final pending = await _requestRepository.listPendingByRestaurant(
      params.restaurantId,
    );

    final items = <StaffRequestQueueItemView>[];
    for (final request in pending) {
      final session = _sessionDataSource.getSession(request.sessionId);
      final table = session == null
          ? null
          : _sessionDataSource.getTable(session.tableId);
      items.add(
        StaffRequestQueueItemView(
          request: request,
          tableLabel: table?.label ?? 'Table',
          sessionDisplayNumber: session?.displayNumber ?? '—',
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
