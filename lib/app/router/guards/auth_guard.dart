import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Staff authentication route guard (Sprint 2).
///
/// Returns redirect path when unauthenticated, or null to proceed.
abstract final class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    // Stub: allow all routes until auth is implemented.
    return null;
  }
}
