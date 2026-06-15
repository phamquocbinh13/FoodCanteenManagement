import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/batch/confirm_batch_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/add_to_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/clear_session_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/edit_cart_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/get_session_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/remove_cart_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/update_cart_item_quantity_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/get_menu_catalog_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/lock_menu_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase, SessionEngineDataSourceDailySequence;
import 'package:food_canteen_management/application/usecases/session/get_session_bill_use_case.dart';
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
import 'package:food_canteen_management/domain/entities/restaurant_table.dart';
import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/domain/events/domain_events.dart';

import '../helpers/test_helpers.dart';

final class _NoOpEvents implements DomainEventPublisher {
  @override
  Future<void> publish(DomainEvent event) async {}
}

final class _Sequence implements SessionEngineDataSourceDailySequence {
  _Sequence(this._ds);
  final InMemorySessionEngineDataSource _ds;
  @override
  int nextDailySequence(String dateKey) => _ds.nextDailySequence(dateKey);
}

void main() {
  late FakeClock clock;
  late FakeIdGenerator ids;
  late OrderingStore store;
  late InMemoryCartLocalDataSource cartLocal;
  late InMemorySessionEngineDataSource sessionDs;
  late SessionEngineRepositoryImpl sessionRepo;
  late MenuRepositoryImpl menuRepo;
  late SessionCartRepositoryImpl cartRepo;
  late BatchRepositoryImpl batchRepo;
  late String sessionId;

  const curryRiceId = 'item-curry-rice';
  const porkRollId = 'item-pork-roll-rice';
  const friedChickenId = 'item-fried-chicken-rice';

  Map<String, dynamic> defaultSelections({List<String> toppings = const []}) {
    return {
      'groups': {
        'rice_size': {'optionKeys': ['normal']},
        'soup': {'optionKeys': ['no']},
        if (toppings.isNotEmpty)
          'toppings': {'optionKeys': toppings},
      },
      'note': 'Ít muối',
    };
  }

  setUp(() async {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
    ids = FakeIdGenerator(prefix: 'id');
    store = OrderingStore();
    cartLocal = InMemoryCartLocalDataSource();
    sessionDs = InMemorySessionEngineDataSource(clock: clock, store: store);
    sessionRepo = SessionEngineRepositoryImpl(
      dataSource: sessionDs,
      idGenerator: ids,
      timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
      clock: clock,
    );
    menuRepo = MenuRepositoryImpl(store: store);
    cartRepo = SessionCartRepositoryImpl(store: store, localDataSource: cartLocal);
    batchRepo = BatchRepositoryImpl(store: store);

    final create = CreateSessionUseCase(
      repository: sessionRepo,
      policy: const SessionPolicy(),
      clock: clock,
      idGenerator: ids,
      eventPublisher: _NoOpEvents(),
      sequenceProvider: _Sequence(sessionDs),
    );
    final created = await create(
      const CreateSessionParams(
        restaurantId: SessionEngineConstants.demoRestaurantId,
        tableId: SessionEngineConstants.demoTable1Id,
        tableStatus: TableStatus.available,
        openedVia: SessionOpenedVia.cashierManual,
      ),
    );
    sessionId = (created as Success).value.snapshot.session.id;
  });

  group('Demo seed data', () {
    test('loads rice and drinks categories without pho', () {
      expect(store.categories.containsKey('cat-rice'), isTrue);
      expect(store.categories.containsKey('cat-drinks'), isTrue);
      expect(store.categories.containsKey('cat-noodles'), isFalse);
      expect(store.menuItems.containsKey('item-pho'), isFalse);
      expect(store.menuItems['item-curry-rice']!.name, 'Cơm cà ri gà');
      expect(store.menuItems['item-curry-rice']!.basePrice.amountMinor, 4500000);
      expect(store.menuItems.containsKey('item-tra-da'), isTrue);
    });
  });

  group('CustomizationValidator', () {
    test('requires rice size selection', () {
      const validator = CustomizationValidator();
      final result = validator.validate(
        groups: [store.customizationGroups['grp-curry-size']!],
        optionsByGroupId: {
          'grp-curry-size': [
            store.customizationOptions['opt-curry-normal']!,
            store.customizationOptions['opt-curry-more']!,
          ],
        },
        selectionsJson: const {'groups': {}},
      );
      expect(result, isA<Err<void>>());
    });

    test('accepts valid modifier selection', () {
      const validator = CustomizationValidator();
      final result = validator.validate(
        groups: [store.customizationGroups['grp-curry-size']!],
        optionsByGroupId: {
          'grp-curry-size': [
            store.customizationOptions['opt-curry-normal']!,
            store.customizationOptions['opt-curry-more']!,
          ],
        },
        selectionsJson: {
          'groups': {
            'rice_size': {'optionKeys': ['more']},
          },
        },
      );
      expect(result, isA<Success<void>>());
    });
  });

  group('Menu catalog caching', () {
    test('returns cached catalog on same menu version', () async {
      final useCase = GetMenuCatalogUseCase(
        menuRepository: menuRepo,
        store: store,
        clock: clock,
      );
      final first = await useCase(
        const GetMenuCatalogParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      final second = await useCase(
        const GetMenuCatalogParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(first, isA<Success>());
      expect(second, isA<Success>());
      expect(
        (first as Success).value.cachedAt,
        (second as Success).value.cachedAt,
      );
      expect((first as Success).value.menuVersion, store.menuVersion);
    });

    test('invalidates cache when menu version bumps', () async {
      final useCase = GetMenuCatalogUseCase(
        menuRepository: menuRepo,
        store: store,
        clock: clock,
      );
      final first = await useCase(
        const GetMenuCatalogParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      final firstVersion = (first as Success).value.menuVersion;
      store.bumpMenuVersion();
      final second = await useCase(
        const GetMenuCatalogParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect((second as Success).value.menuVersion, store.menuVersion);
      expect((second as Success).value.menuVersion, isNot(firstVersion));
    });
  });

  group('Cart and batch flow', () {
    late AddToCartUseCase addToCart;
    late GetSessionCartUseCase getCart;
    late UpdateCartItemQuantityUseCase updateQty;
    late RemoveCartItemUseCase removeItem;
    late EditCartItemUseCase editItem;
    late ClearSessionCartUseCase clearCart;
    late ConfirmBatchUseCase confirmBatch;
    late GetSessionBillUseCase getBill;

    setUp(() {
      final timeline = SessionTimelineRecorder(idGenerator: ids, clock: clock);
      addToCart = AddToCartUseCase(
        cartRepository: cartRepo,
        menuRepository: menuRepo,
        customizationValidator: const CustomizationValidator(),
        customizationRenderer: const CustomizationRenderer(),
        timelineRecorder: timeline,
        sessionDataSource: sessionDs,
        idGenerator: ids,
        clock: clock,
      );
      getCart = GetSessionCartUseCase(
        cartRepository: cartRepo,
        menuRepository: menuRepo,
        clock: clock,
      );
      updateQty = UpdateCartItemQuantityUseCase(
        cartRepository: cartRepo,
        clock: clock,
      );
      removeItem = RemoveCartItemUseCase(cartRepository: cartRepo);
      editItem = EditCartItemUseCase(
        cartRepository: cartRepo,
        menuRepository: menuRepo,
        customizationValidator: const CustomizationValidator(),
        customizationRenderer: const CustomizationRenderer(),
        idGenerator: ids,
        clock: clock,
      );
      clearCart = ClearSessionCartUseCase(cartRepository: cartRepo);
      confirmBatch = ConfirmBatchUseCase(
        cartRepository: cartRepo,
        batchRepository: batchRepo,
        menuRepository: menuRepo,
        sessionEngineRepository: sessionRepo,
        sessionDataSource: sessionDs,
        customizationRenderer: const CustomizationRenderer(),
        timelineRecorder: timeline,
        idGenerator: ids,
        eventPublisher: _NoOpEvents(),
        clock: clock,
        orderingStore: store,
      );
      getBill = GetSessionBillUseCase(
        store: store,
        sessionDataSource: sessionDs,
        getSessionCart: getCart,
      );
    });

    Future<void> addCurryRice({int quantity = 1}) async {
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
          quantity: quantity,
          selectionsJson: defaultSelections(toppings: ['egg']),
        ),
      );
    }

    test('cart subtotal includes modifiers', () async {
      await addCurryRice();
      final cart = await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(cart, isA<Success>());
      expect((cart as Success).value.subtotal.amountMinor, greaterThan(4500000));
    });

    test('increases quantity', () async {
      await addCurryRice();
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      final lineId = cart.items.first.id;
      await updateQty(
        UpdateCartItemQuantityParams(
          sessionCartId: cart.cart.id,
          cartItemId: lineId,
          delta: 1,
        ),
      );
      final updated = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(updated.items.first.quantity.value, 2);
    });

    test('decreases quantity', () async {
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
          quantity: 2,
          selectionsJson: defaultSelections(),
        ),
      );
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      await updateQty(
        UpdateCartItemQuantityParams(
          sessionCartId: cart.cart.id,
          cartItemId: cart.items.first.id,
          delta: -1,
        ),
      );
      final updated = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(updated.items.first.quantity.value, 1);
    });

    test('removes item when quantity reaches zero', () async {
      await addCurryRice();
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      await updateQty(
        UpdateCartItemQuantityParams(
          sessionCartId: cart.cart.id,
          cartItemId: cart.items.first.id,
          delta: -1,
        ),
      );
      final updated = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(updated.isEmpty, isTrue);
    });

    test('removes item completely', () async {
      await addCurryRice();
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      await removeItem(
        RemoveCartItemParams(
          sessionCartId: cart.cart.id,
          cartItemId: cart.items.first.id,
        ),
      );
      final updated = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(updated.isEmpty, isTrue);
    });

    test('edits customization and note', () async {
      await addCurryRice();
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      final before = cart.items.first.unitPriceSnapshot.amountMinor;

      await editItem(
        EditCartItemParams(
          sessionCartId: cart.cart.id,
          cartItemId: cart.items.first.id,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          selectionsJson: {
            'groups': {
              'rice_size': {'optionKeys': ['more']},
              'soup': {'optionKeys': ['yes']},
              'toppings': {'optionKeys': ['chicken', 'cha']},
            },
            'note': 'Không hành',
          },
        ),
      );

      final updated = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(updated.items.first.unitPriceSnapshot.amountMinor, greaterThan(before));
      expect(
        updated.items.first.selectionsJson['note'],
        'Không hành',
      );
    });

    test('persists and restores cart per session', () async {
      await addCurryRice();
      final cartBefore = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;

      final restoredRepo = SessionCartRepositoryImpl(
        store: OrderingStore(),
        localDataSource: cartLocal,
      );
      final restoredGetCart = GetSessionCartUseCase(
        cartRepository: restoredRepo,
        menuRepository: menuRepo,
        clock: clock,
      );

      final restored = await restoredGetCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(restored, isA<Success>());
      expect((restored as Success).value.items.length, cartBefore.items.length);
    });

    test('different sessions have different carts', () async {
      store.tables['table-2'] = RestaurantTable(
        id: 'table-2',
        restaurantId: SessionEngineConstants.demoRestaurantId,
        label: 'Table 2',
        status: TableStatus.available,
        createdAt: clock.now(),
        updatedAt: clock.now(),
      );

      final create = CreateSessionUseCase(
        repository: sessionRepo,
        policy: const SessionPolicy(),
        clock: clock,
        idGenerator: ids,
        eventPublisher: _NoOpEvents(),
        sequenceProvider: _Sequence(sessionDs),
      );
      final secondSession = (await create(
        const CreateSessionParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          tableId: 'table-2',
          tableStatus: TableStatus.available,
          openedVia: SessionOpenedVia.cashierManual,
        ),
      ) as Success)
          .value
          .snapshot
          .session
          .id;

      await addCurryRice();
      final cart1 = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      final cart2 = (await getCart(
        GetSessionCartParams(
          sessionId: secondSession,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;

      expect(cart1.isEmpty, isFalse);
      expect(cart2.isEmpty, isTrue);
    });

    test('confirm batch creates sequential batch numbers', () async {
      await addCurryRice();
      final first = await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(first, isA<Success>());
      expect((first as Success).value.batch.batchNumber, 1);

      await addCurryRice();
      final second = await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect((second as Success).value.batch.batchNumber, 2);
    });

    test('clears cart after confirm', () async {
      await addCurryRice();
      await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      final cart = await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect((cart as Success).value.isEmpty, isTrue);
    });

    test('batch items store price snapshots', () async {
      await addCurryRice();
      final ticket = (await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      final item = ticket.items.first;
      expect(item.menuItemNameSnapshot, 'Cơm cà ri gà');
      expect(item.unitPriceSnapshot.amountMinor, greaterThan(0));
      expect(item.kitchenNotesRendered, contains('Ít muối'));

      store.menuItems[curryRiceId] = store.menuItems[curryRiceId]!.copyWith(
        basePrice: store.menuItems[curryRiceId]!.basePrice.copyWith(
          amountMinor: 9900000,
        ),
      );

      expect(item.unitPriceSnapshot.amountMinor, isNot(9900000));
    });

    test('session bill recalculates from batch snapshots', () async {
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
          quantity: 1,
          selectionsJson: defaultSelections(),
        ),
      );
      await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );

      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: porkRollId,
          quantity: 1,
          selectionsJson: defaultSelections(),
        ),
      );
      await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );

      final bill = (await getBill(
        GetSessionBillParams(sessionId: sessionId),
      ) as Success)
          .value;

      var expectedMinor = 0;
      for (final batch in store.batchesForSession(sessionId)) {
        for (final line in store.batchItemsByBatchId[batch.id]!) {
          expectedMinor += line.lineTotal.amountMinor;
        }
      }
      expect(bill.subtotalMinor, expectedMinor);
      expect(bill.totalMinor, greaterThan(0));
    });

    test('clear cart removes all items', () async {
      await addCurryRice();
      await clearCart(ClearSessionCartParams(sessionId: sessionId));
      final cart = (await getCart(
        GetSessionCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(cart.isEmpty, isTrue);
    });

    test('blocks add when item locked', () async {
      final lock = LockMenuItemUseCase(
        menuRepository: menuRepo,
        store: store,
      );
      await lock(
        const LockMenuItemParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
        ),
      );

      final result = await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
          quantity: 1,
          selectionsJson: defaultSelections(),
        ),
      );
      expect(result, isA<Err>());
    });

    test('demo flow: three rice dishes across two batches', () async {
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: curryRiceId,
          quantity: 1,
          selectionsJson: defaultSelections(toppings: ['egg']),
        ),
      );
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: porkRollId,
          quantity: 1,
          selectionsJson: defaultSelections(),
        ),
      );
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: friedChickenId,
          quantity: 1,
          selectionsJson: defaultSelections(toppings: ['cha']),
        ),
      );

      final batch1 = (await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(batch1.items.length, 3);

      await addCurryRice();
      final batch2 = (await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      ) as Success)
          .value;
      expect(batch2.batch.batchNumber, 2);

      final bill = (await getBill(
        GetSessionBillParams(sessionId: sessionId),
      ) as Success)
          .value;
      expect(bill.subtotalMinor, greaterThan(0));
    });
  });
}
