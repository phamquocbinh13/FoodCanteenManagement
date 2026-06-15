import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../application/validators/customization_validator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/customization_group.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';

/// Customer menu browse, customize, cart, and batch confirm.
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
        title: const Text('Menu'),
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
                      hintText: 'Search menu…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: ordering.setSearchQuery,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      for (final category in catalog.categories) ...[
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
                                : () => _openCustomize(item, sessionId),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _openCustomize(MenuItem item, String sessionId) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    final detail = await ordering.loadItemDetail(item.id);
    if (!mounted || detail == null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CustomizeSheet(
        detail: detail,
        onAdd: (selections) async {
          final ok = await ordering.addToCart(
            sessionId: sessionId,
            menuItemId: item.id,
            quantity: 1,
            selectionsJson: selections,
          );
          if (context.mounted && ok) Navigator.pop(context);
        },
      ),
    );
    await ordering.refreshCart(sessionId);
  }

  Future<void> _showCart(String sessionId) async {
    final ordering = ref.read(customerOrderingControllerProvider);
    await ordering.refreshCart(sessionId);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final cart = ordering.cart;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Your Cart', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              if (cart == null || cart.isEmpty)
                const Text('Cart is empty')
              else ...[
                for (final line in cart.items)
                  ListTile(
                    title: Text('Item ${line.menuItemId}'),
                    subtitle: Text('Qty ${line.quantity.value}'),
                    trailing: Text(
                      '\$${(line.unitPriceSnapshot.amountMinor * line.quantity.value / 100).toStringAsFixed(2)}',
                    ),
                  ),
                Text(
                  'Subtotal: \$${cart.subtotal.amountDecimal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: ordering.isLoading
                      ? null
                      : () async {
                          final ok = await ordering.confirmBatch(sessionId);
                          if (context.mounted) {
                            Navigator.pop(context);
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Batch #${ordering.lastBatch?.batch.batchNumber} sent to kitchen!',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: const Text('Confirm Batch'),
                ),
              ],
            ],
          ),
        );
      },
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
    return Card(
      child: ListTile(
        enabled: !unavailable && onTap != null,
        title: Text(item.name),
        subtitle: Text(
          unavailable
              ? 'Unavailable'
              : item.description ?? '\$${item.basePrice.amountDecimal.toStringAsFixed(2)}',
        ),
        trailing: unavailable
            ? const Icon(Icons.block, color: Colors.grey)
            : Text('\$${item.basePrice.amountDecimal.toStringAsFixed(2)}'),
        onTap: unavailable ? null : onTap,
      ),
    );
  }
}

class _CustomizeSheet extends StatefulWidget {
  const _CustomizeSheet({required this.detail, required this.onAdd});

  final MenuItemDetailView detail;
  final Future<void> Function(Map<String, dynamic> selections) onAdd;

  @override
  State<_CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends State<_CustomizeSheet> {
  final _noteController = TextEditingController();
  final _selections = <String, List<String>>{};

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final item = detail.item;
    final groups = detail.groups;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final group in groups) ...[
              Text('${group.name}${group.isRequired ? ' *' : ''}'),
              const SizedBox(height: AppSpacing.xs),
              ..._buildGroupOptions(group, detail.optionsByGroupId[group.id]),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Special instructions',
                hintText: 'Extra spicy, less salt…',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => widget.onAdd(_buildSelectionsJson()),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupOptions(
    CustomizationGroup group,
    List<dynamic>? options,
  ) {
    if (options == null) return [];
    return options.map((opt) {
      final selected = _selections[group.key]?.contains(opt.key) ?? false;
      if (group.selectionType == CustomizationSelectionType.singleSelect ||
          group.selectionType == CustomizationSelectionType.boolean) {
        return RadioListTile<String>(
          title: Text(opt.name as String),
          value: opt.key as String,
          groupValue: _selections[group.key]?.isNotEmpty == true
              ? _selections[group.key]!.first
              : null,
          onChanged: (value) {
            setState(() => _selections[group.key] = [value!]);
          },
        );
      }
      return CheckboxListTile(
        title: Text(opt.name as String),
        value: selected,
        onChanged: (value) {
          setState(() {
            final list = List<String>.from(_selections[group.key] ?? []);
            if (value == true) {
              list.add(opt.key as String);
            } else {
              list.remove(opt.key);
            }
            _selections[group.key] = list;
          });
        },
      );
    }).toList();
  }

  Map<String, dynamic> _buildSelectionsJson() {
    return buildSelectionsJson(
      groups: _selections,
      note: _noteController.text,
    );
  }
}
