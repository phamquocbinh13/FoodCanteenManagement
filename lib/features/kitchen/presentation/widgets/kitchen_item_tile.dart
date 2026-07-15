import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Large-touch batch item tile — one tap completes immediately.
class KitchenItemTile extends StatelessWidget {
  const KitchenItemTile({
    super.key,
    required this.item,
    required this.isPending,
    this.onTap,
  });

  final KitchenBatchItemViewModel item;
  final bool isPending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = item.isCompleted;

    return Material(
      color: completed ? AppColors.surfaceRaised : AppColors.brandSoft,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: isPending ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.name}${item.quantityLabel.isNotEmpty ? ' ${item.quantityLabel}' : ''}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                          color: completed ? AppColors.inkMuted : null,
                        ),
                      ),
                      if (item.kitchenNotes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            item.kitchenNotes,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isPending)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (completed)
                  const Icon(Icons.check_circle, color: AppColors.success)
                else
                  const Icon(Icons.touch_app, color: AppColors.brand),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
