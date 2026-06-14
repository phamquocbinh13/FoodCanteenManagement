import '../../core/result/result.dart';
import 'validator.dart';

final class PaymentValidator implements Validator<PaymentValidationInput> {
  const PaymentValidator();

  @override
  Result<void> validate(PaymentValidationInput input) {
    if (input.sessionId.trim().isEmpty) {
      return validationError('Session ID is required', code: 'sessionId');
    }
    if (input.amountMinor < 0) {
      return validationError('Amount cannot be negative', code: 'amountMinor');
    }
    return const Success(null);
  }
}

final class PaymentValidationInput {
  const PaymentValidationInput({
    required this.sessionId,
    required this.amountMinor,
  });

  final String sessionId;
  final int amountMinor;
}
