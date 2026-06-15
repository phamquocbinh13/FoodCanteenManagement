import '../../../application/session/session_constants.dart';
import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/enums/domain_enums.dart';

/// In-memory store backing the Session Engine mock implementation.
final class InMemorySessionEngineStore {
  final Map<String, RestaurantTable> tables = {};
  final Map<String, DineInSession> sessions = {};
  final Map<String, SessionAuthToken> tokensBySessionId = {};
  final Map<String, String> sessionIdByTokenValue = {};
  final List<SessionTimelineEvent> timeline = [];
  int dailySessionSequence = 0;
  String? lastDateKey;

  void seedDemoTables(DateTime now) {
    if (tables.isNotEmpty) return;
    tables[SessionEngineConstants.demoTable1Id] = RestaurantTable(
      id: SessionEngineConstants.demoTable1Id,
      restaurantId: SessionEngineConstants.demoRestaurantId,
      label: 'Table 1',
      status: TableStatus.available,
      createdAt: now,
      updatedAt: now,
    );
  }
}
