import 'package:flutter/material.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// Large-touch cashier tile for a pending staff request.
///
/// UX gain: table + type + age at a glance; one primary handle action;
/// payment requests visually prioritized.
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
    final ageMinutes =
        DateTime.now().toUtc().difference(item.request.requestedAt.toUtc()).inMinutes;
    final aging = ageMinutes >= 5;
    final tone = item.isPayment
        ? StatusTone.warning
        : (aging ? StatusTone.accent : StatusTone.brand);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusChip(label: item.tableLabel, tone: tone),
              const SizedBox(width: AppSpacing.sm),
              Text(
                item.sessionDisplayNumber,
                style: theme.textTheme.labelMedium,
              ),
              const Spacer(),
              Text(
                _elapsedLabel(ageMinutes),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: aging ? AppColors.accent : AppColors.inkMuted,
                  fontWeight: aging ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(item.typeLabel, style: theme.textTheme.titleMedium),
          if (item.request.note != null && item.request.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(item.request.note!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Mark handled',
            isExpanded: true,
            isLoading: isHandling,
            onPressed: isHandling ? null : onHandle,
          ),
        ],
      ),
    );
  }

  String _elapsedLabel(int minutes) {
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return '${minutes}m ago';
    return '${minutes ~/ 60}h ago';
  }
}
