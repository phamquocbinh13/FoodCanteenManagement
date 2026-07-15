import 'package:get_it/get_it.dart';

import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/request/create_staff_request_use_case.dart';
import '../../../application/usecases/request/handle_staff_request_use_case.dart';
import '../../../application/usecases/request/list_pending_staff_requests_use_case.dart';
import '../../../application/usecases/request/list_session_staff_requests_use_case.dart';
import '../../../application/usecases/session/mark_waiting_payment_use_case.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../data/repositories/request/request_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../../domain/services/request_domain_service.dart';

/// Request queue module — customer call-staff + cashier handling.
abstract final class RequestModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton(() => const RequestDomainService());

    sl.registerLazySingleton<RequestRepository>(
      () => RequestRepositoryImpl(store: sl<OrderingStore>()),
    );

    sl.registerLazySingleton(
      () => CreateStaffRequestUseCase(
        requestRepository: sl<RequestRepository>(),
        sessionDataSource: sl<SessionEngineDataSource>(),
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
        sessionDataSource: sl<SessionEngineDataSource>(),
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
        sessionDataSource: sl<SessionEngineDataSource>(),
      ),
    );

    sl.registerLazySingleton(
      () => ListSessionStaffRequestsUseCase(
        requestRepository: sl<RequestRepository>(),
      ),
    );
  }
}
