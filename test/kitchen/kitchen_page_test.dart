import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_canteen_management/app/di/injection.dart';
import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/batch/confirm_batch_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/add_to_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/complete_batch_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/get_kitchen_menu_panel_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/get_kitchen_queue_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/toggle_menu_availability_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase;
import 'package:food_canteen_management/application/validators/customization_validator.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/data/datasources/cart/cart_local_datasource.dart';
import 'package:food_canteen_management/data/datasources/ordering/ordering_store.dart';
import 'package:food_canteen_management/data/datasources/session/in_memory_session_engine_datasource.dart';
import 'package:food_canteen_management/data/repositories/batch/batch_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/cart/session_cart_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/menu/menu_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/session/session_engine_repository_impl.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/domain/services/kitchen_domain_service.dart';
import 'package:food_canteen_management/features/auth/presentation/providers/auth_provider.dart';
import 'package:food_canteen_management/features/kitchen/presentation/controllers/kitchen_controller.dart';
import 'package:food_canteen_management/features/kitchen/presentation/pages/kitchen_page.dart';
import 'package:food_canteen_management/features/kitchen/presentation/providers/kitchen_provider.dart';

import '../helpers/test_helpers.dart';

final class _NoOpEvents implements DomainEventPublisher {
  @override
  Future<void> publish(DomainEvent event) async {}
}


Map<String, dynamic> defaultSelections() => {
      'groups': {
        'rice_size': {'optionKeys': ['normal']},
        'soup': {'optionKeys': ['no']},
      },
    };

Future<KitchenController> buildKitchenController() async {
  final clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
  final ids = FakeIdGenerator(prefix: 'kpage');
  final store = OrderingStore();
  final sessionDs = InMemorySessionEngineDataSource(clock: clock, store: store);
  final sessionRepo = SessionEngineRepositoryImpl(
    dataSource: sessionDs,
    idGenerator: ids,
    timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
    clock: clock,
  );
  final menuRepo = MenuRepositoryImpl(store: store);
  final cartRepo = SessionCartRepositoryImpl(
    store: store,
    localDataSource: InMemoryCartLocalDataSource(),
  );
  final batchRepo = BatchRepositoryImpl(store: store);
  final timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);

  final create = CreateSessionUseCase(
    repository: sessionRepo,
    policy: const SessionPolicy(),
    clock: clock,
    idGenerator: ids,
    eventPublisher: _NoOpEvents(),
  );
  final sessionId = ((await create(
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
    eventPublisher: _NoOpEvents(),
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

  final controller = KitchenController(
    getKitchenQueue: GetKitchenQueueUseCase(
      batchRepository: batchRepo,
      sessionEngineRepository: sessionRepo,
      kitchenDomainService: const KitchenDomainService(),
      clock: clock,
    ),
    completeBatchItem: CompleteBatchItemUseCase(
      batchRepository: batchRepo,
      sessionEngineRepository: sessionRepo,
      timelineRecorder: timeline,
      eventPublisher: _NoOpEvents(),
      idGenerator: ids,
      clock: clock,
    ),
    toggleMenuAvailability: ToggleMenuAvailabilityUseCase(
      menuRepository: menuRepo,
      eventPublisher: _NoOpEvents(),
      idGenerator: ids,
      clock: clock,
    ),
    getKitchenMenuPanel: GetKitchenMenuPanelUseCase(menuRepository: menuRepo),
  );
  await controller.refresh();
  return controller;
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Injection.reset();
    await Injection.init();
    await sl<AuthController>().login(username: 'kitchen', password: 'kitchen123');
  });

  testWidgets('KitchenPage shows FIFO batch with large-touch item tiles',
      (tester) async {
    final controller = await buildKitchenController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kitchenControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: KitchenPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Batch #1'), findsOneWidget);
    expect(find.textContaining('Cơm cà ri gà'), findsOneWidget);
    expect(find.textContaining('Trà đá'), findsOneWidget);

    await tester.tap(find.textContaining('Cơm cà ri gà'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Cơm cà ri gà'), findsOneWidget);
    expect(find.textContaining('Batch #1'), findsOneWidget);
  });

  testWidgets('KitchenPage one tap completes item without confirmation dialog',
      (tester) async {
    final controller = await buildKitchenController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kitchenControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: KitchenPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.textContaining('Trà đá'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
