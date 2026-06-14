import 'package:get_it/get_it.dart';

import '../../../application/mappers/menu_mapper.dart';
import '../../../application/validators/menu_validator.dart';
import '../../../data/datasources/menu/menu_datasource.dart';
import '../../../data/repositories/menu/menu_repository_impl.dart';
import '../../../domain/repositories/menu_repository.dart';

abstract final class MenuModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<MenuRemoteDataSource>(
      () => const StubMenuRemoteDataSource(),
    );

    sl.registerLazySingleton<MenuRepository>(
      () => MenuRepositoryImpl(remote: sl<MenuRemoteDataSource>()),
    );

    sl.registerLazySingleton(() => const MenuMapper());
    sl.registerLazySingleton(() => const MenuValidator());
  }
}
