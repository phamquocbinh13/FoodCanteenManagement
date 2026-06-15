import '../../core/result/result.dart';
import '../entities/dine_in_session.dart';
import '../entities/session_engine_snapshot.dart';
import '../enums/domain_enums.dart';

/// Session Engine persistence contract. All methods return [Result].
abstract interface class SessionEngineRepository {
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
  });

  Future<Result<SessionEngineSnapshot>> join({
    required String sessionTokenValue,
    required DateTime now,
    String? deviceId,
  });

  Future<Result<SessionEngineSnapshot>> close({
    required String sessionId,
    required String restaurantId,
    String? closedByUserId,
    required DateTime now,
  });

  Future<Result<SessionEngineSnapshot>> markWaitingPayment({
    required String sessionId,
    required String restaurantId,
    required DateTime now,
  });

  Future<Result<SessionEngineSnapshot>> transfer({
    required String sessionId,
    required String restaurantId,
    required String targetTableId,
    required DateTime now,
  });

  Future<Result<SessionEngineSnapshot>> findByToken(String sessionTokenValue);

  Future<Result<SessionEngineSnapshot?>> findActiveByTable({
    required String restaurantId,
    required String tableId,
  });

  Future<Result<List<SessionEngineSnapshot>>> restoreActiveSessions(
    String restaurantId,
  );

  Future<Result<SessionEngineSnapshot>> update(DineInSession session);

  Future<Result<int>> nextBatchNumber({
    required String sessionId,
    required String restaurantId,
  });

  Future<Result<SessionEngineSnapshot>> validateToken(String sessionTokenValue);
}
