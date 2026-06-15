import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/menu/customization_renderer.dart';
import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/application/session/session_timeline_recorder.dart';
import 'package:food_canteen_management/application/usecases/batch/confirm_batch_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/add_to_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/cart/get_session_cart_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/get_menu_catalog_use_case.dart';
import 'package:food_canteen_management/application/usecases/menu/lock_menu_item_use_case.dart';
import 'package:food_canteen_management/application/usecases/session/create_session_use_case.dart'
    show CreateSessionParams, CreateSessionUseCase, SessionEngineDataSourceDailySequence;
import 'package:food_canteen_management/application/usecases/session/get_session_bill_use_case.dart';
import 'package:food_canteen_management/application/validators/customization_validator.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/data/datasources/ordering/ordering_store.dart';
import 'package:food_canteen_management/data/datasources/session/in_memory_session_engine_datasource.dart';
import 'package:food_canteen_management/data/repositories/batch/batch_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/cart/session_cart_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/menu/menu_repository_impl.dart';
import 'package:food_canteen_management/data/repositories/session/session_engine_repository_impl.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
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
  late InMemorySessionEngineDataSource sessionDs;
  late SessionEngineRepositoryImpl sessionRepo;
  late MenuRepositoryImpl menuRepo;
  late SessionCartRepositoryImpl cartRepo;
  late BatchRepositoryImpl batchRepo;
  late String sessionId;

  setUp(() async {
    clock = FakeClock(DateTime.utc(2025, 6, 15, 12));
    ids = FakeIdGenerator(prefix: 'id');
    store = OrderingStore();
    sessionDs = InMemorySessionEngineDataSource(clock: clock, store: store);
    sessionRepo = SessionEngineRepositoryImpl(
      dataSource: sessionDs,
      idGenerator: ids,
      timelineRecorder: SessionTimelineRecorder(idGenerator: ids, clock: clock),
      clock: clock,
    );
    menuRepo = MenuRepositoryImpl(store: store);
    cartRepo = SessionCartRepositoryImpl(store: store);
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

  group('CustomizationValidator', () {
    test('requires rice size selection', () {
      const validator = CustomizationValidator();
      final result = validator.validate(
        groups: [
          store.customizationGroups['grp-rice-size']!,
        ],
        optionsByGroupId: {
          'grp-rice-size': [
            store.customizationOptions['opt-normal']!,
            store.customizationOptions['opt-large']!,
          ],
        },
        selectionsJson: const {'groups': {}},
      );
      expect(result, isA<Err<void>>());
    });

    test('accepts valid modifier selection', () {
      const validator = CustomizationValidator();
      final result = validator.validate(
        groups: [
          store.customizationGroups['grp-rice-size']!,
        ],
        optionsByGroupId: {
          'grp-rice-size': [
            store.customizationOptions['opt-normal']!,
            store.customizationOptions['opt-large']!,
          ],
        },
        selectionsJson: {
          'groups': {
            'rice_size': {'optionKeys': ['large']},
          },
        },
      );
      expect(result, isA<Success<void>>());
    });
  });

  group('Menu catalog caching', () {
    test('returns cached catalog on second call', () async {
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
    });
  });

  group('Cart and batch flow', () {
    late AddToCartUseCase addToCart;
    late GetSessionCartUseCase getCart;
    late ConfirmBatchUseCase confirmBatch;
    late GetSessionBillUseCase getBill;

    setUp(() {
      final timeline =
          SessionTimelineRecorder(idGenerator: ids, clock: clock);
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
        clock: clock,
      );
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
      );
      getBill = GetSessionBillUseCase(
        store: store,
        sessionDataSource: sessionDs,
        getSessionCart: getCart,
      );
    });

    Future<void> addFriedRice() async {
      await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-fried-rice',
          quantity: 1,
          selectionsJson: {
            'groups': {
              'rice_size': {'optionKeys': ['large']},
              'toppings': {'optionKeys': ['chicken']},
            },
            'note': 'Extra spicy',
          },
        ),
      );
    }

    test('cart subtotal includes modifiers', () async {
      await addFriedRice();
      final cart = await getCart(GetSessionCartParams(sessionId: sessionId));
      expect(cart, isA<Success>());
      expect((cart as Success).value.subtotal.amountMinor, greaterThan(850));
    });

    test('confirm batch creates sequential batch numbers', () async {
      await addFriedRice();
      final first = await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect(first, isA<Success>());
      expect((first as Success).value.batch.batchNumber, 1);

      await addFriedRice();
      final second = await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      expect((second as Success).value.batch.batchNumber, 2);
    });

    test('clears cart after confirm', () async {
      await addFriedRice();
      await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      final cart = await getCart(GetSessionCartParams(sessionId: sessionId));
      expect((cart as Success).value.isEmpty, isTrue);
    });

    test('session bill sums confirmed batches', () async {
      await addFriedRice();
      await confirmBatch(
        ConfirmBatchParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
        ),
      );
      final bill = await getBill(GetSessionBillParams(sessionId: sessionId));
      expect((bill as Success).value.totalMinor, greaterThan(0));
    });

    test('blocks add when item locked', () async {
      final lock = LockMenuItemUseCase(
        menuRepository: menuRepo,
        store: store,
      );
      await lock(
        const LockMenuItemParams(
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-fried-rice',
        ),
      );

      final result = await addToCart(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: SessionEngineConstants.demoRestaurantId,
          menuItemId: 'item-fried-rice',
          quantity: 1,
          selectionsJson: {
            'groups': {
              'rice_size': {'optionKeys': ['normal']},
            },
          },
        ),
      );
      expect(result, isA<Err>());
    });
  });
}
