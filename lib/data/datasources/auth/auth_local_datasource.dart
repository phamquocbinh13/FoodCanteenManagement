import 'dart:convert';

import '../../../application/auth/auth_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/entities/auth_session.dart';
import 'auth_datasource.dart';

/// Persists auth session via [LocalStorage] abstraction.
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;

  @override
  Future<Result<void>> saveSession(AuthSession session) async {
    try {
      final json = jsonEncode(session.toJson());
      await _storage.setString(AuthStorageKeys.sessionJson, json);
      await _storage.setString(AuthStorageKeys.accessToken, session.accessToken);
      await _storage.setString(
        AuthStorageKeys.refreshToken,
        session.refreshToken,
      );
      await _storage.setString(AuthStorageKeys.userId, session.user.id);
      await _storage.setString(
        AuthStorageKeys.role,
        session.user.role.name,
      );
      await _storage.setString(
        AuthStorageKeys.expiresAt,
        session.expiresAt.toIso8601String(),
      );
      return const Success(null);
    } catch (error) {
      return Err(
        StorageFailure('Failed to save session', code: AuthErrorCodes.unknown),
      );
    }
  }

  @override
  Future<Result<AuthSession?>> readSession() async {
    try {
      final json = await _storage.getString(AuthStorageKeys.sessionJson);
      if (json == null || json.isEmpty) return const Success(null);
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Success(AuthSession.fromJson(map));
    } catch (error) {
      return Err(
        StorageFailure('Failed to read session', code: AuthErrorCodes.unknown),
      );
    }
  }

  @override
  Future<Result<void>> clearSession() async {
    try {
      await _storage.remove(AuthStorageKeys.sessionJson);
      await _storage.remove(AuthStorageKeys.accessToken);
      await _storage.remove(AuthStorageKeys.refreshToken);
      await _storage.remove(AuthStorageKeys.userId);
      await _storage.remove(AuthStorageKeys.role);
      await _storage.remove(AuthStorageKeys.expiresAt);
      return const Success(null);
    } catch (error) {
      return Err(
        StorageFailure('Failed to clear session', code: AuthErrorCodes.unknown),
      );
    }
  }

  @override
  Future<Result<bool>> hasValidSession({required DateTime now}) async {
    final sessionResult = await readSession();
    if (sessionResult is Err<AuthSession?>) {
      return Err(sessionResult.failure);
    }

    final session = sessionResult.valueOrNull;
    if (session == null) return const Success(false);
    if (!session.user.active) return const Success(false);
    if (now.isAfter(session.expiresAt)) return const Success(false);
    return const Success(true);
  }
}
