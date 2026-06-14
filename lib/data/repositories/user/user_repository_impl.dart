import '../../../domain/entities/role.dart';
import '../../../domain/entities/staff_user.dart';
import '../../../domain/entities/user_role.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../../datasources/user/user_datasource.dart';

/// User repository implementation shell. Sprint 2.
final class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserRemoteDataSource remote}) : _remote = remote;

  // ignore: unused_field
  final UserRemoteDataSource _remote;

  Never _notImplemented(String method) =>
      throw UnimplementedError('UserRepositoryImpl.$method');

  @override
  Future<StaffUser?> findByEmail({
    required String restaurantId,
    required String email,
  }) =>
      _notImplemented('findByEmail');

  @override
  Future<StaffUser?> findById(String userId) => _notImplemented('findById');

  @override
  Future<List<Role>> getRolesForUser(String userId) =>
      _notImplemented('getRolesForUser');

  @override
  Future<List<UserRole>> getUserRoles(String userId) =>
      _notImplemented('getUserRoles');
}
