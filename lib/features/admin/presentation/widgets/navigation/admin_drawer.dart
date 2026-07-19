import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../providers/admin_nav_provider.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminNavIndexProvider);

    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.canvas,
            ),
            child: Text(
              'ROMS Admin',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(context, ref, 0, Icons.dashboard, 'Overview', currentIndex),
          _buildDrawerItem(context, ref, 1, Icons.restaurant, 'Operations', currentIndex),
          _buildDrawerItem(context, ref, 2, Icons.analytics, 'Analytics', currentIndex),
          _buildDrawerItem(context, ref, 3, Icons.admin_panel_settings, 'Administration', currentIndex),
          _buildDrawerItem(context, ref, 4, Icons.settings, 'Settings', currentIndex),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () {
              ref.read(authControllerProvider).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, WidgetRef ref, int index, IconData icon, String title, int currentIndex) {
    final isSelected = index == currentIndex;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.brand : AppColors.inkMuted,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.brand : AppColors.ink,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        ref.read(adminNavIndexProvider.notifier).state = index;
        Navigator.pop(context); // Close the drawer
      },
    );
  }
}
