import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../controllers/auth_controller.dart';

export '../controllers/auth_controller.dart';

/// Bridges GetIt [AuthController] into Riverpod.
final authControllerProvider = Provider<AuthController>((ref) {
  return sl<AuthController>();
});

/// Listens to [AuthController] for router refresh and UI rebuilds.
final authControllerListenableProvider =
    ChangeNotifierProvider<AuthController>((ref) {
  return sl<AuthController>();
});

final authStateProvider = Provider<AuthenticationStatus>((ref) {
  return ref.watch(authControllerListenableProvider).status;
});

final currentUserProvider = Provider((ref) {
  return ref.watch(authControllerListenableProvider).currentUser;
});

final currentRoleProvider = Provider((ref) {
  return ref.watch(authControllerListenableProvider).currentRole;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authControllerListenableProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authControllerListenableProvider).errorMessage;
});

final permissionServiceProvider = Provider((ref) {
  return ref.watch(authControllerListenableProvider).permissionService;
});
