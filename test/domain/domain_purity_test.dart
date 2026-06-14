import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain layer has no Flutter imports', () {
    final domainDir = Directory('lib/domain');
    expect(domainDir.existsSync(), isTrue);

    final violations = <String>[];
    for (final entity in domainDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('.freezed.dart') ||
          entity.path.contains('.g.dart')) {
        continue;
      }

      final content = entity.readAsStringSync();
      if (content.contains("import 'package:flutter/") ||
          content.contains('import "package:flutter/')) {
        violations.add(entity.path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Domain must remain pure Dart: ${violations.join(', ')}',
    );
  });
}
