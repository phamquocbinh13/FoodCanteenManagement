import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ShiftScheduler extends StatelessWidget {
  const ShiftScheduler({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Staff Schedule', style: Theme.of(context).textTheme.headlineMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BACKEND REQUIRED',
                  style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Center(
            child: Text('Schedule logic TBD - Awaiting backend schema migrations.', 
              style: TextStyle(color: AppColors.inkMuted)),
          ),
        ],
      ),
    );
  }
}
