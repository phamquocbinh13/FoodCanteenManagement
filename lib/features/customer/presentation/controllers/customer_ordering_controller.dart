import 'package:flutter/foundation.dart';

import '../../../../application/menu/cart_view.dart';
import '../../../../application/menu/kitchen_batch_ticket.dart';
import '../../../../application/menu/menu_catalog_view.dart';
import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../application/session/session_constants.dart';
import '../../../../application/usecases/batch/confirm_batch_use_case.dart';
import '../../../../application/usecases/cart/add_to_cart_use_case.dart';
import '../../../../application/usecases/cart/clear_session_cart_use_case.dart';
import '../../../../application/usecases/cart/edit_cart_item_use_case.dart';
import '../../../../application/usecases/cart/get_session_cart_use_case.dart';
import '../../../../application/usecases/cart/remove_cart_item_use_case.dart';
import '../../../../application/usecases/cart/update_cart_item_quantity_use_case.dart';
import '../../../../application/usecases/menu/get_menu_catalog_use_case.dart';
import '../../../../application/usecases/menu/get_menu_item_detail_use_case.dart';
import '../../../../application/usecases/session/get_session_bill_use_case.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/session_cart_item.dart';
import '../../../../domain/entities/session_payment_summary.dart';

/// Customer ordering controller: menu browse, cart editing, batch confirm.
final class CustomerOrderingController extends ChangeNotifier {
  CustomerOrderingController({
    required GetMenuCatalogUseCase getMenuCatalog,
    required GetMenuItemDetailUseCase getMenuItemDetail,
    required AddToCartUseCase addToCart,
    required GetSessionCartUseCase getSessionCart,
    required UpdateCartItemQuantityUseCase updateCartItemQuantity,
    required RemoveCartItemUseCase removeCartItem,
    required EditCartItemUseCase editCartItem,
    required ClearSessionCartUseCase clearSessionCart,
    required ConfirmBatchUseCase confirmBatch,
    required GetSessionBillUseCase getSessionBill,
  })  : _getMenuCatalog = getMenuCatalog,
        _getMenuItemDetail = getMenuItemDetail,
        _addToCart = addToCart,
        _getSessionCart = getSessionCart,
        _updateCartItemQuantity = updateCartItemQuantity,
        _removeCartItem = removeCartItem,
        _editCartItem = editCartItem,
        _clearSessionCart = clearSessionCart,
        _confirmBatch = confirmBatch,
        _getSessionBill = getSessionBill;

  final GetMenuCatalogUseCase _getMenuCatalog;
  final GetMenuItemDetailUseCase _getMenuItemDetail;
  final AddToCartUseCase _addToCart;
  final GetSessionCartUseCase _getSessionCart;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantity;
  final RemoveCartItemUseCase _removeCartItem;
  final EditCartItemUseCase _editCartItem;
  final ClearSessionCartUseCase _clearSessionCart;
  final ConfirmBatchUseCase _confirmBatch;
  final GetSessionBillUseCase _getSessionBill;

  MenuCatalogView? _catalog;
  CartView? _cart;
  SessionPaymentSummary? _bill;
  String? _errorMessage;
  bool _isLoading = false;
  String _searchQuery = '';
  KitchenBatchTicket? _lastBatch;
  final Set<String> _pendingCartItemIds = {};

  MenuCatalogView? get catalog => _catalog;
  CartView? get cart => _cart;
  SessionPaymentSummary? get bill => _bill;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  KitchenBatchTicket? get lastBatch => _lastBatch;

  bool isCartItemPending(String cartItemId) =>
      _pendingCartItemIds.contains(cartItemId);

  bool get isCartBusy => _isLoading || _pendingCartItemIds.isNotEmpty;

  int get cartItemCount => _cart?.totalItemCount ?? 0;

  Future<void> loadMenu() async {
    _setLoading(true);
    final result = await _getMenuCatalog(
      const GetMenuCatalogParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
      ),
    );
    _setLoading(false);
    switch (result) {
      case Success(:final value):
        _catalog = value;
        _errorMessage = null;
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<MenuItemDetailView?> loadItemDetail(String menuItemId) async {
    final result = await _getMenuItemDetail(
      GetMenuItemDetailParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
        menuItemId: menuItemId,
      ),
    );
    return switch (result) {
      Success(:final value) => value,
      Err() => null,
    };
  }

  Future<bool> addToCart({
    required String sessionId,
    required String menuItemId,
    required int quantity,
    required Map<String, dynamic> selectionsJson,
  }) async {
    _setLoading(true);
    final result = await _addToCart(
      AddToCartParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
        menuItemId: menuItemId,
        quantity: quantity,
        selectionsJson: selectionsJson,
      ),
    );
    _setLoading(false);
    if (result is Err<SessionCartItem>) {
      _errorMessage = result.failure.message;
      notifyListeners();
      return false;
    }
    await refreshCart(sessionId);
    return true;
  }

  Future<void> refreshCart(String sessionId) async {
    final result = await _getSessionCart(
      GetSessionCartParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
      ),
    );
    if (result is Success<CartView>) {
      _cart = result.value;
    }
    await refreshBill(sessionId);
    notifyListeners();
  }

  Future<bool> updateQuantity({
    required String sessionId,
    required String cartItemId,
    required int delta,
  }) async {
    final cartId = _cart?.cart.id;
    if (cartId == null) return false;
    if (_pendingCartItemIds.contains(cartItemId)) return false;

    _pendingCartItemIds.add(cartItemId);
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _updateCartItemQuantity(
        UpdateCartItemQuantityParams(
          sessionCartId: cartId,
          cartItemId: cartItemId,
          delta: delta,
        ),
      );
      if (result is Err<SessionCartItem?>) {
        _errorMessage = result.failure.message;
        return false;
      }
      await refreshCart(sessionId);
      return true;
    } finally {
      _pendingCartItemIds.remove(cartItemId);
      notifyListeners();
    }
  }

  Future<bool> removeItem({
    required String sessionId,
    required String cartItemId,
  }) async {
    final cartId = _cart?.cart.id;
    if (cartId == null) return false;
    if (_pendingCartItemIds.contains(cartItemId)) return false;

    _pendingCartItemIds.add(cartItemId);
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _removeCartItem(
        RemoveCartItemParams(sessionCartId: cartId, cartItemId: cartItemId),
      );
      if (result is Err<void>) {
        _errorMessage = result.failure.message;
        return false;
      }
      await refreshCart(sessionId);
      return true;
    } finally {
      _pendingCartItemIds.remove(cartItemId);
      notifyListeners();
    }
  }

  Future<bool> editCartItem({
    required String sessionId,
    required String cartItemId,
    required Map<String, dynamic> selectionsJson,
  }) async {
    final cartId = _cart?.cart.id;
    if (cartId == null) return false;
    if (_pendingCartItemIds.contains(cartItemId)) return false;

    _pendingCartItemIds.add(cartItemId);
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _editCartItem(
        EditCartItemParams(
          sessionCartId: cartId,
          cartItemId: cartItemId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          selectionsJson: selectionsJson,
        ),
      );
      if (result is Err<SessionCartItem>) {
        _errorMessage = result.failure.message;
        return false;
      }
      await refreshCart(sessionId);
      return true;
    } finally {
      _pendingCartItemIds.remove(cartItemId);
      notifyListeners();
    }
  }

  Future<bool> clearCart(String sessionId) async {
    final result = await _clearSessionCart(
      ClearSessionCartParams(sessionId: sessionId),
    );
    if (result is Err<void>) {
      _errorMessage = result.failure.message;
      notifyListeners();
      return false;
    }
    _cart = null;
    await refreshBill(sessionId);
    notifyListeners();
    return true;
  }

  Future<bool> confirmBatch(String sessionId) async {
    _setLoading(true);
    final result = await _confirmBatch(
      ConfirmBatchParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
      ),
    );
    _setLoading(false);
    switch (result) {
      case Success(:final value):
        _lastBatch = value;
        _cart = null;
        _errorMessage = null;
        await refreshBill(sessionId);
        notifyListeners();
        return true;
      case Err(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }

  Future<void> refreshBill(String sessionId) async {
    final result = await _getSessionBill(
      GetSessionBillParams(sessionId: sessionId, includeOpenCart: true),
    );
    if (result is Success<SessionPaymentSummary>) {
      _bill = result.value;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  List<dynamic> filteredItems(String categoryId) {
    final items = _catalog?.itemsByCategoryId[categoryId] ?? [];
    if (_searchQuery.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.name.toLowerCase().contains(_searchQuery) ||
              (item.description?.toLowerCase().contains(_searchQuery) ?? false),
        )
        .toList();
  }

  bool get hasSearchResults {
    if (_catalog == null || _searchQuery.isEmpty) return true;
    for (final category in _catalog!.categories) {
      if (filteredItems(category.id).isNotEmpty) return true;
    }
    return false;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
