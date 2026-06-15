import '../../../domain/entities/session_engine_snapshot.dart';

SessionEngineSnapshot? findSessionById(
  List<SessionEngineSnapshot> sessions,
  String sessionId,
) {
  for (final snapshot in sessions) {
    if (snapshot.session.id == sessionId) return snapshot;
  }
  return null;
}
