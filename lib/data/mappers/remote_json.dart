import '../../core/network/json_key_codec.dart';

/// Shared Nest → domain JSON parsing for all remote repositories.
///
/// Pattern for every feature:
/// 1. `api.send` → `Map<String, dynamic>` (camelCase)
/// 2. [parseRemoteJson] / [parseRemoteList] → freezed entity `fromJson`
abstract final class RemoteJson {
  static Map<String, dynamic> normalize(Map<String, dynamic> json) =>
      camelCaseKeysToSnake(json);

  static T parse<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      fromJson(normalize(json));

  static List<T> parseList<T>(
    Iterable<dynamic> rows,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      [
        for (final row in rows)
          parse(row as Map<String, dynamic>, fromJson),
      ];
}
