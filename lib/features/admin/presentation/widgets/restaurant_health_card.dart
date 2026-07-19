import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';

class RestaurantHealthCard extends ConsumerWidget {
  const RestaurantHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthStatus = ref.watch(adminHealthStatusProvider);
    final kitchenLoad = ref.watch(adminKitchenLoadProvider);
    final revenue = ref.watch(adminRevenueProvider);

    Color statusColor;
    String statusText;
    switch (healthStatus) {
      case HealthStatus.good:
        statusColor = AppColors.success;
        statusText = 'Optimal';
        break;
      case HealthStatus.medium:
        statusColor = AppColors.warning;
        statusText = 'Elevated Load';
        break;
      case HealthStatus.critical:
        statusColor = AppColors.error;
        statusText = 'Heavy Load';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Restaurant Health', style: Theme.of(context).textTheme.headlineMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Metric(label: 'Revenue', value: revenue),
              _Metric(label: 'Kitchen Queue', value: kitchenLoad),
              _Metric(label: 'Inventory', value: 'Safe'),
              _Metric(label: 'CSAT', value: '4.9/5'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleLarge ?? const TextStyle()),
      ],
    );
  }
}
