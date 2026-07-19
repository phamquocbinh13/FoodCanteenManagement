import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';

class PredictiveInsightsBanner extends ConsumerWidget {
  const PredictiveInsightsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(adminInsightsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), Colors.transparent],
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: insightsState.when(
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.alerts.map((alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(alert, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                )).toList(),
              ),
              loading: () => const Text('Generating AI insights...'),
              error: (e, st) => const Text('Insights unavailable.'),
            ),
          ),
        ],
      ),
    );
  }
}
