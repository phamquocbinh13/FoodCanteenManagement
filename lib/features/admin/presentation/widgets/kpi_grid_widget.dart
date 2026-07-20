import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class KpiGridWidget extends ConsumerWidget {
  const KpiGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiState = ref.watch(adminKpisProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Performance Indicators', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          kpiState.when(
            data: (data) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildKpi(context, 'Average Order Value', '${NumberFormat.decimalPattern().format(data.averageOrderValueMinor / 100)} ₫'),
                _buildKpi(context, 'Total Sessions', '${data.totalSessions}'),
                _buildKpi(context, 'Total Revenue', '${NumberFormat.decimalPattern().format(data.totalRevenueMinor / 100)} ₫'),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Failed to load KPIs: $e', style: const TextStyle(color: AppColors.error)),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Payment Methods', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          kpiState.when(
            data: (data) {
              if (data.paymentMethods.isEmpty) return const Text('No payments yet.', style: TextStyle(color: AppColors.inkMuted));
              return Column(
                children: data.paymentMethods.map((pm) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pm.method.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium),
                      Text('${NumberFormat.decimalPattern().format(pm.totalMinor / 100)} ₫', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildKpi(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }
}
