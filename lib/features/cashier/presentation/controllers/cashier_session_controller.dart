import 'package:flutter/foundation.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../application/session/session_constants.dart';
import '../../../../application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import '../../../../application/usecases/payment/close_session_with_payment_use_case.dart';
import '../../../../application/usecases/session/close_session_use_case.dart';
import '../../../../application/usecases/session/create_session_use_case.dart';
import '../../../../application/usecases/session/list_restaurant_tables_use_case.dart';
import '../../../../application/usecases/session/mark_waiting_payment_use_case.dart';
import '../../../../application/usecases/session/restore_session_use_case.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/restaurant_table.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../domain/services/session_state_machine.dart';

/// Cashier-side session controller for floor open / pay / force-close.
final class CashierSessionController extends ChangeNotifier {
  CashierSessionController({
    required String restaurantId,
    required CreateSessionUseCase createSession,
    required CloseSessionUseCase closeSession,
    required MarkWaitingPaymentUseCase markWaitingPayment,
    required RestoreSessionUseCase restoreSession,
    required GetCashierBatchSummariesUseCase getCashierBatchSummaries,
    required ListRestaurantTablesUseCase listTables,
    CloseSessionWithPaymentUseCase? closeWithPayment,
  })  : _restaurantId = restaurantId,
        _createSession = createSession,
        _closeSession = closeSession,
        _markWaitingPayment = markWaitingPayment,
        _restoreSession = restoreSession,
        _getCashierBatchSummaries = getCashierBatchSummaries,
        _listTables = listTables,
        _closeWithPayment = closeWithPayment;

  final String _restaurantId;
  final CreateSessionUseCase _createSession;
  final CloseSessionUseCase _closeSession;
  final MarkWaitingPaymentUseCase _markWaitingPayment;
  final RestoreSessionUseCase _restoreSession;
  final GetCashierBatchSummariesUseCase _getCashierBatchSummaries;
  final ListRestaurantTablesUseCase _listTables;
  final CloseSessionWithPaymentUseCase? _closeWithPayment;

  SessionEngineSnapshot? _activeSnapshot;
  List<SessionEngineSnapshot> _activeSessions = [];
  List<RestaurantTable> _tables = [];
  String? _sessionToken;
  String? _errorMessage;
  bool _isLoading = false;
  List<CashierBatchSummaryView> _batchSummaries = [];

  SessionEngineSnapshot? get activeSnapshot => _activeSnapshot;
  List<SessionEngineSnapshot> get activeSessions =>
      List.unmodifiable(_activeSessions);
  List<RestaurantTable> get tables => List.unmodifiable(_tables);
  String? get sessionToken => _sessionToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasActiveSession => _activeSnapshot != null;
  List<CashierBatchSummaryView> get batchSummaries => _batchSummaries;

  SessionLifecyclePhase get lifecyclePhase {
    final status = _activeSnapshot?.session.status;
    if (status == null) return SessionLifecyclePhase.available;
    return status.lifecyclePhase;
  }

  SessionEngineSnapshot? sessionForTable(String tableId) {
    for (final snapshot in _activeSessions) {
      if (snapshot.session.tableId == tableId) return snapshot;
    }
    return null;
  }

  bool isTableOccupied(String tableId) {
    if (sessionForTable(tableId) != null) return true;
    for (final table in _tables) {
      if (table.id == tableId && table.status == TableStatus.occupied) {
        return true;
      }
    }
    return false;
  }

  Future<void> restore() async {
    _setLoading(true);
    await Future.wait([
      _loadTables(),
      _loadActiveSessions(),
    ]);
    _setLoading(false);
    notifyListeners();
  }

  Future<void> _loadTables() async {
    final result = await _listTables(
      ListRestaurantTablesParams(
        restaurantId: _restaurantId,
      ),
    );
    if (result is Success<List<RestaurantTable>>) {
      _tables = result.value;
    }
  }

  Future<void> _loadActiveSessions() async {
    final result = await _restoreSession(
      RestoreSessionParams(
        restaurantId: _restaurantId,
      ),
    );
    if (result is Success<List<SessionEngineSnapshot>>) {
      _activeSessions = result.value;
      final selectedId = _activeSnapshot?.session.id;
      if (selectedId != null) {
        SessionEngineSnapshot? match;
        for (final s in _activeSessions) {
          if (s.session.id == selectedId) {
            match = s;
            break;
          }
        }
        _activeSnapshot = match;
      } else if (_activeSessions.length == 1) {
        _activeSnapshot = _activeSessions.first;
      }
      if (_activeSnapshot != null) {
        await refreshBatchSummaries();
      } else {
        _batchSummaries = [];
      }
      _errorMessage = null;
    }
  }

  void selectSession(SessionEngineSnapshot snapshot) {
    _activeSnapshot = snapshot;
    _sessionToken = null;
    _errorMessage = null;
    refreshBatchSummaries();
    notifyListeners();
  }

  void clearSelection() {
    _activeSnapshot = null;
    _sessionToken = null;
    _batchSummaries = [];
    notifyListeners();
  }

  Future<void> createOnTable1({String? openedByUserId}) {
    return createOnTable(
      SessionEngineConstants.demoTable1Id,
      openedByUserId: openedByUserId,
    );
  }

  Future<void> createOnTable(
    String tableId, {
    String? openedByUserId,
  }) async {
    final existing = sessionForTable(tableId);
    if (existing != null) {
      selectSession(existing);
      return;
    }

    _setLoading(true);
    final result = await _createSession(
      CreateSessionParams(
        restaurantId: _restaurantId,
        tableId: tableId,
        tableStatus: TableStatus.available,
        openedVia: SessionOpenedVia.cashierManual,
        openedByUserId: openedByUserId,
      ),
    );
    _setLoading(false);

    switch (result) {
      case Success(:final value):
        _activeSnapshot = value.snapshot;
        _sessionToken = value.sessionTokenValue;
        _errorMessage = null;
        await Future.wait([_loadTables(), _loadActiveSessions()]);
        await refreshBatchSummaries();
      case Err(:final failure):
        _errorMessage = failure.message;
        await Future.wait([_loadTables(), _loadActiveSessions()]);
        final afterConflict = sessionForTable(tableId);
        if (afterConflict != null) {
          _activeSnapshot = afterConflict;
          _sessionToken = null;
          _errorMessage = null;
          await refreshBatchSummaries();
        }
    }
    notifyListeners();
  }

  Future<void> onTableTapped(
    String tableId, {
    String? openedByUserId,
  }) async {
    final existing = sessionForTable(tableId);
    if (existing != null) {
      selectSession(existing);
      return;
    }
    if (isTableOccupied(tableId)) {
      _errorMessage = 'Table already has an active session. Pull to refresh.';
      notifyListeners();
      return;
    }
    await createOnTable(tableId, openedByUserId: openedByUserId);
  }

  Future<void> markWaitingPayment() async {
    final snapshot = _activeSnapshot;
    if (snapshot == null) return;

    _setLoading(true);
    final result = await _markWaitingPayment(
      MarkWaitingPaymentParams(
        sessionId: snapshot.session.id,
        restaurantId: snapshot.session.restaurantId,
      ),
    );
    _setLoading(false);

    switch (result) {
      case Success(:final value):
        _activeSnapshot = value;
        _errorMessage = null;
        await _loadActiveSessions();
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<void> closeSession({
    String? closedByUserId,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    SessionCloseType closeType = SessionCloseType.payment,
    ForceCloseReason? forceCloseReason,
    String? forceCloseNote,
  }) async {
    final snapshot = _activeSnapshot;
    if (snapshot == null) return;

    _setLoading(true);
    final Result<Object?> result;
    final paymentClose = _closeWithPayment;
    if (paymentClose != null) {
      result = await paymentClose(
        CloseSessionWithPaymentParams(
          restaurantId: snapshot.session.restaurantId,
          sessionId: snapshot.session.id,
          paymentMethod: paymentMethod,
          closeType: closeType,
          forceCloseReason: forceCloseReason,
          forceCloseNote: forceCloseNote,
        ),
      );
    } else {
      result = await _closeSession(
        CloseSessionParams(
          sessionId: snapshot.session.id,
          restaurantId: snapshot.session.restaurantId,
          closedByUserId: closedByUserId,
        ),
      );
    }
    _setLoading(false);

    switch (result) {
      case Success():
        _activeSnapshot = null;
        _sessionToken = null;
        _batchSummaries = [];
        _errorMessage = null;
        await Future.wait([_loadTables(), _loadActiveSessions()]);
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<void> refreshBatchSummaries() async {
    final sessionId = _activeSnapshot?.session.id;
    if (sessionId == null) {
      _batchSummaries = [];
      return;
    }
    final result = await _getCashierBatchSummaries(
      GetCashierBatchSummariesParams(
        sessionId: sessionId,
        restaurantId: _restaurantId,
      ),
    );
    if (result is Success<List<CashierBatchSummaryView>>) {
      _batchSummaries = result.value;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
