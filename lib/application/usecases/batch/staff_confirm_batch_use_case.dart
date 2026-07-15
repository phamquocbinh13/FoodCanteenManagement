import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../menu/kitchen_batch_ticket.dart';
import '../use_case.dart';

/// Staff: confirm session cart → new kitchen batch
/// (`POST /restaurants/:rid/sessions/:sid/batches/confirm`).
final class StaffConfirmBatchUseCase
    implements UseCase<KitchenBatchTicket, StaffConfirmBatchParams> {
  StaffConfirmBatchUseCase({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Result<KitchenBatchTicket>> call(StaffConfirmBatchParams params) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${params.restaurantId}/sessions/${params.sessionId}/batches/confirm',
          method: HttpMethod.post,
          body: {
            'actorType': 'user',
            if (params.actorId != null) 'actorId': params.actorId,
          },
        ),
      );
      final data = response.data;
      final batch = RemoteJson.parse(
        data['batch'] as Map<String, dynamic>,
        KitchenBatch.fromJson,
      );
      final items = RemoteJson.parseList(
        data['items'] as List<dynamic>? ?? const [],
        BatchItem.fromJson,
      );
      return Success(
        KitchenBatchTicket(
          batch: batch,
          tableLabel: data['tableLabel'] as String? ?? params.sessionId,
          items: items,
        ),
      );
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class StaffConfirmBatchParams {
  const StaffConfirmBatchParams({
    required this.restaurantId,
    required this.sessionId,
    this.actorId,
  });

  final String restaurantId;
  final String sessionId;
  final String? actorId;
}
