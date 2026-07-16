import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../application/session/customer_session_messages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/restaurant_brand.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';
import '../widgets/customer_demo_exit_button.dart';

/// Customer session hub after a successful join.
class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSession());
  }

  Future<void> _ensureSession() async {
    final controller = ref.read(customerSessionControllerProvider);
    if (controller.isJoined &&
        controller.sessionToken == widget.sessionToken) {
      return;
    }

    final ok = await controller.join(widget.sessionToken);
    if (!mounted) return;
    if (!ok) {
      context.go('/customer');
      return;
    }
    await ref.read(customerOrderingControllerProvider).refreshSessionOrdering(
          ref.read(customerSessionControllerProvider).snapshot!.session.id,
        );
  }

  Future<void> _requestPayment() async {
    final controller = ref.read(customerSessionControllerProvider);
    await controller.requestPayment();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(CustomerSessionMessages.paymentRequested)),
    );
  }

  StatusTone _phaseTone(SessionLifecyclePhase phase) {
    return switch (phase) {
      SessionLifecyclePhase.available => StatusTone.success,
      SessionLifecyclePhase.occupied => StatusTone.brand,
      SessionLifecyclePhase.waitingPayment => StatusTone.warning,
      SessionLifecyclePhase.closed => StatusTone.neutral,
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customerSessionControllerProvider);
    final ordering = ref.watch(customerOrderingControllerProvider);
    final theme = Theme.of(context);
    final snapshot = controller.snapshot;
    final brand = RestaurantBrand.current;

    if (controller.isLoading && snapshot == null) {
      return const Scaffold(
        body: Center(child: LoadingIndicator()),
      );
    }

    if (snapshot == null) {
      return Scaffold(
        body: ErrorState(
          title: 'Session unavailable',
          message:
              controller.errorMessage ?? CustomerSessionMessages.sessionNotFound,
          onRetry: () => context.go('/customer'),
          retryLabel: 'Back to join',
        ),
      );
    }

    final phase = controller.lifecyclePhase;
    final bill = ordering.bill;

    return Scaffold(
      appBar: AppBar(
        title: Text(brand.displayName),
        actions: [
          RomsIconButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh',
            onPressed: controller.isLoading
                ? null
                : () async {
                    await controller.refreshCurrentSession();
                    if (!context.mounted) return;
                    await ordering.refreshSessionOrdering(
                      snapshot.session.id,
                    );
                  },
          ),
          const CustomerDemoExitButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RomsTableLabel(
                      label: snapshot.tableLabel,
                      emphasize: true,
                      statusLabel: controller.statusLabel,
                      tone: _phaseTone(phase),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    RomsSessionBadge(
                      displayNumber: snapshot.session.displayNumber,
                      phaseLabel: controller.statusLabel,
                      tone: _phaseTone(phase),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      brand.tagline ?? 'Your dining session',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Order progress', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              if (ordering.batchProgress.isEmpty)
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restaurant_outlined,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'No orders sent to the kitchen yet. Browse the menu to begin.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...ordering.batchProgress.map(
                  (batch) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.xs,
                            ),
                            title: Text(
                              'Batch #${batch.batchNumber}',
                              style: theme.textTheme.titleMedium,
                            ),
                            trailing: StatusChip(
                              label: batch.statusLabel,
                              tone: batch.isCompleted
                                  ? StatusTone.success
                                  : StatusTone.warning,
                            ),
                          ),
                          if (batch.items.isNotEmpty) ...[
                            const Divider(height: 1),
                            ...batch.items.map((item) => ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              title: Text(item.name),
                              subtitle: item.kitchenNotes.isNotEmpty
                                ? Text(item.kitchenNotes)
                                : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.quantityLabel,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.inkMuted,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  RomsMoneyText(
                                    amountMinor: item.lineTotalMinor,
                                    currencyCode: 'VND',
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(height: AppSpacing.xs),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              Text('Bill so far', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: bill != null && bill.totalMinor > 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Bill', style: theme.textTheme.bodyLarge),
                              RomsMoneyText(
                                amountMinor: bill.totalMinor,
                                currencyCode: 'VND',
                                large: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Paid', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted)),
                              RomsMoneyText(
                                amountMinor: bill.paidMinor,
                                currencyCode: 'VND',
                                color: AppColors.inkMuted,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Outstanding', style: theme.textTheme.titleMedium?.copyWith(color: AppColors.warning)),
                              RomsMoneyText(
                                amountMinor: bill.outstandingMinor,
                                currencyCode: 'VND',
                                color: AppColors.warning,
                                large: true,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Text(
                        'No items ordered yet.',
                        style: theme.textTheme.bodyMedium,
                      ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Browse menu',
                icon: Icons.menu_book_outlined,
                isExpanded: true,
                onPressed: () async {
                  await context.push('/s/${widget.sessionToken}/menu');
                  if (!context.mounted) return;
                  await ordering.refreshSessionOrdering(snapshot.session.id);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Call staff',
                icon: Icons.support_agent_outlined,
                isExpanded: true,
                onPressed: () => context.push(
                  '/s/${widget.sessionToken}/request',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: controller.paymentRequested
                    ? 'Payment requested'
                    : 'Request payment (Cash)',
                icon: Icons.payments_outlined,
                isExpanded: true,
                onPressed: phase == SessionLifecyclePhase.closed ||
                        controller.paymentRequested || bill == null || bill.outstandingMinor <= 0
                    ? null
                    : _requestPayment,
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: 'Pay with VNPAY',
                icon: Icons.qr_code_2_outlined,
                isExpanded: true,
                onPressed: phase == SessionLifecyclePhase.closed || bill == null || bill.outstandingMinor <= 0
                    ? null
                    : () async {
                        final url = await ordering.createVnpayIntent();
                        if (url != null && mounted) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
                          // The user returns when the webview is closed.
                          // It will automatically refresh in the background because of the SSE event,
                          // but we could also check the status.
                          final status = await ordering.checkPaymentStatus();
                          if (status == 'paid') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful!')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Not Completed. Check again later.')));
                          }
                        } else if (ordering.errorMessage != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ordering.errorMessage!)));
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
