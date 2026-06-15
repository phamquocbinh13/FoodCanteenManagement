import '../../../application/session/session_constants.dart';
import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/enums/domain_enums.dart';
import '../ordering/demo_menu_seed.dart';
import '../ordering/ordering_store.dart';
import 'session_engine_datasource.dart';

/// In-memory Session Engine datasource backed by shared [OrderingStore].
final class InMemorySessionEngineDataSource implements SessionEngineDataSource {
  InMemorySessionEngineDataSource({
    required Clock clock,
    required OrderingStore store,
  })  : _clock = clock,
        _store = store {
    _store.tables.putIfAbsent(
      SessionEngineConstants.demoTable1Id,
      () => RestaurantTable(
        id: SessionEngineConstants.demoTable1Id,
        restaurantId: SessionEngineConstants.demoRestaurantId,
        label: 'Table 1',
        status: TableStatus.available,
        createdAt: _clock.now(),
        updatedAt: _clock.now(),
      ),
    );
    DemoMenuSeed.seed(_store, _clock);
  }

  final Clock _clock;
  final OrderingStore _store;

  OrderingStore get store => _store;

  @override
  Future<Result<void>> reset() async {
    _store.tables.clear();
    _store.sessions.clear();
    _store.tokensBySessionId.clear();
    _store.sessionIdByTokenValue.clear();
    _store.timeline.clear();
    _store.dailySessionSequence = 0;
    _store.lastDateKey = null;
    _store.categories.clear();
    _store.menuItems.clear();
    _store.customizationGroups.clear();
    _store.customizationOptions.clear();
    _store.menuCachedAt = null;
    _store.cartsBySessionId.clear();
    _store.cartItemsByCartId.clear();
    _store.batches.clear();
    _store.batchItemsByBatchId.clear();
    _store.customizationsByBatchItemId.clear();
    _store.batchCompletedAtById.clear();
    _store.batchItemStatusHistory.clear();
    _store.tables[SessionEngineConstants.demoTable1Id] = RestaurantTable(
      id: SessionEngineConstants.demoTable1Id,
      restaurantId: SessionEngineConstants.demoRestaurantId,
      label: 'Table 1',
      status: TableStatus.available,
      createdAt: _clock.now(),
      updatedAt: _clock.now(),
    );
    DemoMenuSeed.seed(_store, _clock);
    return const Success(null);
  }

  @override
  RestaurantTable? getTable(String tableId) => _store.tables[tableId];

  @override
  DineInSession? getSession(String sessionId) => _store.sessions[sessionId];

  @override
  DineInSession? findActiveSessionByTable({
    required String restaurantId,
    required String tableId,
  }) {
    for (final session in _store.sessions.values) {
      if (session.restaurantId == restaurantId &&
          session.tableId == tableId &&
          session.status != SessionStatus.closed) {
        return session;
      }
    }
    return null;
  }

  @override
  List<DineInSession> listActiveSessions(String restaurantId) {
    return _store.sessions.values
        .where(
          (s) =>
              s.restaurantId == restaurantId && s.status != SessionStatus.closed,
        )
        .toList();
  }

  @override
  SessionAuthToken? getActiveToken(String sessionId) {
    final token = _store.tokensBySessionId[sessionId];
    if (token == null || token.revokedAt != null) return null;
    return token;
  }

  @override
  String? resolveSessionIdByToken(String tokenValue) {
    return _store.sessionIdByTokenValue[tokenValue];
  }

  @override
  List<SessionTimelineEvent> timelineForSession(String sessionId) {
    return _store.timeline.where((e) => e.sessionId == sessionId).toList();
  }

  @override
  void saveTable(RestaurantTable table) {
    _store.tables[table.id] = table;
  }

  @override
  void saveSession(DineInSession session) {
    _store.sessions[session.id] = session;
  }

  @override
  void saveToken(SessionAuthToken token, {required String tokenValue}) {
    _store.tokensBySessionId[token.sessionId] = token;
    _store.sessionIdByTokenValue[tokenValue] = token.sessionId;
  }

  @override
  void revokeToken(String sessionId, DateTime revokedAt) {
    final token = _store.tokensBySessionId[sessionId];
    if (token == null) return;
    _store.tokensBySessionId[sessionId] = token.copyWith(revokedAt: revokedAt);
  }

  @override
  void appendTimeline(SessionTimelineEvent event) {
    _store.timeline.add(event);
  }

  @override
  int nextDailySequence(String dateKey) {
    if (_store.lastDateKey != dateKey) {
      _store.lastDateKey = dateKey;
      _store.dailySessionSequence = 0;
    }
    _store.dailySessionSequence += 1;
    return _store.dailySessionSequence;
  }

  @override
  List<String> batchIdsForSession(String sessionId) {
    return _store.batchIdsForSession(sessionId);
  }
}
