import 'package:flutter/foundation.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../application/usecases/kitchen/complete_batch_item_use_case.dart';
import '../../../../application/usecases/kitchen/get_kitchen_menu_panel_use_case.dart';
import '../../../../application/usecases/kitchen/get_kitchen_queue_use_case.dart';
import '../../../../application/usecases/kitchen/toggle_menu_availability_use_case.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/menu_item.dart';

/// Kitchen Display System controller — queue + one-tap item completion.
final class KitchenController extends ChangeNotifier {
  KitchenController({
    required String restaurantId,
    required GetKitchenQueueUseCase getKitchenQueue,
    required CompleteBatchItemUseCase completeBatchItem,
    required ToggleMenuAvailabilityUseCase toggleMenuAvailability,
    required GetKitchenMenuPanelUseCase getKitchenMenuPanel,
  })  : _restaurantId = restaurantId,
        _getKitchenQueue = getKitchenQueue,
        _completeBatchItem = completeBatchItem,
        _toggleMenuAvailability = toggleMenuAvailability,
        _getKitchenMenuPanel = getKitchenMenuPanel;

  final String _restaurantId;
  final GetKitchenQueueUseCase _getKitchenQueue;
  final CompleteBatchItemUseCase _completeBatchItem;
  final ToggleMenuAvailabilityUseCase _toggleMenuAvailability;
  final GetKitchenMenuPanelUseCase _getKitchenMenuPanel;

  KitchenQueueView? _queue;
  List<KitchenMenuItemViewModel> _menuItems = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _showCompleted = false;
  final Set<String> _pendingItemIds = {};

  KitchenQueueView? get queue => _queue;
  List<KitchenMenuItemViewModel> get menuItems => _menuItems;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get showCompleted => _showCompleted;

  bool isItemPending(String batchItemId) => _pendingItemIds.contains(batchItemId);

  Future<void> loadQueue() async {
    _setLoading(true);
    final result = await _getKitchenQueue(
      GetKitchenQueueParams(
        restaurantId: _restaurantId,
        showCompleted: _showCompleted,
      ),
    );
    _setLoading(false);
    switch (result) {
      case Success(:final value):
        _queue = value;
        _errorMessage = null;
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<void> loadMenuPanel() async {
    final result = await _getKitchenMenuPanel(
      GetKitchenMenuPanelParams(
        restaurantId: _restaurantId,
      ),
    );
    if (result is Success<List<KitchenMenuItemViewModel>>) {
      _menuItems = result.value;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await Future.wait([loadQueue(), loadMenuPanel()]);
  }

  void setShowCompleted(bool value) {
    if (_showCompleted == value) return;
    _showCompleted = value;
    notifyListeners();
    loadQueue();
  }

  Future<bool> completeItem(String batchItemId) async {
    if (_pendingItemIds.contains(batchItemId)) return false;

    _pendingItemIds.add(batchItemId);
    notifyListeners();

    final result = await _completeBatchItem(
      CompleteBatchItemParams(
        restaurantId: _restaurantId,
        batchItemId: batchItemId,
      ),
    );

    _pendingItemIds.remove(batchItemId);

    if (result is Err<void>) {
      _errorMessage = result.failure.message;
      notifyListeners();
      return false;
    }

    await loadQueue();
    return true;
  }

  Future<bool> toggleMenuItem(String menuItemId) async {
    final result = await _toggleMenuAvailability(
      ToggleMenuAvailabilityParams(
        restaurantId: _restaurantId,
        menuItemId: menuItemId,
      ),
    );
    if (result is Err<MenuItem>) {
      _errorMessage = result.failure.message;
      notifyListeners();
      return false;
    }
    await loadMenuPanel();
    return true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
