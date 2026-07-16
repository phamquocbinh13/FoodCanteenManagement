import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
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

// ---------------------------------------------------------------------------
// Premium Rainforest Sanctuary Asset Map & Asset Substitution Logic
// ---------------------------------------------------------------------------
const _kMenuAssets = <String, String>{
  'cà ri gà':        'assets/images/menu/item_curry_chicken.png',
  'chả lá lốt':      'assets/images/menu/item_pork_roll.png',
  'gà xào nấm':      'assets/images/menu/item_chicken_mushroom.png',
  'thịt kho':        'assets/images/menu/item_braised_pork.png',
  'gà chiên':        'assets/images/menu/item_crispy_chicken.png',
  'trà đá':          'assets/images/menu/item_iced_tea.png',
  'soda':            'assets/images/menu/item_soft_drinks.png',
  'coca cola':       'assets/images/menu/item_soft_drinks.png',
  'pepsi':           'assets/images/menu/item_soft_drinks.png',
  'sprite':          'assets/images/menu/item_soft_drinks.png',
  'nước ngọt':       'assets/images/menu/item_soft_drinks.png',
};

String? _assetFor(MenuItem item) {
  final key = item.name.toLowerCase();
  for (final entry in _kMenuAssets.entries) {
    if (key.contains(entry.key)) return entry.value;
  }
  return null;
}

/// Customer menu — Premium 2-row horizontal gallery layout.
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

    // Filter items into Rice Selections and Beverages
    final List<MenuItem> riceItems = [];
    final List<MenuItem> beverageItems = [];

    if (catalog != null) {
      for (final category in catalog.categories) {
        final items = ordering.filteredItems(category.id).cast<MenuItem>();
        final catName = category.name.toLowerCase();
        if (catName.contains('cơm') || catName.contains('rice')) {
          riceItems.addAll(items);
        } else if (catName.contains('uống') || catName.contains('nước') || catName.contains('drink') || catName.contains('beverage')) {
          beverageItems.addAll(items);
        } else {
          // Fallback bucket based on item fields
          for (final item in items) {
            if (item.name.toLowerCase().contains('cơm')) {
              riceItems.add(item);
            } else {
              beverageItems.add(item);
            }
          }
        }
      }
    }

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
          const CustomerDemoExitButton(),
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
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Search Field ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: TextField(
                      onChanged: ordering.setSearchQuery,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search dishes…',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.inkMuted,
                        ),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          size: 20,
                          color: AppColors.inkMuted,
                        ),
                        filled: false,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.inkMuted,
                            width: 1,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.inkMuted,
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.brand,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Search Result State or Galleries ─────────────────────
                  if (ordering.searchQuery.isNotEmpty && !ordering.hasSearchResults)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: EmptyState(
                        title: 'No matches',
                        message: 'Try another name or clear the search.',
                        icon: Icons.search_off_outlined,
                      ),
                    )
                  else ...[
                    // ── Row 1: Rice Selections ─────────────────────────────
                    if (riceItems.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text(
                          'RICE SELECTIONS',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.ink,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          itemCount: riceItems.length,
                          itemBuilder: (context, index) {
                            final item = riceItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.lg),
                              child: _HorizontalMenuItemCard(
                                item: item,
                                sessionId: sessionId,
                                onTap: () => _openCustomize(item: item, sessionId: sessionId!),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],

                    // ── Row 2: Beverages ───────────────────────────────────
                    if (beverageItems.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text(
                          'BEVERAGES',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.ink,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          itemCount: beverageItems.length,
                          itemBuilder: (context, index) {
                            final item = beverageItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.lg),
                              child: _HorizontalMenuItemCard(
                                item: item,
                                sessionId: sessionId,
                                onTap: () => _openCustomize(item: item, sessionId: sessionId!),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ],
              ),
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

// ---------------------------------------------------------------------------
// Fixed Size horizontal gallery card (height constraints applied)
// ---------------------------------------------------------------------------
class _HorizontalMenuItemCard extends StatelessWidget {
  const _HorizontalMenuItemCard({
    required this.item,
    required this.sessionId,
    required this.onTap,
  });

  final MenuItem item;
  final String? sessionId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unavailable = item.availability != MenuAvailability.available;
    final asset = _assetFor(item);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: unavailable || sessionId == null ? null : onTap,
      child: SizedBox(
        width: 186.0, // Fixed width to respect 4:3 with height 140
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Constrained 4:3 Image Container (Height 140.0) ──────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                height: 140.0,
                width: 186.0,
                child: asset != null
                    ? Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        opacity: unavailable
                            ? const AlwaysStoppedAnimation(0.4)
                            : null,
                      )
                    : Container(
                        color: AppColors.surfaceRaised,
                        child: Center(
                          child: Icon(
                            unavailable ? Icons.block_outlined : Icons.restaurant_outlined,
                            size: 32,
                            color: unavailable ? AppColors.inkDisabled : AppColors.inkMuted,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8.0),
            // ── Titles & Tabular Prices (Open, Borderless Layout) ─────────────
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: unavailable ? AppColors.inkDisabled : AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2.0),
            if (unavailable)
              const StatusChip(
                label: 'Hết món',
                tone: StatusTone.danger,
              )
            else
              RomsMoneyText(
                amountMinor: item.basePrice.amountMinor,
                currencyCode: item.basePrice.currencyCode,
                color: AppColors.brand,
              ),
          ],
        ),
      ),
    );
  }
}
