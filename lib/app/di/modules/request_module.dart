import 'package:get_it/get_it.dart';

import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/request/create_staff_request_use_case.dart';
import '../../../application/usecases/request/handle_staff_request_use_case.dart';
import '../../../application/usecases/request/list_pending_staff_requests_use_case.dart';
import '../../../application/usecases/request/list_session_staff_requests_use_case.dart';
import '../../../application/usecases/session/mark_waiting_payment_use_case.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/repositories/request/remote_request_repository.dart';
import '../../../data/repositories/request/request_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/request_domain_service.dart';
import '../../config/app_config.dart';

/// Request queue module — customer call-staff + cashier handling.
abstract final class RequestModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton(() => const RequestDomainService());

    sl.registerLazySingleton<RequestRepository>(
      () => sl<AppConfig>().useRemoteBackend
          ? RemoteRequestRepository(
              apiClient: sl<ApiClient>(),
              localSession: sl<CustomerSessionLocalDataSource>(),
            )
          : RequestRepositoryImpl(store: sl<OrderingStore>()),
    );

    sl.registerLazySingleton(
      () => CreateStaffRequestUseCase(
        requestRepository: sl<RequestRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
        timelineRecorder: sl<SessionTimelineRecorder>(),
        markWaitingPayment: sl<MarkWaitingPaymentUseCase>(),
        domainService: sl<RequestDomainService>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => HandleStaffRequestUseCase(
        requestRepository: sl<RequestRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
        timelineRecorder: sl<SessionTimelineRecorder>(),
        domainService: sl<RequestDomainService>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => ListPendingStaffRequestsUseCase(
        requestRepository: sl<RequestRepository>(),
        sessionEngineRepository: sl<SessionEngineRepository>(),
      ),
    );

    sl.registerLazySingleton(
      () => ListSessionStaffRequestsUseCase(
        requestRepository: sl<RequestRepository>(),
      ),
    );
  }
}
