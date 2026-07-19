import '../../../core/network/api_client.dart';
import '../../../domain/repositories/restaurant_repository.dart';

class RemoteRestaurantRepository implements RestaurantRepository {
  final ApiClient _apiClient;

  RemoteRestaurantRepository(this._apiClient);

  @override
  Future<Restaurant?> findById(String restaurantId) async {
    return null; // Not needed for admin dashboard settings update yet
  }

  @override
  Future<Restaurant?> findBySlug(String slug) async {
    return null; 
  }

  @override
  Future<RestaurantSettings?> getSettings(String restaurantId) async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        const ApiRequest(path: '/settings', method: HttpMethod.get),
      );
      return RestaurantSettings.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<RestaurantSettings> updateSettings(Map<String, dynamic> data) async {
    final response = await _apiClient.send<Map<String, dynamic>>(
      ApiRequest(path: '/settings', method: HttpMethod.put, body: data),
    );
    return RestaurantSettings.fromJson(response.data);
  }
}
