import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/restaurant_context.dart';
import '../../../../app/di/injection.dart';
import '../../../../application/menu/cart_view.dart';
import '../../../../application/menu/menu_catalog_view.dart';
import '../../../../application/usecases/batch/staff_confirm_batch_use_case.dart';
import '../../../../application/usecases/cart/add_to_cart_use_case.dart';
import '../../../../application/usecases/cart/get_session_cart_use_case.dart';
import '../../../../application/usecases/cart/remove_cart_item_use_case.dart';
import '../../../../application/usecases/cart/update_cart_item_quantity_use_case.dart';
import '../../../../application/usecases/menu/get_menu_catalog_use_case.dart';
import '../../../../application/usecases/menu/get_menu_item_detail_use_case.dart';
import '../../../../application/usecases/batch/update_batch_item_quantity_use_case.dart';
import '../../../../application/usecases/batch/remove_batch_item_use_case.dart';
import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../core/result/result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/entities/authenticated_user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../customer/presentation/widgets/customize_sheet.dart';
import '../providers/cashier_session_provider.dart';

/// Tab 3 — amend guest orders via staff cart → new kitchen batch.
///
/// Confirmed batch lines are immutable on the backend. Staff edits create a
/// new cart confirmation (new batch). Completed batches are view-only.
class CashierEditOrdersTab extends ConsumerStatefulWidget {
  const CashierEditOrdersTab({super.key});

  @override
  ConsumerState<CashierEditOrdersTab> createState() =>
      _CashierEditOrdersTabState();
}

class _CashierEditOrdersTabState extends ConsumerState<CashierEditOrdersTab> {
  String? _selectedSessionId;
  CartView? _cart;
  MenuCatalogView? _catalog;
  String? _error;
  bool _busy = false;

  String get _restaurantId => sl<RestaurantContext>().restaurantId;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(cashierSessionControllerProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final occupied = session.activeSessions;
    final menuItems = _flattenMenu(_catalog);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: RomsSplitView(
        masterWidth: 320,
        master: _buildMaster(context, session, occupied, theme),
        detail: _buildDetail(context, session, user, theme, menuItems),
      ),
    );
  }

  Widget _buildMaster(
    BuildContext context,
    CashierSessionController session,
    List<SessionEngineSnapshot> occupied,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Active Sessions',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Refresh',
              icon: session.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, size: 20),
              onPressed: session.isLoading ? null : _refreshAll,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            child: occupied.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      EmptyState(
                        title: 'No open sessions',
                        message: 'Open a table on the Floor tab first.',
                        icon: Icons.table_restaurant_outlined,
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: occupied.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final snap = occupied[index];
                      final isSelected = _selectedSessionId == snap.session.id;
                      return Material(
                        color: isSelected
                            ? AppColors.brandSoft
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => _selectSession(snap),
                          borderRadius: BorderRadius.circular(8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.brand
                                    : theme.colorScheme.outlineVariant,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snap.tableLabel,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      RomsSessionBadge(
                                        displayNumber:
                                            snap.session.displayNumber,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Opened ${_formatTime(snap.session.openedAt)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetail(
    BuildContext context,
    CashierSessionController session,
    AuthenticatedUser? user,
    ThemeData theme,
    List<MenuItem> menuItems,
  ) {
    if (_selectedSessionId == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: EmptyState(
            title: 'No session selected',
            message: 'Select a session on the left to edit orders.',
            icon: Icons.edit_note_outlined,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'EDIT ORDERS · ${session.activeSnapshot?.tableLabel ?? ""}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (_busy)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text('Kitchen batches', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (session.batchSummaries.isEmpty)
                  Text('No batches yet.', style: theme.textTheme.bodyMedium)
                else
                  ...session.batchSummaries.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Batch #${b.batchNumber}'),
                              subtitle: Text(
                                b.completedAt != null
                                    ? 'Completed — locked'
                                    : 'In kitchen — add-ons via new batch',
                              ),
                              trailing: StatusChip(
                                label: b.statusLabel,
                                tone: b.completedAt != null
                                    ? StatusTone.success
                                    : StatusTone.warning,
                              ),
                            ),
                            if (b.items.isNotEmpty) ...[
                              const Divider(),
                              ...b.items.map((item) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.name),
                                subtitle: Text('Qty ${item.quantityLabel}'),
                                trailing: b.completedAt != null ? null : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _busy ? null : () => _changeBatchItemQty(item.id, -1),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: _busy ? null : () => _changeBatchItemQty(item.id, 1),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: _busy ? null : () => _removeBatchItem(item.id),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                Text('Open cart (amend)', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (_cart == null)
                  const LoadingIndicator(message: 'Loading cart…')
                else if (_cart!.lines.isEmpty)
                  Text(
                    'Cart is empty. Add menu items below, then confirm to kitchen.',
                    style: theme.textTheme.bodyMedium,
                  )
                else
                  ..._cart!.lines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(line.menuItemName),
                          subtitle: Text('Qty ${line.item.quantity.value}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: _busy
                                    ? null
                                    : () => _changeQty(line.item.id, -1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: _busy
                                    ? null
                                    : () => _changeQty(line.item.id, 1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: _busy
                                    ? null
                                    : () => _removeLine(line.item.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Confirm cart to kitchen',
                  isExpanded: true,
                  isLoading: _busy,
                  onPressed: _busy || (_cart?.lines.isEmpty ?? true)
                      ? null
                      : () => _confirm(user?.id),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Add menu item', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (_catalog == null)
                  SecondaryButton(
                    label: 'Load menu',
                    isExpanded: true,
                    onPressed: _loadCatalog,
                  )
                else
                  ...menuItems.take(16).map(
                        (item) => ListTile(
                          title: Text(item.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _busy ? null : () => _addItem(item.id),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _refreshAll() async {
    final session = ref.read(cashierSessionControllerProvider);
    await session.restore();
    if (_selectedSessionId != null) {
      await _loadCart(_selectedSessionId!);
    }
  }

  List<MenuItem> _flattenMenu(MenuCatalogView? catalog) {
    if (catalog == null) return const [];
    final items = <MenuItem>[];
    for (final cat in catalog.categories) {
      items.addAll(catalog.itemsByCategoryId[cat.id] ?? const []);
    }
    return items;
  }

  Future<void> _selectSession(SessionEngineSnapshot snap) async {
    setState(() {
      _selectedSessionId = snap.session.id;
      _cart = null;
      _error = null;
    });
    final session = ref.read(cashierSessionControllerProvider);
    await session.selectSession(snap);
    await _loadCart(snap.session.id);
  }

  Future<void> _loadCart(String sessionId) async {
    final result = await sl<GetSessionCartUseCase>()(
      GetSessionCartParams(sessionId: sessionId),
    );
    if (!mounted) return;
    if (result is Success<CartView>) {
      setState(() => _cart = result.value);
    } else if (result is Err<CartView>) {
      setState(() => _error = result.failure.message);
    }
  }

  Future<void> _loadCatalog() async {
    final result = await sl<GetMenuCatalogUseCase>()(
      GetMenuCatalogParams(restaurantId: _restaurantId),
    );
    if (!mounted) return;
    if (result is Success<MenuCatalogView>) {
      setState(() => _catalog = result.value);
    }
  }

  Future<void> _addItem(String menuItemId) async {
    final sessionId = _selectedSessionId;
    if (sessionId == null) return;
    setState(() => _busy = true);

    final detailResult = await sl<GetMenuItemDetailUseCase>()(
      GetMenuItemDetailParams(
        restaurantId: _restaurantId,
        menuItemId: menuItemId,
      ),
    );
    setState(() => _busy = false);

    if (detailResult is Err) {
      setState(() => _error = (detailResult as Err).failure.message);
      return;
    }

    final detail = (detailResult as Success<MenuItemDetailView>).value;

    if (detail.groups.isNotEmpty) {
      if (!mounted) return;
      await showRomsBottomSheet<void>(
        context: context,
        builder: (context) => CustomizeSheet(
          detail: detail,
          submitLabel: 'Add to cart',
          onSubmit: (selections) async {
            setState(() => _busy = true);
            final result = await sl<AddToCartUseCase>()(
              AddToCartParams(
                sessionId: sessionId,
                restaurantId: _restaurantId,
                menuItemId: menuItemId,
                quantity: 1,
                selectionsJson: selections,
              ),
            );
            setState(() => _busy = false);
            if (result is Err) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text((result as Err).failure.message)),
                );
              }
            } else {
              if (mounted) Navigator.pop(context);
              await _loadCart(sessionId);
            }
          },
        ),
      );
    } else {
      setState(() => _busy = true);
      final result = await sl<AddToCartUseCase>()(
        AddToCartParams(
          sessionId: sessionId,
          restaurantId: _restaurantId,
          menuItemId: menuItemId,
          quantity: 1,
          selectionsJson: const {'groups': {}},
        ),
      );
      setState(() => _busy = false);
      if (result is Err) {
        setState(() => _error = (result as Err).failure.message);
        return;
      }
      await _loadCart(sessionId);
    }
  }

  Future<void> _changeQty(String cartItemId, int delta) async {
    final sessionId = _selectedSessionId;
    final cart = _cart;
    if (sessionId == null || cart == null) return;
    setState(() => _busy = true);
    final result = await sl<UpdateCartItemQuantityUseCase>()(
      UpdateCartItemQuantityParams(
        sessionCartId: cart.cart.id,
        cartItemId: cartItemId,
        delta: delta,
      ),
    );
    if (result is Err) {
      // delta -1 at qty 1 → remove
      if (delta < 0) {
        await sl<RemoveCartItemUseCase>()(
          RemoveCartItemParams(
            sessionCartId: cart.cart.id,
            cartItemId: cartItemId,
          ),
        );
      }
    }
    setState(() => _busy = false);
    await _loadCart(sessionId);
  }

  Future<void> _removeLine(String cartItemId) async {
    final sessionId = _selectedSessionId;
    final cart = _cart;
    if (sessionId == null || cart == null) return;
    setState(() => _busy = true);
    await sl<RemoveCartItemUseCase>()(
      RemoveCartItemParams(
        sessionCartId: cart.cart.id,
        cartItemId: cartItemId,
      ),
    );
    setState(() => _busy = false);
    await _loadCart(sessionId);
  }

  Future<void> _changeBatchItemQty(String batchItemId, int delta) async {
    final sessionId = _selectedSessionId;
    if (sessionId == null) return;
    setState(() => _busy = true);
    
    final result = await sl<UpdateBatchItemQuantityUseCase>()(
      UpdateBatchItemQuantityParams(
        restaurantId: _restaurantId,
        batchItemId: batchItemId,
        delta: delta,
      ),
    );
    setState(() => _busy = false);

    if (result is Err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((result as Err).failure.message)),
        );
      }
      return;
    }
    
    await ref.read(cashierSessionControllerProvider).refreshSessionDetail();
  }

  Future<void> _removeBatchItem(String batchItemId) async {
    final sessionId = _selectedSessionId;
    if (sessionId == null) return;
    setState(() => _busy = true);
    
    final result = await sl<RemoveBatchItemUseCase>()(
      RemoveBatchItemParams(
        restaurantId: _restaurantId,
        batchItemId: batchItemId,
      ),
    );
    setState(() => _busy = false);

    if (result is Err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((result as Err).failure.message)),
        );
      }
      return;
    }
    
    await ref.read(cashierSessionControllerProvider).refreshSessionDetail();
  }

  Future<void> _confirm(String? actorId) async {
    final sessionId = _selectedSessionId;
    if (sessionId == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await sl<StaffConfirmBatchUseCase>()(
      StaffConfirmBatchParams(
        restaurantId: _restaurantId,
        sessionId: sessionId,
        actorId: actorId,
      ),
    );
    setState(() => _busy = false);
    if (result is Err) {
      setState(() => _error = (result as Err).failure.message);
      return;
    }
    await ref.read(cashierSessionControllerProvider).refreshSessionDetail();
    await _loadCart(sessionId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New batch sent to kitchen')),
      );
    }
  }
}
