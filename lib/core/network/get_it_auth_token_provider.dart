import 'package:get_it/get_it.dart';

import '../../data/datasources/auth/auth_datasource.dart';
import 'interceptors/auth_interceptor.dart';

/// Lazily resolves staff access token after [AuthLocalDataSource] is registered.
final class GetItAuthTokenProvider implements AuthTokenProvider {
  GetItAuthTokenProvider(this._getIt);

  final GetIt _getIt;

  @override
  Future<String?> getAccessToken() async {
    if (!_getIt.isRegistered<AuthLocalDataSource>()) return null;
    final result = await _getIt<AuthLocalDataSource>().readSession();
    return result.valueOrNull?.accessToken;
  }
}
