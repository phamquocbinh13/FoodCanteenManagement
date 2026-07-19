import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/analytics_metrics.dart';

class ProductVelocityGrid extends ConsumerWidget {
  const ProductVelocityGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velocityState = ref.watch(adminVelocityProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Velocity', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          velocityState.when(
            data: (data) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _VelocityList(
                    title: 'Best Sellers',
                    items: data.bestSellers,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _VelocityList(
                    title: 'Needs Attention',
                    items: data.worstSellers,
                    isPositive: false,
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Failed to load velocity: $e', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _VelocityList extends StatelessWidget {
  const _VelocityList({
    required this.title,
    required this.items,
    required this.isPositive,
  });

  final String title;
  final List<ProductVelocity> items;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text('No data available.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style: Theme.of(context).textTheme.bodyMedium),
              Row(
                children: [
                  Text(
                    '${item.quantitySold}x',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? AppColors.success : AppColors.error,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
