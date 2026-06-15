import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../datasources/cart/cart_local_datasource.dart';
import '../../datasources/ordering/ordering_store.dart';

/// Cart persistence contract for dine-in sessions.
abstract interface class SessionCartRepository {
  Future<Result<SessionCart>> getOrCreateCart({
    required String sessionId,
    required DateTime now,
  });

  Future<Result<List<SessionCartItem>>> getCartItems(String sessionCartId);

  Future<Result<SessionCartItem>> saveCartItem(SessionCartItem item);

  Future<Result<void>> removeCartItem({
    required String sessionCartId,
    required String itemId,
  });

  Future<Result<void>> clearCart(String sessionId);

  Future<Result<SessionCartItem?>> findCartItem({
    required String sessionCartId,
    required String itemId,
  });
}

final class SessionCartRepositoryImpl implements SessionCartRepository {
  SessionCartRepositoryImpl({
    required OrderingStore store,
    required CartLocalDataSource localDataSource,
  })  : _store = store,
        _localDataSource = localDataSource;

  final OrderingStore _store;
  final CartLocalDataSource _localDataSource;

  @override
  Future<Result<SessionCart>> getOrCreateCart({
    required String sessionId,
    required DateTime now,
  }) async {
    await _restoreFromLocal(sessionId);

    final existing = _store.cartsBySessionId[sessionId];
    if (existing != null) return Success(existing);

    final cart = SessionCart(
      id: 'cart-$sessionId',
      sessionId: sessionId,
      createdAt: now,
      updatedAt: now,
    );
    _store.cartsBySessionId[sessionId] = cart;
    _store.cartItemsByCartId[cart.id] = [];
    await _persist(sessionId);
    return Success(cart);
  }

  @override
  Future<Result<List<SessionCartItem>>> getCartItems(String sessionCartId) async {
    return Success(List.unmodifiable(_store.cartItemsByCartId[sessionCartId] ?? []));
  }

  @override
  Future<Result<SessionCartItem>> saveCartItem(SessionCartItem item) async {
    final items = _store.cartItemsByCartId.putIfAbsent(
      item.sessionCartId,
      () => [],
    );
    final index = items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }

    final sessionId = _sessionIdForCart(item.sessionCartId);
    if (sessionId != null) {
      await _persist(sessionId);
    }
    return Success(item);
  }

  @override
  Future<Result<void>> removeCartItem({
    required String sessionCartId,
    required String itemId,
  }) async {
    final items = _store.cartItemsByCartId[sessionCartId];
    if (items == null) {
      return const Err(NotFoundFailure('Cart not found'));
    }
    items.removeWhere((i) => i.id == itemId);

    final sessionId = _sessionIdForCart(sessionCartId);
    if (sessionId != null) {
      await _persist(sessionId);
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> clearCart(String sessionId) async {
    final cart = _store.cartsBySessionId[sessionId];
    if (cart != null) {
      _store.cartItemsByCartId[cart.id] = [];
      await _localDataSource.clear(sessionId);
    }
    return const Success(null);
  }

  @override
  Future<Result<SessionCartItem?>> findCartItem({
    required String sessionCartId,
    required String itemId,
  }) async {
    final items = _store.cartItemsByCartId[sessionCartId] ?? [];
    for (final item in items) {
      if (item.id == itemId) return Success(item);
    }
    return const Success(null);
  }

  Future<void> _restoreFromLocal(String sessionId) async {
    if (_store.cartsBySessionId.containsKey(sessionId)) return;

    final saved = await _localDataSource.load(sessionId);
    if (saved == null) return;

    _store.cartsBySessionId[sessionId] = saved.cart;
    _store.cartItemsByCartId[saved.cart.id] = List.of(saved.items);
  }

  Future<void> _persist(String sessionId) async {
    final cart = _store.cartsBySessionId[sessionId];
    if (cart == null) {
      await _localDataSource.clear(sessionId);
      return;
    }
    final items = _store.cartItemsByCartId[cart.id] ?? [];
    if (items.isEmpty) {
      await _localDataSource.clear(sessionId);
      return;
    }
    await _localDataSource.save(
      sessionId: sessionId,
      cart: cart,
      items: items,
    );
  }

  String? _sessionIdForCart(String sessionCartId) {
    for (final entry in _store.cartsBySessionId.entries) {
      if (entry.value.id == sessionCartId) return entry.key;
    }
    return null;
  }
}
