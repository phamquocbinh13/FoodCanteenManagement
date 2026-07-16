import 'package:get_it/get_it.dart';

import '../../../application/usecases/payment/check_payment_status_use_case.dart';
import '../../../application/usecases/payment/close_session_with_payment_use_case.dart';
import '../../../application/usecases/payment/create_vnpay_intent_use_case.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../domain/events/domain_events.dart';

/// Payment close — server-owned atomic transaction via [ApiClient].
abstract final class PaymentModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton(
      () => CloseSessionWithPaymentUseCase(
        apiClient: sl<ApiClient>(),
        eventPublisher: sl<DomainEventPublisher>(),
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
      ),
    );
    sl.registerLazySingleton(
      () => CreateVnpayIntentUseCase(
        sl<ApiClient>(),
        sl<CustomerSessionLocalDataSource>(),
      ),
    );
    sl.registerLazySingleton(
      () => CheckPaymentStatusUseCase(
        sl<ApiClient>(),
        sl<CustomerSessionLocalDataSource>(),
      ),
    );
  }
}
