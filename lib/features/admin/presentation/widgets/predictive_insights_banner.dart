import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_dashboard_provider.dart';
import 'weather_forecast_widget.dart';

class PredictiveInsightsBanner extends ConsumerWidget {
  const PredictiveInsightsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(adminInsightsProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121815), // Surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A221E)), // Surface Raised
      ),
      child: insightsState.when(
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFC5A880), size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.alerts.map((alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          alert, 
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE6EBE7), // Ink Primary
                          )
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
            if (data.forecastDays.isNotEmpty) ...[
              const Divider(height: 1, color: Color(0xFF1A221E)),
              const SizedBox(height: 8),
              WeatherForecastWidget(forecastDays: data.forecastDays),
              const SizedBox(height: 16),
            ]
          ],
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Generating AI insights...', style: TextStyle(color: Color(0xFF829289))),
        ),
        error: (e, st) => const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Insights unavailable.', style: TextStyle(color: Color(0xFF829289))),
        ),
      ),
    );
  }
}
