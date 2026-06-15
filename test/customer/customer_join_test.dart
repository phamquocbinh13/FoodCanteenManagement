import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/session/customer_session_messages.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_token_parser.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/join_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/validate_session_use_case.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/data/datasources/customer/customer_session_local_datasource.dart';
import 'package:food_canteen_management/data/datasources/ordering/ordering_store.dart';
import 'package:food_canteen_management/data/datasources/session/in_memory_session_engine_datasource.dart';
import 'package:food_canteen_management/data/repositories/session/session_engine_repository_impl.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/features/customer/presentation/controllers/customer_session_controller.dart';

import '../helpers/test_helpers.dart';

final class _CollectingDomainEventPublisher implements DomainEventPublisher {
  final List<DomainEvent> events = [];

  @override
  Future<void> publish(DomainEvent event) async => events.add(event);
}

final class _Sequence implements SessionEngineDataSourceDailySequence {
  _Sequence(this._dataSource);
  final InMemorySessionEngineDataSource _dataSource;
  @override
  int nextDailySequence(String dateKey) => _dataSource.nextDailySequence(dateKey);
}

void main() {
  late FakeClock clock;
  late FakeIdGenerator ids;
  late InMemorySessionEngineDataSource dataSource;
  late SessionEngineRepositoryImpl repository;
  late InMemoryCustomerSessionLocalDataSource customerLocal;
  late _CollectingDomainEventPublisher events;
  late CustomerSessionController controller;
  late String sessionToken;

  setUp(() async {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 10));
    ids = FakeIdGenerator(prefix: 'id');
    dataSource = InMemorySessionEngineDataSource(
      clock: clock,
      store: OrderingStore(),
    );
    repository = SessionEngineRepositoryImpl(
      dataSource: dataSource,
      idGenerator: ids,
      timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
      clock: clock,
    );
    customerLocal = InMemoryCustomerSessionLocalDataSource();
    events = _CollectingDomainEventPublisher();

    final create = CreateSessionUseCase(
      repository: repository,
      policy: const SessionPolicy(),
      clock: clock,
      idGenerator: ids,
      eventPublisher: events,
      sequenceProvider: _Sequence(dataSource),
    );

    final created = await create(
      const CreateSessionParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
        tableId: SessionEngineConstants.demoTable1Id,
        tableStatus: TableStatus.available,
        openedVia: SessionOpenedVia.cashierManual,
      ),
    );
    sessionToken = (created as Success).value.sessionTokenValue;

    controller = CustomerSessionController(
      joinSession: JoinSessionUseCase(
        repository: repository,
        policy: const SessionPolicy(),
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      ),
      validateSession: ValidateSessionUseCase(
        repository: repository,
        policy: const SessionPolicy(),
        clock: clock,
      ),
      local: customerLocal,
      idGenerator: ids,
      eventPublisher: events,
      now: clock.now,
    );
  });

  group('SessionTokenParser', () {
    test('extracts token from join path', () {
      expect(
        SessionTokenParser.normalize('/join/sess_abc123'),
        'sess_abc123',
      );
    });

    test('passes through raw token', () {
      expect(SessionTokenParser.normalize('sess_A8X92P'), 'sess_A8X92P');
    });
  });

  group('CustomerSessionController', () {
    test('join by manual code succeeds', () async {
      final ok = await controller.join(sessionToken);
      expect(ok, isTrue);
      expect(controller.snapshot?.tableLabel, 'Table 1');
    });

    test('join by QR token string succeeds', () async {
      final ok = await controller.join(sessionToken);
      expect(ok, isTrue);
      expect(events.events.whereType<CustomerJoined>(), hasLength(1));
    });

    test('join by join path from QR deep link', () async {
      final ok = await controller.join('/join/$sessionToken');
      expect(ok, isTrue);
    });

    test('rejects invalid code', () async {
      final ok = await controller.join('invalid-token');
      expect(ok, isFalse);
      expect(
        controller.errorMessage,
        CustomerSessionMessages.sessionNotFound,
      );
    });

    test('rejects expired token', () async {
      clock.advance(SessionEngineConstants.tokenTtl + const Duration(hours: 1));
      final ok = await controller.join(sessionToken);
      expect(ok, isFalse);
      expect(
        controller.errorMessage,
        CustomerSessionMessages.sessionExpired,
      );
    });

    test('rejects closed session', () async {
      await controller.join(sessionToken);
      final sessionId = controller.snapshot!.session.id;
      await repository.close(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
        now: clock.now(),
      );

      final ok = await controller.join(sessionToken);
      expect(ok, isFalse);
      expect(controller.errorMessage, CustomerSessionMessages.sessionEnded);
    });

    test('persists and restores customer context', () async {
      await controller.join(sessionToken);

      final restored = CustomerSessionController(
        joinSession: JoinSessionUseCase(
          repository: repository,
          policy: const SessionPolicy(),
          clock: clock,
          idGenerator: ids,
          eventPublisher: events,
        ),
        validateSession: ValidateSessionUseCase(
          repository: repository,
          policy: const SessionPolicy(),
          clock: clock,
        ),
        local: customerLocal,
        idGenerator: ids,
        eventPublisher: events,
        now: clock.now,
      );

      final ok = await restored.tryRestore();
      expect(ok, isTrue);
      expect(restored.sessionToken, sessionToken);
      expect(restored.snapshot?.session.displayNumber, isNotEmpty);
    });

    test('refresh reconnect validates stored session', () async {
      await controller.join(sessionToken);
      final ok = await controller.refreshCurrentSession();
      expect(ok, isTrue);
    });

    test('request payment does not close session', () async {
      await controller.join(sessionToken);
      await controller.requestPayment();
      expect(controller.paymentRequested, isTrue);
      expect(controller.snapshot?.session.status, SessionStatus.open);
    });
  });
}
