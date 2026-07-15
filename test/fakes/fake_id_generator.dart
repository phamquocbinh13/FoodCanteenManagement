import 'package:food_canteen_management/core/id/id_generator.dart';

/// Deterministic ID generator for tests.
final class FakeIdGenerator implements IdGenerator {
  FakeIdGenerator({this.prefix = 'test-id'});

  final String prefix;
  int _counter = 0;

  @override
  String nextId() => '$prefix-${_counter++}';

  void reset([int value = 0]) => _counter = value;
}
