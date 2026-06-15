import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../menu/menu_catalog_view.dart';
import '../use_case.dart';

/// Loads customer-visible menu catalog with version-aware in-memory caching.
final class GetMenuCatalogUseCase
    implements UseCase<MenuCatalogView, GetMenuCatalogParams> {
  GetMenuCatalogUseCase({
    required MenuRepository menuRepository,
    required OrderingStore store,
    required Clock clock,
  })  : _menuRepository = menuRepository,
        _store = store,
        _clock = clock;

  final MenuRepository _menuRepository;
  final OrderingStore _store;
  final Clock _clock;

  MenuCatalogView? _cache;
  String? _cacheRestaurantId;
  int? _cacheVersion;

  @override
  Future<Result<MenuCatalogView>> call(GetMenuCatalogParams params) async {
    if (_cache != null &&
        _cacheRestaurantId == params.restaurantId &&
        _cacheVersion == _store.menuVersion) {
      return Success(_cache!);
    }

    final categories = await _menuRepository.listCategories(params.restaurantId);
    final items = await _menuRepository.listAvailableItems(params.restaurantId);

    final byCategory = <String, List<dynamic>>{};
    for (final item in items) {
      byCategory.putIfAbsent(item.categoryId, () => []).add(item);
    }

    final view = MenuCatalogView(
      categories: categories,
      itemsByCategoryId: {
        for (final entry in byCategory.entries)
          entry.key: entry.value.cast(),
      },
      cachedAt: _clock.now(),
      menuVersion: _store.menuVersion,
    );

    _cache = view;
    _cacheRestaurantId = params.restaurantId;
    _cacheVersion = _store.menuVersion;
    _store.cacheVersion = _store.menuVersion;
    _store.menuCachedAt = view.cachedAt;

    return Success(view);
  }

  void invalidateCache() {
    _cache = null;
    _cacheRestaurantId = null;
    _cacheVersion = null;
    _store.menuCachedAt = null;
    _store.cacheVersion = null;
  }
}

final class GetMenuCatalogParams {
  const GetMenuCatalogParams({required this.restaurantId});

  final String restaurantId;
}
