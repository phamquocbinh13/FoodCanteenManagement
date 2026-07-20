import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../kitchen/kitchen_workflow_view.dart';
import '../use_case.dart';

/// Staff: aggregate kitchen workflow board (backend-owned).
final class GetKitchenWorkflowUseCase
    implements UseCase<KitchenWorkflowView, GetKitchenWorkflowParams> {
  GetKitchenWorkflowUseCase({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Result<KitchenWorkflowView>> call(
    GetKitchenWorkflowParams params,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/${params.restaurantId}/kitchen/workflow',
        ),
      );
      return Success(KitchenWorkflowView.fromJson(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class GetKitchenWorkflowParams {
  const GetKitchenWorkflowParams({required this.restaurantId});

  final String restaurantId;
}
