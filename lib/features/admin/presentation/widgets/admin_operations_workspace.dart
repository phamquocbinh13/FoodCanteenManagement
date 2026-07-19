import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'floor_occupancy_matrix.dart';
import 'recent_activities_feed.dart';
import 'shift_scheduler.dart';

class AdminOperationsWorkspace extends StatelessWidget {
  const AdminOperationsWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: ShiftScheduler(),
              ),
              const SizedBox(width: AppSpacing.xxl),
              const Expanded(
                flex: 1,
                child: FloorOccupancyMatrix(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const RecentActivitiesFeed(), // Used as "Live Timeline" proxy
        ],
      ),
    );
  }
}
