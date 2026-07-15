import 'package:flutter/material.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Large-touch cashier tile for a pending staff request.
class StaffRequestTile extends StatelessWidget {
  const StaffRequestTile({
    super.key,
    required this.item,
    required this.onHandle,
    this.isHandling = false,
  });

  final StaffRequestQueueItemView item;
  final VoidCallback? onHandle;
  final bool isHandling;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = item.isPayment
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    item.tableLabel,
                    style: theme.textTheme.labelLarge?.copyWith(color: accent),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  item.sessionDisplayNumber,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  _elapsedLabel(item.request.requestedAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(item.typeLabel, style: theme.textTheme.titleMedium),
            if (item.request.note != null && item.request.note!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                item.request.note!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: isHandling ? null : onHandle,
              child: isHandling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Mark Handled'),
            ),
          ],
        ),
      ),
    );
  }

  String _elapsedLabel(DateTime requestedAt) {
    final minutes = DateTime.now().toUtc().difference(requestedAt.toUtc()).inMinutes;
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return '${minutes}m ago';
    return '${minutes ~/ 60}h ago';
  }
}
