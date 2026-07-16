import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import 'elapsed_time_text.dart';
import 'kitchen_item_tile.dart';

/// Kitchen ticket card — layout optimized for rapid processing.
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
    
    // Highlight threshold at 8 minutes per operational rules
    final aging = !isDone && age.inMinutes >= 8;
    final timeColor = aging ? AppColors.accent : AppColors.inkMuted;

    return AnimatedOpacity(
      opacity: isDone ? 0.55 : 1,
      duration: AppMotion.duration(context, AppMotion.normal),
      child: AnimatedContainer(
        duration: AppMotion.duration(context, AppMotion.normal),
        curve: AppMotion.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surface, // Surface background #121815
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Grouped Table info and Session details ─────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batch.tableLabel,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Batch #${batch.batchNumber} · Session ${batch.sessionDisplayNumber}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  StatusChip(
                    label: _statusLabel,
                    tone: isDone ? StatusTone.success : StatusTone.warning,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // ── Urgency Time Tracking Row ──────────────────────────────────
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: timeColor,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      formatKitchenClockTime(batch.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: timeColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: ElapsedTimeText(
                      createdAt: batch.createdAt,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: timeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // ── Actionable Item List ───────────────────────────────────────
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
    );
  }
}
