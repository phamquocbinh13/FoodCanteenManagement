import '../../domain/enums/domain_enums.dart';

/// Fine-grained permission keys for future RBAC beyond role checks.
enum AppPermission {
  viewKitchenQueue,
  manageMenu,
  closeSession,
  forceCloseSession,
  handleRequests,
  manageTables,
  claimDelivery,
  reassignDelivery,
  viewAuditLog,
  manageStaff,
}

/// Maps [RoleKey] to default permissions.
abstract final class RolePermissions {
  static const Map<RoleKey, Set<AppPermission>> defaults = {
    RoleKey.admin: {
      AppPermission.viewKitchenQueue,
      AppPermission.manageMenu,
      AppPermission.closeSession,
      AppPermission.forceCloseSession,
      AppPermission.handleRequests,
      AppPermission.manageTables,
      AppPermission.claimDelivery,
      AppPermission.reassignDelivery,
      AppPermission.viewAuditLog,
      AppPermission.manageStaff,
    },
    RoleKey.manager: {
      AppPermission.viewKitchenQueue,
      AppPermission.manageMenu,
      AppPermission.closeSession,
      AppPermission.handleRequests,
      AppPermission.manageTables,
      AppPermission.claimDelivery,
      AppPermission.reassignDelivery,
      AppPermission.viewAuditLog,
    },
    RoleKey.cashier: {
      AppPermission.closeSession,
      AppPermission.handleRequests,
      AppPermission.manageTables,
      AppPermission.reassignDelivery,
    },
    RoleKey.kitchen: {
      AppPermission.viewKitchenQueue,
      AppPermission.manageMenu,
    },
    RoleKey.shipper: {
      AppPermission.claimDelivery,
    },
  };

  static Set<AppPermission> forRole(RoleKey role) {
    return defaults[role] ?? {};
  }

  static Set<AppPermission> fromNames(Iterable<String> names) {
    return names
        .map(
          (name) => AppPermission.values.firstWhere(
            (p) => p.name == name,
            orElse: () => throw ArgumentError('Unknown permission: $name'),
          ),
        )
        .toSet();
  }

  static Set<AppPermission> fromNamesSafe(Iterable<String> names) {
    return names
        .map(
          (name) => AppPermission.values
              .where((p) => p.name == name)
              .cast<AppPermission?>()
              .firstOrNull,
        )
        .whereType<AppPermission>()
        .toSet();
  }
}

/// Authorization service abstraction.
abstract interface class PermissionService {
  bool hasPermission(AppPermission permission);
  bool hasAnyPermission(Iterable<AppPermission> permissions);
  bool hasAllPermissions(Iterable<AppPermission> permissions);
}

/// Role-backed permission service updated on login/logout.
final class RoleBasedPermissionService implements PermissionService {
  RoleBasedPermissionService();

  Set<AppPermission> _granted = {};

  void updateFromRole(RoleKey role) {
    _granted = RolePermissions.forRole(role);
  }

  void updateFromPermissionNames(Iterable<String> names) {
    _granted = RolePermissions.fromNamesSafe(names);
  }

  void clear() {
    _granted = {};
  }

  @override
  bool hasPermission(AppPermission permission) => _granted.contains(permission);

  @override
  bool hasAnyPermission(Iterable<AppPermission> permissions) {
    return permissions.any(_granted.contains);
  }

  @override
  bool hasAllPermissions(Iterable<AppPermission> permissions) {
    return permissions.every(_granted.contains);
  }
}

/// Empty permission service for unauthenticated state.
final class UnauthenticatedPermissionService implements PermissionService {
  const UnauthenticatedPermissionService();

  @override
  bool hasPermission(AppPermission permission) => false;

  @override
  bool hasAnyPermission(Iterable<AppPermission> permissions) => false;

  @override
  bool hasAllPermissions(Iterable<AppPermission> permissions) => false;
}
