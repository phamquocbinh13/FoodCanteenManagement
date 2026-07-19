import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'employee_management_widget.dart';
import 'role_management_widget.dart';
import 'recent_activities_feed.dart';

class AdminAdministrationWorkspace extends StatelessWidget {
  const AdminAdministrationWorkspace({super.key});

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
                child: EmployeeManagementWidget(),
              ),
              const SizedBox(width: AppSpacing.xxl),
              const Expanded(
                flex: 1,
                child: RoleManagementWidget(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const RecentActivitiesFeed(), // Audit logs
        ],
      ),
    );
  }
}
