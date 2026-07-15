import '../../../domain/entities/staff_request.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../datasources/ordering/ordering_store.dart';

/// In-memory [RequestRepository] backed by shared [OrderingStore].
final class RequestRepositoryImpl implements RequestRepository {
  RequestRepositoryImpl({required OrderingStore store}) : _store = store;

  final OrderingStore _store;

  @override
  Future<StaffRequest> create(StaffRequest request) async {
    _store.staffRequests[request.id] = request;
    return request;
  }

  @override
  Future<StaffRequest> update(StaffRequest request) async {
    _store.staffRequests[request.id] = request;
    return request;
  }

  @override
  Future<StaffRequest?> findById(String requestId) async {
    return _store.staffRequests[requestId];
  }

  @override
  Future<List<StaffRequest>> listPendingByRestaurant(
    String restaurantId,
  ) async {
    return _store.pendingRequestsForRestaurant(restaurantId);
  }

  @override
  Future<List<StaffRequest>> listBySessionId(String sessionId) async {
    return _store.staffRequests.values
        .where((r) => r.sessionId == sessionId)
        .toList()
      ..sort((a, b) => a.requestedAt.compareTo(b.requestedAt));
  }
}
