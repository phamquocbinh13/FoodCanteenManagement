import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_display_number_generator.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/session/close_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/join_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/mark_waiting_payment_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/validate_session_use_case.dart';
import 'package:food_canteen_management/core/result/result.dart';
import '../fakes/ordering_store.dart';
import '../fakes/in_memory_session_engine_datasource.dart';
import '../fakes/session_engine_repository_impl.dart';
import 'package:food_canteen_management/domain/entities/session_auth_token.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/domain/services/session_state_machine.dart';

import '../helpers/test_helpers.dart';

final class CollectingDomainEventPublisher implements DomainEventPublisher {
  final List<DomainEvent> events = [];

  @override
  Future<void> publish(DomainEvent event) async {
    events.add(event);
  }
}

void main() {
  late FakeClock clock;
  late FakeIdGenerator ids;
  late InMemorySessionEngineDataSource dataSource;
  late SessionEngineRepositoryImpl repository;
  late SessionTimelineRecorder timeline;
  late SessionPolicy policy;
  late CollectingDomainEventPublisher events;

  setUp(() {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 10));
    ids = FakeIdGenerator(prefix: 'id');
    dataSource = InMemorySessionEngineDataSource(
      clock: clock,
      store: OrderingStore(),
    );
    timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);
    repository = SessionEngineRepositoryImpl(
      dataSource: dataSource,
      idGenerator: ids,
      timelineRecorder: timeline,
      clock: clock,
    );
    policy = const SessionPolicy();
    events = CollectingDomainEventPublisher();
  });

  group('SessionStateMachine', () {
    test('allows occupied → waiting payment → closed', () {
      expect(
        SessionStateMachine.canTransition(
          SessionStatus.open,
          SessionStatus.paymentPending,
        ),
        isTrue,
      );
      expect(
        SessionStateMachine.canTransition(
          SessionStatus.paymentPending,
          SessionStatus.closed,
        ),
        isTrue,
      );
    });

    test('rejects closed → occupied', () {
      expect(
        SessionStateMachine.canTransition(
          SessionStatus.closed,
          SessionStatus.open,
        ),
        isFalse,
      );
    });

    test('rejects waiting payment → available (open)', () {
      expect(
        SessionStateMachine.canTransition(
          SessionStatus.paymentPending,
          SessionStatus.open,
        ),
        isFalse,
      );
    });
  });

  group('SessionDisplayNumberGenerator', () {
    test('formats daily sequence', () {
      final number = SessionDisplayNumberGenerator.generate(
        clock: clock,
        dailySequence: 23,
      );
      expect(number, 'S-20250615-00023');
    });
  });

  group('SessionPolicy', () {
    test('rejects join on expired token', () {
      final token = SessionAuthToken(
        id: 't1',
        sessionId: 's1',
        tokenHash: 'hash',
        expiresAt: clock.now().subtract(const Duration(minutes: 1)),
        createdAt: clock.now(),
      );

      final result = policy.canJoin(
        status: SessionStatus.open,
        token: token,
        now: clock.now(),
      );

      expect(result, isA<Err<void>>());
    });

    test('canRequestPayment rejects payment pending', () {
      final result = policy.canRequestPayment(
        status: SessionStatus.paymentPending,
      );
      expect(result, isA<Err<void>>());
    });
  });

  group('CreateSessionUseCase', () {
    test('creates session with display number and token', () async {
      final useCase = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );

      final result = await useCase(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );

      expect(result, isA<Success>());
      final access = (result as Success).value;
      expect(access.snapshot.session.displayNumber, 'S-20250615-00001');
      expect(access.sessionTokenValue, isNotEmpty);
      expect(events.events, hasLength(1));
      expect(events.events.first, isA<SessionCreated>());
    });

    test('rejects second active session on same table', () async {
      final useCase = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );

      await useCase(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );

      final second = await useCase(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.occupied,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );

      expect(second, isA<Err>());
    });
  });

  group('JoinSessionUseCase', () {
    test('customer joins via token', () async {
      final create = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final created = await create(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );
      final token = (created as Success).value.sessionTokenValue;

      final join = JoinSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final joined = await join(JoinSessionParams(sessionToken: token));

      expect(joined, isA<Success>());
      expect(events.events.whereType<CustomerJoined>(), hasLength(1));
    });

    test('rejects expired token', () async {
      final create = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final created = await create(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );
      final token = (created as Success).value.sessionTokenValue;

      clock.advance(SessionEngineConstants.tokenTtl + const Duration(minutes: 1));

      final validate = ValidateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
      );
      final result = await validate(ValidateSessionParams(sessionToken: token));
      expect(result, isA<Err>());
    });
  });

  group('CloseSessionUseCase', () {
    test('closes session and invalidates token', () async {
      final create = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final created = await create(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );
      final access = (created as Success).value;

      final close = CloseSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final closed = await close(
        CloseSessionParams(
          sessionId: access.snapshot.session.id,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );

      expect(closed, isA<Success>());
      final table = dataSource.getTable(SessionEngineConstants.demoTable1Id)!;
      expect(table.status, TableStatus.available);

      final validate = await repository.validateToken(access.sessionTokenValue);
      expect(validate, isA<Err>());
    });
  });

  group('Timeline', () {
    test('records lifecycle events', () async {
      final create = CreateSessionUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      final created = await create(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: SessionEngineConstants.demoTable1Id,
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      );
      final sessionId = (created as Success).value.snapshot.session.id;

      final mark = MarkWaitingPaymentUseCase(
        repository: repository,
        policy: policy,
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      );
      await mark(
        MarkWaitingPaymentParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );

      final timelineEvents = dataSource.timelineForSession(sessionId);
      expect(timelineEvents, isNotEmpty);
      expect(
        timelineEvents.map((e) => e.eventType),
        contains(SessionTimelineEventType.sessionOpened),
      );
      expect(
        timelineEvents.map((e) => e.eventType),
        contains(SessionTimelineEventType.paymentRequested),
      );
    });
  });
}

