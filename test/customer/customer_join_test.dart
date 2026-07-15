import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/session/customer_session_messages.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_token_parser.dart';
import 'package:food_canteen_management/application/usecases/request/create_staff_request_use_case.dart';
import 'package:food_canteen_management/application/usecases/request/list_session_staff_requests_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/join_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/mark_waiting_payment_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/validate_session_use_case.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/data/datasources/customer/customer_session_local_datasource.dart';
import 'package:food_canteen_management/data/datasources/ordering/ordering_store.dart';
import 'package:food_canteen_management/data/datasources/session/in_memory_session_engine_datasource.dart';
import 'package:food_canteen_management/data/repositories/request/request_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/session/session_engine_repository_impl.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/domain/services/request_domain_service.dart';
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

CustomerSessionController _buildCustomerController({
  required SessionEngineRepositoryImpl repository,
  required InMemorySessionEngineDataSource dataSource,
  required OrderingStore store,
  required InMemoryCustomerSessionLocalDataSource customerLocal,
  required FakeClock clock,
  required FakeIdGenerator ids,
  required DomainEventPublisher events,
}) {
  final timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);
  final requestRepo = RequestRepositoryImpl(store: store);
  return CustomerSessionController(
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
    createStaffRequest: CreateStaffRequestUseCase(
      requestRepository: requestRepo,
      sessionDataSource: dataSource,
      timelineRecorder: timeline,
      markWaitingPayment: MarkWaitingPaymentUseCase(
        repository: repository,
        policy: const SessionPolicy(),
        clock: clock,
        idGenerator: ids,
        eventPublisher: events,
      ),
      domainService: const RequestDomainService(),
      idGenerator: ids,
      eventPublisher: events,
      clock: clock,
    ),
    listSessionStaffRequests: ListSessionStaffRequestsUseCase(
      requestRepository: requestRepo,
    ),
    local: customerLocal,
    idGenerator: ids,
  );
}

void main() {
  late FakeClock clock;
  late FakeIdGenerator ids;
  late OrderingStore store;
  late InMemorySessionEngineDataSource dataSource;
  late SessionEngineRepositoryImpl repository;
  late InMemoryCustomerSessionLocalDataSource customerLocal;
  late _CollectingDomainEventPublisher events;
  late CustomerSessionController controller;
  late String sessionToken;

  setUp(() async {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 10));
    ids = FakeIdGenerator(prefix: 'id');
    store = OrderingStore();
    dataSource = InMemorySessionEngineDataSource(
      clock: clock,
      store: store,
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

    controller = _buildCustomerController(
      repository: repository,
      dataSource: dataSource,
      store: store,
      customerLocal: customerLocal,
      clock: clock,
      ids: ids,
      events: events,
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

      final restored = _buildCustomerController(
        repository: repository,
        dataSource: dataSource,
        store: store,
        customerLocal: customerLocal,
        clock: clock,
        ids: ids,
        events: events,
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

    test('request payment queues staff request and waits for payment', () async {
      await controller.join(sessionToken);
      final ok = await controller.requestPayment();
      expect(ok, isTrue);
      expect(controller.paymentRequested, isTrue);
      expect(
        controller.snapshot?.session.status,
        SessionStatus.paymentPending,
      );
      expect(controller.sessionRequests, isNotEmpty);
      expect(
        events.events.whereType<StaffRequestCreated>(),
        isNotEmpty,
      );
    });

    test('leaveSession clears persisted token for demo role switch', () async {
      await controller.join(sessionToken);
      expect((await customerLocal.readSessionToken()).valueOrNull, sessionToken);

      await controller.leaveSession();

      expect(controller.isJoined, isFalse);
      expect(controller.sessionToken, isNull);
      expect((await customerLocal.readSessionToken()).valueOrNull, isNull);
    });
  });
}
