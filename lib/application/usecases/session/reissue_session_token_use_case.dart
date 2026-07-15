import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../use_case.dart';

/// Staff: revoke active join token and issue a new QR/session code.
final class ReissueSessionTokenUseCase
    implements UseCase<SessionAccess, ReissueSessionTokenParams> {
  ReissueSessionTokenUseCase({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<Result<SessionAccess>> call(ReissueSessionTokenParams params) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${params.restaurantId}/sessions/${params.sessionId}/reissue-token',
          method: HttpMethod.post,
          body: const {},
        ),
      );
      final data = response.data;
      final token = data['sessionToken'] as String? ?? '';
      final snapshot = RemoteJson.parse(
        data['snapshot'] as Map<String, dynamic>? ?? data,
        SessionEngineSnapshot.fromJson,
      );
      return Success(
        SessionAccess(snapshot: snapshot, sessionTokenValue: token),
      );
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class ReissueSessionTokenParams {
  const ReissueSessionTokenParams({
    required this.restaurantId,
    required this.sessionId,
  });

  final String restaurantId;
  final String sessionId;
}
