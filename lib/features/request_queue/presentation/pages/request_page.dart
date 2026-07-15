import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../application/session/customer_session_messages.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../customer/presentation/providers/customer_session_provider.dart';
import '../providers/request_queue_provider.dart';
import '../widgets/staff_request_tile.dart';

/// Cashier request queue — pending call-staff items across active sessions.
class RequestPage extends ConsumerWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(requestQueueControllerProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return StaffScaffold(
      title: 'Request Queue',
      body: RefreshIndicator(
        onRefresh: queue.refresh,
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
                      'Call-staff requests',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Handle customer requests quickly. Payment requests '
                      'mark the table as waiting for payment.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PendingBadge(count: queue.pendingCount),
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
            if (queue.isLoading && queue.items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (queue.items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'No pending requests.\nPull to refresh.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
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
                  itemCount: queue.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = queue.items[index];
                    final busy = queue.handlingRequestId == item.request.id;
                    return StaffRequestTile(
                      item: item,
                      isHandling: busy,
                      onHandle: user == null
                          ? null
                          : () async {
                              final ok = await queue.handle(
                                requestId: item.request.id,
                                handledByUserId: user.id,
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? '${item.typeLabel} handled'
                                        : queue.errorMessage ??
                                            'Could not handle request',
                                  ),
                                ),
                              );
                            },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: count == 0
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          count == 0 ? 'Queue clear' : '$count pending',
          style: theme.textTheme.labelLarge?.copyWith(
            color: count == 0
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Customer call-staff surface for an active session.
class SessionRequestPage extends ConsumerStatefulWidget {
  const SessionRequestPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  ConsumerState<SessionRequestPage> createState() => _SessionRequestPageState();
}

class _SessionRequestPageState extends ConsumerState<SessionRequestPage> {
  static const _options = <(RequestType, IconData, String, String)>[
    (
      RequestType.staffAssistance,
      Icons.support_agent_rounded,
      'Staff Assistance',
      'Ask a team member to come to your table',
    ),
    (
      RequestType.extraWater,
      Icons.water_drop_outlined,
      'Extra Water',
      'Request water for the table',
    ),
    (
      RequestType.extraBowl,
      Icons.rice_bowl_outlined,
      'Extra Bowl',
      'Request an extra bowl',
    ),
    (
      RequestType.extraSpoon,
      Icons.restaurant_outlined,
      'Extra Spoon',
      'Request an extra spoon',
    ),
    (
      RequestType.payment,
      Icons.payments_outlined,
      'Request Payment',
      'Ask cashier to bring the bill',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(customerSessionControllerProvider);
      if (!controller.isJoined) {
        await controller.join(widget.sessionToken);
      }
      await controller.refreshSessionRequests();
    });
  }

  Future<void> _submit(RequestType type) async {
    final controller = ref.read(customerSessionControllerProvider);
    final ok = await controller.createStaffRequest(type);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (type == RequestType.payment
                  ? CustomerSessionMessages.paymentRequested
                  : CustomerSessionMessages.staffNotified)
              : (controller.errorMessage ?? 'Request failed. Please try again.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customerSessionControllerProvider);
    final theme = Theme.of(context);
    final paymentPending = controller.paymentRequested ||
        controller.lifecyclePhase == SessionLifecyclePhase.waitingPayment;

    return Scaffold(
      appBar: AppBar(title: const Text('Call Staff')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'How can we help?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your request goes to the cashier queue immediately.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (controller.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                controller.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ..._options.map((option) {
              final (type, icon, title, subtitle) = option;
              final disabled = controller.isLoading ||
                  controller.lifecyclePhase == SessionLifecyclePhase.closed ||
                  (type == RequestType.payment && paymentPending);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _RequestOptionCard(
                  icon: icon,
                  title: title,
                  subtitle: type == RequestType.payment && paymentPending
                      ? 'Payment already requested — staff will assist shortly'
                      : subtitle,
                  enabled: !disabled,
                  emphasize: type == RequestType.payment,
                  onTap: () => _submit(type),
                ),
              );
            }),
            if (controller.sessionRequests.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text('Recent requests', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...controller.sessionRequests.reversed.take(5).map(
                    (r) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(staffRequestTypeLabel(r.requestType)),
                      subtitle: Text(
                        r.status == RequestStatus.pending
                            ? 'Pending'
                            : 'Handled',
                      ),
                      trailing: Icon(
                        r.status == RequestStatus.pending
                            ? Icons.schedule
                            : Icons.check_circle_outline,
                        color: r.status == RequestStatus.pending
                            ? theme.colorScheme.tertiary
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestOptionCard extends StatelessWidget {
  const _RequestOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
    this.emphasize = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: emphasize
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: enabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: enabled
                            ? null
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.38,
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: enabled
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface.withValues(alpha: 0.24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
