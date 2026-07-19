import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';

class RecentActivitiesFeed extends ConsumerWidget {
  const RecentActivitiesFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(adminAuditFeedProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent System Activities', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          feedState.when(
            data: (logs) {
              if (logs.isEmpty) {
                return Text('No recent activity.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: logs.map((log) {
                  final time = '${log.occurredAt.hour.toString().padLeft(2, '0')}:${log.occurredAt.minute.toString().padLeft(2, '0')}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(time, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted, fontSize: 12)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '${log.action.name.toUpperCase()} - ${log.entityType}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Failed to load feed', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
