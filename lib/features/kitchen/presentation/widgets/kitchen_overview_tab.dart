import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_overview_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/kitchen_overview_provider.dart';

/// Operational kitchen dashboard — what to cook next, not vanity metrics.
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            children: [
              Material(
                color: view.ordersWaiting > 0 || view.longestWaitingMinutes >= 10
                    ? AppColors.warning.withValues(alpha: 0.12)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    next,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _MetricStrip(
                cells: [
                  _Metric('Active tickets', '${view.totalActiveOrders}', true),
                  _Metric('Preparing', '${view.ordersPreparing}', false),
                  _Metric('Ready', '${view.ordersReady}', false),
                  _Metric('Waiting', '${view.ordersWaiting}', false),
                  _Metric('Food qty', '${view.totalFoodOrders}', false),
                  _Metric('Drink qty', '${view.totalDrinkOrders}', false),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: view.longestWaitingMinutes >= 10
                            ? AppColors.danger
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LONGEST WAITING TICKET',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              view.longestWaitingTable == null
                                  ? 'None — queue clear'
                                  : '${view.longestWaitingTable} · '
                                      '${view.longestWaitingMinutes.round()}m',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'DEMAND BY MENU ITEM',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (view.menuDemand.isEmpty)
                Text(
                  'No active demand — stand by for new tickets.',
                  style: theme.textTheme.bodyMedium,
                )
              else
                ...view.menuDemand.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.name,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${row.quantity}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _nextAction(KitchenOverviewView view) {
    if (view.totalActiveOrders == 0) {
      return 'NEXT: Queue clear — stand by';
    }
    if (view.ordersWaiting > 0) {
      return 'NEXT: Start waiting tickets ($view.ordersWaiting)';
    }
    if (view.ordersPreparing > 0) {
      return 'NEXT: Finish preparing ($view.ordersPreparing) · '
          'top demand first';
    }
    if (view.ordersReady > 0) {
      return 'NEXT: Ready for pickup ($view.ordersReady)';
    }
    return 'NEXT: Monitor active tickets';
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.emphasize);
  final String label;
  final String value;
  final bool emphasize;
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.cells});
  final List<_Metric> cells;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 900
            ? 6
            : constraints.maxWidth >= 520
                ? 3
                : 2;
        final gap = AppSpacing.xs;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final cell in cells)
              SizedBox(
                width: width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                    color: cell.emphasize
                        ? theme.colorScheme.surfaceContainerHighest
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cell.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          cell.value,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
