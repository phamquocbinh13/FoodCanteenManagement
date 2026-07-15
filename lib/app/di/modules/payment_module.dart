import 'package:get_it/get_it.dart';

import '../../../application/mappers/payment_mapper.dart';
import '../../../application/policies/payment_policy.dart';
import '../../../application/usecases/payment/close_session_with_payment_use_case.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/payment/payment_datasource.dart';
import '../../../data/repositories/payment/payment_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../config/app_config.dart';

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

    if (sl<AppConfig>().useRemoteBackend) {
      sl.registerLazySingleton(
        () => CloseSessionWithPaymentUseCase(
          apiClient: sl<ApiClient>(),
          eventPublisher: sl<DomainEventPublisher>(),
          idGenerator: sl<IdGenerator>(),
          clock: sl<Clock>(),
        ),
      );
    }
  }
}
