import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_nav_provider.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/admin_main_workspace.dart';
import '../widgets/admin_operations_workspace.dart';
import '../widgets/admin_analytics_workspace.dart';
import '../widgets/admin_administration_workspace.dart';
import '../widgets/admin_settings_workspace.dart';
import '../widgets/admin_system_radar.dart';
import '../widgets/navigation/admin_drawer.dart';
import '../widgets/navigation/admin_rail.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep refresher alive while admin page is open
    ref.watch(adminDashboardRefresherProvider);
    final activeIndex = ref.watch(adminNavIndexProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isDesktop = constraints.maxWidth >= 1024;

        final bodyContent = _buildBody(activeIndex);

        // Mobile Layout
        if (isMobile) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            appBar: AppBar(
              title: const Text('ROMS Admin', style: TextStyle(color: AppColors.ink)),
              backgroundColor: AppColors.surface,
              iconTheme: const IconThemeData(color: AppColors.brand),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(adminDashboardRefresherProvider).refreshAll();
                  },
                ),
              ],
            ),
            drawer: const AdminDrawer(),
            body: Stack(
              fit: StackFit.expand,
              children: [
                _buildAmbientBackground(),
                SafeArea(child: bodyContent),
              ],
            ),
          );
        }

        // Desktop and Tablet Layout
        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: Row(
            children: [
              Column(
                children: [
                  Expanded(child: AdminRail(extended: isDesktop)),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      tooltip: 'Logout',
                      onPressed: () {
                        ref.read(authControllerProvider).logout();
                      },
                    ),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1, color: AppColors.surface),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildAmbientBackground(),
                    SafeArea(child: bodyContent),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmbientBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.06,
          child: Image.asset(
            'assets/images/login/bg_cashier_lobby.webp',
            fit: BoxFit.cover,
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return _buildOverviewLayout();
      case 1:
        return const AdminOperationsWorkspace();
      case 2:
        return const AdminAnalyticsWorkspace();
      case 3:
        return const AdminAdministrationWorkspace();
      case 4:
        return const AdminSettingsWorkspace();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverviewLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) {
          // On mobile/tablet, stack them vertically
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: const [
              AdminMainWorkspace(),
              SizedBox(height: AppSpacing.xxl),
              AdminSystemRadar(),
            ],
          );
        }

        // Desktop: Two-column asymmetric grid
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                flex: 7,
                child: AdminMainWorkspace(),
              ),
              SizedBox(width: AppSpacing.xxl),
              Expanded(
                flex: 3,
                child: AdminSystemRadar(),
              ),
            ],
          ),
        );
      },
    );
  }
}
