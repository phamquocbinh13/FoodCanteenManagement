import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'elapsed_time_text.dart';
import 'kitchen_item_tile.dart';

/// Kitchen ticket card — batch metadata + one-tap item completion.
class KitchenBatchCard extends StatelessWidget {
  const KitchenBatchCard({
    super.key,
    required this.batch,
    required this.isItemPending,
    required this.onCompleteItem,
    this.isHighlighted = false,
  });

  final KitchenBatchViewModel batch;
  final bool Function(String id) isItemPending;
  final Future<void> Function(String itemId) onCompleteItem;
  final bool isHighlighted;

  String get _statusLabel => switch (batch.status) {
        KitchenBatchDisplayStatus.completed => 'Đã hoàn thành',
        KitchenBatchDisplayStatus.pending => 'Đang chuẩn bị',
      };

  int get _itemCount => batch.items.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = batch.status == KitchenBatchDisplayStatus.completed;
    final highlightColor = theme.colorScheme.primary.withValues(alpha: 0.45);

    return AnimatedOpacity(
      opacity: isDone ? 0.55 : 1,
      duration: const Duration(milliseconds: 400),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isHighlighted
              ? Border.all(color: highlightColor, width: 2.5)
              : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: highlightColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Card(
          elevation: isDone ? 0 : 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch #${batch.batchNumber}',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '$_itemCount món',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        _statusLabel,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  batch.tableLabel,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  batch.sessionDisplayNumber,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      formatKitchenClockTime(batch.createdAt),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ElapsedTimeText(
                      createdAt: batch.createdAt,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...batch.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: KitchenItemTile(
                      item: item,
                      isPending: isItemPending(item.id),
                      onTap: item.isActionable
                          ? () => onCompleteItem(item.id)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
