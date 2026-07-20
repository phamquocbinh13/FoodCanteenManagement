import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/restaurant_context.dart';
import '../../../../app/di/injection.dart';
import '../../../../application/kitchen/kitchen_workflow_view.dart';
import '../../../../application/usecases/kitchen/get_kitchen_workflow_use_case.dart';
import '../../../../core/result/result.dart';

/// Lazy kitchen workflow — loads when Workflow tab is first watched.
final kitchenWorkflowProvider =
    FutureProvider.autoDispose<KitchenWorkflowView>((ref) async {
  final result = await sl<GetKitchenWorkflowUseCase>()(
    GetKitchenWorkflowParams(
      restaurantId: sl<RestaurantContext>().restaurantId,
    ),
  );
  return switch (result) {
    Success(:final value) => value,
    Err(:final failure) => throw Exception(failure.message),
  };
});
