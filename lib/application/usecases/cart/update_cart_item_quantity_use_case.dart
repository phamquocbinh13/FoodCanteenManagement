import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/value_objects/quantity.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../use_case.dart';

/// Increases or decreases cart line quantity. Removes item when quantity reaches zero.
final class UpdateCartItemQuantityUseCase
    implements UseCase<SessionCartItem?, UpdateCartItemQuantityParams> {
  UpdateCartItemQuantityUseCase({
    required SessionCartRepository cartRepository,
    required Clock clock,
  })  : _cartRepository = cartRepository,
        _clock = clock;

  final SessionCartRepository _cartRepository;
  final Clock _clock;

  @override
  Future<Result<SessionCartItem?>> call(UpdateCartItemQuantityParams params) async {
    final found = await _cartRepository.findCartItem(
      sessionCartId: params.sessionCartId,
      itemId: params.cartItemId,
    );
    if (found is Err<SessionCartItem?>) return Err(found.failure);
    final existing = (found as Success<SessionCartItem?>).value;
    if (existing == null) {
      return const Err(NotFoundFailure('Cart item not found'));
    }

    final newQty = existing.quantity.value + params.delta;
    if (newQty <= 0) {
      await _cartRepository.removeCartItem(
        sessionCartId: params.sessionCartId,
        itemId: params.cartItemId,
      );
      return const Success(null);
    }

    final now = _clock.now();
    final updated = existing.copyWith(
      quantity: Quantity(newQty),
      updatedAt: now,
    );
    return _cartRepository.saveCartItem(updated);
  }
}

final class UpdateCartItemQuantityParams {
  const UpdateCartItemQuantityParams({
    required this.sessionCartId,
    required this.cartItemId,
    required this.delta,
  });

  final String sessionCartId;
  final String cartItemId;
  final int delta;
}
