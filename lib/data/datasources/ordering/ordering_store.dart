import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/batch_item_customization.dart';
import '../../../domain/entities/batch_item_status_history.dart';
import '../../../domain/entities/customization_group.dart';
import '../../../domain/entities/customization_option.dart';
import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/entities/session_auth_token.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/enums/domain_enums.dart';

/// Shared in-memory store for session engine, menu, cart, and batch data.
final class OrderingStore {
  // Session engine
  final Map<String, RestaurantTable> tables = {};
  final Map<String, DineInSession> sessions = {};
  final Map<String, SessionAuthToken> tokensBySessionId = {};
  final Map<String, String> sessionIdByTokenValue = {};
  final List<SessionTimelineEvent> timeline = [];
  int dailySessionSequence = 0;
  String? lastDateKey;

  /// Call-staff request queue (session-scoped).
  final Map<String, StaffRequest> staffRequests = {};

  // Menu catalog
  final Map<String, MenuCategory> categories = {};
  final Map<String, MenuItem> menuItems = {};
  final Map<String, CustomizationGroup> customizationGroups = {};
  final Map<String, CustomizationOption> customizationOptions = {};
  DateTime? menuCachedAt;

  /// Increments when menu catalog changes; drives cache invalidation.
  int menuVersion = 0;

  /// Last version written into [GetMenuCatalogUseCase] cache.
  int? cacheVersion;

  // Session carts (temporary, cleared on batch confirm)
  final Map<String, SessionCart> cartsBySessionId = {};
  final Map<String, List<SessionCartItem>> cartItemsByCartId = {};

  // Confirmed batches (immutable kitchen work units)
  final Map<String, KitchenBatch> batches = {};
  final Map<String, List<BatchItem>> batchItemsByBatchId = {};
  final Map<String, List<BatchItemCustomization>> customizationsByBatchItemId =
      {};

  /// When all items in a batch reach completed — set once, never cleared.
  final Map<String, DateTime> batchCompletedAtById = {};

  final List<BatchItemStatusHistory> batchItemStatusHistory = [];

  List<String> batchIdsForSession(String sessionId) {
    return batches.values
        .where((b) => b.sessionId == sessionId)
        .map((b) => b.id)
        .toList();
  }

  List<String> requestIdsForSession(String sessionId) {
    return staffRequests.values
        .where((r) => r.sessionId == sessionId)
        .map((r) => r.id)
        .toList();
  }

  List<StaffRequest> pendingRequestsForRestaurant(String restaurantId) {
    return staffRequests.values
        .where(
          (r) =>
              r.restaurantId == restaurantId &&
              r.status == RequestStatus.pending,
        )
        .toList()
      ..sort((a, b) => a.requestedAt.compareTo(b.requestedAt));
  }

  List<KitchenBatch> batchesForSession(String sessionId) {
    return batches.values.where((b) => b.sessionId == sessionId).toList()
      ..sort((a, b) => a.batchNumber.compareTo(b.batchNumber));
  }

  void bumpMenuVersion() {
    menuVersion++;
    menuCachedAt = null;
    cacheVersion = null;
  }
}
