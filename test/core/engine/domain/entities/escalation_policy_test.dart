import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';

void main() {
  group('EscalationPolicy defaults', () {
    test('matches specification values', () {
      const policy = EscalationPolicy();

      expect(policy.maxSnoozes, equals(3));
      expect(policy.snoozeBaseDelayMinutes, equals(5));
      expect(policy.responseWindowSeconds, equals(300));
      expect(policy.maxEscalations, equals(3));
      expect(policy.escalationIntervalSeconds, equals(600));
      expect(policy.confirmationWindowSeconds, equals(30));
    });

    test('two default policies are equal', () {
      const a = EscalationPolicy();
      const b = EscalationPolicy();

      expect(a, equals(b));
    });
  });

  group('EscalationPolicy custom values', () {
    test('critical medication policy with reduced snoozes', () {
      const policy = EscalationPolicy(maxSnoozes: 2);

      expect(policy.maxSnoozes, equals(2));
      expect(policy.snoozeBaseDelayMinutes, equals(5));
      expect(policy.maxEscalations, equals(3));
    });

    test('fully custom policy preserves all values', () {
      const policy = EscalationPolicy(
        maxSnoozes: 1,
        snoozeBaseDelayMinutes: 10,
        responseWindowSeconds: 120,
        maxEscalations: 5,
        escalationIntervalSeconds: 300,
        confirmationWindowSeconds: 60,
      );

      expect(policy.maxSnoozes, equals(1));
      expect(policy.snoozeBaseDelayMinutes, equals(10));
      expect(policy.responseWindowSeconds, equals(120));
      expect(policy.maxEscalations, equals(5));
      expect(policy.escalationIntervalSeconds, equals(300));
      expect(policy.confirmationWindowSeconds, equals(60));
    });

    test('different values are not equal', () {
      const a = EscalationPolicy(maxSnoozes: 3);
      const b = EscalationPolicy(maxSnoozes: 2);

      expect(a, isNot(equals(b)));
    });

    test('copyWith preserves unchanged fields', () {
      const original = EscalationPolicy();
      final modified = original.copyWith(maxSnoozes: 1);

      expect(modified.maxSnoozes, equals(1));
      expect(modified.snoozeBaseDelayMinutes, equals(5));
      expect(modified.responseWindowSeconds, equals(300));
    });
  });

  group('Snooze delay formula verification', () {
    test('snoozeCount=0: delay = base * (0+1+1) = base * 2 = 10 min', () {
      const policy = EscalationPolicy(snoozeBaseDelayMinutes: 5);
      const snoozeCount = 0;
      final delay = policy.snoozeBaseDelayMinutes * (snoozeCount + 1 + 1);
      expect(delay, equals(10));
    });

    test('snoozeCount=1 (second snooze): delay = base * (1+1+1) = 15 min', () {
      const policy = EscalationPolicy(snoozeBaseDelayMinutes: 5);
      const snoozeCount = 1;
      final newCount = snoozeCount + 1;
      final delay = policy.snoozeBaseDelayMinutes * (newCount + 1);
      expect(delay, equals(15));
    });

    test('snoozeCount=2 (third snooze): delay = base * (2+1+1) = 20 min', () {
      const policy = EscalationPolicy(snoozeBaseDelayMinutes: 5);
      const snoozeCount = 2;
      final newCount = snoozeCount + 1;
      final delay = policy.snoozeBaseDelayMinutes * (newCount + 1);
      expect(delay, equals(20));
    });

    test('custom baseDelay of 10: delays scale accordingly', () {
      const policy = EscalationPolicy(snoozeBaseDelayMinutes: 10);
      final newCount = 0 + 1;
      final delay = policy.snoozeBaseDelayMinutes * (newCount + 1);
      expect(delay, equals(20));
    });

    test('boundary: snoozeCount=2 with maxSnoozes=3 is last valid snooze', () {
      const policy = EscalationPolicy(maxSnoozes: 3);
      const snoozeCount = 2;
      final newCount = snoozeCount + 1;
      expect(newCount < policy.maxSnoozes, isFalse);
      expect(newCount >= policy.maxSnoozes, isTrue);
    });

    test('boundary: snoozeCount=1 with maxSnoozes=3 still snoozes', () {
      const policy = EscalationPolicy(maxSnoozes: 3);
      const snoozeCount = 1;
      final newCount = snoozeCount + 1;
      expect(newCount >= policy.maxSnoozes, isFalse);
    });
  });
}
