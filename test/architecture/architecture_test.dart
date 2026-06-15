import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/policies/session_policy.dart';
import 'package:food_canteen_management/application/validators/user_validator.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Result', () {
    test('guard wraps success', () async {
      final result = await Result.guard(() async => 42);
      expect(result, isA<Success<int>>());
      expect(result.valueOrNull, 42);
    });

    test('guard wraps thrown errors as Err', () async {
      final result = await Result.guard(() async {
        throw Exception('boom');
      });
      expect(result, isA<Err<int>>());
    });
  });

  group('FakeClock', () {
    test('advances deterministically', () {
      final clock = createFakeClock();
      clock.advance(const Duration(hours: 1));
      expect(clock.now().hour, 13);
    });
  });

  group('FakeIdGenerator', () {
    test('produces sequential ids', () {
      final ids = createFakeIdGenerator();
      expect(ids.nextId(), 'test-0');
      expect(ids.nextId(), 'test-1');
    });
  });

  group('SessionPolicy', () {
    test('rejects closed session', () {
      const policy = SessionPolicy();
      final result = policy.evaluate(
        const SessionPolicyContext(status: SessionStatus.closed),
      );
      expect(result, isA<Err<bool>>());
    });
  });

  group('UserValidator', () {
    test('rejects short password', () {
      const validator = UserValidator();
      final result = validator.validate(
        const UserValidationInput(username: 'a@b.com', password: '123'),
      );
      expect(result, isA<Err<void>>());
    });
  });
}
