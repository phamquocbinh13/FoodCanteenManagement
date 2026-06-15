import 'package:freezed_annotation/freezed_annotation.dart';

import 'dine_in_session.dart';
import 'session_auth_token.dart';

part 'session_engine_snapshot.freezed.dart';
part 'session_engine_snapshot.g.dart';

/// Aggregate read model returned by the Session Engine repository.
@freezed
abstract class SessionEngineSnapshot with _$SessionEngineSnapshot {
  const factory SessionEngineSnapshot({
    required DineInSession session,
    SessionAuthToken? activeToken,
    required String tableLabel,
    @Default([]) List<String> batchIds,
    @Default([]) List<String> requestIds,
  }) = _SessionEngineSnapshot;

  factory SessionEngineSnapshot.fromJson(Map<String, dynamic> json) =>
      _$SessionEngineSnapshotFromJson(json);
}

/// Result of creating or joining a session including bearer token value.
@freezed
abstract class SessionAccess with _$SessionAccess {
  const factory SessionAccess({
    required SessionEngineSnapshot snapshot,
    required String sessionTokenValue,
  }) = _SessionAccess;
}
