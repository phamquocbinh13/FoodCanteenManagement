import '../../core/result/result.dart';
import 'validator.dart';

/// Validates session lifecycle inputs. Rules enforced in Sprint 3.
final class SessionValidator implements Validator<SessionValidationInput> {
  const SessionValidator();

  @override
  Result<void> validate(SessionValidationInput input) {
    if (input.tableId.trim().isEmpty) {
      return validationError('Table ID is required', code: 'tableId');
    }
    if (input.restaurantId.trim().isEmpty) {
      return validationError('Restaurant ID is required', code: 'restaurantId');
    }
    return const Success(null);
  }
}

final class SessionValidationInput {
  const SessionValidationInput({
    required this.restaurantId,
    required this.tableId,
  });

  final String restaurantId;
  final String tableId;
}
