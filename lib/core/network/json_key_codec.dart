/// Converts API camelCase JSON maps to Flutter freezed snake_case keys.
Map<String, dynamic> camelCaseKeysToSnake(Map<String, dynamic> input) {
  return input.map((key, value) {
    final snake = _camelToSnake(key);
    if (value is Map<String, dynamic>) {
      return MapEntry(snake, camelCaseKeysToSnake(value));
    }
    if (value is List) {
      return MapEntry(
        snake,
        value
            .map(
              (e) => e is Map<String, dynamic> ? camelCaseKeysToSnake(e) : e,
            )
            .toList(),
      );
    }
    return MapEntry(snake, value);
  });
}

String _camelToSnake(String input) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
    if (isUpper) {
      if (i > 0) buffer.write('_');
      buffer.write(char.toLowerCase());
    } else {
      buffer.write(char);
    }
  }
  return buffer.toString();
}
