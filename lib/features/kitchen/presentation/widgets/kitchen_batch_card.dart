import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import 'elapsed_time_text.dart';
import 'kitchen_item_tile.dart';

/// Kitchen ticket card — glanceable table + one-tap item completion.
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
        KitchenBatchDisplayStatus.completed => 'Done',
        KitchenBatchDisplayStatus.pending => 'Preparing',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = batch.status == KitchenBatchDisplayStatus.completed;
    final age = DateTime.now().difference(batch.createdAt);
    final aging = !isDone && age.inMinutes >= 10;

    return AnimatedOpacity(
      opacity: isDone ? 0.55 : 1,
      duration: AppMotion.duration(context, AppMotion.normal),
      child: AnimatedContainer(
        duration: AppMotion.duration(context, AppMotion.normal),
        curve: AppMotion.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isHighlighted
                ? AppColors.brand
                : aging
                    ? AppColors.accent
                    : AppColors.border,
            width: isHighlighted || aging ? 2 : 1,
          ),
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
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
                            batch.tableLabel,
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Batch #${batch.batchNumber} · ${batch.items.length} items',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.inkMuted,
                            ),
                          ),
                          Text(
                            batch.sessionDisplayNumber,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    StatusChip(
                      label: _statusLabel,
                      tone: isDone ? StatusTone.success : StatusTone.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: aging ? AppColors.accent : AppColors.inkMuted,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        formatKitchenClockTime(batch.createdAt),
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: ElapsedTimeText(
                        createdAt: batch.createdAt,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: aging ? AppColors.accent : AppColors.inkMuted,
                          fontWeight: FontWeight.w600,
                        ),
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
