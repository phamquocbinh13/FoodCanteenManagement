import '../entities/audit_log.dart';
import '../entities/idempotency_record.dart';
import '../entities/restaurant.dart';
import '../entities/restaurant_settings.dart';
import '../entities/role.dart';
import '../entities/staff_user.dart';
import '../entities/user_role.dart';

export '../entities/restaurant.dart';
export '../entities/restaurant_settings.dart';

/// Persistence contract for tenant and staff identity.
abstract interface class RestaurantRepository {
  Future<Restaurant?> findById(String restaurantId);

  Future<Restaurant?> findBySlug(String slug);

  Future<RestaurantSettings?> getSettings(String restaurantId);
}

/// Persistence contract for staff users and roles.
abstract interface class UserRepository {
  Future<StaffUser?> findByEmail({
    required String restaurantId,
    required String email,
  });

  Future<StaffUser?> findById(String userId);

  Future<List<Role>> getRolesForUser(String userId);

  Future<List<UserRole>> getUserRoles(String userId);
}

/// Persistence contract for append-only audit and idempotency.
abstract interface class AuditRepository {
  Future<void> append(AuditLog entry);

  Future<List<AuditLog>> listByEntity({
    required String restaurantId,
    required String entityType,
    required String entityId,
  });

  Future<IdempotencyRecord?> findIdempotencyRecord({
    required String restaurantId,
    required String idempotencyKey,
  });

  Future<IdempotencyRecord> saveIdempotencyRecord(IdempotencyRecord record);
}
