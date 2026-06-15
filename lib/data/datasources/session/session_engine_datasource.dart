import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../datasource.dart';

/// Session Engine persistence contract for mock and future remote backends.
abstract interface class SessionEngineDataSource implements MemoryDataSource {
  RestaurantTable? getTable(String tableId);

  DineInSession? getSession(String sessionId);

  DineInSession? findActiveSessionByTable({
    required String restaurantId,
    required String tableId,
  });

  List<DineInSession> listActiveSessions(String restaurantId);

  SessionAuthToken? getActiveToken(String sessionId);

  String? resolveSessionIdByToken(String tokenValue);

  List<SessionTimelineEvent> timelineForSession(String sessionId);

  void saveTable(RestaurantTable table);

  void saveSession(DineInSession session);

  void saveToken(SessionAuthToken token, {required String tokenValue});

  void revokeToken(String sessionId, DateTime revokedAt);

  void appendTimeline(SessionTimelineEvent event);

  int nextDailySequence(String dateKey);
}
