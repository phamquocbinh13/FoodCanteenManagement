import '../../core/id/id_generator.dart';

/// Generates opaque session bearer tokens for customer join.
abstract final class SessionTokenGenerator {
  static String generateSecureToken(IdGenerator idGenerator) {
    final part1 = idGenerator.nextId().replaceAll('-', '');
    final part2 = idGenerator.nextId().replaceAll('-', '');
    return 'sess_${part1}_$part2';
  }
}
