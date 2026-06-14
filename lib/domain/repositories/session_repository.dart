import '../entities/dine_in_session.dart';
import '../entities/kitchen_batch.dart';
import '../entities/restaurant_table.dart';
import '../entities/session_auth_token.dart';
import '../entities/session_cart.dart';
import '../entities/session_cart_item.dart';
import '../entities/session_device.dart';
import '../entities/session_timeline_event.dart';
import '../entities/table_qr_token_record.dart';

/// Persistence contract for dine-in session aggregate.
///
/// Implementation belongs in data layer. No Flutter, no API specifics.
abstract interface class SessionRepository {
  Future<DineInSession?> findActiveByTableId({
    required String restaurantId,
    required String tableId,
  });

  Future<DineInSession?> findById({
    required String restaurantId,
    required String sessionId,
  });

  Future<DineInSession> create(DineInSession session);

  Future<DineInSession> update(DineInSession session);

  Future<SessionAuthToken> issueToken(SessionAuthToken token);

  Future<SessionAuthToken?> findActiveTokenBySessionId(String sessionId);

  Future<SessionCart> getOrCreateCart(String sessionId);

  Future<SessionCart> updateCart(SessionCart cart);

  Future<List<SessionCartItem>> getCartItems(String sessionCartId);

  Future<SessionCartItem> addCartItem(SessionCartItem item);

  Future<void> removeCartItem(String sessionCartId, String itemId);

  Future<void> clearCart(String sessionCartId);

  Future<SessionDevice> registerDevice(SessionDevice device);

  Future<SessionTimelineEvent> appendTimelineEvent(SessionTimelineEvent event);

  Future<List<KitchenBatch>> getBatchesBySessionId(String sessionId);

  Future<TableQrTokenRecord?> resolveJoinToken(String tokenHash);

  Future<RestaurantTable?> getTableById({
    required String restaurantId,
    required String tableId,
  });
}
