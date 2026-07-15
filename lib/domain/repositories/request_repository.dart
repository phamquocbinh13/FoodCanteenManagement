import '../entities/staff_request.dart';

/// Persistence contract for customer call-staff request queue.
abstract interface class RequestRepository {
  Future<StaffRequest> create(StaffRequest request);

  Future<StaffRequest> update(StaffRequest request);

  Future<StaffRequest?> findById(String requestId);

  Future<List<StaffRequest>> listPendingByRestaurant(String restaurantId);

  Future<List<StaffRequest>> listBySessionId(String sessionId);
}
