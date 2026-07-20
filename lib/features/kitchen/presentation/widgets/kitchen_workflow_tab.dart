import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_workflow_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/kitchen_workflow_provider.dart';

/// Operational kitchen production planning board — aggregates preparing demand by wait priority and customization metrics.
class KitchenWorkflowTab extends ConsumerWidget {
  const KitchenWorkflowTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(kitchenWorkflowProvider);
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return async.when(
      loading: () => const LoadingIndicator(message: 'Loading workflow…'),
      error: (e, _) => ErrorState(
        title: 'Workflow unavailable',
        message: e.toString(),
        onRetry: () => ref.invalidate(kitchenWorkflowProvider),
      ),
      data: (view) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(kitchenWorkflowProvider),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            children: [
              // ── 1. QUICK STATS PANEL ─────────────────────────────────────
              Text(
                'QUICK STATS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 12.0),
              _buildStatsGrid(context, view.stats, width),
              const SizedBox(height: 24.0),

              // ── 2. PRODUCTION PRIORITY ───────────────────────────────────
              Text(
                'PRODUCTION PRIORITY (WAITING BUCKETS)',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 12.0),
              _buildBucketSection(context, 'URGENT (>= 20m)', view.buckets['URGENT'] ?? [], AppColors.accent, Icons.whatshot),
              const SizedBox(height: 12.0),
              _buildBucketSection(context, 'HIGH (10 - 19m)', view.buckets['HIGH'] ?? [], AppColors.brand, Icons.warning_amber),
              const SizedBox(height: 12.0),
              _buildBucketSection(context, 'NORMAL (5 - 9m)', view.buckets['NORMAL'] ?? [], Colors.blue, Icons.timer),
              const SizedBox(height: 12.0),
              _buildBucketSection(context, 'NEW (0 - 4m)', view.buckets['NEW'] ?? [], Colors.teal, Icons.fiber_new),
              const SizedBox(height: 24.0),

              // ── 3. PREPARATION SUMMARY ──────────────────────────────────
              Text(
                'PREPARATION SUMMARY (ATTRIBUTES AGGREGATION)',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 12.0),
              if (view.preparationSummary.isEmpty)
                Text(
                  'No active customizations.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
                )
              else
                _buildPreparationSummary(context, view.preparationSummary),
              const SizedBox(height: 12.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context, KitchenWorkflowStats stats, double width) {
    final theme = Theme.of(context);
    final columns = width > 800 ? 4 : (width > 500 ? 2 : 1);

    final statsItems = [
      (
        'Oldest Ticket',
        '${stats.oldestTicketMinutes}m',
        stats.oldestTicketMinutes >= 20 ? AppColors.accent : AppColors.brand,
      ),
      (
        'Most Ordered',
        stats.mostOrderedItem,
        AppColors.brand,
      ),
      (
        'Total Food Qty',
        '${stats.totalFoodQty}',
        AppColors.brand,
      ),
      (
        'Avg Wait Time',
        '${stats.averageWaitingTimeMinutes}m',
        AppColors.brand,
      ),
    ];

    if (columns == 4) {
      return Row(
        children: statsItems.map((item) {
          return Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: item.$3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if (columns == 2) {
      return Column(
        children: [
          Row(
            children: [
              _buildStatCard(context, statsItems[0]),
              _buildStatCard(context, statsItems[1]),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              _buildStatCard(context, statsItems[2]),
              _buildStatCard(context, statsItems[3]),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: statsItems.map((item) => _buildStatCard(context, item)).toList(),
      );
    }
  }

  Widget _buildStatCard(BuildContext context, (String, String, Color) item) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.$1,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: 4.0),
              Text(
                item.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: item.$2 == 'None' ? AppColors.inkMuted : item.$3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBucketSection(
    BuildContext context,
    String title,
    List<KitchenWorkflowItem> items,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: items.isNotEmpty,
          leading: Icon(icon, color: color),
          title: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '${items.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: items.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No active items in this bucket.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
                      ),
                    )
                  : Column(
                      children: items.map((item) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${item.batchCount} batch${item.batchCount > 1 ? 'es' : ''} • Oldest: ${item.oldestWaitingMinutes}m ago',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Qty ${item.quantity}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreparationSummary(
    BuildContext context,
    List<KitchenPreparationSummaryGroup> summary,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: summary.map((group) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.group.toUpperCase(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.brand,
                ),
              ),
              const Divider(color: AppColors.brandSoft, height: 16.0),
              Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                children: group.options.map((opt) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.brand.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          opt.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            color: AppColors.brand,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${opt.quantity}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
