import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
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
}

final class SessionCartRepositoryImpl implements SessionCartRepository {
  SessionCartRepositoryImpl({required OrderingStore store}) : _store = store;

  final OrderingStore _store;

  @override
  Future<Result<SessionCart>> getOrCreateCart({
    required String sessionId,
    required DateTime now,
  }) async {
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
    return const Success(null);
  }

  @override
  Future<Result<void>> clearCart(String sessionId) async {
    final cart = _store.cartsBySessionId[sessionId];
    if (cart != null) {
      _store.cartItemsByCartId[cart.id] = [];
    }
    return const Success(null);
  }
}
