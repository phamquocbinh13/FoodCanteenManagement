import '../../../core/network/api_client.dart';
import '../../../domain/entities/role.dart';
import '../../../domain/entities/staff_user.dart';
import '../../../domain/entities/user_role.dart';
import '../../../domain/repositories/restaurant_repository.dart';

class RemoteUserRepository implements UserRepository {
  final ApiClient _apiClient;

  RemoteUserRepository(this._apiClient);

  @override
  Future<StaffUser?> findByEmail({required String restaurantId, required String email}) async {
    // Only used for local lookup or caching in this simplified architecture.
    // In remote architecture, we can fetch all and filter, or just return null for now.
    final allStaff = await getAllStaff(restaurantId);
    return allStaff.where((s) => s.email == email).firstOrNull;
  }

  @override
  Future<StaffUser?> findById(String userId) async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        ApiRequest(path: '/staff/$userId', method: HttpMethod.get),
      );
      return StaffUser.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<StaffUser>> getAllStaff(String restaurantId) async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        ApiRequest(
          path: '/staff', 
          method: HttpMethod.get,
          headers: {'x-restaurant-id': restaurantId},
        ),
      );
      return response.data.map((e) => StaffUser.fromJson(e)).toList();
    } catch (e, st) {
      print('getAllStaff error: $e');
      print(st);
      return [];
    }
  }

  Future<StaffUser> createStaff(String restaurantId, Map<String, dynamic> data) async {
    final response = await _apiClient.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/staff', 
        method: HttpMethod.post, 
        body: data,
        headers: {'x-restaurant-id': restaurantId},
      ),
    );
    return StaffUser.fromJson(response.data);
  }

  Future<StaffUser> updateStaff(String restaurantId, String userId, Map<String, dynamic> data) async {
    final response = await _apiClient.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/staff/$userId', 
        method: HttpMethod.put, 
        body: data,
        headers: {'x-restaurant-id': restaurantId},
      ),
    );
    return StaffUser.fromJson(response.data);
  }

  Future<void> assignRoles(String userId, List<String> roleIds) async {
    await _apiClient.send(
      ApiRequest(path: '/roles/staff/$userId', method: HttpMethod.put, body: {'roleIds': roleIds}),
    );
  }

  Future<List<Role>> getAllRoles() async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        const ApiRequest(path: '/roles', method: HttpMethod.get),
      );
      return response.data.map((e) => Role.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Role>> getRolesForUser(String userId) async {
    return []; // Handled within StaffUser model directly via `user_role` mapping usually
  }

  @override
  Future<List<UserRole>> getUserRoles(String userId) async {
    return [];
  }
}
