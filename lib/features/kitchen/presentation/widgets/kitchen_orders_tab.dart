import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/kitchen_controller.dart';
import '../providers/kitchen_provider.dart';
import 'kitchen_batch_card.dart';

/// Tab 1 — FIFO kitchen queue.
///
/// UX gain: empty state without emoji; KDS multi-column reduces scroll under rush.
class KitchenOrdersTab extends ConsumerStatefulWidget {
  const KitchenOrdersTab({
    super.key,
    required this.highlightedBatchIds,
    required this.onBatchesUpdated,
  });

  final Set<String> highlightedBatchIds;
  final void Function(List<KitchenBatchViewModel> batches) onBatchesUpdated;

  @override
  ConsumerState<KitchenOrdersTab> createState() => _KitchenOrdersTabState();
}

class _KitchenOrdersTabState extends ConsumerState<KitchenOrdersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<KitchenBatchViewModel>? _lastReportedBatches;

  void _maybeReportBatches(KitchenQueueView? queue) {
    if (queue == null) return;
    final batches = queue.batches;
    if (_lastReportedBatches == batches) return;
    _lastReportedBatches = batches;
    widget.onBatchesUpdated(batches);
  }

  Future<void> _completeItem(
    BuildContext context,
    KitchenController kitchen,
    String itemId,
  ) async {
    final ok = await kitchen.completeItem(itemId);
    if (!context.mounted) return;
    if (!ok && kitchen.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(kitchen.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final kitchen = ref.watch(kitchenControllerProvider);
    final theme = Theme.of(context);
    _maybeReportBatches(kitchen.queue);

    if (kitchen.isLoading && kitchen.queue == null) {
      return const LoadingIndicator(message: 'Loading kitchen queue…');
    }

    final batches = kitchen.queue?.batches ?? [];
    // Phone 1 · tablet/POS 2 · KDS 1280+ 3 (fills width, no dead columns).
    final w = AppBreakpoints.widthOf(context);
    final columns = w >= AppBreakpoints.kds
        ? 3
        : (w >= AppBreakpoints.tablet ? 2 : 1);

    return RefreshIndicator(
      onRefresh: kitchen.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilterChip(
                    label: const Text('Completed'),
                    selected: kitchen.showCompleted,
                    onSelected: kitchen.setShowCompleted,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          if (kitchen.errorMessage != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  kitchen.errorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          if (batches.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                title: 'Queue clear',
                message: 'No active tickets. New batches appear here automatically.',
                icon: Icons.soup_kitchen_outlined,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final gap = AppSpacing.sm;
                    final width = columns == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - gap * (columns - 1)) /
                            columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final batch in batches)
                          SizedBox(
                            width: width,
                            child: KitchenBatchCard(
                              batch: batch,
                              isHighlighted: widget.highlightedBatchIds
                                  .contains(batch.batchId),
                              isItemPending: kitchen.isItemPending,
                              onCompleteItem: (itemId) =>
                                  _completeItem(context, kitchen, itemId),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
