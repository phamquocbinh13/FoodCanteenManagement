import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/injection.dart';
import '../../../application/auth/role_resolver.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../route_paths.dart';

/// Role-based access guard for staff surfaces.
abstract final class RoleGuard {
  static String? redirect(
    BuildContext context,
    GoRouterState state, {
    required String requiredRoute,
  }) {
    final auth = sl<AuthController>();

    if (!auth.isAuthenticated) return RoutePaths.login;

    final role = auth.currentRole;
    if (role == null) return RoutePaths.login;

    if (!RoleResolver.canAccessRoute(role, requiredRoute)) {
      return RoleResolver.homeRouteFor(role);
    }

    return null;
  }

  static String? kitchenGuard(BuildContext context, GoRouterState state) {
    return redirect(context, state, requiredRoute: RoutePaths.kitchen);
  }

  static String? cashierGuard(BuildContext context, GoRouterState state) {
    return redirect(context, state, requiredRoute: RoutePaths.cashier);
  }

  static String? adminGuard(BuildContext context, GoRouterState state) {
    return redirect(context, state, requiredRoute: RoutePaths.admin);
  }

  static String? shipperGuard(BuildContext context, GoRouterState state) {
    return redirect(context, state, requiredRoute: RoutePaths.shipper);
  }
}
