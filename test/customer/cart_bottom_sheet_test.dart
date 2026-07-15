import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/batch/confirm_batch_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/add_to_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/clear_session_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/edit_cart_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/get_session_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/remove_cart_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/update_cart_item_quantity_use_case.dart';
import 'package:food_canteen_management/application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/get_menu_catalog_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/get_menu_item_detail_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase;
import 'package:food_canteen_management/application/usecases/session/get_session_bill_use_case.dart';
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
import 'package:food_canteen_management/features/customer/presentation/controllers/customer_ordering_controller.dart';
import 'package:food_canteen_management/features/customer/presentation/providers/customer_ordering_provider.dart';
import 'package:food_canteen_management/features/customer/presentation/widgets/cart_bottom_sheet.dart';

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

Future<({CustomerOrderingController controller, String sessionId})>
    createOrderingHarness() async {
  final clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
  final ids = FakeIdGenerator(prefix: 'widget');
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

  final createSession = CreateSessionUseCase(
    repository: sessionRepo,
    policy: const SessionPolicy(),
    clock: clock,
    idGenerator: ids,
    eventPublisher: _NoOpEvents(),
  );
  final created = await createSession(
    const CreateSessionParams(
      restaurantId: SessionEngineConstants.demoRestaurantId,
      tableId: SessionEngineConstants.demoTable1Id,
      tableStatus: TableStatus.available,
      openedVia: SessionOpenedVia.cashierManual,
    ),
  );
  final sessionId =
      (created as Success<dynamic>).value.snapshot.session.id as String;

  final getCart = GetSessionCartUseCase(
    cartRepository: cartRepo,
    menuRepository: menuRepo,
    clock: clock,
  );

  final controller = CustomerOrderingController(
    restaurantId: SessionEngineConstants.demoRestaurantId,
    getMenuCatalog: GetMenuCatalogUseCase(
      menuRepository: menuRepo,
      clock: clock,
    ),
    getMenuItemDetail: GetMenuItemDetailUseCase(menuRepository: menuRepo),
    addToCart: AddToCartUseCase(
      cartRepository: cartRepo,
      menuRepository: menuRepo,
      customizationValidator: const CustomizationValidator(),
      customizationRenderer: const CustomizationRenderer(),
      timelineRecorder: timeline,
      sessionEngineRepository: sessionRepo,
      idGenerator: ids,
      clock: clock,
    ),
    getSessionCart: getCart,
    updateCartItemQuantity: UpdateCartItemQuantityUseCase(
      cartRepository: cartRepo,
      clock: clock,
    ),
    removeCartItem: RemoveCartItemUseCase(cartRepository: cartRepo),
    editCartItem: EditCartItemUseCase(
      cartRepository: cartRepo,
      menuRepository: menuRepo,
      customizationValidator: const CustomizationValidator(),
      customizationRenderer: const CustomizationRenderer(),
      idGenerator: ids,
      clock: clock,
    ),
    clearSessionCart: ClearSessionCartUseCase(cartRepository: cartRepo),
    confirmBatch: ConfirmBatchUseCase(
      cartRepository: cartRepo,
      batchRepository: batchRepo,
      menuRepository: menuRepo,
      sessionEngineRepository: sessionRepo,
      customizationRenderer: const CustomizationRenderer(),
      timelineRecorder: timeline,
      idGenerator: ids,
      eventPublisher: _NoOpEvents(),
      clock: clock,
    ),
    getSessionBill: GetSessionBillUseCase(
      sessionRepository: sessionRepo,
      batchRepository: BatchRepositoryImpl(store: store),
      getSessionCart: getCart,
    ),
    getSessionBatchProgress: GetSessionBatchProgressUseCase(
      batchRepository: batchRepo,
    ),
  );

  await controller.loadMenu();
  await controller.addToCart(
    sessionId: sessionId,
    menuItemId: 'item-curry-rice',
    quantity: 1,
    selectionsJson: defaultSelections(),
  );

  return (controller: controller, sessionId: sessionId);
}

Widget buildCartSheet({
  required CustomerOrderingController controller,
  required String sessionId,
}) {
  return ProviderScope(
    overrides: [
      customerOrderingControllerProvider.overrideWith((ref) => controller),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: CartBottomSheet(sessionId: sessionId),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartBottomSheet reactivity', () {
    late CustomerOrderingController controller;
    late String sessionId;

    setUp(() async {
      final harness = await createOrderingHarness();
      controller = harness.controller;
      sessionId = harness.sessionId;
    });

    testWidgets('+ updates quantity without reopening sheet', (tester) async {
      await tester.pumpWidget(buildCartSheet(
        controller: controller,
        sessionId: sessionId,
      ));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Your cart'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('Your cart'), findsOneWidget);
      expect(controller.cart!.items.first.quantity.value, 2);
    });

    testWidgets('- decreases quantity without reopening sheet', (tester) async {
      await controller.updateQuantity(
        sessionId: sessionId,
        cartItemId: controller.cart!.items.first.id,
        delta: 1,
      );

      await tester.pumpWidget(buildCartSheet(
        controller: controller,
        sessionId: sessionId,
      ));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Your cart'), findsOneWidget);
    });

    testWidgets('remove updates list without reopening sheet', (tester) async {
      await tester.pumpWidget(buildCartSheet(
        controller: controller,
        sessionId: sessionId,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cơm cà ri gà'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(find.text('Cơm cà ri gà'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Your cart'), findsOneWidget);
    });

    testWidgets('totals update automatically after quantity change',
        (tester) async {
      await tester.pumpWidget(buildCartSheet(
        controller: controller,
        sessionId: sessionId,
      ));
      await tester.pumpAndSettle();

      final subtotalBefore = controller.cart!.subtotal.amountMinor;

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(controller.cart!.subtotal.amountMinor, greaterThan(subtotalBefore));
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.textContaining('2 items'), findsOneWidget);
    });

    testWidgets('edit opens nested sheet and updates cart on save',
        (tester) async {
      await tester.pumpWidget(buildCartSheet(
        controller: controller,
        sessionId: sessionId,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Update item'), findsOneWidget);
      expect(find.text('Your cart'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Nhiều cơm'),
        120,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Nhiều cơm'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.widgetWithText(ElevatedButton, 'Update item'),
        120,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update item'));
      await tester.pumpAndSettle();

      expect(find.text('Your cart'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Update item'), findsNothing);
      expect(
        controller.cart!.items.first.unitPriceSnapshot.amountMinor,
        greaterThan(4500000),
      );
    });
  });
}
