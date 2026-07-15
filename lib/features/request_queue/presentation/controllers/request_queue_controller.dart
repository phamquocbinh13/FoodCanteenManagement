import 'package:flutter/foundation.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../application/usecases/request/handle_staff_request_use_case.dart';
import '../../../../application/usecases/request/list_pending_staff_requests_use_case.dart';
import '../../../../core/result/result.dart';

/// Cashier-facing pending request queue.
final class RequestQueueController extends ChangeNotifier {
  RequestQueueController({
    required String restaurantId,
    required ListPendingStaffRequestsUseCase listPending,
    required HandleStaffRequestUseCase handleRequest,
  })  : _restaurantId = restaurantId,
        _listPending = listPending,
        _handleRequest = handleRequest;

  final String _restaurantId;
  final ListPendingStaffRequestsUseCase _listPending;
  final HandleStaffRequestUseCase _handleRequest;

  List<StaffRequestQueueItemView> _items = const [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _handlingRequestId;

  List<StaffRequestQueueItemView> get items => _items;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get pendingCount => _items.length;
  String? get handlingRequestId => _handlingRequestId;

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _listPending(
      ListPendingStaffRequestsParams(
        restaurantId: _restaurantId,
      ),
    );

    _isLoading = false;
    switch (result) {
      case Success(:final value):
        _items = value;
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<bool> handle({
    required String requestId,
    required String handledByUserId,
  }) async {
    _handlingRequestId = requestId;
    _errorMessage = null;
    notifyListeners();

    final result = await _handleRequest(
      HandleStaffRequestParams(
        restaurantId: _restaurantId,
        requestId: requestId,
        handledByUserId: handledByUserId,
      ),
    );

    _handlingRequestId = null;

    switch (result) {
      case Success():
        await refresh();
        return true;
      case Err(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }
}
