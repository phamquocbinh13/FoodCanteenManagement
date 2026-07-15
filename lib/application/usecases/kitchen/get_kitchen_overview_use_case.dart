import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../kitchen/kitchen_overview_view.dart';
import '../use_case.dart';

/// Staff: aggregate kitchen awareness board (backend-owned).
final class GetKitchenOverviewUseCase
    implements UseCase<KitchenOverviewView, GetKitchenOverviewParams> {
  GetKitchenOverviewUseCase({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Result<KitchenOverviewView>> call(
    GetKitchenOverviewParams params,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/${params.restaurantId}/kitchen/overview',
        ),
      );
      return Success(KitchenOverviewView.fromJson(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class GetKitchenOverviewParams {
  const GetKitchenOverviewParams({required this.restaurantId});

  final String restaurantId;
}
