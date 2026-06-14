import 'package:get_it/get_it.dart';

import '../../../application/mappers/batch_mapper.dart';
import '../../../application/policies/kitchen_policy.dart';
import '../../../application/usecases/batch/add_batch_use_case.dart';
import '../../../application/usecases/batch/complete_batch_use_case.dart';
import '../../../data/repositories/batch/batch_repository_impl.dart';
import '../../../domain/repositories/batch_repository.dart';

abstract final class KitchenModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<BatchRepository>(() => BatchRepositoryImpl());

    sl.registerLazySingleton(() => const BatchMapper());
    sl.registerLazySingleton(() => const KitchenPolicy());

    sl.registerLazySingleton(
      () => AddBatchUseCase(batchRepository: sl<BatchRepository>()),
    );

    sl.registerLazySingleton(
      () => CompleteBatchUseCase(batchRepository: sl<BatchRepository>()),
    );
  }
}
