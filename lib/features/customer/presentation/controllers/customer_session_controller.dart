import 'package:flutter/foundation.dart';

import '../../../../application/session/customer_session_messages.dart';
import '../../../../application/session/session_token_parser.dart';
import '../../../../application/usecases/session/join_session_use_case.dart';
import '../../../../application/usecases/session/validate_session_use_case.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/id/id_generator.dart';
import '../../../../core/result/result.dart';
import '../../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../domain/events/domain_events.dart';
import '../../../../domain/services/session_state_machine.dart';

/// Customer-side session state. All joins go through [JoinSessionUseCase].
final class CustomerSessionController extends ChangeNotifier {
  CustomerSessionController({
    required JoinSessionUseCase joinSession,
    required ValidateSessionUseCase validateSession,
    required CustomerSessionLocalDataSource local,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    required DateTime Function() now,
  })  : _joinSession = joinSession,
        _validateSession = validateSession,
        _local = local,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _now = now;

  final JoinSessionUseCase _joinSession;
  final ValidateSessionUseCase _validateSession;
  final CustomerSessionLocalDataSource _local;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final DateTime Function() _now;

  SessionEngineSnapshot? _snapshot;
  String? _sessionToken;
  String? _errorMessage;
  bool _isLoading = false;
  bool _paymentRequested = false;

  SessionEngineSnapshot? get snapshot => _snapshot;
  String? get sessionToken => _sessionToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isJoined => _snapshot != null;
  bool get paymentRequested => _paymentRequested;

  SessionLifecyclePhase get lifecyclePhase {
    final status = _snapshot?.session.status;
    if (status == null) return SessionLifecyclePhase.available;
    return status.lifecyclePhase;
  }

  String get statusLabel => switch (lifecyclePhase) {
        SessionLifecyclePhase.available => 'Available',
        SessionLifecyclePhase.occupied => 'Dining',
        SessionLifecyclePhase.waitingPayment => 'Waiting for Payment',
        SessionLifecyclePhase.closed => 'Ended',
      };

  /// Attempts reconnect from persisted token (app refresh / relaunch).
  Future<bool> tryRestore() async {
    _setLoading(true);
    final stored = await _local.readSessionToken();
    if (stored is Err<String?>) {
      _setError(stored.failure.message);
      _setLoading(false);
      return false;
    }

    final token = stored.valueOrNull;
    if (token == null) {
      _setLoading(false);
      return false;
    }

    final restored = await _validateAndBind(token);
    _setLoading(false);
    return restored;
  }

  /// Join via QR scan or manual code — both resolve to [JoinSessionUseCase].
  Future<bool> join(String rawToken) async {
    _setLoading(true);
    _errorMessage = null;

    final token = SessionTokenParser.normalize(rawToken);
    if (token.isEmpty) {
      _setError(CustomerSessionMessages.sessionNotFound);
      _setLoading(false);
      return false;
    }

    final deviceResult = await _local.getOrCreateDeviceId(_idGenerator);
    if (deviceResult is Err<String>) {
      _setError(deviceResult.failure.message);
      _setLoading(false);
      return false;
    }

    final result = await _joinSession(
      JoinSessionParams(
        sessionToken: token,
        deviceId: deviceResult.valueOrNull!,
      ),
    );

    _setLoading(false);

    return switch (result) {
      Success(:final value) => _bindSession(token, value),
      Err(:final failure) => _fail(failure),
    };
  }

  Future<bool> refreshCurrentSession() async {
    final token = _sessionToken;
    if (token == null) return false;

    _setLoading(true);
    final ok = await _validateAndBind(token);
    _setLoading(false);
    return ok;
  }

  Future<void> requestPayment() async {
    final snapshot = _snapshot;
    if (snapshot == null) return;

    await _eventPublisher.publish(
      PaymentRequested(
        eventId: _idGenerator.nextId(),
        occurredAt: _now(),
        aggregateId: snapshot.session.id,
      ),
    );
    _paymentRequested = true;
    notifyListeners();
  }

  Future<void> leaveSession() async {
    await _local.clearSession();
    _snapshot = null;
    _sessionToken = null;
    _paymentRequested = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _validateAndBind(String token) async {
    final result = await _validateSession(
      ValidateSessionParams(sessionToken: token),
    );

    return switch (result) {
      Success(:final value) => _bindSession(token, value, persist: false),
      Err(:final failure) => _fail(failure, clearStorage: true),
    };
  }

  bool _bindSession(
    String token,
    SessionEngineSnapshot snapshot, {
    bool persist = true,
  }) {
    _snapshot = snapshot;
    _sessionToken = token;
    _errorMessage = null;
    _paymentRequested = false;
    if (persist) {
      _local.saveSessionToken(token);
    }
    notifyListeners();
    return true;
  }

  bool _fail(Failure failure, {bool clearStorage = false}) {
    if (clearStorage) {
      _local.clearSession();
    }
    _snapshot = null;
    _sessionToken = null;
    _setError(customerSessionFailureMessage(failure.code));
    return false;
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
