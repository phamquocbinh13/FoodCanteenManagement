import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CashierPage extends ConsumerWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);

    return StaffScaffold(
      title: 'Cashier',
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (role != null) StaffRoleBadge(role: role),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Cashier workspace',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
