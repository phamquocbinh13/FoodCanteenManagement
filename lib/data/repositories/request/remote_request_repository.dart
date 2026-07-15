import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/json_key_codec.dart';
import '../../../core/network/session_token_headers.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../datasources/customer/customer_session_local_datasource.dart';
import '../../../application/session/session_constants.dart';

/// [RequestRepository] backed by NestJS Request APIs.
final class RemoteRequestRepository implements RequestRepository {
  RemoteRequestRepository({
    required ApiClient apiClient,
    required CustomerSessionLocalDataSource localSession,
    String restaurantId = SessionEngineConstants.demoRestaurantId,
  })  : _api = apiClient,
        _local = localSession,
        _restaurantId = restaurantId;

  final ApiClient _api;
  final CustomerSessionLocalDataSource _local;
  final String _restaurantId;

  final Map<String, StaffRequest> _byId = {};

  StaffRequest _parse(Map<String, dynamic> json) {
    final request = StaffRequest.fromJson(camelCaseKeysToSnake(json));
    _byId[request.id] = request;
    return request;
  }

  String _requestType(RequestType value) => switch (value) {
        RequestType.payment => 'payment',
        RequestType.staffAssistance => 'staff_assistance',
        RequestType.extraWater => 'extra_water',
        RequestType.extraBowl => 'extra_bowl',
        RequestType.extraSpoon => 'extra_spoon',
      };

  @override
  Future<StaffRequest> create(StaffRequest request) async {
    final headers = await customerSessionHeaders(_local);
    try {
      if (headers.isNotEmpty) {
        final response = await _api.send<Map<String, dynamic>>(
          ApiRequest(
            path: '/sessions/me/requests',
            method: HttpMethod.post,
            requiresAuth: false,
            headers: headers,
            body: {
              'requestType': _requestType(request.requestType),
              if (request.note != null) 'note': request.note,
            },
          ),
        );
        return _parse(response.data);
      }

      // Staff cannot create customer requests without a session token in Stage A.
      // Fall back to customer-shaped create is unavailable — persist via pending
      // list is not supported; surface as error by reusing session path failure.
      throw const UnauthorizedException(
        'Customer session token required to create staff request',
        code: 'SESSION_TOKEN_REQUIRED',
      );
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<StaffRequest> update(StaffRequest request) async {
    try {
      if (request.status == RequestStatus.handled) {
        final response = await _api.send<Map<String, dynamic>>(
          ApiRequest(
            path:
                '/restaurants/${request.restaurantId}/requests/${request.id}/handle',
            method: HttpMethod.post,
            body: {
              if (request.handledByUserId != null)
                'handledByUserId': request.handledByUserId,
            },
          ),
        );
        return _parse(response.data);
      }
      _byId[request.id] = request;
      return request;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<StaffRequest?> findById(String requestId) async {
    final cached = _byId[requestId];
    if (cached != null) return cached;

    // No get-by-id endpoint — refresh pending queue for default restaurant.
    await listPendingByRestaurant(_restaurantId);
    return _byId[requestId];
  }

  @override
  Future<List<StaffRequest>> listPendingByRestaurant(
    String restaurantId,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/requests/pending'),
      );
      return (response.data['requests'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parse)
          .toList();
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<List<StaffRequest>> listBySessionId(String sessionId) async {
    final headers = await customerSessionHeaders(_local);
    try {
      if (headers.isNotEmpty) {
        final response = await _api.send<Map<String, dynamic>>(
          ApiRequest(
            path: '/sessions/me/requests',
            requiresAuth: false,
            headers: headers,
          ),
        );
        final requests = (response.data['requests'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .map(_parse)
            .where((r) => r.sessionId == sessionId)
            .toList();
        return requests;
      }

      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$_restaurantId/sessions/$sessionId/requests',
        ),
      );
      return (response.data['requests'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parse)
          .toList();
    } catch (e) {
      throw failureFromException(e);
    }
  }
}
