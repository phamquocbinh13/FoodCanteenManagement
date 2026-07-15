import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/session/customer_session_messages.dart';
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
import 'package:food_canteen_management/application/usecases/request/create_staff_request_use_case.dart';
import 'package:food_canteen_management/application/usecases/request/list_session_staff_requests_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase;
import 'package:food_canteen_management/application/usecases/session/get_session_bill_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/join_session_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/mark_waiting_payment_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/validate_session_use_case.dart';
import 'package:food_canteen_management/application/validators/customization_validator.dart';
import 'package:food_canteen_management/core/result/result.dart';
import '../fakes/cart_local_datasource.dart';
import 'package:food_canteen_management/data/datasources/customer/customer_session_local_datasource.dart';
import '../fakes/ordering_store.dart';
import '../fakes/in_memory_session_engine_datasource.dart';
import '../fakes/batch_repository_impl.dart';
import '../fakes/session_cart_repository_impl.dart';
import '../fakes/menu_repository_impl.dart';
import '../fakes/request_repository_impl.dart';
import '../fakes/session_engine_repository_impl.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';
import 'package:food_canteen_management/domain/services/request_domain_service.dart';
import 'package:food_canteen_management/features/customer/presentation/controllers/customer_ordering_controller.dart';
import 'package:food_canteen_management/features/customer/presentation/providers/customer_ordering_provider.dart';
import 'package:food_canteen_management/features/customer/presentation/providers/customer_session_provider.dart';
import 'package:food_canteen_management/features/customer/presentation/widgets/customer_demo_exit_button.dart';

import '../helpers/test_helpers.dart';

final class _NoOpEvents implements DomainEventPublisher {
  @override
  Future<void> publish(DomainEvent event) async {}
}


Future<
    ({
      CustomerSessionController session,
      CustomerOrderingController ordering,
      InMemoryCustomerSessionLocalDataSource local,
      String sessionId,
    })> buildCustomerDemoContext() async {
  final clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
  final ids = FakeIdGenerator(prefix: 'exit');
  final store = OrderingStore();
  final local = InMemoryCustomerSessionLocalDataSource();
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
  final created = await create(
    const CreateSessionParams(
      restaurantId: SessionEngineConstants.demoRestaurantId,
      tableId: SessionEngineConstants.demoTable1Id,
      tableStatus: TableStatus.available,
      openedVia: SessionOpenedVia.cashierManual,
    ),
  );
  final sessionToken = (created as Success).value.sessionTokenValue;

  final requestRepo = RequestRepositoryImpl(store: store);
  final session = CustomerSessionController(
    joinSession: JoinSessionUseCase(
      repository: sessionRepo,
      policy: const SessionPolicy(),
      clock: clock,
      idGenerator: ids,
      eventPublisher: _NoOpEvents(),
    ),
    validateSession: ValidateSessionUseCase(
      repository: sessionRepo,
      policy: const SessionPolicy(),
      clock: clock,
    ),
    createStaffRequest: CreateStaffRequestUseCase(
      requestRepository: requestRepo,
      sessionEngineRepository: sessionRepo,
      timelineRecorder: timeline,
      markWaitingPayment: MarkWaitingPaymentUseCase(
        repository: sessionRepo,
        policy: const SessionPolicy(),
        clock: clock,
        idGenerator: ids,
        eventPublisher: _NoOpEvents(),
      ),
      domainService: const RequestDomainService(),
      idGenerator: ids,
      eventPublisher: _NoOpEvents(),
      clock: clock,
    ),
    listSessionStaffRequests: ListSessionStaffRequestsUseCase(
      requestRepository: requestRepo,
    ),
    local: local,
    idGenerator: ids,
  );
  await session.join(sessionToken);

  final getCart = GetSessionCartUseCase(
    cartRepository: cartRepo,
    menuRepository: menuRepo,
    clock: clock,
  );
  final ordering = CustomerOrderingController(
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

  await ordering.addToCart(
    sessionId: session.snapshot!.session.id,
    menuItemId: 'item-curry-rice',
    quantity: 1,
    selectionsJson: const {
      'groups': {
        'rice_size': {'optionKeys': ['normal']},
        'soup': {'optionKeys': ['no']},
      },
    },
  );

  return (
    session: session,
    ordering: ordering,
    local: local,
    sessionId: session.snapshot!.session.id,
  );
}

void main() {
  group('Customer demo exit', () {
    test('leaveSession clears persisted token and in-memory snapshot', () async {
      final ctx = await buildCustomerDemoContext();
      expect(ctx.session.isJoined, isTrue);
      expect((await ctx.local.readSessionToken()).valueOrNull, isNotNull);

      await ctx.session.leaveSession();

      expect(ctx.session.isJoined, isFalse);
      expect(ctx.session.sessionToken, isNull);
      expect((await ctx.local.readSessionToken()).valueOrNull, isNull);
    });

    test('resetSessionState clears ordering memory', () async {
      final ctx = await buildCustomerDemoContext();
      expect(ctx.ordering.cartItemCount, greaterThan(0));

      ctx.ordering.resetSessionState();

      expect(ctx.ordering.cart, isNull);
      expect(ctx.ordering.cartItemCount, 0);
      expect(ctx.ordering.batchProgress, isEmpty);
    });

    testWidgets('exit button shows confirmation then clears customer scope',
        (tester) async {
      final ctx = await buildCustomerDemoContext();
      final router = GoRouter(
        initialLocation: '/session',
        routes: [
          GoRoute(
            path: '/session',
            builder: (context, state) => Scaffold(
              appBar: AppBar(actions: const [CustomerDemoExitButton()]),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(body: Text('Staff Login')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerSessionControllerProvider.overrideWith((ref) => ctx.session),
            customerOrderingControllerProvider.overrideWith((ref) => ctx.ordering),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Leave session'));
      await tester.pumpAndSettle();
      expect(find.text(CustomerSessionMessages.demoExitPrompt), findsOneWidget);

      await tester.tap(find.text(CustomerSessionMessages.demoExitConfirm));
      await tester.pumpAndSettle();

      expect(ctx.session.isJoined, isFalse);
      expect((await ctx.local.readSessionToken()).valueOrNull, isNull);
      expect(ctx.ordering.cart, isNull);
      expect(find.text('Staff Login'), findsOneWidget);
    });

    testWidgets('cancel keeps active customer session', (tester) async {
      final ctx = await buildCustomerDemoContext();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerSessionControllerProvider.overrideWith((ref) => ctx.session),
            customerOrderingControllerProvider.overrideWith((ref) => ctx.ordering),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(actions: const [CustomerDemoExitButton()]),
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Leave session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(CustomerSessionMessages.demoExitCancel));
      await tester.pumpAndSettle();

      expect(ctx.session.isJoined, isTrue);
      expect((await ctx.local.readSessionToken()).valueOrNull, isNotNull);
    });
  });
}
