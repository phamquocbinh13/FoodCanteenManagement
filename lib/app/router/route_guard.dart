import 'package:go_router/go_router.dart';

import '../../../application/auth/role_resolver.dart';
import '../../app/di/injection.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import 'route_paths.dart';

/// Centralized staff route protection.
abstract final class RouteGuard {
  static const _publicRoutes = {
    RoutePaths.splash,
    RoutePaths.login,
  };

  static const _staffRoutes = {
    RoutePaths.admin,
    RoutePaths.cashier,
    RoutePaths.kitchen,
    RoutePaths.shipper,
    RoutePaths.menu,
    RoutePaths.delivery,
    RoutePaths.takeaway,
    RoutePaths.request,
  };

  static String? globalRedirect(GoRouterState state) {
    final auth = sl<AuthController>();
    final location = state.matchedLocation;

    if (_publicRoutes.contains(location)) {
      return _publicRouteRedirect(auth, location);
    }

    if (_isCustomerRoute(location)) {
      return null;
    }

    if (_isStaffRoute(location)) {
      return _staffRouteRedirect(auth, location);
    }

    return null;
  }

  static String? _publicRouteRedirect(AuthController auth, String location) {
    if (location == RoutePaths.login &&
        auth.status == AuthenticationStatus.authenticated) {
      return auth.homeRoute();
    }
    return null;
  }

  static String? _staffRouteRedirect(AuthController auth, String location) {
    if (auth.status == AuthenticationStatus.loading ||
        auth.status == AuthenticationStatus.unknown) {
      return RoutePaths.splash;
    }

    if (!auth.isAuthenticated) {
      return RoutePaths.login;
    }

    final role = auth.currentRole;
    if (role == null) return RoutePaths.login;

    if (!RoleResolver.canAccessRoute(role, location)) {
      return RoleResolver.homeRouteFor(role);
    }

    return null;
  }

  static bool _isStaffRoute(String location) {
    if (_staffRoutes.contains(location)) return true;
    return _staffRoutes.any((route) => location.startsWith('$route/'));
  }

  static bool _isCustomerRoute(String location) {
    if (location.startsWith('/join/')) return true;
    if (location.startsWith('/s/')) return true;
    if (location.startsWith('/customer')) return true;
    return location == RoutePaths.customer;
  }
}
