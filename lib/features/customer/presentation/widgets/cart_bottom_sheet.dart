import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/menu/cart_line_view.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/entities/menu_item.dart';
import '../controllers/customer_ordering_controller.dart';
import '../providers/customer_ordering_provider.dart';
import 'cart_ordering_messages.dart';
import 'customize_sheet.dart';

/// Reactive cart sheet — confirm is the single primary action.
///
/// UX gain: one confirm CTA, large qty steppers, Atelier money, no language
/// switch vs menu hub, clear empty state.
class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordering = ref.watch(customerOrderingControllerProvider);
    final cart = ordering.cart;
    final bill = ordering.bill;
    final currency = cart?.subtotal.currencyCode ?? 'VND';
    final theme = Theme.of(context);

    return RomsBottomSheetScaffold(
      title: 'Your cart',
      child: cart == null || cart.isEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EmptyState(
                  title: 'Cart is empty',
                  message: 'Add dishes from the menu, then confirm to send to the kitchen.',
                  icon: Icons.shopping_bag_outlined,
                ),
                SecondaryButton(
                  label: 'Browse menu',
                  isExpanded: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final line in cart.lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _CartLineTile(
                            line: line,
                            isPending: ordering.isCartItemPending(line.item.id),
                            onChanged: (qty) => _setQuantity(
                              context,
                              ref,
                              line: line,
                              quantity: qty,
                            ),
                            onRemove: () => _removeItem(context, ref, line),
                            onEdit: () => _editItem(context, ref, line),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${cart.totalItemCount} items',
                  style: theme.textTheme.bodyMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: theme.textTheme.titleMedium),
                    RomsMoneyText(
                      amountMinor: cart.subtotal.amountMinor,
                      currencyCode: currency,
                    ),
                  ],
                ),
                if (bill != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Est. bill', style: theme.textTheme.bodyMedium),
                      RomsMoneyText(
                        amountMinor: bill.totalMinor,
                        currencyCode: currency,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Keep browsing',
                        onPressed: ordering.isCartBusy
                            ? null
                            : () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Clear',
                        onPressed: ordering.isCartBusy
                            ? null
                            : () => _clearCart(context, ref),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: 'Send to kitchen',
                  icon: Icons.soup_kitchen_outlined,
                  isExpanded: true,
                  isLoading: ordering.isLoading,
                  onPressed: ordering.isCartBusy
                      ? null
                      : () => _confirmBatch(context, ref),
                ),
              ],
            ),
    );
  }

  Future<void> _setQuantity(
    BuildContext context,
    WidgetRef ref, {
    required CartLineView line,
    required int quantity,
  }) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    if (ordering.isCartItemPending(line.item.id)) return;

    final delta = quantity - line.item.quantity.value;
    if (delta == 0) return;

    final ok = await ordering.updateQuantity(
      sessionId: sessionId,
      cartItemId: line.item.id,
      delta: delta,
    );
    if (!context.mounted) return;
    if (!ok) {
      _showFailureSnackBar(
        context,
        ordering.errorMessage ?? CartOrderingMessages.updateQuantityFailed,
      );
    }
  }

  Future<void> _removeItem(
    BuildContext context,
    WidgetRef ref,
    CartLineView line,
  ) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    if (ordering.isCartItemPending(line.item.id)) return;

    final ok = await ordering.removeItem(
      sessionId: sessionId,
      cartItemId: line.item.id,
    );
    if (!context.mounted) return;
    if (!ok) {
      _showFailureSnackBar(
        context,
        ordering.errorMessage ?? CartOrderingMessages.removeItemFailed,
      );
    }
  }

  Future<void> _editItem(
    BuildContext context,
    WidgetRef ref,
    CartLineView line,
  ) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    if (ordering.isCartItemPending(line.item.id)) return;

    final menuItem = _findMenuItem(ordering, line.item.menuItemId);
    if (menuItem == null) {
      if (context.mounted) {
        _showFailureSnackBar(context, CartOrderingMessages.loadItemFailed);
      }
      return;
    }

    final detail = await ordering.loadItemDetail(menuItem.id);
    if (!context.mounted) return;
    if (detail == null) {
      _showFailureSnackBar(context, CartOrderingMessages.loadItemFailed);
      return;
    }

    await showRomsBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final current = ref.watch(customerOrderingControllerProvider);
            return CustomizeSheet(
              detail: detail,
              initialSelections: line.item.selectionsJson,
              submitLabel: 'Update item',
              isSubmitting: current.isCartItemPending(line.item.id),
              onSubmit: (selections) async {
                final ok = await ref
                    .read(customerOrderingControllerProvider)
                    .editCartItem(
                      sessionId: sessionId,
                      cartItemId: line.item.id,
                      selectionsJson: selections,
                    );
                if (!sheetContext.mounted) return;
                if (ok) {
                  Navigator.pop(sheetContext);
                  return;
                }
                final message = ref
                        .read(customerOrderingControllerProvider)
                        .errorMessage ??
                    CartOrderingMessages.editItemFailed;
                _showFailureSnackBar(sheetContext, message);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _clearCart(BuildContext context, WidgetRef ref) async {
    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: 'Clear cart?',
      message: 'All items in this cart will be removed.',
      confirmLabel: 'Clear',
      cancelLabel: 'Keep',
      isDestructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    final ordering = ref.read(customerOrderingControllerProvider);
    final ok = await ordering.clearCart(sessionId);
    if (!context.mounted) return;
    if (!ok) {
      _showFailureSnackBar(
        context,
        ordering.errorMessage ?? CartOrderingMessages.clearCartFailed,
      );
    }
  }

  Future<void> _confirmBatch(BuildContext context, WidgetRef ref) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    final ok = await ordering.confirmBatch(sessionId);
    if (!context.mounted) return;
    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Batch #${ordering.lastBatch?.batch.batchNumber} sent to kitchen',
          ),
        ),
      );
      return;
    }
    _showFailureSnackBar(
      context,
      ordering.errorMessage ?? CartOrderingMessages.confirmBatchFailed,
    );
  }

  MenuItem? _findMenuItem(CustomerOrderingController ordering, String id) {
    final catalog = ordering.catalog;
    if (catalog == null) return null;
    for (final items in catalog.itemsByCategoryId.values) {
      for (final item in items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  void _showFailureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({
    required this.line,
    required this.isPending,
    required this.onChanged,
    required this.onRemove,
    required this.onEdit,
  });

  final CartLineView line;
  final bool isPending;
  final ValueChanged<int> onChanged;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(line.menuItemName, style: theme.textTheme.titleSmall),
          if ((line.item.selectionsJson['__kitchenNotes'] as String?)?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              line.item.selectionsJson['__kitchenNotes'] as String,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              IgnorePointer(
                ignoring: isPending,
                child: Opacity(
                  opacity: isPending ? 0.5 : 1,
                  child: RomsQtyStepper(
                    value: line.item.quantity.value,
                    onChanged: onChanged,
                    min: 1,
                  ),
                ),
              ),
              if (isPending) ...[
                const SizedBox(width: AppSpacing.sm),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
              const Spacer(),
              RomsMoneyText(
                amountMinor: line.lineTotal.amountMinor,
                currencyCode: line.lineTotal.currencyCode,
              ),
            ],
          ),
          Row(
            children: [
              RomsTextButton(
                label: 'Remove',
                icon: Icons.delete_outline,
                onPressed: isPending ? null : onRemove,
              ),
              RomsTextButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: isPending ? null : onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
