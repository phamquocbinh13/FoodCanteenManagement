import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/injection.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';

/// Staff authentication route guard.
abstract final class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final auth = sl<AuthController>();

    if (auth.status == AuthenticationStatus.authenticated) {
      return auth.homeRoute();
    }

    return null;
  }
}
