import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../request_queue/presentation/providers/request_queue_provider.dart';
import '../../../request_queue/presentation/widgets/staff_request_tile.dart';
import '../providers/cashier_session_provider.dart';

enum _QueueFilter { pending, handling, resolved }

/// Tab 2 — pending customer requests with urgency grouping + filters.
class CashierRequestQueueTab extends ConsumerStatefulWidget {
  const CashierRequestQueueTab({super.key});

  @override
  ConsumerState<CashierRequestQueueTab> createState() =>
      _CashierRequestQueueTabState();
}

class _CashierRequestQueueTabState
    extends ConsumerState<CashierRequestQueueTab> {
  _QueueFilter _filter = _QueueFilter.pending;

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(requestQueueControllerProvider);
    final session = ref.watch(cashierSessionControllerProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    final pending = List<StaffRequestQueueItemView>.from(queue.items)
      ..sort((a, b) {
        final urg = (b.isPayment ? 1 : 0).compareTo(a.isPayment ? 1 : 0);
        if (urg != 0) return urg;
        return a.request.requestedAt.compareTo(b.request.requestedAt);
      });

    final visible = switch (_filter) {
      _QueueFilter.pending => pending,
      _QueueFilter.handling => pending
          .where((i) => queue.handlingRequestId == i.request.id)
          .toList(),
      _QueueFilter.resolved => const <StaffRequestQueueItemView>[],
    };

    final oldestId = pending.isEmpty ? null : pending.first.request.id;
    final newestId = pending.isEmpty ? null : pending.last.request.id;

    return RefreshIndicator(
      onRefresh: () async {
        await queue.refresh();
        await session.restore();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Request Queue (${queue.pendingCount})',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Payment requests first. Oldest waiting at the top.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      FilterChip(
                        label: Text('Pending (${pending.length})'),
                        selected: _filter == _QueueFilter.pending,
                        onSelected: (_) =>
                            setState(() => _filter = _QueueFilter.pending),
                      ),
                      FilterChip(
                        label: const Text('Handling'),
                        selected: _filter == _QueueFilter.handling,
                        onSelected: (_) =>
                            setState(() => _filter = _QueueFilter.handling),
                      ),
                      FilterChip(
                        label: const Text('Resolved'),
                        selected: _filter == _QueueFilter.resolved,
                        onSelected: (_) =>
                            setState(() => _filter = _QueueFilter.resolved),
                      ),
                    ],
                  ),
                  if (queue.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      queue.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (queue.isLoading && pending.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: LoadingIndicator(message: 'Loading requests…'),
            )
          else if (_filter == _QueueFilter.resolved)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                title: 'Resolved clear the queue',
                message:
                    'Handled requests leave the pending board. Pull to refresh.',
                icon: Icons.task_alt_outlined,
              ),
            )
          else if (visible.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                title: 'Queue clear',
                message: 'No requests in this filter.',
                icon: Icons.inbox_outlined,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              sliver: SliverList.separated(
                itemCount: visible.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = visible[index];
                  final busy = queue.handlingRequestId == item.request.id;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (item.request.id == oldestId && pending.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: StatusChip(
                            label: 'Oldest',
                            tone: StatusTone.warning,
                          ),
                        ),
                      if (item.request.id == newestId && pending.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: StatusChip(
                            label: 'Newest',
                            tone: StatusTone.brand,
                          ),
                        ),
                      StaffRequestTile(
                        item: item,
                        isHandling: busy,
                        onHandle: user == null ||
                                item.request.status != RequestStatus.pending
                            ? null
                            : () async {
                                final ok = await queue.handle(
                                  requestId: item.request.id,
                                  handledByUserId: user.id,
                                );
                                if (ok) await session.restore();
                              },
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
