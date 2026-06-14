import '../../domain/entities/dine_in_session.dart';
import 'mapper.dart';

/// Placeholder DTO for session persistence layer (Sprint 3).
typedef SessionDto = Map<String, dynamic>;

/// Maps [SessionDto] ↔ [DineInSession]. Implementation deferred.
final class SessionMapper implements BidirectionalMapper<DineInSession, SessionDto> {
  const SessionMapper();

  @override
  DineInSession toEntity(SessionDto dto) {
    throw UnimplementedError('SessionMapper.toEntity not implemented');
  }

  @override
  SessionDto toDto(DineInSession entity) {
    throw UnimplementedError('SessionMapper.toDto not implemented');
  }
}
