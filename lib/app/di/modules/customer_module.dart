import 'package:get_it/get_it.dart';

import '../../../core/id/id_generator.dart';
import '../../../application/usecases/request/create_staff_request_use_case.dart';
import '../../../application/usecases/request/list_session_staff_requests_use_case.dart';
import '../../../application/usecases/session/join_session_use_case.dart';
import '../../../application/usecases/session/validate_session_use_case.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../features/customer/presentation/controllers/customer_session_controller.dart';

abstract final class CustomerModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton(
      () => CustomerSessionController(
        joinSession: sl<JoinSessionUseCase>(),
        validateSession: sl<ValidateSessionUseCase>(),
        createStaffRequest: sl<CreateStaffRequestUseCase>(),
        listSessionStaffRequests: sl<ListSessionStaffRequestsUseCase>(),
        local: sl<CustomerSessionLocalDataSource>(),
        idGenerator: sl<IdGenerator>(),
      ),
    );
  }
}
