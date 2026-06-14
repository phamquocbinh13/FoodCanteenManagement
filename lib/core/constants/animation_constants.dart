/// Animation duration tokens.
abstract final class AnimationConstants {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 1500);
}

/// Standard animation curves.
abstract final class AnimationCurves {
  // Use Material curves via Theme; these are semantic aliases.
  static const String standard = 'standard';
  static const String emphasized = 'emphasized';
}
