import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_overview_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/kitchen_overview_provider.dart';

/// Operational kitchen dashboard — restructured layout placing Demand at the top and Stats at the bottom.
class KitchenOverviewTab extends ConsumerWidget {
  const KitchenOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(kitchenOverviewProvider);
    final theme = Theme.of(context);

    return async.when(
      loading: () => const LoadingIndicator(message: 'Loading overview…'),
      error: (e, _) => ErrorState(
        title: 'Overview unavailable',
        message: e.toString(),
        onRetry: () => ref.invalidate(kitchenOverviewProvider),
      ),
      data: (view) {
        final next = _nextAction(view);
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(kitchenOverviewProvider),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            children: [
              // ── 1. Next Action Status Banner ──────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  next,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // ── 2. ENHANCED DEMAND SLATE TILES (TOP SECTION) ──────────────
              Text(
                'DEMAND BY MENU ITEM',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 12.0),
              if (view.menuDemand.isEmpty)
                Text(
                  'No active demand — stand by for new tickets.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
                )
              else
                Wrap(
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: view.menuDemand.map((row) {
                    return Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        color: AppColors.surface, // Surface Token #121815
                        borderRadius: BorderRadius.circular(8.0), // Radius.sm
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${row.quantity}',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              color: AppColors.brand, // Brand Gold #C5A880
                              fontWeight: FontWeight.w700,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              row.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                color: AppColors.ink, // Ink Primary #E6EBE7
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24.0),

              // ── 3. LONGEST WAITING TICKET (Urgency section) ────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LONGEST WAITING TICKET',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    view.longestWaitingTable == null
                        ? 'None — queue clear'
                        : '${view.longestWaitingTable} · ${view.longestWaitingMinutes.round()}m',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accent, // Accent Terracotta #BD6B42
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // ── 4. CONSOLIDATED STATISTICS FOOTER (Bottom Section) ──────────
              _CleanSystemStatisticsBar(view: view),
            ],
          ),
        );
      },
    );
  }

  String _nextAction(KitchenOverviewView view) {
    if (view.totalActiveOrders == 0) {
      return 'Prepare dishes • Top Demand First';
    }
    final topDish = view.menuDemand.isNotEmpty ? view.menuDemand.first.name : 'dishes';
    return 'Prepare $topDish • Top Demand First';
  }
}

class _CleanSystemStatisticsBar extends StatelessWidget {
  const _CleanSystemStatisticsBar({required this.view});
  final KitchenOverviewView view;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final List<(String, int)> metrics = [
      ('Active', view.totalActiveOrders),
      ('Preparing', view.ordersPreparing),
      ('Ready', view.ordersReady),
      ('Food Qty', view.totalFoodOrders),
      ('Drink Qty', view.totalDrinkOrders),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SYSTEM STATISTICS',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface, // Surface background #121815
            borderRadius: BorderRadius.circular(8.0), // Radius.sm
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < metrics.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '|',
                        style: TextStyle(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${metrics[i].$1}: ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                        TextSpan(
                          text: '${metrics[i].$2}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.bold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
