import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../shared/formatters/money_formatter.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực đơn'),
        actions: [
          if (sessionId != null)
            IconButton(
              icon: Badge(
                label: Text('${ordering.cartItemCount}'),
                isLabelVisible: ordering.cartItemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => _showCart(sessionId),
            ),
          const CustomerDemoExitButton(),
        ],
      ),
      body: catalog == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tìm món…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: ordering.setSearchQuery,
                  ),
                ),
                if (ordering.searchQuery.isNotEmpty &&
                    !ordering.hasSearchResults)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Text('Không tìm thấy món phù hợp.'),
                  )
                else
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        for (final category in catalog.categories) ...[
                          if (ordering.filteredItems(category.id).isNotEmpty) ...[
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ...ordering.filteredItems(category.id).map(
                              (item) => _MenuItemTile(
                                item: item as MenuItem,
                                onTap: sessionId == null
                                    ? null
                                    : () => _openCustomize(
                                          item: item,
                                          sessionId: sessionId,
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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CustomizeSheet(
        detail: detail,
        submitLabel: 'Thêm vào giỏ',
        isSubmitting: ordering.isLoading,
        onSubmit: (selections) async {
          final ok = await ref.read(customerOrderingControllerProvider).addToCart(
                sessionId: sessionId,
                menuItemId: item.id,
                quantity: 1,
                selectionsJson: selections,
              );
          if (context.mounted && ok) Navigator.pop(context);
          if (context.mounted && !ok) {
            final message = ref
                    .read(customerOrderingControllerProvider)
                    .errorMessage ??
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

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
    final price = formatMoneyDisplay(
      amountMinor: item.basePrice.amountMinor,
      currencyCode: item.basePrice.currencyCode,
    );
    return Card(
      child: ListTile(
        enabled: !unavailable && onTap != null,
        leading: item.imageUrl != null
            ? Image.network(
                item.imageUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.rice_bowl_outlined),
        title: Text(item.name),
        subtitle: Text(
          unavailable ? 'Hết món' : item.description ?? price,
        ),
        trailing: unavailable
            ? const Icon(Icons.block, color: Colors.grey)
            : Text(price),
        onTap: unavailable ? null : onTap,
      ),
    );
  }
}
