import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/admin_nav_provider.dart';

class AdminRail extends ConsumerWidget {
  const AdminRail({super.key, this.extended = false});

  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminNavIndexProvider);

    return NavigationRail(
      backgroundColor: AppColors.surface,
      extended: extended,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        ref.read(adminNavIndexProvider.notifier).state = index;
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Overview'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant),
          label: Text('Operations'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Analytics'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text('Administration'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      selectedIconTheme: const IconThemeData(color: AppColors.brand),
      unselectedIconTheme: const IconThemeData(color: AppColors.inkMuted),
      selectedLabelTextStyle: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle: const TextStyle(color: AppColors.inkMuted),
    );
  }
}
