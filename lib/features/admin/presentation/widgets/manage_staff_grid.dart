import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ManageStaffGrid extends StatelessWidget {
  const ManageStaffGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Clean, spacious, borderless data grid
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manage Staff',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.ink,
                  letterSpacing: 0.5,
                ),
              ),
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
              )
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                return _buildPlaceholderRow();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.canvas,
          child: Icon(Icons.person_off, size: 16, color: AppColors.inkMuted),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deferred (No API)',
                style: TextStyle(color: AppColors.inkMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
