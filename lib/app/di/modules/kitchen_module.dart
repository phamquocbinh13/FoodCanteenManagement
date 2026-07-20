import 'package:get_it/get_it.dart';

import '../../../application/menu/customization_renderer.dart';
import '../../../application/menu/kitchen_batch_ticket.dart';
import '../../../application/policies/kitchen_policy.dart';
import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/batch/add_batch_use_case.dart';
import '../../../application/usecases/batch/server_confirm_batch_use_case.dart';
import '../../../application/usecases/cart/add_to_cart_use_case.dart';
import '../../../application/usecases/cart/clear_session_cart_use_case.dart';
import '../../../application/usecases/cart/edit_cart_item_use_case.dart';
import '../../../application/usecases/cart/get_session_cart_use_case.dart';
import '../../../application/usecases/cart/remove_cart_item_use_case.dart';
import '../../../application/usecases/cart/update_cart_item_quantity_use_case.dart';
import '../../../application/usecases/kitchen/complete_batch_item_use_case.dart';
import '../../../application/usecases/batch/staff_confirm_batch_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_menu_panel_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_overview_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_workflow_use_case.dart';
import '../../../application/usecases/kitchen/get_kitchen_queue_use_case.dart';
import '../../../application/usecases/batch/update_batch_item_quantity_use_case.dart';
import '../../../application/usecases/batch/remove_batch_item_use_case.dart';
import '../../../application/usecases/kitchen/get_session_batch_progress_use_case.dart';
import '../../../application/usecases/kitchen/toggle_menu_availability_use_case.dart';
import '../../../application/usecases/session/get_session_bill_use_case.dart';
import '../../../application/usecases/use_case.dart';
import '../../../application/validators/customization_validator.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../data/repositories/batch/remote_batch_repository.dart';
import '../../../data/repositories/cart/remote_session_cart_repository.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../config/restaurant_context.dart';
import '../../../domain/services/batch_domain_service.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../../domain/services/menu_domain_service.dart';

abstract final class KitchenModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<SessionCartRepository>(
      () => RemoteSessionCartRepository(
        apiClient: sl<ApiClient>(),
        localSession: sl<CustomerSessionLocalDataSource>(),
        restaurantId: sl<RestaurantContext>().restaurantId,
      ),
    );

    sl.registerLazySingleton<BatchRepository>(
      () => RemoteBatchRepository(
        apiClient: sl<ApiClient>(),
        localSession: sl<CustomerSessionLocalDataSource>(),
        defaultRestaurantId: sl<RestaurantContext>().restaurantId,
      ),
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

    sl.registerLazySingleton(
      () {
        final batches = sl<BatchRepository>();
        return ServerConfirmBatchUseCase(
          apiClient: sl<ApiClient>(),
          localSession: sl<CustomerSessionLocalDataSource>(),
          eventPublisher: sl<DomainEventPublisher>(),
          idGenerator: sl<IdGenerator>(),
          clock: sl<Clock>(),
          batchCache: batches is RemoteBatchRepository ? batches : null,
        );
      },
    );

    sl.registerLazySingleton<UseCase<KitchenBatchTicket, ConfirmBatchParams>>(
      () => sl<ServerConfirmBatchUseCase>(),
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
        apiClient: sl<ApiClient>(),
        localSession: sl<CustomerSessionLocalDataSource>(),
        preferCustomerProgressApi: true,
      ),
    );

    sl.registerLazySingleton(
      () => GetCashierBatchSummariesUseCase(
        batchRepository: sl<BatchRepository>(),
        kitchenDomainService: sl<KitchenDomainService>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetKitchenOverviewUseCase(apiClient: sl<ApiClient>()),
    );

    sl.registerLazySingleton(
      () => GetKitchenWorkflowUseCase(apiClient: sl<ApiClient>()),
    );

    sl.registerLazySingleton(
      () => StaffConfirmBatchUseCase(apiClient: sl<ApiClient>()),
    );

    sl.registerLazySingleton(
      () => UpdateBatchItemQuantityUseCase(
        batchRepository: sl<BatchRepository>(),
      ),
    );

    sl.registerLazySingleton(
      () => RemoveBatchItemUseCase(
        batchRepository: sl<BatchRepository>(),
      ),
    );
  }
}
