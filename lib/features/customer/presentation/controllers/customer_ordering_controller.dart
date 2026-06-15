import 'package:flutter/foundation.dart';

import '../../../../application/menu/cart_view.dart';
import '../../../../application/menu/kitchen_batch_ticket.dart';
import '../../../../application/menu/menu_catalog_view.dart';
import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../application/session/session_constants.dart';
import '../../../../application/usecases/batch/confirm_batch_use_case.dart';
import '../../../../application/usecases/cart/add_to_cart_use_case.dart';
import '../../../../application/usecases/cart/get_session_cart_use_case.dart';
import '../../../../application/usecases/menu/get_menu_catalog_use_case.dart';
import '../../../../application/usecases/menu/get_menu_item_detail_use_case.dart';
import '../../../../application/usecases/session/get_session_bill_use_case.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/session_cart_item.dart';
import '../../../../domain/entities/session_payment_summary.dart';

/// Customer ordering controller: menu browse, cart, batch confirm.
final class CustomerOrderingController extends ChangeNotifier {
  CustomerOrderingController({
    required GetMenuCatalogUseCase getMenuCatalog,
    required GetMenuItemDetailUseCase getMenuItemDetail,
    required AddToCartUseCase addToCart,
    required GetSessionCartUseCase getSessionCart,
    required ConfirmBatchUseCase confirmBatch,
    required GetSessionBillUseCase getSessionBill,
  })  : _getMenuCatalog = getMenuCatalog,
        _getMenuItemDetail = getMenuItemDetail,
        _addToCart = addToCart,
        _getSessionCart = getSessionCart,
        _confirmBatch = confirmBatch,
        _getSessionBill = getSessionBill;

  final GetMenuCatalogUseCase _getMenuCatalog;
  final GetMenuItemDetailUseCase _getMenuItemDetail;
  final AddToCartUseCase _addToCart;
  final GetSessionCartUseCase _getSessionCart;
  final ConfirmBatchUseCase _confirmBatch;
  final GetSessionBillUseCase _getSessionBill;

  MenuCatalogView? _catalog;
  CartView? _cart;
  SessionPaymentSummary? _bill;
  String? _errorMessage;
  bool _isLoading = false;
  String _searchQuery = '';
  KitchenBatchTicket? _lastBatch;

  MenuCatalogView? get catalog => _catalog;
  CartView? get cart => _cart;
  SessionPaymentSummary? get bill => _bill;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  KitchenBatchTicket? get lastBatch => _lastBatch;

  int get cartItemCount =>
      _cart?.items.fold<int>(0, (sum, i) => sum + i.quantity.value) ?? 0;

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
      GetSessionCartParams(sessionId: sessionId),
    );
    if (result is Success<CartView>) {
      _cart = result.value;
    }
    notifyListeners();
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
