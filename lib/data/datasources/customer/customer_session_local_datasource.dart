import '../../../application/session/customer_storage_keys.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../core/storage/local_storage.dart';

/// Persists customer session token and device id for reconnect.
abstract interface class CustomerSessionLocalDataSource {
  Future<Result<String?>> readSessionToken();

  Future<Result<void>> saveSessionToken(String token);

  Future<Result<void>> clearSession();

  Future<Result<String>> getOrCreateDeviceId(IdGenerator idGenerator);
}

final class CustomerSessionLocalDataSourceImpl
    implements CustomerSessionLocalDataSource {
  CustomerSessionLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  Future<Result<String?>> readSessionToken() async {
    try {
      final token = await _storage.getString(CustomerStorageKeys.sessionToken);
      if (token == null || token.isEmpty) return const Success(null);
      return Success(token);
    } catch (error) {
      return Err(StorageFailure('Failed to read customer session'));
    }
  }

  @override
  Future<Result<void>> saveSessionToken(String token) async {
    try {
      await _storage.setString(CustomerStorageKeys.sessionToken, token);
      return const Success(null);
    } catch (error) {
      return Err(StorageFailure('Failed to save customer session'));
    }
  }

  @override
  Future<Result<void>> clearSession() async {
    try {
      await _storage.remove(CustomerStorageKeys.sessionToken);
      return const Success(null);
    } catch (error) {
      return Err(StorageFailure('Failed to clear customer session'));
    }
  }

  @override
  Future<Result<String>> getOrCreateDeviceId(IdGenerator idGenerator) async {
    try {
      final existing = await _storage.getString(CustomerStorageKeys.deviceId);
      if (existing != null && existing.isNotEmpty) {
        return Success(existing);
      }

      final deviceId = idGenerator.nextId();
      await _storage.setString(CustomerStorageKeys.deviceId, deviceId);
      return Success(deviceId);
    } catch (error) {
      return Err(StorageFailure('Failed to resolve device id'));
    }
  }
}

/// In-memory customer session store for unit tests.
final class InMemoryCustomerSessionLocalDataSource
    implements CustomerSessionLocalDataSource {
  String? _token;
  String? _deviceId;

  @override
  Future<Result<void>> clearSession() async {
    _token = null;
    return const Success(null);
  }

  @override
  Future<Result<String>> getOrCreateDeviceId(IdGenerator idGenerator) async {
    _deviceId ??= idGenerator.nextId();
    return Success(_deviceId!);
  }

  @override
  Future<Result<String?>> readSessionToken() async => Success(_token);

  @override
  Future<Result<void>> saveSessionToken(String token) async {
    _token = token;
    return const Success(null);
  }
}
