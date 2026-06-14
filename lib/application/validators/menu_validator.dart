import '../../core/result/result.dart';
import 'validator.dart';

final class MenuValidator implements Validator<MenuValidationInput> {
  const MenuValidator();

  @override
  Result<void> validate(MenuValidationInput input) {
    if (input.menuItemId.trim().isEmpty) {
      return validationError('Menu item ID is required', code: 'menuItemId');
    }
    return const Success(null);
  }
}

final class MenuValidationInput {
  const MenuValidationInput({required this.menuItemId});

  final String menuItemId;
}
