import '../../domain/enums/domain_enums.dart';
import '../../app/router/route_paths.dart';

/// Centralized role → workspace route mapping.
///
/// No role-based navigation logic should live inside feature pages.
abstract final class RoleResolver {
  static String homeRouteFor(RoleKey role) {
    return switch (role) {
      RoleKey.admin => RoutePaths.admin,
      RoleKey.manager => RoutePaths.admin,
      RoleKey.cashier => RoutePaths.cashier,
      RoleKey.kitchen => RoutePaths.kitchen,
      RoleKey.shipper => RoutePaths.shipper,
    };
  }

  static bool canAccessRoute(RoleKey role, String routePath) {
    final home = homeRouteFor(role);
    if (routePath == home) return true;

    // Admin and manager share admin workspace and staff flows.
    if (role == RoleKey.admin || role == RoleKey.manager) {
      return _adminAccessibleRoutes.contains(routePath);
    }

    return routePath == home;
  }

  static const Set<String> _adminAccessibleRoutes = {
    RoutePaths.admin,
    RoutePaths.menu,
    RoutePaths.delivery,
    RoutePaths.takeaway,
    RoutePaths.request,
    RoutePaths.cashier,
    RoutePaths.kitchen,
    RoutePaths.shipper,
  };

  static Set<RoleKey> rolesForRoute(String routePath) {
    return RoleKey.values.where((role) => canAccessRoute(role, routePath)).toSet();
  }
}
