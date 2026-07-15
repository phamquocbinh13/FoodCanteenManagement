import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../providers/cashier_session_provider.dart';
import '../widgets/force_close_sheet.dart';
import '../widgets/payment_close_sheet.dart';
import '../widgets/session_qr_display.dart';

/// Floor session detail — QR, bill, batches, requests, close actions.
class CashierSessionDetailPage extends ConsumerStatefulWidget {
  const CashierSessionDetailPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<CashierSessionDetailPage> createState() =>
      _CashierSessionDetailPageState();
}

class _CashierSessionDetailPageState
    extends ConsumerState<CashierSessionDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = ref.read(cashierSessionControllerProvider);
      final ok = await session.openSessionById(widget.sessionId);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session not found on floor')),
        );
        context.pop();
      }
    });
  }

  Future<void> _closeWithPayment(CashierSessionController session) async {
    final choice = await showPaymentCloseSheet(context);
    if (choice == null || !mounted) return;

    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: 'Close session with payment?',
      message:
          'Records payment, closes the session, frees the table, and revokes '
          'guest access. This cannot be undone.',
      confirmLabel: 'Take payment & close',
      cancelLabel: 'Not yet',
    );
    if (confirmed == true) {
      await session.closeSession(paymentMethod: choice.paymentMethod);
      if (mounted) context.pop();
    }
  }

  Future<void> _forceClose(CashierSessionController session) async {
    final choice = await showForceCloseSheet(context);
    if (choice == null || !mounted) return;

    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: 'Force close this session?',
      message: 'The table will be freed without a normal payment.',
      confirmLabel: 'Force close',
      cancelLabel: 'Keep open',
      isDestructive: true,
    );
    if (confirmed == true) {
      await session.closeSession(
        closeType: SessionCloseType.forceClosed,
        forceCloseReason: choice.reason,
        forceCloseNote: choice.note,
        paymentMethod: PaymentMethod.other,
      );
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(cashierSessionControllerProvider);
    final snapshot = session.activeSnapshot;
    final theme = Theme.of(context);
    final phase = session.lifecyclePhase;
    final tone = switch (phase) {
      SessionLifecyclePhase.available => StatusTone.success,
      SessionLifecyclePhase.occupied => StatusTone.brand,
      SessionLifecyclePhase.waitingPayment => StatusTone.warning,
      SessionLifecyclePhase.closed => StatusTone.neutral,
    };
    final duration = session.sessionDuration;
    final durationLabel = duration == null
        ? '—'
        : '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';

    return StaffScaffold(
      title: snapshot?.tableLabel ?? 'Session',
      body: snapshot == null
          ? const LoadingIndicator(message: 'Loading session…')
          : RefreshIndicator(
              onRefresh: () async {
                await session.restore();
                await session.refreshSessionDetail();
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
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
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Session info', style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        _kv(theme, 'Opened', _formatDateTime(snapshot.session.openedAt)),
                        _kv(theme, 'Duration', durationLabel),
                        _kv(theme, 'Status', _phaseLabel(phase)),
                        _kv(theme, 'Session id', snapshot.session.id),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Guest join', style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        if (session.sessionToken != null) ...[
                          Text('Session code', style: theme.textTheme.labelLarge),
                          SelectableText(
                            session.sessionToken!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: SessionQrDisplay(
                              sessionToken: session.sessionToken!,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'No join code in memory for this session. '
                            'Reissue to generate a new QR code.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        SecondaryButton(
                          label: 'Reissue join code',
                          isExpanded: true,
                          isLoading: session.isLoading,
                          onPressed: session.isLoading
                              ? null
                              : () => session.reissueJoinToken(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bill summary', style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        if (session.bill == null)
                          Text('No bill yet', style: theme.textTheme.bodyMedium)
                        else ...[
                          _kv(
                            theme,
                            'Subtotal',
                            _money(session.bill!.subtotalMinor),
                          ),
                          _kv(
                            theme,
                            'Total',
                            _money(session.bill!.totalMinor),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Batches', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (session.batchSummaries.isEmpty)
                    Text(
                      'No kitchen batches yet.',
                      style: theme.textTheme.bodyMedium,
                    )
                  else
                    ...session.batchSummaries.map(
                      (batch) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Batch #${batch.batchNumber}'),
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
                  const SizedBox(height: AppSpacing.md),
                  Text('Customer requests', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (session.sessionRequests.isEmpty)
                    Text(
                      'No requests for this session.',
                      style: theme.textTheme.bodyMedium,
                    )
                  else
                    ...session.sessionRequests.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(staffRequestTypeLabel(r.requestType)),
                            subtitle: Text(
                              '${r.status.name} · ${_formatTime(r.requestedAt)}',
                            ),
                            trailing: StatusChip(
                              label: r.status.name,
                              tone: r.status == RequestStatus.pending
                                  ? StatusTone.warning
                                  : StatusTone.success,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (session.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    DecoratedBox(
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
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  SecondaryButton(
                    label: 'Mark waiting payment',
                    isExpanded: true,
                    onPressed: session.isLoading ||
                            phase == SessionLifecyclePhase.waitingPayment
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
                        : () => _closeWithPayment(session),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DangerButton(
                    label: 'Force close',
                    icon: Icons.lock_reset_outlined,
                    isExpanded: true,
                    onPressed: session.isLoading
                        ? null
                        : () => _forceClose(session),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: 'Refresh',
                    isExpanded: true,
                    onPressed: session.isLoading
                        ? null
                        : () async {
                            await session.restore();
                            await session.refreshSessionDetail();
                          },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _kv(ThemeData theme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(k, style: theme.textTheme.labelLarge),
          ),
          Expanded(child: Text(v, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  String _phaseLabel(SessionLifecyclePhase phase) => switch (phase) {
        SessionLifecyclePhase.available => 'Available',
        SessionLifecyclePhase.occupied => 'Occupied',
        SessionLifecyclePhase.waitingPayment => 'Waiting payment',
        SessionLifecyclePhase.closed => 'Closed',
      };

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')} ${_formatTime(local)}';
  }

  String _money(int minor) {
    final major = minor / 100;
    return major.toStringAsFixed(major.truncateToDouble() == major ? 0 : 2);
  }
}
