import '../../../application/session/session_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/session_token_headers.dart';
import '../../../core/result/result.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../../datasources/customer/customer_session_local_datasource.dart';

/// [SessionCartRepository] backed by NestJS Cart APIs (`/sessions/me/cart*`).
final class RemoteSessionCartRepository implements SessionCartRepository {
  RemoteSessionCartRepository({
    required ApiClient apiClient,
    required CustomerSessionLocalDataSource localSession,
    String restaurantId = SessionEngineConstants.demoRestaurantId,
  })  : _api = apiClient,
        _local = localSession,
        _restaurantId = restaurantId;

  final ApiClient _api;
  final CustomerSessionLocalDataSource _local;
  final String _restaurantId;

  final Map<String, String> _sessionIdByCartId = {};
  final Map<String, SessionCart> _cartsBySessionId = {};

  SessionCart _parseCart(Map<String, dynamic> json) =>
      RemoteJson.parse(json, SessionCart.fromJson);

  SessionCartItem _parseItem(Map<String, dynamic> json) =>
      RemoteJson.parse(json, SessionCartItem.fromJson);

  Future<Map<String, String>> _headers() => customerSessionHeaders(_local);

  Future<ApiResponse<Map<String, dynamic>>> _sendCart({
    required String sessionId,
    required String relativePath,
    HttpMethod method = HttpMethod.get,
    Object? body,
  }) async {
    final headers = await _headers();
    if (headers.isNotEmpty) {
      return _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me/cart$relativePath',
          method: method,
          requiresAuth: false,
          headers: headers,
          body: body,
        ),
      );
    }

    // Staff JWT path when no customer session token is present.
    return _api.send<Map<String, dynamic>>(
      ApiRequest(
        path:
            '/restaurants/$_restaurantId/sessions/$sessionId/cart$relativePath',
        method: method,
        body: body,
      ),
    );
  }

  void _rememberCart(SessionCart cart) {
    _cartsBySessionId[cart.sessionId] = cart;
    _sessionIdByCartId[cart.id] = cart.sessionId;
  }

  String? _sessionIdForCart(String sessionCartId) =>
      _sessionIdByCartId[sessionCartId] ??
      _cartsBySessionId.entries
          .where((e) => e.value.id == sessionCartId)
          .map((e) => e.key)
          .firstOrNull;

  @override
  Future<Result<SessionCart>> getOrCreateCart({
    required String sessionId,
    required DateTime now,
  }) async {
    try {
      final response = await _sendCart(sessionId: sessionId, relativePath: '');
      final cart = _parseCart(response.data['cart'] as Map<String, dynamic>);
      _rememberCart(cart);
      return Success(cart);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<List<SessionCartItem>>> getCartItems(
    String sessionCartId,
  ) async {
    final sessionId = _sessionIdForCart(sessionCartId);
    if (sessionId == null) {
      return const Err(NotFoundFailure('Cart not found'));
    }
    try {
      final response = await _sendCart(sessionId: sessionId, relativePath: '');
      final cart = _parseCart(response.data['cart'] as Map<String, dynamic>);
      _rememberCart(cart);
      final items = (response.data['items'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parseItem)
          .toList();
      return Success(items);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionCartItem>> saveCartItem(SessionCartItem item) async {
    final sessionId = _sessionIdForCart(item.sessionCartId);
    if (sessionId == null) {
      return const Err(NotFoundFailure('Cart not found'));
    }

    try {
      final existing = await findCartItem(
        sessionCartId: item.sessionCartId,
        itemId: item.id,
      );
      if (existing is Err<SessionCartItem?>) return Err(existing.failure);

      if (existing is Success<SessionCartItem?> && existing.value != null) {
        await _sendCart(
          sessionId: sessionId,
          relativePath: '/items/${item.id}',
          method: HttpMethod.patch,
          body: {'quantity': item.quantity.value},
        );
        final response = await _sendCart(
          sessionId: sessionId,
          relativePath: '/items/${item.id}',
          method: HttpMethod.put,
          body: {'selectionsJson': item.selectionsJson},
        );
        final items = (response.data['items'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .map(_parseItem);
        final updated = items.firstWhere(
          (i) => i.id == item.id,
          orElse: () => item,
        );
        return Success(updated);
      }

      // New line — POST and return server-created item.
      final beforeIds = <String>{};
      final before = await getCartItems(item.sessionCartId);
      if (before is Success<List<SessionCartItem>>) {
        beforeIds.addAll(before.value.map((i) => i.id));
      }

      final response = await _sendCart(
        sessionId: sessionId,
        relativePath: '/items',
        method: HttpMethod.post,
        body: {
          'menuItemId': item.menuItemId,
          'quantity': item.quantity.value,
          'selectionsJson': item.selectionsJson,
        },
      );
      final cart = _parseCart(response.data['cart'] as Map<String, dynamic>);
      _rememberCart(cart);
      final items = (response.data['items'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parseItem)
          .toList();
      SessionCartItem? created;
      for (final i in items) {
        if (!beforeIds.contains(i.id)) {
          created = i;
          break;
        }
      }
      created ??= items.isNotEmpty ? items.last : null;
      if (created == null) {
        return const Err(UnknownFailure('Cart item was not created'));
      }
      return Success(created);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<void>> removeCartItem({
    required String sessionCartId,
    required String itemId,
  }) async {
    final sessionId = _sessionIdForCart(sessionCartId);
    if (sessionId == null) {
      return const Err(NotFoundFailure('Cart not found'));
    }
    try {
      await _sendCart(
        sessionId: sessionId,
        relativePath: '/items/$itemId',
        method: HttpMethod.delete,
      );
      return const Success(null);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<void>> clearCart(String sessionId) async {
    try {
      await _sendCart(
        sessionId: sessionId,
        relativePath: '',
        method: HttpMethod.delete,
      );
      final cart = _cartsBySessionId.remove(sessionId);
      if (cart != null) _sessionIdByCartId.remove(cart.id);
      return const Success(null);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionCartItem?>> findCartItem({
    required String sessionCartId,
    required String itemId,
  }) async {
    final itemsResult = await getCartItems(sessionCartId);
    if (itemsResult is Err<List<SessionCartItem>>) {
      return Err(itemsResult.failure);
    }
    final items = (itemsResult as Success<List<SessionCartItem>>).value;
    for (final item in items) {
      if (item.id == itemId) return Success(item);
    }
    return const Success(null);
  }
}
