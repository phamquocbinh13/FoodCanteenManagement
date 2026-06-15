/// Normalizes scanned or pasted values into a raw session bearer token.
abstract final class SessionTokenParser {
  /// QR and manual entry may provide the raw token or a join path fragment.
  static String normalize(String input) {
    var value = input.trim();
    if (value.isEmpty) return value;

    if (value.contains('/join/')) {
      value = value.split('/join/').last;
    }

    if (value.contains('?')) {
      value = value.split('?').first;
    }

    if (value.contains('#')) {
      value = value.split('#').first;
    }

    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }
}
