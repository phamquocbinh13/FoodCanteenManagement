import '../../../core/result/result.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../use_case.dart';

/// Removes a line from the session cart.
final class RemoveCartItemUseCase implements UseCase<void, RemoveCartItemParams> {
  RemoveCartItemUseCase({required SessionCartRepository cartRepository})
      : _cartRepository = cartRepository;

  final SessionCartRepository _cartRepository;

  @override
  Future<Result<void>> call(RemoveCartItemParams params) {
    return _cartRepository.removeCartItem(
      sessionCartId: params.sessionCartId,
      itemId: params.cartItemId,
    );
  }
}

final class RemoveCartItemParams {
  const RemoveCartItemParams({
    required this.sessionCartId,
    required this.cartItemId,
  });

  final String sessionCartId;
  final String cartItemId;
}
