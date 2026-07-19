import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class RevenueChartWidget extends ConsumerWidget {
  const RevenueChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueState = ref.watch(adminRevenueHistoryProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue History (14 Days)', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          revenueState.when(
            data: (data) {
              if (data.isEmpty) return const Text('No revenue data available.', style: TextStyle(color: AppColors.inkMuted));
              
              int maxRevenue = 1;
              for (final r in data) {
                if (r.revenueMinor > maxRevenue) maxRevenue = r.revenueMinor;
              }

              return SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data.map((point) {
                    final heightRatio = point.revenueMinor / maxRevenue;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${NumberFormat.compact().format(point.revenueMinor)} ₫', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                        const SizedBox(height: 4),
                        Container(
                          width: 32,
                          height: 150 * heightRatio,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          point.date.substring(5), // Show MM-DD
                          style: const TextStyle(fontSize: 10, color: AppColors.ink),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Failed to load revenue: $e', style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
