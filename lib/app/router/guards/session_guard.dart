import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route_paths.dart';

/// Customer session token guard for in-session routes (Sprint 3).
abstract final class SessionGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final sessionToken = state.pathParameters['sessionToken'];
    if (sessionToken == null || sessionToken.isEmpty) {
      return RoutePaths.splash;
    }
    // Stub: token validation deferred to session engine sprint.
    return null;
  }
}
