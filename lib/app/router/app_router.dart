import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/admin_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cashier/presentation/pages/cashier_page.dart';
import '../../features/customer/presentation/pages/customer_page.dart';
import '../../features/delivery/presentation/pages/delivery_page.dart';
import '../../features/kitchen/presentation/pages/kitchen_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/request_queue/presentation/pages/request_page.dart';
import '../../features/shipper/presentation/pages/shipper_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/takeaway/presentation/pages/takeaway_page.dart';
import '../shell/app_shell.dart';
import 'guards/auth_guard.dart';
import 'guards/role_guard.dart';
import 'guards/session_guard.dart';
import 'route_paths.dart';

/// Centralized go_router configuration.
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = createRouter();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: RoutePaths.splash,
              name: RoutePaths.splashName,
              builder: (context, state) => const SplashPage(),
            ),
            GoRoute(
              path: RoutePaths.login,
              name: RoutePaths.loginName,
              redirect: AuthGuard.redirect,
              builder: (context, state) => const LoginPage(),
            ),

            // Customer surface
            GoRoute(
              path: RoutePaths.customer,
              name: RoutePaths.customerName,
              builder: (context, state) => const CustomerPage(),
            ),
            GoRoute(
              path: RoutePaths.joinPattern,
              name: RoutePaths.joinName,
              builder: (_, state) => JoinPage(
                joinToken: state.pathParameters['joinToken'] ?? '',
              ),
            ),
            GoRoute(
              path: RoutePaths.sessionPattern,
              name: RoutePaths.sessionName,
              redirect: SessionGuard.redirect,
              builder: (_, state) => SessionPage(
                sessionToken: state.pathParameters['sessionToken'] ?? '',
              ),
              routes: [
                GoRoute(
                  path: 'menu',
                  name: RoutePaths.sessionMenuName,
                  redirect: SessionGuard.redirect,
                  builder: (_, state) => SessionMenuPage(
                    sessionToken: state.pathParameters['sessionToken'] ?? '',
                  ),
                ),
                GoRoute(
                  path: 'request',
                  name: RoutePaths.sessionRequestName,
                  redirect: SessionGuard.redirect,
                  builder: (_, state) => SessionRequestPage(
                    sessionToken: state.pathParameters['sessionToken'] ?? '',
                  ),
                ),
              ],
            ),

            // Staff surfaces
            GoRoute(
              path: RoutePaths.cashier,
              name: RoutePaths.cashierName,
              redirect: RoleGuard.cashierGuard,
              builder: (context, state) => const CashierPage(),
            ),
            GoRoute(
              path: RoutePaths.kitchen,
              name: RoutePaths.kitchenName,
              redirect: RoleGuard.kitchenGuard,
              builder: (context, state) => const KitchenPage(),
            ),
            GoRoute(
              path: RoutePaths.admin,
              name: RoutePaths.adminName,
              redirect: RoleGuard.adminGuard,
              builder: (context, state) => const AdminPage(),
            ),
            GoRoute(
              path: RoutePaths.shipper,
              name: RoutePaths.shipperName,
              redirect: RoleGuard.shipperGuard,
              builder: (context, state) => const ShipperPage(),
            ),

            // Shared staff flows
            GoRoute(
              path: RoutePaths.menu,
              name: RoutePaths.menuName,
              builder: (context, state) => const MenuPage(),
            ),
            GoRoute(
              path: RoutePaths.delivery,
              name: RoutePaths.deliveryName,
              builder: (context, state) => const DeliveryPage(),
            ),
            GoRoute(
              path: RoutePaths.takeaway,
              name: RoutePaths.takeawayName,
              builder: (context, state) => const TakeawayPage(),
            ),
            GoRoute(
              path: RoutePaths.request,
              name: RoutePaths.requestName,
              builder: (context, state) => const RequestPage(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(
          child: Text(state.error?.toString() ?? 'Unknown routing error'),
        ),
      ),
    );
  }
}
