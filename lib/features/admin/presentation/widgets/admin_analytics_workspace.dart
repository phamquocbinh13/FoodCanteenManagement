import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'kpi_grid_widget.dart';
import 'revenue_chart_widget.dart';
import 'heatmap_widget.dart';
import 'product_velocity_grid.dart';

class AdminAnalyticsWorkspace extends StatelessWidget {
  const AdminAnalyticsWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const KpiGridWidget(),
          const SizedBox(height: AppSpacing.xxl),
          const RevenueChartWidget(),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 1,
                child: HeatmapWidget(),
              ),
              const SizedBox(width: AppSpacing.xxl),
              const Expanded(
                flex: 1,
                child: ProductVelocityGrid(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
