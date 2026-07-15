import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/kitchen_controller.dart';
import '../providers/kitchen_provider.dart';
import 'kitchen_batch_card.dart';

/// Tab 1 — FIFO kitchen queue only (no inventory).
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
      return const Center(child: CircularProgressIndicator());
    }

    final batches = kitchen.queue?.batches ?? [];

    return RefreshIndicator(
      onRefresh: kitchen.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Đơn theo thứ tự FIFO',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Hiện đã xong'),
                    selected: kitchen.showCompleted,
                    onSelected: kitchen.setShowCompleted,
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🍳', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Hiện chưa có đơn cần làm.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final batch = batches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: KitchenBatchCard(
                        batch: batch,
                        isHighlighted:
                            widget.highlightedBatchIds.contains(batch.batchId),
                        isItemPending: kitchen.isItemPending,
                        onCompleteItem: (itemId) =>
                            _completeItem(context, kitchen, itemId),
                      ),
                    );
                  },
                  childCount: batches.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
