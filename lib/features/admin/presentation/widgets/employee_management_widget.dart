import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_dashboard_provider.dart';
import 'staff_form_dialog.dart';
import '../../../../domain/entities/staff_user.dart';
import '../../../../app/config/restaurant_context.dart';
import 'package:get_it/get_it.dart';

class EmployeeManagementWidget extends ConsumerStatefulWidget {
  const EmployeeManagementWidget({super.key});

  @override
  ConsumerState<EmployeeManagementWidget> createState() => _EmployeeManagementWidgetState();
}

class _EmployeeManagementWidgetState extends ConsumerState<EmployeeManagementWidget> {
  Future<void> _showStaffDialog({StaffUser? user}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StaffFormDialog(initialUser: user),
    );

    if (result != null) {
      try {
        final repo = ref.read(adminUserRepoProvider);
        final restaurantId = GetIt.I<RestaurantContext>().restaurantId;
        if (user == null) {
          await repo.createStaff(restaurantId, result);
        } else {
          await repo.updateStaff(restaurantId, user.id, result);
        }
        ref.invalidate(adminStaffListProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(user == null ? 'Employee created' : 'Employee updated')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save employee: $e'), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffListAsync = ref.watch(adminStaffListProvider);

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
              Text('Employee Directory', style: Theme.of(context).textTheme.headlineMedium),
              ElevatedButton.icon(
                onPressed: () => _showStaffDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          staffListAsync.when(
            data: (staffList) {
              if (staffList.isEmpty) {
                return const Center(child: Text('No employees found', style: TextStyle(color: AppColors.inkMuted)));
              }
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Roles')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: staffList.map((staff) {
                  return DataRow(
                    cells: [
                      DataCell(Text(staff.displayName)),
                      DataCell(Text(staff.email)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: staff.isActive ? AppColors.successSoft : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            staff.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: staff.isActive ? AppColors.success : AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Wrap(
                          spacing: 4,
                          children: staff.roles.map((r) => Chip(
                            label: Text(r.name, style: const TextStyle(fontSize: 11)),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          )).toList(),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.inkMuted, size: 20),
                          onPressed: () => _showStaffDialog(user: staff),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Failed to load employees: $err')),
          ),
        ],
      ),
    );
  }
}
