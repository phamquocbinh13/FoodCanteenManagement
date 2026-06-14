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

/// Maps [RoleKey] to default permissions. Override per-user in Sprint 2.
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
}

/// Authorization service abstraction.
abstract interface class PermissionService {
  bool hasPermission(AppPermission permission);
  bool hasAnyPermission(Iterable<AppPermission> permissions);
  bool hasAllPermissions(Iterable<AppPermission> permissions);
}

/// Stub implementation using role defaults until auth sprint.
final class StubPermissionService implements PermissionService {
  StubPermissionService({Set<AppPermission> granted = const {}}) : _granted = granted;

  final Set<AppPermission> _granted;

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
