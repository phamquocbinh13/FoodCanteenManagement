import 'package:flutter/foundation.dart';

import '../../../../application/auth/auth_constants.dart';
import '../../../../application/auth/role_resolver.dart';
import '../../../../application/usecases/auth/check_authentication_use_case.dart';
import '../../../../application/usecases/auth/login_use_case.dart';
import '../../../../application/usecases/auth/logout_use_case.dart';
import '../../../../application/usecases/use_case.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/result/result.dart';
import '../../../../domain/entities/auth_session.dart';
import '../../../../domain/entities/authenticated_user.dart';
import '../../../../domain/enums/domain_enums.dart';

/// Authentication status for presentation layer.
enum AuthenticationStatus {
  unknown,
  loading,
  authenticated,
  unauthenticated,
}

/// Single source of auth truth for router guards and Riverpod.
final class AuthController extends ChangeNotifier {
  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthenticationUseCase checkAuthenticationUseCase,
    required RoleBasedPermissionService permissionService,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthenticationUseCase = checkAuthenticationUseCase,
        _permissionService = permissionService;

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthenticationUseCase _checkAuthenticationUseCase;
  final RoleBasedPermissionService _permissionService;

  AuthenticationStatus status = AuthenticationStatus.unknown;
  AuthenticatedUser? currentUser;
  RoleKey? currentRole;
  String? errorMessage;
  bool isLoading = false;

  bool get isAuthenticated =>
      status == AuthenticationStatus.authenticated && currentUser != null;

  PermissionService get permissionService => _permissionService;

  Future<void> checkAuthentication() async {
    isLoading = true;
    status = AuthenticationStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _checkAuthenticationUseCase(const NoParams());

    switch (result) {
      case Success<AuthSession?>(:final value):
        if (value != null) {
          _applySession(value);
        } else {
          _clearState(AuthenticationStatus.unauthenticated);
        }
      case Err<AuthSession?>(:final failure):
        errorMessage = authFailureMessage(failure.code);
        _clearState(AuthenticationStatus.unauthenticated);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    status = AuthenticationStatus.loading;
    notifyListeners();

    final result = await _loginUseCase(
      LoginParams(username: username, password: password),
    );

    isLoading = false;

    switch (result) {
      case Success<AuthSession>(:final value):
        _applySession(value);
        notifyListeners();
        return true;
      case Err<AuthSession>(:final failure):
        errorMessage = authFailureMessage(
          failure.code,
          fallback: failure.message,
        );
        _clearState(AuthenticationStatus.unauthenticated);
        notifyListeners();
        return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _logoutUseCase(const NoParams());
    _clearState(AuthenticationStatus.unauthenticated);

    isLoading = false;
    notifyListeners();
  }

  String? homeRoute() {
    final role = currentRole;
    if (role == null) return null;
    return RoleResolver.homeRouteFor(role);
  }

  void _applySession(AuthSession session) {
    currentUser = session.user;
    currentRole = session.user.role;
    status = AuthenticationStatus.authenticated;
    _permissionService.updateFromPermissionNames(session.user.permissions);
  }

  void _clearState(AuthenticationStatus nextStatus) {
    currentUser = null;
    currentRole = null;
    status = nextStatus;
    _permissionService.clear();
  }
}
