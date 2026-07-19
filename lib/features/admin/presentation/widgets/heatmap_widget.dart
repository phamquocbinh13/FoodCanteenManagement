import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class HeatmapWidget extends ConsumerWidget {
  const HeatmapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapState = ref.watch(adminHeatmapProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hourly Traffic Heatmap', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xxl),
          heatmapState.when(
            data: (data) {
              if (data.isEmpty) return const Text('No traffic data available.', style: TextStyle(color: AppColors.inkMuted));
              
              int maxIntensity = 1;
              for (final h in data) {
                if (h.intensity > maxIntensity) maxIntensity = h.intensity;
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(24, (hour) {
                  final point = data.where((e) => e.hour == hour).firstOrNull;
                  final intensity = point?.intensity ?? 0;
                  final intensityRatio = intensity / maxIntensity;
                  
                  return Tooltip(
                    message: '$hour:00 - $intensity sessions',
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: intensity == 0 
                            ? AppColors.border 
                            : AppColors.primary.withAlpha((255 * (0.2 + 0.8 * intensityRatio)).toInt()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$hour:00',
                          style: TextStyle(
                            fontSize: 10, 
                            color: intensity == 0 ? AppColors.inkMuted : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Failed to load heatmap: $e', style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
