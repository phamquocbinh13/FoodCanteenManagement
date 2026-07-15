import 'package:get_it/get_it.dart';

import '../../../application/menu/customization_renderer.dart';
import '../../../application/validators/customization_validator.dart';
import '../../../application/usecases/menu/get_menu_catalog_use_case.dart';
import '../../../application/usecases/menu/get_menu_item_detail_use_case.dart';
import '../../../application/usecases/menu/lock_menu_item_use_case.dart';
import '../../../core/clock/clock.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/repositories/menu/menu_repository_impl.dart';
import '../../../data/repositories/menu/remote_menu_repository.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../config/app_config.dart';

abstract final class MenuModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton(() => const MenuDomainService());
    sl.registerLazySingleton(() => const CustomizationValidator());
    sl.registerLazySingleton(() => const CustomizationRenderer());

    sl.registerLazySingleton<MenuRepository>(
      () => sl<AppConfig>().useRemoteBackend
          ? RemoteMenuRepository(apiClient: sl<ApiClient>())
          : MenuRepositoryImpl(
              store: sl<OrderingStore>(),
              menuDomainService: sl<MenuDomainService>(),
            ),
    );

    sl.registerLazySingleton(
      () => GetMenuCatalogUseCase(
        menuRepository: sl<MenuRepository>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => GetMenuItemDetailUseCase(menuRepository: sl<MenuRepository>()),
    );

    sl.registerLazySingleton(
      () => LockMenuItemUseCase(
        menuRepository: sl<MenuRepository>(),
        menuDomainService: sl<MenuDomainService>(),
      ),
    );
  }
}
