import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../request_queue/presentation/providers/request_queue_provider.dart';
import '../../../request_queue/presentation/widgets/staff_request_tile.dart';
import '../providers/cashier_session_provider.dart';
import '../widgets/session_qr_display.dart';

class CashierPage extends ConsumerWidget {
  const CashierPage({super.key});

  Future<void> _closeWithPayment(
    BuildContext context,
    CashierSessionController session,
  ) async {
    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: 'Close session with payment?',
      message:
          'This records payment, closes the session, frees the table, and '
          'revokes customer access. This cannot be undone.',
      confirmLabel: 'Take payment & close',
      cancelLabel: 'Not yet',
    );
    if (confirmed == true) {
      await session.closeSession(paymentMethod: PaymentMethod.cash);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final session = ref.watch(cashierSessionControllerProvider);
    final queue = ref.watch(requestQueueControllerProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return StaffScaffold(
      title: 'Cashier',
      body: RefreshIndicator(
        onRefresh: () async {
          await session.restore();
          await queue.refresh();
          if (session.hasActiveSession) {
            await session.refreshBatchSummaries();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (kDebugMode && role != null)
                    Center(child: StaffRoleBadge(role: role)),
                  const SizedBox(height: AppSpacing.md),
                  Text('Floor session', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Open tables, share QR, take payment, free the floor.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _StatusCard(session: session),
                  const SizedBox(height: AppSpacing.lg),
                  _RequestQueuePreview(
                    pendingCount: queue.pendingCount,
                    previewItems: queue.items.take(3).toList(),
                    isHandlingId: queue.handlingRequestId,
                    onOpenQueue: () => context.push(RoutePaths.request),
                    onHandle: user == null
                        ? null
                        : (requestId) async {
                            final ok = await queue.handle(
                              requestId: requestId,
                              handledByUserId: user.id,
                            );
                            if (!context.mounted) return;
                            if (ok) await session.restore();
                          },
                  ),
                  if (session.hasActiveSession &&
                      session.batchSummaries.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text('Kitchen batches', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    ...session.batchSummaries.map(
                      (batch) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Batch #${batch.batchNumber}',
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              'Created ${_formatTime(batch.createdAt)}'
                              '${batch.completedAt != null ? ' · Done ${_formatTime(batch.completedAt!)}' : ''}',
                            ),
                            trailing: StatusChip(
                              label: batch.statusLabel,
                              tone: batch.completedAt != null
                                  ? StatusTone.success
                                  : StatusTone.warning,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (session.hasActiveSession &&
                      session.sessionToken != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _CustomerShareCard(
                      tableLabel:
                          session.activeSnapshot?.tableLabel ?? 'Table',
                      displayNumber:
                          session.activeSnapshot?.session.displayNumber ?? '',
                      sessionToken: session.sessionToken!,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  if (session.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.dangerSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            session.errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!session.hasActiveSession)
                    PrimaryButton(
                      label: 'Open session — Table 1',
                      icon: Icons.table_restaurant_outlined,
                      isExpanded: true,
                      isLoading: session.isLoading,
                      onPressed: session.isLoading
                          ? null
                          : () => session.createOnTable1(
                                openedByUserId: user?.id,
                              ),
                    ),
                  if (session.hasActiveSession) ...[
                    SecondaryButton(
                      label: 'Mark waiting payment',
                      isExpanded: true,
                      onPressed: session.isLoading ||
                              session.lifecyclePhase ==
                                  SessionLifecyclePhase.waitingPayment
                          ? null
                          : () => session.markWaitingPayment(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      label: 'Take payment & close',
                      icon: Icons.payments_outlined,
                      isExpanded: true,
                      isLoading: session.isLoading,
                      onPressed: session.isLoading
                          ? null
                          : () => _closeWithPayment(context, session),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  final local = dt.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

class _RequestQueuePreview extends StatelessWidget {
  const _RequestQueuePreview({
    required this.pendingCount,
    required this.previewItems,
    required this.onOpenQueue,
    required this.onHandle,
    this.isHandlingId,
  });

  final int pendingCount;
  final List<StaffRequestQueueItemView> previewItems;
  final VoidCallback onOpenQueue;
  final Future<void> Function(String requestId)? onHandle;
  final String? isHandlingId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Request queue',
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (pendingCount > 0)
              StatusChip(
                label: '$pendingCount pending',
                tone: StatusTone.warning,
              ),
            RomsTextButton(
              label: pendingCount == 0 ? 'Open queue' : 'View all',
              onPressed: onOpenQueue,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (previewItems.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'No pending call-staff requests.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          ...previewItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: StaffRequestTile(
                item: item,
                isHandling: isHandlingId == item.request.id,
                onHandle: onHandle == null
                    ? null
                    : () => onHandle!(item.request.id),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.session});

  final CashierSessionController session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = session.activeSnapshot;
    final phase = session.lifecyclePhase;
    final tone = switch (phase) {
      SessionLifecyclePhase.available => StatusTone.success,
      SessionLifecyclePhase.occupied => StatusTone.brand,
      SessionLifecyclePhase.waitingPayment => StatusTone.warning,
      SessionLifecyclePhase.closed => StatusTone.neutral,
    };

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (snapshot != null) ...[
            RomsTableLabel(
              label: snapshot.tableLabel,
              emphasize: true,
              statusLabel: _phaseLabel(phase),
              tone: tone,
            ),
            const SizedBox(height: AppSpacing.md),
            RomsSessionBadge(
              displayNumber: snapshot.session.displayNumber,
              phaseLabel: snapshot.session.status.name,
              tone: tone,
            ),
          ] else ...[
            Text('No active session', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Table 1 is available to open.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  String _phaseLabel(SessionLifecyclePhase phase) {
    return switch (phase) {
      SessionLifecyclePhase.available => 'Available',
      SessionLifecyclePhase.occupied => 'Occupied',
      SessionLifecyclePhase.waitingPayment => 'Waiting payment',
      SessionLifecyclePhase.closed => 'Closed',
    };
  }
}

class _CustomerShareCard extends StatelessWidget {
  const _CustomerShareCard({
    required this.tableLabel,
    required this.displayNumber,
    required this.sessionToken,
  });

  final String tableLabel;
  final String displayNumber;
  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Guest join',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(tableLabel, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          RomsSessionBadge(displayNumber: displayNumber),
          const SizedBox(height: AppSpacing.md),
          Text('Session code', style: theme.textTheme.labelLarge),
          SelectableText(
            sessionToken,
            style: theme.textTheme.titleSmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(child: SessionQrDisplay(sessionToken: sessionToken)),
        ],
      ),
    );
  }
}
