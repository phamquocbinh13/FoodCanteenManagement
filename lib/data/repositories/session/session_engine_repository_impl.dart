import '../../../application/session/session_constants.dart';
import '../../../application/session/session_timeline_recorder.dart';
import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/entities/session_payment_summary.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/session_state_machine.dart';
import '../../../domain/services/table_domain_service.dart';
import '../../datasources/session/session_engine_datasource.dart';

/// Session Engine repository backed by [SessionEngineDataSource].
final class SessionEngineRepositoryImpl implements SessionEngineRepository {
  SessionEngineRepositoryImpl({
    required SessionEngineDataSource dataSource,
    required IdGenerator idGenerator,
    required SessionTimelineRecorder timelineRecorder,
    required Clock clock,
    TableDomainService? tableDomainService,
  })  : _dataSource = dataSource,
        _idGenerator = idGenerator,
        _timeline = timelineRecorder,
        _clock = clock,
        _tableService = tableDomainService ?? const TableDomainService();

  final SessionEngineDataSource _dataSource;
  final IdGenerator _idGenerator;
  final SessionTimelineRecorder _timeline;
  final Clock _clock;
  final TableDomainService _tableService;

  @override
  Future<Result<SessionAccess>> create({
    required String restaurantId,
    required String tableId,
    required SessionOpenedVia openedVia,
    String? openedByUserId,
    required String displayNumber,
    required int sessionSequence,
    required String sessionTokenValue,
    required DateTime tokenExpiresAt,
    required DateTime now,
  }) async {
    final table = _dataSource.getTable(tableId);
    if (table == null || table.restaurantId != restaurantId) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.tableNotFound,
          code: SessionErrorCodes.tableNotFound,
        ),
      );
    }

    final existing = _dataSource.findActiveSessionByTable(
      restaurantId: restaurantId,
      tableId: tableId,
    );
    if (existing != null) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.activeSessionExists,
          code: SessionErrorCodes.activeSessionExists,
        ),
      );
    }

    if (!_tableService.canTransition(table.status, TableStatus.occupied)) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.tableNotFound,
          code: SessionErrorCodes.tableOccupied,
        ),
      );
    }

    final sessionId = _idGenerator.nextId();
    final session = DineInSession(
      id: sessionId,
      restaurantId: restaurantId,
      tableId: tableId,
      sessionNumber: sessionSequence,
      displayNumber: displayNumber,
      status: SessionStatus.open,
      openedVia: openedVia,
      openedByUserId: openedByUserId,
      currentBatchNumber: 0,
      paymentStatus: SessionPaymentStatus.unpaid,
      paymentSummary: const SessionPaymentSummary(),
      openedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    final token = SessionAuthToken(
      id: _idGenerator.nextId(),
      sessionId: sessionId,
      tokenHash: hashSessionToken(sessionTokenValue),
      expiresAt: tokenExpiresAt,
      createdAt: now,
    );

    final occupiedTable = _tableService
        .markOccupied(table)
        .copyWith(updatedAt: now);

    _dataSource.saveSession(session);
    _dataSource.saveTable(occupiedTable);
    _dataSource.saveToken(token, tokenValue: sessionTokenValue);
    _dataSource.appendTimeline(
      _timeline.sessionCreated(
        sessionId: sessionId,
        displayNumber: displayNumber,
        tableId: tableId,
        actorId: openedByUserId,
      ),
    );

    return Success(
      SessionAccess(
        snapshot: _snapshot(session, token, occupiedTable.label),
        sessionTokenValue: sessionTokenValue,
      ),
    );
  }

  @override
  Future<Result<SessionEngineSnapshot>> join({
    required String sessionTokenValue,
    required DateTime now,
    String? deviceId,
  }) async {
    final validation = await validateToken(sessionTokenValue);
    if (validation is Err<SessionEngineSnapshot>) {
      return Err(validation.failure);
    }

    final snapshot = (validation as Success<SessionEngineSnapshot>).value;
    _dataSource.appendTimeline(
      _timeline.customerJoined(
        sessionId: snapshot.session.id,
        deviceId: deviceId,
      ),
    );

    return Success(snapshot);
  }

  @override
  Future<Result<SessionEngineSnapshot>> close({
    required String sessionId,
    required String restaurantId,
    String? closedByUserId,
    required DateTime now,
  }) async {
    final session = _dataSource.getSession(sessionId);
    if (session == null || session.restaurantId != restaurantId) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.sessionNotFound,
          code: SessionErrorCodes.sessionNotFound,
        ),
      );
    }

    if (session.status == SessionStatus.closed) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.sessionClosed,
          code: SessionErrorCodes.sessionClosed,
        ),
      );
    }

    if (!SessionStateMachine.canTransition(session.status, SessionStatus.closed)) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.invalidTransition,
          code: SessionErrorCodes.invalidTransition,
        ),
      );
    }

    final table = _dataSource.getTable(session.tableId);
    if (table == null) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.tableNotFound,
          code: SessionErrorCodes.tableNotFound,
        ),
      );
    }

    final closedSession = session.copyWith(
      status: SessionStatus.closed,
      closedByUserId: closedByUserId,
      closedAt: now,
      updatedAt: now,
    );

    final availableTable = _tableService
        .markAvailable(table)
        .copyWith(updatedAt: now);

    _dataSource.saveSession(closedSession);
    _dataSource.saveTable(availableTable);
    _dataSource.revokeToken(sessionId, now);
    _dataSource.appendTimeline(
      _timeline.sessionClosed(
        sessionId: sessionId,
        actorId: closedByUserId,
      ),
    );

    return Success(
      _snapshot(closedSession, null, availableTable.label),
    );
  }

  @override
  Future<Result<SessionEngineSnapshot>> markWaitingPayment({
    required String sessionId,
    required String restaurantId,
    required DateTime now,
  }) async {
    final session = _dataSource.getSession(sessionId);
    if (session == null || session.restaurantId != restaurantId) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.sessionNotFound,
          code: SessionErrorCodes.sessionNotFound,
        ),
      );
    }

    if (!SessionStateMachine.canTransition(
      session.status,
      SessionStatus.paymentPending,
    )) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.invalidTransition,
          code: SessionErrorCodes.invalidTransition,
        ),
      );
    }

    final updated = session.copyWith(
      status: SessionStatus.paymentPending,
      paymentStatus: SessionPaymentStatus.waitingPayment,
      paymentSoftLock: true,
      updatedAt: now,
    );

    _dataSource.saveSession(updated);
    _dataSource.appendTimeline(
      _timeline.waitingPaymentEntered(sessionId: sessionId),
    );

    final table = _dataSource.getTable(session.tableId);
    return Success(
      _snapshot(
        updated,
        _dataSource.getActiveToken(sessionId),
        table?.label ?? session.tableId,
      ),
    );
  }

  @override
  Future<Result<SessionEngineSnapshot>> transfer({
    required String sessionId,
    required String restaurantId,
    required String targetTableId,
    required DateTime now,
  }) async {
    return const Err(
      ValidationFailure(
        SessionErrorMessages.transferUnsupported,
        code: SessionErrorCodes.transferUnsupported,
      ),
    );
  }

  @override
  Future<Result<SessionEngineSnapshot>> findByToken(
    String sessionTokenValue,
  ) {
    return validateToken(sessionTokenValue);
  }

  @override
  Future<Result<SessionEngineSnapshot?>> findActiveByTable({
    required String restaurantId,
    required String tableId,
  }) async {
    final session = _dataSource.findActiveSessionByTable(
      restaurantId: restaurantId,
      tableId: tableId,
    );
    if (session == null) return const Success(null);

    final table = _dataSource.getTable(tableId);
    return Success(
      _snapshot(
        session,
        _dataSource.getActiveToken(session.id),
        table?.label ?? tableId,
      ),
    );
  }

  @override
  Future<Result<List<SessionEngineSnapshot>>> restoreActiveSessions(
    String restaurantId,
  ) async {
    final sessions = _dataSource.listActiveSessions(restaurantId);
    final snapshots = sessions.map((session) {
      final table = _dataSource.getTable(session.tableId);
      return _snapshot(
        session,
        _dataSource.getActiveToken(session.id),
        table?.label ?? session.tableId,
      );
    }).toList();
    return Success(snapshots);
  }

  @override
  Future<Result<SessionEngineSnapshot>> update(DineInSession session) async {
    _dataSource.saveSession(session);
    final table = _dataSource.getTable(session.tableId);
    return Success(
      _snapshot(
        session,
        _dataSource.getActiveToken(session.id),
        table?.label ?? session.tableId,
      ),
    );
  }

  @override
  Future<Result<int>> nextBatchNumber({
    required String sessionId,
    required String restaurantId,
  }) async {
    final session = _dataSource.getSession(sessionId);
    if (session == null || session.restaurantId != restaurantId) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.sessionNotFound,
          code: SessionErrorCodes.sessionNotFound,
        ),
      );
    }

    if (session.status == SessionStatus.closed) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.sessionClosed,
          code: SessionErrorCodes.sessionClosed,
        ),
      );
    }

    final next = session.currentBatchNumber + 1;
    final now = _clock.now();
    final updated = session.copyWith(
      currentBatchNumber: next,
      updatedAt: now,
    );
    _dataSource.saveSession(updated);
    _dataSource.appendTimeline(
      _timeline.batchCreated(
        sessionId: sessionId,
        batchNumber: next,
      ),
    );
    return Success(next);
  }

  @override
  Future<Result<SessionEngineSnapshot>> validateToken(
    String sessionTokenValue,
  ) async {
    final sessionId = _dataSource.resolveSessionIdByToken(sessionTokenValue);
    if (sessionId == null) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.invalidToken,
          code: SessionErrorCodes.invalidToken,
        ),
      );
    }

    final session = _dataSource.getSession(sessionId);
    if (session == null) {
      return Err(
        NotFoundFailure(
          SessionErrorMessages.sessionNotFound,
          code: SessionErrorCodes.sessionNotFound,
        ),
      );
    }

    if (session.status == SessionStatus.closed) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.sessionClosed,
          code: SessionErrorCodes.sessionClosed,
        ),
      );
    }

    final token = _dataSource.getActiveToken(sessionId);
    if (token == null) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.invalidToken,
          code: SessionErrorCodes.invalidToken,
        ),
      );
    }

    if (!token.expiresAt.isAfter(_clock.now())) {
      return Err(
        ValidationFailure(
          SessionErrorMessages.tokenExpired,
          code: SessionErrorCodes.tokenExpired,
        ),
      );
    }

    final table = _dataSource.getTable(session.tableId);
    return Success(
      _snapshot(
        session,
        token,
        table?.label ?? session.tableId,
      ),
    );
  }

  SessionEngineSnapshot _snapshot(
    DineInSession session,
    SessionAuthToken? token,
    String tableLabel,
  ) {
    return SessionEngineSnapshot(
      session: session,
      activeToken: token,
      tableLabel: tableLabel,
    );
  }
}
