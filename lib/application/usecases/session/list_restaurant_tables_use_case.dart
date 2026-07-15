import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/repositories/table_repository.dart';
import '../use_case.dart';

/// Lists active floor tables for a restaurant.
final class ListRestaurantTablesUseCase
    implements UseCase<List<RestaurantTable>, ListRestaurantTablesParams> {
  ListRestaurantTablesUseCase({required TableRepository repository})
      : _repository = repository;

  final TableRepository _repository;

  @override
  Future<Result<List<RestaurantTable>>> call(
    ListRestaurantTablesParams params,
  ) async {
    try {
      final tables = await _repository.listByRestaurant(params.restaurantId);
      return Success(tables);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class ListRestaurantTablesParams {
  const ListRestaurantTablesParams({required this.restaurantId});

  final String restaurantId;
}
