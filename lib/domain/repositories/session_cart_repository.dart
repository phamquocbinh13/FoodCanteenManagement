import '../../core/result/result.dart';
import '../entities/session_cart.dart';
import '../entities/session_cart_item.dart';

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
