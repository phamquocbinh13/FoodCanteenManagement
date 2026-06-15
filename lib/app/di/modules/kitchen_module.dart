import 'package:get_it/get_it.dart';

import '../../../application/menu/customization_renderer.dart';
import '../../../application/policies/kitchen_policy.dart';
import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/batch/add_batch_use_case.dart';
import '../../../application/usecases/batch/complete_batch_use_case.dart';
import '../../../application/usecases/cart/add_to_cart_use_case.dart';
import '../../../application/usecases/cart/clear_session_cart_use_case.dart';
import '../../../application/usecases/cart/edit_cart_item_use_case.dart';
import '../../../application/usecases/cart/get_session_cart_use_case.dart';
import '../../../application/usecases/cart/remove_cart_item_use_case.dart';
import '../../../application/usecases/cart/update_cart_item_quantity_use_case.dart';
import '../../../application/usecases/kitchen/complete_batch_item_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_menu_panel_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_queue_use_case.dart';
import '../../../application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import '../../../application/usecases/kitchen/toggle_menu_availability_use_case.dart';
import '../../../application/usecases/session/get_session_bill_use_case.dart';
import '../../../application/validators/customization_validator.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/datasources/cart/cart_local_datasource.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../data/repositories/batch/batch_repository_impl.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/batch_domain_service.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../../domain/services/menu_domain_service.dart';

abstract final class KitchenModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<SessionCartRepository>(
      () => SessionCartRepositoryImpl(
        store: sl<OrderingStore>(),
        localDataSource: sl<CartLocalDataSource>(),
      ),
    );

    sl.registerLazySingleton<BatchRepository>(
      () => BatchRepositoryImpl(store: sl<OrderingStore>()),
    );

    sl.registerLazySingleton(() => const BatchDomainService());
    sl.registerLazySingleton(() => const KitchenDomainService());
    sl.registerLazySingleton(() => const KitchenPolicy());

    sl.registerLazySingleton(
      () => GetSessionCartUseCase(
        cartRepository: sl<SessionCartRepository>(),
        menuRepository: sl<MenuRepository>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => AddToCartUseCase(
        cartRepository: sl<SessionCartRepository>(),
        menuRepository: sl<MenuRepository>(),
        customizationValidator: sl<CustomizationValidator>(),
        customizationRenderer: sl<CustomizationRenderer>(),
        timelineRecorder: sl<SessionTimelineRecorder>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
        menuDomainService: sl<MenuDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => UpdateCartItemQuantityUseCase(
        cartRepository: sl<SessionCartRepository>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => RemoveCartItemUseCase(cartRepository: sl<SessionCartRepository>()),
    );

    sl.registerLazySingleton(
      () => EditCartItemUseCase(
        cartRepository: sl<SessionCartRepository>(),
        menuRepository: sl<MenuRepository>(),
        customizationValidator: sl<CustomizationValidator>(),
        customizationRenderer: sl<CustomizationRenderer>(),
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
        menuDomainService: sl<MenuDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => ClearSessionCartUseCase(cartRepository: sl<SessionCartRepository>()),
    );

    sl.registerLazySingleton(
      () => ConfirmBatchUseCase(
        cartRepository: sl<SessionCartRepository>(),
        batchRepository: sl<BatchRepository>(),
        menuRepository: sl<MenuRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
        customizationRenderer: sl<CustomizationRenderer>(),
        timelineRecorder: sl<SessionTimelineRecorder>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
        clock: sl<Clock>(),
        orderingStore: sl<OrderingStore>(),
        batchDomainService: sl<BatchDomainService>(),
        menuDomainService: sl<MenuDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => AddBatchUseCase(confirmBatch: sl<ConfirmBatchUseCase>()),
    );

    sl.registerLazySingleton(
      () => GetSessionBillUseCase(
        store: sl<OrderingStore>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
        getSessionCart: sl<GetSessionCartUseCase>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetKitchenQueueUseCase(
        batchRepository: sl<BatchRepository>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
        kitchenDomainService: sl<KitchenDomainService>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => CompleteBatchItemUseCase(
        batchRepository: sl<BatchRepository>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
        timelineRecorder: sl<SessionTimelineRecorder>(),
        eventPublisher: sl<DomainEventPublisher>(),
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => ToggleMenuAvailabilityUseCase(
        menuRepository: sl<MenuRepository>(),
        store: sl<OrderingStore>(),
        eventPublisher: sl<DomainEventPublisher>(),
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
        menuDomainService: sl<MenuDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetKitchenMenuPanelUseCase(
        menuRepository: sl<MenuRepository>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetSessionBatchProgressUseCase(
        store: sl<OrderingStore>(),
        batchRepository: sl<BatchRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetCashierBatchSummariesUseCase(
        store: sl<OrderingStore>(),
        batchRepository: sl<BatchRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => CompleteBatchUseCase(batchRepository: sl<BatchRepository>()),
    );
  }
}
