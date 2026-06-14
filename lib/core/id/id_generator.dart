import 'package:uuid/uuid.dart';

/// Generates unique identifiers without scattering UUID logic.
abstract interface class IdGenerator {
  String nextId();
}

/// UUID v4 generator backed by the `uuid` package.
final class UuidGenerator implements IdGenerator {
  UuidGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  String nextId() => _uuid.v4();
}

/// Deterministic ID generator for tests.
final class FakeIdGenerator implements IdGenerator {
  FakeIdGenerator({this.prefix = 'test-id'});

  final String prefix;
  int _counter = 0;

  @override
  String nextId() => '$prefix-${_counter++}';

  void reset([int value = 0]) => _counter = value;
}
