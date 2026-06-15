import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';

/// Customer menu catalog read model.
final class MenuCatalogView {
  const MenuCatalogView({
    required this.categories,
    required this.itemsByCategoryId,
    required this.cachedAt,
    this.menuVersion = 0,
  });

  final List<MenuCategory> categories;
  final Map<String, List<MenuItem>> itemsByCategoryId;
  final DateTime cachedAt;
  final int menuVersion;
}
