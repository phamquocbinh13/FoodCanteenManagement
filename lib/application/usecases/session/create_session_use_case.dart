import '../../../application/session/session_constants.dart';
import '../../../application/session/session_display_number_generator.dart';
import '../../../application/session/session_token_generator.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../policies/session_policy.dart';
import '../use_case.dart';

/// Opens a dine-in session on a table and issues a customer join token.
final class CreateSessionUseCase
    implements UseCase<SessionAccess, CreateSessionParams> {
  CreateSessionUseCase({
    required SessionEngineRepository repository,
    required SessionPolicy policy,
    required Clock clock,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    SessionEngineDataSourceDailySequence? sequenceProvider,
  })  : _repository = repository,
        _policy = policy,
        _clock = clock,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _sequenceProvider = sequenceProvider;

  final SessionEngineRepository _repository;
  final SessionPolicy _policy;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final SessionEngineDataSourceDailySequence? _sequenceProvider;

  @override
  Future<Result<SessionAccess>> call(CreateSessionParams params) async {
    final now = _clock.now();
    final tableLookup = await _repository.findActiveByTable(
      restaurantId: params.restaurantId,
      tableId: params.tableId,
    );
    if (tableLookup is Err<SessionEngineSnapshot?>) {
      return Err(tableLookup.failure);
    }

    final hasActive = tableLookup.valueOrNull != null;
    final policyResult = _policy.canCreate(
      tableStatus: params.tableStatus,
      hasActiveSession: hasActive,
    );
    if (policyResult is Err<void>) {
      return Err(policyResult.failure);
    }

    final dateKey = _dateKey(now);
    final sequence = _sequenceProvider?.nextDailySequence(dateKey) ??
        params.fallbackSequence ??
        1;
    final displayNumber = SessionDisplayNumberGenerator.generate(
      clock: _clock,
      dailySequence: sequence,
    );
    final tokenValue = SessionTokenGenerator.generateSecureToken(_idGenerator);
    final expiresAt = now.add(SessionEngineConstants.tokenTtl);

    final createResult = await _repository.create(
      restaurantId: params.restaurantId,
      tableId: params.tableId,
      openedVia: params.openedVia,
      openedByUserId: params.openedByUserId,
      displayNumber: displayNumber,
      sessionSequence: sequence,
      sessionTokenValue: tokenValue,
      tokenExpiresAt: expiresAt,
      now: now,
    );

    if (createResult is Success<SessionAccess>) {
      final access = createResult.value;
      await _eventPublisher.publish(
        SessionCreated(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: access.snapshot.session.id,
          tableId: params.tableId,
          restaurantId: params.restaurantId,
          displayNumber: displayNumber,
        ),
      );
    }

    return createResult;
  }

  String _dateKey(DateTime now) {
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}

/// Supplies daily session sequence from datasource.
abstract interface class SessionEngineDataSourceDailySequence {
  int nextDailySequence(String dateKey);
}

final class CreateSessionParams {
  const CreateSessionParams({
    required this.restaurantId,
    required this.tableId,
    required this.tableStatus,
    required this.openedVia,
    this.openedByUserId,
    this.fallbackSequence,
  });

  final String restaurantId;
  final String tableId;
  final TableStatus tableStatus;
  final SessionOpenedVia openedVia;
  final String? openedByUserId;
  final int? fallbackSequence;
}
