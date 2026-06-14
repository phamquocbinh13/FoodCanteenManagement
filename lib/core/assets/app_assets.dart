/// Strongly typed asset path references.
///
/// Never use raw string paths in widgets — always reference via [AppAssets].
abstract final class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.png';

  // Icons
  static const String iconMenu = 'assets/icons/menu.svg';
  static const String iconKitchen = 'assets/icons/kitchen.svg';
  static const String iconDelivery = 'assets/icons/delivery.svg';

  // Lottie animations
  static const String animationLoading = 'assets/animations/loading.json';
  static const String animationEmpty = 'assets/animations/empty.json';
  static const String animationSuccess = 'assets/animations/success.json';

  // Fonts (registered in pubspec when added)
  static const String fontPrimary = 'Roboto';
}

/// Asset category helpers for type-safe grouping.
abstract final class AppImageAssets {
  static const List<String> all = [
    AppAssets.logo,
    AppAssets.placeholder,
  ];
}

abstract final class AppIconAssets {
  static const List<String> all = [
    AppAssets.iconMenu,
    AppAssets.iconKitchen,
    AppAssets.iconDelivery,
  ];
}

abstract final class AppLottieAssets {
  static const List<String> all = [
    AppAssets.animationLoading,
    AppAssets.animationEmpty,
    AppAssets.animationSuccess,
  ];
}
