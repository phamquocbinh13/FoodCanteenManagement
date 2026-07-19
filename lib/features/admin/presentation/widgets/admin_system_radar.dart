import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminSystemRadar extends ConsumerWidget {
  const AdminSystemRadar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(adminSystemAlertProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top: Alert Banner using Accent Terracotta token
        if (alert != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.accent, 
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.canvas, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'System Alert: ${alert.typeLabel} at ${alert.tableLabel}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.canvas,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.successSoft, 
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'System Nominal: No active alerts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xxl),

        // Middle: Side-by-side horizontal Quick Actions button dock
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.ink,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: _buildActionButton('Manage Menu', Icons.restaurant_menu)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildActionButton('Export Log', Icons.download)),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Bottom: Recent Activity logs using Ink Muted (Deferred)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'System Radar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.ink,
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warningSoft,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'BACKEND REQUIRED',
                style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _buildActivityLogPlaceholder(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.brand, size: 24),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogPlaceholder(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '--:--',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 12,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Text(
            'Activity logs deferred pending Audit Logs API.',
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: 13,
              height: 1.45, 
            ),
          ),
        ),
      ],
    );
  }
}
