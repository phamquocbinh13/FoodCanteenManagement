import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/menu/cart_line_view.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../shared/formatters/money_formatter.dart';
import '../controllers/customer_ordering_controller.dart';
import '../providers/customer_ordering_provider.dart';
import 'cart_ordering_messages.dart';
import 'customize_sheet.dart';

/// Reactive cart bottom sheet — always renders latest [CustomerOrderingController] state.
class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordering = ref.watch(customerOrderingControllerProvider);
    final cart = ordering.cart;
    final bill = ordering.bill;
    final currency = cart?.subtotal.currencyCode ?? 'VND';

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Giỏ hàng', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          if (cart == null || cart.isEmpty) ...[
            const Text('Bạn chưa chọn món nào.'),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chọn món'),
            ),
          ] else ...[
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final line in cart.lines)
                    _CartLineTile(
                      line: line,
                      isPending: ordering.isCartItemPending(line.item.id),
                      onIncrease: () => _updateQuantity(
                        context,
                        ref,
                        line: line,
                        delta: 1,
                      ),
                      onDecrease: () => _updateQuantity(
                        context,
                        ref,
                        line: line,
                        delta: -1,
                      ),
                      onRemove: () => _removeItem(context, ref, line),
                      onEdit: () => _editItem(context, ref, line),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tổng món: ${cart.totalItemCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Tạm tính: ${formatMoneyDisplay(amountMinor: cart.subtotal.amountMinor, currencyCode: currency)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (bill != null)
              Text(
                'Ước tính hóa đơn: ${formatMoneyDisplay(amountMinor: bill.totalMinor, currencyCode: currency)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: ordering.isCartBusy
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Tiếp tục gọi món'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: ordering.isCartBusy
                        ? null
                        : () => _clearCart(context, ref),
                    child: const Text('Xóa giỏ'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: ordering.isCartBusy
                  ? null
                  : () => _confirmBatch(context, ref),
              child: ordering.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Xác nhận Batch'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateQuantity(
    BuildContext context,
    WidgetRef ref, {
    required CartLineView line,
    required int delta,
  }) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    if (ordering.isCartItemPending(line.item.id)) return;

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

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final current = ref.watch(customerOrderingControllerProvider);
            return CustomizeSheet(
              detail: detail,
              initialSelections: line.item.selectionsJson,
              submitLabel: 'Cập nhật',
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng?'),
        content: const Text('Tất cả món trong giỏ sẽ bị xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
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
            'Batch #${ordering.lastBatch?.batch.batchNumber} đã gửi bếp!',
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
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onEdit,
  });

  final CartLineView line;
  final bool isPending;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final price = formatMoneyDisplay(
      amountMinor: line.lineTotal.amountMinor,
      currencyCode: line.lineTotal.currencyCode,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              line.menuItemName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: isPending ? null : onDecrease,
                ),
                Text('${line.item.quantity.value}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: isPending ? null : onIncrease,
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
                Text(price),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: isPending ? null : onRemove,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Xóa'),
                ),
                TextButton.icon(
                  onPressed: isPending ? null : onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Sửa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
