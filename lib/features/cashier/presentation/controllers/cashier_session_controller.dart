import 'package:flutter/foundation.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../application/session/session_constants.dart';
import '../../../../application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import '../../../../application/usecases/session/close_session_use_case.dart';
import '../../../../application/usecases/session/create_session_use_case.dart';
import '../../../../application/usecases/session/mark_waiting_payment_use_case.dart';
import '../../../../application/usecases/session/restore_session_use_case.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../domain/services/session_state_machine.dart';

/// Cashier-side session demo controller for Sprint 3 end-to-end flow.
final class CashierSessionController extends ChangeNotifier {
  CashierSessionController({
    required CreateSessionUseCase createSession,
    required CloseSessionUseCase closeSession,
    required MarkWaitingPaymentUseCase markWaitingPayment,
    required RestoreSessionUseCase restoreSession,
    required GetCashierBatchSummariesUseCase getCashierBatchSummaries,
  })  : _createSession = createSession,
        _closeSession = closeSession,
        _markWaitingPayment = markWaitingPayment,
        _restoreSession = restoreSession,
        _getCashierBatchSummaries = getCashierBatchSummaries;

  final CreateSessionUseCase _createSession;
  final CloseSessionUseCase _closeSession;
  final MarkWaitingPaymentUseCase _markWaitingPayment;
  final RestoreSessionUseCase _restoreSession;
  final GetCashierBatchSummariesUseCase _getCashierBatchSummaries;

  SessionEngineSnapshot? _activeSnapshot;
  String? _sessionToken;
  String? _errorMessage;
  bool _isLoading = false;
  List<CashierBatchSummaryView> _batchSummaries = [];

  SessionEngineSnapshot? get activeSnapshot => _activeSnapshot;
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

  Future<void> restore() async {
    _setLoading(true);
    final result = await _restoreSession(
      const RestoreSessionParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
      ),
    );
    _setLoading(false);

    if (result is Success<List<SessionEngineSnapshot>> &&
        result.value.isNotEmpty) {
      _activeSnapshot = result.value.first;
      _errorMessage = null;
      await refreshBatchSummaries();
      notifyListeners();
    }
  }

  Future<void> createOnTable1({String? openedByUserId}) async {
    _setLoading(true);
    final result = await _createSession(
      CreateSessionParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
        tableId: SessionEngineConstants.demoTable1Id,
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
        await refreshBatchSummaries();
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
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
      case Err(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  Future<void> closeSession({String? closedByUserId}) async {
    final snapshot = _activeSnapshot;
    if (snapshot == null) return;

    _setLoading(true);
    final result = await _closeSession(
      CloseSessionParams(
        sessionId: snapshot.session.id,
        restaurantId: snapshot.session.restaurantId,
        closedByUserId: closedByUserId,
      ),
    );
    _setLoading(false);

    switch (result) {
      case Success():
        _activeSnapshot = null;
        _sessionToken = null;
        _errorMessage = null;
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
        restaurantId: SessionEngineConstants.demoRestaurantId,
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
