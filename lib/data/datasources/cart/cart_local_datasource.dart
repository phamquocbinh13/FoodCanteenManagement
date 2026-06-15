import 'dart:convert';

import '../../../application/session/cart_storage_keys.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';

/// Persists session carts locally so they survive app restart and navigation.
abstract interface class CartLocalDataSource {
  Future<void> save({
    required String sessionId,
    required SessionCart cart,
    required List<SessionCartItem> items,
  });

  Future<({SessionCart cart, List<SessionCartItem> items})?> load(
    String sessionId,
  );

  Future<void> clear(String sessionId);
}

final class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  Future<void> save({
    required String sessionId,
    required SessionCart cart,
    required List<SessionCartItem> items,
  }) async {
    final payload = jsonEncode({
      'cart': cart.toJson(),
      'items': items.map((i) => i.toJson()).toList(),
    });
    await _storage.setString(CartStorageKeys.cartJson(sessionId), payload);
  }

  @override
  Future<({SessionCart cart, List<SessionCartItem> items})?> load(
    String sessionId,
  ) async {
    final raw = await _storage.getString(CartStorageKeys.cartJson(sessionId));
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final cart = SessionCart.fromJson(decoded['cart'] as Map<String, dynamic>);
    final items = (decoded['items'] as List<dynamic>)
        .map((e) => SessionCartItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return (cart: cart, items: items);
  }

  @override
  Future<void> clear(String sessionId) async {
    await _storage.remove(CartStorageKeys.cartJson(sessionId));
  }
}

/// In-memory cart store for unit tests.
final class InMemoryCartLocalDataSource implements CartLocalDataSource {
  final Map<String, String> _payloads = {};

  @override
  Future<void> clear(String sessionId) async {
    _payloads.remove(CartStorageKeys.cartJson(sessionId));
  }

  @override
  Future<({SessionCart cart, List<SessionCartItem> items})?> load(
    String sessionId,
  ) async {
    final raw = _payloads[CartStorageKeys.cartJson(sessionId)];
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final cart = SessionCart.fromJson(decoded['cart'] as Map<String, dynamic>);
    final items = (decoded['items'] as List<dynamic>)
        .map((e) => SessionCartItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return (cart: cart, items: items);
  }

  @override
  Future<void> save({
    required String sessionId,
    required SessionCart cart,
    required List<SessionCartItem> items,
  }) async {
    _payloads[CartStorageKeys.cartJson(sessionId)] = jsonEncode({
      'cart': cart.toJson(),
      'items': items.map((i) => i.toJson()).toList(),
    });
  }
}
