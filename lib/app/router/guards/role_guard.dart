import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route_paths.dart';

/// Role-based access guard for staff surfaces (Sprint 2).
abstract final class RoleGuard {
  static String? redirect(
    BuildContext context,
    GoRouterState state, {
    required String requiredRoute,
  }) {
    // Stub: allow all routes until RBAC is implemented.
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
