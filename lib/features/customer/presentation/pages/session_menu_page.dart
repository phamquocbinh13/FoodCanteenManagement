import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/cart_ordering_messages.dart';
import '../widgets/customer_demo_exit_button.dart';
import '../widgets/customize_sheet.dart';

/// Customer menu browse, customize, cart editing, and batch confirm.
class SessionMenuPage extends ConsumerStatefulWidget {
  const SessionMenuPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  ConsumerState<SessionMenuPage> createState() => _SessionMenuPageState();
}

class _SessionMenuPageState extends ConsumerState<SessionMenuPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final session = ref.read(customerSessionControllerProvider);
    final ordering = ref.read(customerOrderingControllerProvider);
    await ordering.loadMenu();
    final sessionId = session.snapshot?.session.id;
    if (sessionId != null) {
      await ordering.refreshCart(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(customerSessionControllerProvider);
    final ordering = ref.watch(customerOrderingControllerProvider);
    final sessionId = session.snapshot?.session.id;
    final catalog = ordering.catalog;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          if (sessionId != null)
            RomsIconButton(
              icon: Icons.shopping_cart_outlined,
              tooltip: 'Cart',
              onPressed: () => _showCart(sessionId),
            ),
          if (sessionId != null && ordering.cartItemCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: StatusChip(
                  label: '${ordering.cartItemCount}',
                  tone: StatusTone.brand,
                ),
              ),
            ),
          if (kDebugMode) const CustomerDemoExitButton(),
        ],
      ),
      floatingActionButton: sessionId != null && ordering.cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => _showCart(sessionId),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text('Cart · ${ordering.cartItemCount}'),
            )
          : null,
      body: catalog == null
          ? const RomsSkeletonList()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: SearchField(
                    hintText: 'Search dishes…',
                    onChanged: ordering.setSearchQuery,
                  ),
                ),
                if (ordering.searchQuery.isNotEmpty &&
                    !ordering.hasSearchResults)
                  Expanded(
                    child: EmptyState(
                      title: 'No matches',
                      message: 'Try another name or clear the search.',
                      icon: Icons.search_off_outlined,
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.xxxl,
                      ),
                      children: [
                        for (final category in catalog.categories) ...[
                          if (ordering
                              .filteredItems(category.id)
                              .isNotEmpty) ...[
                            Text(
                              category.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ...ordering.filteredItems(category.id).map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _MenuItemTile(
                                  item: item as MenuItem,
                                  onTap: sessionId == null
                                      ? null
                                      : () => _openCustomize(
                                            item: item,
                                            sessionId: sessionId,
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _openCustomize({
    required MenuItem item,
    required String sessionId,
  }) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    final detail = await ordering.loadItemDetail(item.id);
    if (!mounted || detail == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CartOrderingMessages.loadItemFailed)),
        );
      }
      return;
    }

    if (!mounted) return;
    await showRomsBottomSheet<void>(
      context: context,
      builder: (context) => CustomizeSheet(
        detail: detail,
        submitLabel: 'Add to cart',
        isSubmitting: ordering.isLoading,
        onSubmit: (selections) async {
          final ok =
              await ref.read(customerOrderingControllerProvider).addToCart(
                    sessionId: sessionId,
                    menuItemId: item.id,
                    quantity: 1,
                    selectionsJson: selections,
                  );
          if (context.mounted && ok) Navigator.pop(context);
          if (context.mounted && !ok) {
            final message =
                ref.read(customerOrderingControllerProvider).errorMessage ??
                    CartOrderingMessages.editItemFailed;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
      ),
    );
    await ref.read(customerOrderingControllerProvider).refreshCart(sessionId);
  }

  Future<void> _showCart(String sessionId) async {
    await ref.read(customerOrderingControllerProvider).refreshCart(sessionId);
    if (!mounted) return;

    await showRomsBottomSheet<void>(
      context: context,
      builder: (context) => CartBottomSheet(sessionId: sessionId),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({required this.item, this.onTap});

  final MenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final unavailable = item.availability != MenuAvailability.available;
    final theme = Theme.of(context);

    return AppCard(
      onTap: unavailable ? null : onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              unavailable ? Icons.block : Icons.rice_bowl_outlined,
              color: unavailable ? AppColors.inkDisabled : AppColors.brand,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                if (unavailable)
                  const StatusChip(
                    label: 'Out of stock',
                    tone: StatusTone.danger,
                  )
                else if (item.description != null &&
                    item.description!.trim().isNotEmpty)
                  Text(
                    item.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (!unavailable)
            RomsMoneyText(
              amountMinor: item.basePrice.amountMinor,
              currencyCode: item.basePrice.currencyCode,
            ),
        ],
      ),
    );
  }
}
