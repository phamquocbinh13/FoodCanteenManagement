import '../../core/result/result.dart';

/// Base contract for remote API data sources.
abstract interface class RemoteDataSource {
  /// Health-check hook for connectivity probes.
  Future<Result<void>> ping();
}

/// Base contract for persistent local data sources.
abstract interface class LocalDataSource {
  Future<Result<void>> init();
  Future<Result<void>> clear();
}

/// Base contract for in-memory caches and test doubles.
abstract interface class MemoryDataSource {
  Future<Result<void>> reset();
}
