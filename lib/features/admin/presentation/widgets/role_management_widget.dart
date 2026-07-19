import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_dashboard_provider.dart';

class RoleManagementWidget extends ConsumerWidget {
  const RoleManagementWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesListAsync = ref.watch(adminRolesListProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Roles', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          rolesListAsync.when(
            data: (roles) {
              if (roles.isEmpty) {
                return const Center(child: Text('No roles found', style: TextStyle(color: AppColors.inkMuted)));
              }
              return ListView.separated(
                shrinkWrap: true,
                itemCount: roles.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.border),
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.security, color: AppColors.primary, size: 20),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Failed to load roles: $err')),
          ),
        ],
      ),
    );
  }
}
