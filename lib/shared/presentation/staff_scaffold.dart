import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/feedback/status_chip.dart';
import '../../../core/widgets/layout/app_scaffold.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

/// Staff workspace shell with logout and permission-aware actions.
class StaffScaffold extends ConsumerWidget {
  const StaffScaffold({
    super.key,
    required this.title,
    required this.body,
    this.requiredPermission,
  });

  final String title;
  final Widget body;
  final AppPermission? requiredPermission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionServiceProvider);
    final user = ref.watch(currentUserProvider);

    final canRender = requiredPermission == null ||
        permissions.hasPermission(requiredPermission!);

    return AppScaffold(
      title: title,
      actions: [
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Center(
              child: Text(
                user.fullName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        IconButton(
          tooltip: 'Logout',
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(authControllerProvider).logout();
            if (context.mounted) context.go(RoutePaths.login);
          },
        ),
      ],
      body: canRender
          ? body
          : const Center(
              child: Text('You do not have permission to view this content.'),
            ),
    );
  }
}

/// Displays current role for demo dashboards.
class StaffRoleBadge extends StatelessWidget {
  const StaffRoleBadge({super.key, required this.role});

  final RoleKey role;

  @override
  Widget build(BuildContext context) {
    return StatusChip(label: role.name.toUpperCase());
  }
}
