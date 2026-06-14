import '../../core/errors/failures.dart';
import '../../core/permissions/permission_service.dart';
import '../../core/result/result.dart';
import 'policy.dart';

/// RBAC policy built on [PermissionService].
final class PermissionPolicy implements Policy<PermissionContext, bool> {
  PermissionPolicy(this._permissionService);

  final PermissionService _permissionService;

  @override
  Result<bool> evaluate(PermissionContext context) {
    final allowed = _permissionService.hasPermission(context.permission);
    if (!allowed) {
      return const Err(
        UnauthorizedFailure('Permission denied', code: 'PERMISSION_DENIED'),
      );
    }
    return const Success(true);
  }
}

final class PermissionContext {
  const PermissionContext({required this.permission});

  final AppPermission permission;
}
