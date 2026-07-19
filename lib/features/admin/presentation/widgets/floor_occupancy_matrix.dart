import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cashier/presentation/providers/cashier_session_provider.dart';
import '../../../../core/theme/app_colors.dart';

class FloorOccupancyMatrix extends ConsumerWidget {
  const FloorOccupancyMatrix({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(cashierSessionControllerProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Floor Occupancy Matrix', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          if (sessionState.tables.isEmpty)
             const Text('No tables found.')
          else
             Wrap(
               spacing: 16,
               runSpacing: 16,
               children: sessionState.tables.map((table) {
                 final isOccupied = sessionState.isTableOccupied(table.id);
                 return Container(
                   width: 100,
                   height: 100,
                   decoration: BoxDecoration(
                     color: isOccupied ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                     border: Border.all(
                       color: isOccupied ? AppColors.primary : AppColors.border,
                       width: isOccupied ? 2 : 1,
                     ),
                   ),
                   child: Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(table.label, style: Theme.of(context).textTheme.titleLarge),
                         const SizedBox(height: 8),
                         Text(
                           isOccupied ? 'Occupied' : 'Available',
                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                             color: isOccupied ? AppColors.primary : AppColors.inkMuted,
                             fontSize: 12,
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               }).toList(),
             ),
        ],
      ),
    );
  }
}
