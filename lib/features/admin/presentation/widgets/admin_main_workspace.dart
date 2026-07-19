import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import 'predictive_insights_banner.dart';
import 'restaurant_health_card.dart';
import 'product_velocity_grid.dart';
import 'recent_activities_feed.dart';
import 'floor_occupancy_matrix.dart';

class AdminMainWorkspace extends ConsumerWidget {
  const AdminMainWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PredictiveInsightsBanner(),
          const SizedBox(height: AppSpacing.xxl),
          const RestaurantHealthCard(),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: ProductVelocityGrid(),
              ),
              const SizedBox(width: AppSpacing.lg),
              const Expanded(
                flex: 1,
                child: FloorOccupancyMatrix(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const RecentActivitiesFeed(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
