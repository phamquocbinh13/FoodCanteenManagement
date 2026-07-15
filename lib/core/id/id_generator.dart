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
