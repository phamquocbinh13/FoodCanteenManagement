import 'package:get_it/get_it.dart';

import '../../../application/mappers/payment_mapper.dart';
import '../../../application/policies/payment_policy.dart';
import '../../../data/datasources/payment/payment_datasource.dart';
import '../../../data/repositories/payment/payment_repository_impl.dart';
import '../../../domain/repositories/payment_repository.dart';

abstract final class PaymentModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<PaymentRemoteDataSource>(
      () => const StubPaymentRemoteDataSource(),
    );

    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(remote: sl<PaymentRemoteDataSource>()),
    );

    sl.registerLazySingleton(() => const PaymentMapper());
    sl.registerLazySingleton(() => const PaymentPolicy());
  }
}
