import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/injection.dart';
import '../../core/logger/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';

export '../../features/auth/presentation/providers/auth_provider.dart';

/// Exposes GetIt-registered [AppLogger] to Riverpod consumers.
final loggerProvider = Provider<AppLogger>((ref) => sl<AppLogger>());

/// Exposes GetIt-registered [LocalStorage] to Riverpod consumers.
final localStorageProvider = Provider<LocalStorage>((ref) => sl<LocalStorage>());

/// Exposes GetIt-registered [ApiClient] to Riverpod consumers.
final apiClientProvider = Provider<ApiClient>((ref) => sl<ApiClient>());

/// Active dine-in session state — populated in Sprint 3 (Session Engine).
final sessionProvider = StateProvider<Object?>((ref) => null);

/// Menu catalog state — populated in Sprint 5 (Menu & Batch).
final menuProvider = StateProvider<Object?>((ref) => null);

/// Kitchen queue state — populated in Sprint 6 (Kitchen).
final kitchenProvider = StateProvider<Object?>((ref) => null);

/// Request queue state — populated in Sprint 9 (Request Queue).
final requestProvider = StateProvider<Object?>((ref) => null);
