import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/batch/confirm_batch_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/add_to_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/complete_batch_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/get_kitchen_queue_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/toggle_menu_availability_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase;
import 'package:food_canteen_management/application/validators/customization_validator.dart';
import 'package:food_canteen_management/core/result/result.dart';
import '../fakes/cart_local_datasource.dart';
import '../fakes/ordering_store.dart';
import '../fakes/in_memory_session_engine_datasource.dart';
import '../fakes/batch_repository_impl.dart';
import '../fakes/session_cart_repository_impl.dart';
import '../fakes/menu_repository_impl.dart';
import '../fakes/session_engine_repository_impl.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/domain/services/kitchen_domain_service.dart';

import '../helpers/test_helpers.dart';

Map<String, dynamic> defaultSelections({List<String> toppings = const []}) {
  return {
    'groups': {
      'rice_size': {'optionKeys': ['normal']},
      'soup': {'optionKeys': ['no']},
      if (toppings.isNotEmpty) 'toppings': {'optionKeys': toppings},
    },
    'note': 'Ít muối',
  };
}

final class _RecordingEvents implements DomainEventPublisher {
  final events = <DomainEvent>[];

  @override
  Future<void> publish(DomainEvent event) async {
    events.add(event);
  }
}


void main() {
  late FakeClock clock;
  late FakeIdGenerator ids;
  late OrderingStore store;
  late InMemorySessionEngineDataSource sessionDs;
  late SessionEngineRepositoryImpl sessionRepo;
  late MenuRepositoryImpl menuRepo;
  late SessionCartRepositoryImpl cartRepo;
  late BatchRepositoryImpl batchRepo;
  late _RecordingEvents events;
  late String sessionId;

  setUp(() async {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
    ids = FakeIdGenerator(prefix: 'kds');
    store = OrderingStore();
    events = _RecordingEvents();
    sessionDs = InMemorySessionEngineDataSource(clock: clock, store: store);
    sessionRepo = SessionEngineRepositoryImpl(
      dataSource: sessionDs,
      idGenerator: ids,
      timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
      clock: clock,
    );
    menuRepo = MenuRepositoryImpl(store: store);
    cartRepo = SessionCartRepositoryImpl(
      store: store,
      localDataSource: InMemoryCartLocalDataSource(),
    );
    batchRepo = BatchRepositoryImpl(store: store);

    final create = CreateSessionUseCase(
      repository: sessionRepo,
      policy: const SessionPolicy(),
      clock: clock,
      idGenerator: ids,
      eventPublisher: events,
    );
    sessionId = ((await create(
      const CreateSessionParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
        tableId: SessionEngineConstants.demoTable1Id,
        tableStatus: TableStatus.available,
        openedVia: SessionOpenedVia.cashierManual,
      ),
    )) as Success)
        .value
        .snapshot
        .session
        .id;
  });

  Future<void> confirmCurryAndTea() async {
    final timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);
    final addToCart = AddToCartUseCase(
      cartRepository: cartRepo,
      menuRepository: menuRepo,
      customizationValidator: const CustomizationValidator(),
      customizationRenderer: const CustomizationRenderer(),
      timelineRecorder: timeline,
      sessionEngineRepository: sessionRepo,
      idGenerator: ids,
      clock: clock,
    );
    final confirm = ConfirmBatchUseCase(
      cartRepository: cartRepo,
      batchRepository: batchRepo,
      menuRepository: menuRepo,
      sessionEngineRepository: sessionRepo,
      customizationRenderer: const CustomizationRenderer(),
      timelineRecorder: timeline,
      idGenerator: ids,
      eventPublisher: events,
      clock: clock,
    );

    await addToCart(
      AddToCartParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
        menuItemId: 'item-curry-rice',
        quantity: 1,
        selectionsJson: defaultSelections(),
      ),
    );
    await addToCart(
      AddToCartParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
        menuItemId: 'item-tra-da',
        quantity: 1,
        selectionsJson: const {'groups': {}},
      ),
    );
    await confirm(
      ConfirmBatchParams(
        sessionId: sessionId,
        restaurantId: SessionEngineConstants.demoRestaurantId,
      ),
    );
  }

  group('GetKitchenQueueUseCase', () {
    test('returns FIFO batch with kitchen-safe fields only', () async {
      await confirmCurryAndTea();
      final useCase = GetKitchenQueueUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        kitchenDomainService: const KitchenDomainService(),
        clock: clock,
      );
      final result = await useCase(
        const GetKitchenQueueParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(result, isA<Success>());
      final queue = (result as Success).value;
      expect(queue.batches.length, 1);
      expect(queue.batches.first.batchNumber, 1);
      expect(queue.batches.first.tableLabel, isNotEmpty);
      expect(queue.batches.first.items.length, 2);
    });

    test('hides completed batches by default', () async {
      await confirmCurryAndTea();
      final completeItem = CompleteBatchItemUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
        eventPublisher: events,
        idGenerator: ids,
        clock: clock,
      );
      final batch = store.batchesForSession(sessionId).first;
      final items = store.batchItemsByBatchId[batch.id]!;
      for (final item in items) {
        await completeItem(
          CompleteBatchItemParams(
            restaurantId: SessionEngineConstants.demoRestaurantId,
            batchItemId: item.id,
          ),
        );
      }

      final useCase = GetKitchenQueueUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        kitchenDomainService: const KitchenDomainService(),
        clock: clock,
      );
      final hidden = await useCase(
        const GetKitchenQueueParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect((hidden as Success).value.batches, isEmpty);

      final shown = await useCase(
        const GetKitchenQueueParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          showCompleted: true,
        ),
      );
      expect((shown as Success).value.batches.length, 1);
    });
  });

  group('CompleteBatchItemUseCase', () {
    test('one tap completes item and auto-completes batch', () async {
      await confirmCurryAndTea();
      final batch = store.batchesForSession(sessionId).first;
      final items = store.batchItemsByBatchId[batch.id]!;
      final useCase = CompleteBatchItemUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
        eventPublisher: events,
        idGenerator: ids,
        clock: clock,
      );

      for (final item in items) {
        await useCase(
          CompleteBatchItemParams(
            restaurantId: SessionEngineConstants.demoRestaurantId,
            batchItemId: item.id,
          ),
        );
      }

      expect(store.batchCompletedAtById[batch.id], isNotNull);
      expect(
        events.events.whereType<BatchCompleted>().length,
        1,
      );
      expect(
        sessionDs.store.timeline
            .where((e) => e.eventType == SessionTimelineEventType.batchCompleted)
            .length,
        1,
      );
    });
  });

  group('ToggleMenuAvailabilityUseCase', () {
    test('toggles availability and bumps menu version', () async {
      final useCase = ToggleMenuAvailabilityUseCase(
        menuRepository: menuRepo,
        eventPublisher: events,
        idGenerator: ids,
        clock: clock,
      );
      final before = store.menuVersion;
      final locked = await useCase(
        const ToggleMenuAvailabilityParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-curry-rice',
        ),
      );
      expect((locked as Success).value.availability, MenuAvailability.outOfStock);
      expect(store.menuVersion, greaterThan(before));
      expect(events.events.whereType<MenuDisabled>().length, 1);

      final unlocked = await useCase(
        const ToggleMenuAvailabilityParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-curry-rice',
        ),
      );
      expect((unlocked as Success).value.availability, MenuAvailability.available);
      expect(events.events.whereType<MenuUnlocked>().length, 1);
    });
  });

  group('GetSessionBatchProgressUseCase', () {
    test('customer sees batch-level status only', () async {
      await confirmCurryAndTea();
      final progress = GetSessionBatchProgressUseCase(
        batchRepository: batchRepo,
      );
      final result = await progress(
        GetSessionBatchProgressParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(result, isA<Success>());
      final views = (result as Success).value;
      expect(views.length, 1);
      expect(views.first.statusLabel, 'Preparing');
    });
  });

  group('Acceptance scenario integration', () {
    test('batch #1 completes then batch #2 appears in queue', () async {
      await confirmCurryAndTea();

      final timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);
      final addToCart = AddToCartUseCase(
        cartRepository: cartRepo,
        menuRepository: menuRepo,
        customizationValidator: const CustomizationValidator(),
        customizationRenderer: const CustomizationRenderer(),
        timelineRecorder: timeline,
        sessionEngineRepository: sessionRepo,
        idGenerator: ids,
        clock: clock,
      );
      final confirm = ConfirmBatchUseCase(
        cartRepository: cartRepo,
        batchRepository: batchRepo,
        menuRepository: menuRepo,
        sessionEngineRepository: sessionRepo,
        customizationRenderer: const CustomizationRenderer(),
        timelineRecorder: timeline,
        idGenerator: ids,
        eventPublisher: events,
        clock: clock,
      );
      final completeItem = CompleteBatchItemUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
        eventPublisher: events,
        idGenerator: ids,
        clock: clock,
      );
      final queueUseCase = GetKitchenQueueUseCase(
        batchRepository: batchRepo,
        sessionEngineRepository: sessionRepo,
        kitchenDomainService: const KitchenDomainService(),
        clock: clock,
      );

      final batch1 = store.batchesForSession(sessionId).first;
      for (final item in store.batchItemsByBatchId[batch1.id]!) {
        await completeItem(
          CompleteBatchItemParams(
            restaurantId: SessionEngineConstants.demoRestaurantId,
            batchItemId: item.id,
          ),
        );
      }

      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-pork-roll-rice',
          quantity: 1,
          selectionsJson: defaultSelections(),
        ),
      );
      await confirm(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );

      final queue = (await queueUseCase(
        const GetKitchenQueueParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(queue.batches.length, 1);
      expect(queue.batches.first.batchNumber, 2);
    });
  });
}
