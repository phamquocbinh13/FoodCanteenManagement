import '../../domain/entities/customization_group.dart';
import '../../domain/entities/customization_option.dart';
import '../../domain/entities/menu_item.dart';

/// Menu item detail with modifier groups for customization UI.
final class MenuItemDetailView {
  const MenuItemDetailView({
    required this.item,
    required this.groups,
    required this.optionsByGroupId,
  });

  final MenuItem item;
  final List<CustomizationGroup> groups;
  final Map<String, List<CustomizationOption>> optionsByGroupId;
}
