import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/kitchen_provider.dart';

/// Kitchen Display System — FIFO queue, one-tap item completion, menu toggles.
class KitchenPage extends ConsumerStatefulWidget {
  const KitchenPage({super.key});

  @override
  ConsumerState<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends ConsumerState<KitchenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kitchenControllerProvider).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentRoleProvider);
    final kitchen = ref.watch(kitchenControllerProvider);
    final theme = Theme.of(context);

    return StaffScaffold(
      title: 'Bếp',
      requiredPermission: AppPermission.viewKitchenQueue,
      body: RefreshIndicator(
        onRefresh: () => kitchen.refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (role != null) Center(child: StaffRoleBadge(role: role)),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Hàng đợi bếp',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        FilterChip(
                          label: const Text('Hiện đã xong'),
                          selected: kitchen.showCompleted,
                          onSelected: kitchen.setShowCompleted,
                        ),
                      ],
                    ),
                    if (kitchen.errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        kitchen.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (kitchen.isLoading && kitchen.queue == null)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (kitchen.queue == null || kitchen.queue!.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Không có batch đang chờ',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final batch = kitchen.queue!.batches[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: _KitchenBatchCard(
                          batch: batch,
                          isItemPending: kitchen.isItemPending,
                          onCompleteItem: (itemId) async {
                            final ok = await kitchen.completeItem(itemId);
                            if (!context.mounted) return;
                            if (!ok && kitchen.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(kitchen.errorMessage!)),
                              );
                            }
                          },
                        ),
                      );
                    },
                    childCount: kitchen.queue!.batches.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Tồn kho món', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    ...kitchen.menuItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _MenuAvailabilityTile(
                          item: item,
                          onTap: () => kitchen.toggleMenuItem(item.id),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KitchenBatchCard extends StatelessWidget {
  const _KitchenBatchCard({
    required this.batch,
    required this.isItemPending,
    required this.onCompleteItem,
  });

  final KitchenBatchViewModel batch;
  final bool Function(String id) isItemPending;
  final Future<void> Function(String itemId) onCompleteItem;

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = batch.status == KitchenBatchDisplayStatus.completed;

    return AnimatedOpacity(
      opacity: isDone ? 0.55 : 1,
      duration: const Duration(milliseconds: 400),
      child: Card(
        elevation: isDone ? 0 : 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Batch #${batch.batchNumber}',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                '${batch.tableLabel} • ${batch.sessionDisplayNumber}',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                _formatTime(batch.createdAt.toLocal()),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              ...batch.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _KitchenItemTile(
                    item: item,
                    isPending: isItemPending(item.id),
                    onTap: item.isActionable
                        ? () => onCompleteItem(item.id)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KitchenItemTile extends StatelessWidget {
  const _KitchenItemTile({
    required this.item,
    required this.isPending,
    this.onTap,
  });

  final KitchenBatchItemViewModel item;
  final bool isPending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = item.isCompleted;

    return Material(
      color: completed
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isPending ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🍛 ${item.name}${item.quantityLabel.isNotEmpty ? ' ${item.quantityLabel}' : ''}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (item.kitchenNotes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            '"${item.kitchenNotes}"',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isPending)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (completed)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary)
                else
                  Icon(Icons.touch_app, color: theme.colorScheme.onPrimaryContainer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuAvailabilityTile extends StatelessWidget {
  const _MenuAvailabilityTile({required this.item, required this.onTap});

  final KitchenMenuItemViewModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: item.isAvailable
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Text(item.name, style: theme.textTheme.titleMedium),
                ),
                Text(item.isAvailable ? 'Còn món' : 'Hết món'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
