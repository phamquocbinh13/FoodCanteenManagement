import '../../../core/result/result.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../use_case.dart';

/// Clears all items from the session cart.
final class ClearSessionCartUseCase
    implements UseCase<void, ClearSessionCartParams> {
  ClearSessionCartUseCase({required SessionCartRepository cartRepository})
      : _cartRepository = cartRepository;

  final SessionCartRepository _cartRepository;

  @override
  Future<Result<void>> call(ClearSessionCartParams params) {
    return _cartRepository.clearCart(params.sessionId);
  }
}

final class ClearSessionCartParams {
  const ClearSessionCartParams({required this.sessionId});

  final String sessionId;
}
