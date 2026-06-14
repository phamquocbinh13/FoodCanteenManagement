import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/entities/session_device.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/entities/table_qr_token_record.dart';
import '../../../domain/repositories/session_repository.dart';
import '../../datasources/session/session_datasource.dart';

/// Session repository implementation shell (Sprint 3).
final class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required SessionRemoteDataSource remote,
    SessionLocalDataSource? local,
  })  : _remote = remote,
        _local = local;

  // ignore: unused_field
  final SessionRemoteDataSource _remote;
  // ignore: unused_field
  final SessionLocalDataSource? _local;

  Never _notImplemented(String method) =>
      throw UnimplementedError('SessionRepositoryImpl.$method');

  @override
  Future<DineInSession?> findActiveByTableId({
    required String restaurantId,
    required String tableId,
  }) =>
      _notImplemented('findActiveByTableId');

  @override
  Future<DineInSession?> findById({
    required String restaurantId,
    required String sessionId,
  }) =>
      _notImplemented('findById');

  @override
  Future<DineInSession> create(DineInSession session) =>
      _notImplemented('create');

  @override
  Future<DineInSession> update(DineInSession session) =>
      _notImplemented('update');

  @override
  Future<SessionAuthToken> issueToken(SessionAuthToken token) =>
      _notImplemented('issueToken');

  @override
  Future<SessionAuthToken?> findActiveTokenBySessionId(String sessionId) =>
      _notImplemented('findActiveTokenBySessionId');

  @override
  Future<SessionCart> getOrCreateCart(String sessionId) =>
      _notImplemented('getOrCreateCart');

  @override
  Future<SessionCart> updateCart(SessionCart cart) =>
      _notImplemented('updateCart');

  @override
  Future<List<SessionCartItem>> getCartItems(String sessionCartId) =>
      _notImplemented('getCartItems');

  @override
  Future<SessionCartItem> addCartItem(SessionCartItem item) =>
      _notImplemented('addCartItem');

  @override
  Future<void> removeCartItem(String sessionCartId, String itemId) =>
      _notImplemented('removeCartItem');

  @override
  Future<void> clearCart(String sessionCartId) =>
      _notImplemented('clearCart');

  @override
  Future<SessionDevice> registerDevice(SessionDevice device) =>
      _notImplemented('registerDevice');

  @override
  Future<SessionTimelineEvent> appendTimelineEvent(
    SessionTimelineEvent event,
  ) =>
      _notImplemented('appendTimelineEvent');

  @override
  Future<List<KitchenBatch>> getBatchesBySessionId(String sessionId) =>
      _notImplemented('getBatchesBySessionId');

  @override
  Future<TableQrTokenRecord?> resolveJoinToken(String tokenHash) =>
      _notImplemented('resolveJoinToken');

  @override
  Future<RestaurantTable?> getTableById({
    required String restaurantId,
    required String tableId,
  }) =>
      _notImplemented('getTableById');
}
