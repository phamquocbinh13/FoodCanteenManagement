import 'package:get_it/get_it.dart';

import '../../../application/menu/customization_renderer.dart';
import '../../../application/menu/kitchen_batch_ticket.dart';
import '../../../application/policies/kitchen_policy.dart';
import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/batch/add_batch_use_case.dart';
import '../../../application/usecases/batch/complete_batch_use_case.dart';
import '../../../application/usecases/batch/server_confirm_batch_use_case.dart';
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
import '../../../application/usecases/use_case.dart';
import '../../../application/validators/customization_validator.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/datasources/cart/cart_local_datasource.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/repositories/batch/batch_repository_impl.dart';
import '../../../data/repositories/batch/remote_batch_repository.dart';
import '../../../data/repositories/cart/remote_session_cart_repository.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/batch_domain_service.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../config/app_config.dart';

abstract final class KitchenModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<SessionCartRepository>(
      () => sl<AppConfig>().useRemoteBackend
          ? RemoteSessionCartRepository(
              apiClient: sl<ApiClient>(),
              localSession: sl<CustomerSessionLocalDataSource>(),
            )
          : SessionCartRepositoryImpl(
              store: sl<OrderingStore>(),
              localDataSource: sl<CartLocalDataSource>(),
            ),
    );

    sl.registerLazySingleton<BatchRepository>(
      () => sl<AppConfig>().useRemoteBackend
          ? RemoteBatchRepository(apiClient: sl<ApiClient>())
          : BatchRepositoryImpl(store: sl<OrderingStore>()),
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
        sessionEngineRepository: sl<SessionEngineRepository>(),
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

    if (sl<AppConfig>().useRemoteBackend) {
      sl.registerLazySingleton(
        () => ServerConfirmBatchUseCase(
          apiClient: sl<ApiClient>(),
          localSession: sl<CustomerSessionLocalDataSource>(),
          eventPublisher: sl<DomainEventPublisher>(),
          idGenerator: sl<IdGenerator>(),
          clock: sl<Clock>(),
        ),
      );
    } else {
      sl.registerLazySingleton(
        () => ConfirmBatchUseCase(
          cartRepository: sl<SessionCartRepository>(),
          batchRepository: sl<BatchRepository>(),
          menuRepository: sl<MenuRepository>(),
          sessionEngineRepository: sl<SessionEngineRepository>(),
          customizationRenderer: sl<CustomizationRenderer>(),
          timelineRecorder: sl<SessionTimelineRecorder>(),
          idGenerator: sl<IdGenerator>(),
          eventPublisher: sl<DomainEventPublisher>(),
          clock: sl<Clock>(),
          batchDomainService: sl<BatchDomainService>(),
          menuDomainService: sl<MenuDomainService>(),
        ),
      );
    }

    sl.registerLazySingleton<
        UseCase<KitchenBatchTicket, ConfirmBatchParams>>(
      () => sl<AppConfig>().useRemoteBackend
          ? sl<ServerConfirmBatchUseCase>()
          : sl<ConfirmBatchUseCase>(),
    );

    sl.registerLazySingleton(
      () => AddBatchUseCase(
        confirmBatch: sl<UseCase<KitchenBatchTicket, ConfirmBatchParams>>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetSessionBillUseCase(
        sessionRepository: sl<SessionEngineRepository>(),
        batchRepository: sl<BatchRepository>(),
        getSessionCart: sl<GetSessionCartUseCase>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetKitchenQueueUseCase(
        batchRepository: sl<BatchRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => CompleteBatchItemUseCase(
        batchRepository: sl<BatchRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
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
        batchRepository: sl<BatchRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetCashierBatchSummariesUseCase(
        batchRepository: sl<BatchRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => CompleteBatchUseCase(batchRepository: sl<BatchRepository>()),
    );
  }
}
