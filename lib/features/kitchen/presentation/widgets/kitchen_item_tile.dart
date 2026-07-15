import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
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
      color: completed
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: isPending ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
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
                        '🍛 ${item.name}${item.quantityLabel.isNotEmpty ? ' ${item.quantityLabel}' : ''}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (item.kitchenNotes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            '"${item.kitchenNotes}"',
                            style: theme.textTheme.bodySmall,
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
                  Icon(Icons.check_circle, color: theme.colorScheme.primary)
                else
                  Icon(
                    Icons.touch_app,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
