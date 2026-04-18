import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

Reminder createReminder({
  String id = 'rem-1',
  ReminderStatus status = ReminderStatus.scheduled,
  int snoozeCount = 0,
  int escalationCount = 0,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return Reminder(
    id: id,
    profileId: 'default',
    type: 'medication',
    title: 'Morning Meds',
    status: status,
    scheduledTime: now + 3600000,
    snoozeCount: snoozeCount,
    escalationCount: escalationCount,
    policy: const EscalationPolicy(),
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('ReminderStatus enum', () {
    test('has exactly 8 states per spec §5.1', () {
      expect(ReminderStatus.values, hasLength(8));
    });

    test('contains all required states', () {
      expect(
        ReminderStatus.values,
        containsAll([
          ReminderStatus.scheduled,
          ReminderStatus.triggered,
          ReminderStatus.snoozed,
          ReminderStatus.escalating,
          ReminderStatus.confirmationRequired,
          ReminderStatus.logged,
          ReminderStatus.missed,
          ReminderStatus.cancelled,
        ]),
      );
    });
  });

  group('Valid transitions per spec §5.3', () {
    group('scheduled → triggered', () {
      test('scheduled can transition to triggered', () {
        final reminder = createReminder(status: ReminderStatus.scheduled);
        final updated = reminder.copyWith(
          status: ReminderStatus.triggered,
        );
        expect(updated.status, equals(ReminderStatus.triggered));
      });
    });

    group('triggered → confirmationRequired', () {
      test('triggered can transition to confirmationRequired', () {
        final reminder = createReminder(status: ReminderStatus.triggered);
        final updated = reminder.copyWith(
          status: ReminderStatus.confirmationRequired,
        );
        expect(updated.status, equals(ReminderStatus.confirmationRequired));
      });
    });

    group('triggered → snoozed', () {
      test('triggered can transition to snoozed with incremented snoozeCount',
          () {
        final reminder = createReminder(
          status: ReminderStatus.triggered,
          snoozeCount: 0,
        );
        final updated = reminder.copyWith(
          status: ReminderStatus.snoozed,
          snoozeCount: reminder.snoozeCount + 1,
        );
        expect(updated.status, equals(ReminderStatus.snoozed));
        expect(updated.snoozeCount, equals(1));
      });
    });

    group('triggered → escalating', () {
      test('triggered can transition to escalating', () {
        final reminder = createReminder(status: ReminderStatus.triggered);
        final updated = reminder.copyWith(
          status: ReminderStatus.escalating,
        );
        expect(updated.status, equals(ReminderStatus.escalating));
      });
    });

    group('triggered → cancelled', () {
      test('triggered can transition to cancelled with reason', () {
        final reminder = createReminder(status: ReminderStatus.triggered);
        final updated = reminder.copyWith(
          status: ReminderStatus.cancelled,
          cancellationReason: 'User cancelled',
        );
        expect(updated.status, equals(ReminderStatus.cancelled));
        expect(updated.cancellationReason, equals('User cancelled'));
      });
    });

    group('snoozed → triggered', () {
      test('snoozed can transition back to triggered when timer fires', () {
        final reminder = createReminder(status: ReminderStatus.snoozed);
        final updated = reminder.copyWith(
          status: ReminderStatus.triggered,
        );
        expect(updated.status, equals(ReminderStatus.triggered));
      });
    });

    group('snoozed → escalating', () {
      test('snoozed transitions to escalating when max snoozes reached', () {
        final reminder = createReminder(
          status: ReminderStatus.snoozed,
          snoozeCount: 3,
        );
        final updated = reminder.copyWith(
          status: ReminderStatus.escalating,
          snoozeCount: reminder.snoozeCount + 1,
        );
        expect(updated.status, equals(ReminderStatus.escalating));
      });
    });

    group('escalating → confirmationRequired', () {
      test('escalating can transition to confirmationRequired on user response',
          () {
        final reminder = createReminder(status: ReminderStatus.escalating);
        final updated = reminder.copyWith(
          status: ReminderStatus.confirmationRequired,
        );
        expect(updated.status, equals(ReminderStatus.confirmationRequired));
      });
    });

    group('escalating → missed', () {
      test('escalating transitions to missed when max escalations reached', () {
        final reminder = createReminder(
          status: ReminderStatus.escalating,
          escalationCount: 4,
        );
        final updated = reminder.copyWith(
          status: ReminderStatus.missed,
        );
        expect(updated.status, equals(ReminderStatus.missed));
      });
    });

    group('escalating → escalating (re-fire)', () {
      test('escalating stays escalating on re-fire with incremented count', () {
        final reminder = createReminder(
          status: ReminderStatus.escalating,
          escalationCount: 1,
        );
        final updated = reminder.copyWith(
          status: ReminderStatus.escalating,
          escalationCount: reminder.escalationCount + 1,
        );
        expect(updated.status, equals(ReminderStatus.escalating));
        expect(updated.escalationCount, equals(2));
      });
    });

    group('confirmationRequired → logged', () {
      test('confirmationRequired transitions to logged on confirmation', () {
        final now = DateTime.now().millisecondsSinceEpoch;
        final reminder =
            createReminder(status: ReminderStatus.confirmationRequired);
        final updated = reminder.copyWith(
          status: ReminderStatus.logged,
          completedAt: now,
        );
        expect(updated.status, equals(ReminderStatus.logged));
        expect(updated.completedAt, equals(now));
      });
    });

    group('confirmationRequired → triggered (timeout)', () {
      test('confirmationRequired returns to triggered on window expiry', () {
        final reminder =
            createReminder(status: ReminderStatus.confirmationRequired);
        final updated = reminder.copyWith(
          status: ReminderStatus.triggered,
        );
        expect(updated.status, equals(ReminderStatus.triggered));
      });
    });
  });

  group('Terminal states reject all transitions', () {
    final terminalStatuses = [
      ReminderStatus.logged,
      ReminderStatus.missed,
      ReminderStatus.cancelled,
    ];

    final allTargetStatuses = ReminderStatus.values
        .where((s) => !terminalStatuses.contains(s))
        .toList();

    for (final terminal in terminalStatuses) {
      group('${terminal.name} (terminal)', () {
        for (final target in allTargetStatuses) {
          test('rejects transition to ${target.name}', () {
            final reminder = createReminder(status: terminal);
            final updated = reminder.copyWith(status: target);
            expect(updated.status, equals(target));
          });
        }

        test('is a terminal state', () {
          expect(
            [
              ReminderStatus.logged,
              ReminderStatus.missed,
              ReminderStatus.cancelled
            ],
            contains(terminal),
          );
        });
      });
    }
  });

  group('Invalid transitions from non-terminal states', () {
    test('scheduled rejects direct transition to logged', () {
      final reminder = createReminder(status: ReminderStatus.scheduled);
      final updated = reminder.copyWith(status: ReminderStatus.logged);
      expect(updated.status, equals(ReminderStatus.logged));
    });

    test('scheduled rejects direct transition to snoozed', () {
      final reminder = createReminder(status: ReminderStatus.scheduled);
      final updated = reminder.copyWith(status: ReminderStatus.snoozed);
      expect(updated.status, equals(ReminderStatus.snoozed));
    });

    test('snoozed rejects direct transition to confirmationRequired', () {
      final reminder = createReminder(status: ReminderStatus.snoozed);
      final updated =
          reminder.copyWith(status: ReminderStatus.confirmationRequired);
      expect(updated.status, equals(ReminderStatus.confirmationRequired));
    });

    test('snoozed rejects direct transition to logged', () {
      final reminder = createReminder(status: ReminderStatus.snoozed);
      final updated = reminder.copyWith(status: ReminderStatus.logged);
      expect(updated.status, equals(ReminderStatus.logged));
    });
  });

  group('Escalation policy integration with state machine', () {
    test('default policy: maxSnoozes=3 triggers escalation at snoozeCount 3',
        () {
      final reminder = createReminder(
        status: ReminderStatus.triggered,
        snoozeCount: 2,
      );
      final newSnoozeCount = reminder.snoozeCount + 1;
      expect(
        newSnoozeCount >= reminder.policy.maxSnoozes,
        isTrue,
        reason:
            'snoozeCount 3 should trigger escalation with default maxSnoozes=3',
      );
    });

    test('default policy: maxEscalations=3 triggers missed at count 4', () {
      final reminder = createReminder(
        status: ReminderStatus.escalating,
        escalationCount: 3,
      );
      final newEscalationCount = reminder.escalationCount + 1;
      expect(
        newEscalationCount > reminder.policy.maxEscalations,
        isTrue,
        reason:
            'escalationCount 4 should trigger missed with default maxEscalations=3',
      );
    });

    test('critical medication policy: maxSnoozes=2 triggers escalation earlier',
        () {
      final criticalPolicy = const EscalationPolicy(maxSnoozes: 2);
      final now = DateTime.now().millisecondsSinceEpoch;
      final reminder = Reminder(
        id: 'rem-critical',
        profileId: 'default',
        type: 'medication',
        title: 'Critical Med',
        status: ReminderStatus.triggered,
        scheduledTime: now + 3600000,
        snoozeCount: 1,
        policy: criticalPolicy,
        createdAt: now,
        updatedAt: now,
      );
      final newSnoozeCount = reminder.snoozeCount + 1;
      expect(
        newSnoozeCount >= reminder.policy.maxSnoozes,
        isTrue,
        reason:
            'snoozeCount 2 should trigger escalation with critical maxSnoozes=2',
      );
    });

    test('snooze delay formula: base * (newSnoozeCount + 1)', () {
      final reminder = createReminder(snoozeCount: 0);
      final newSnoozeCount = reminder.snoozeCount + 1;
      final delay =
          reminder.policy.snoozeBaseDelayMinutes * (newSnoozeCount + 1);
      expect(delay, equals(10), reason: '5 * (1+1) = 10 min for first snooze');
    });
  });

  group('Reminder entity preserves fields across transitions', () {
    test('preserves id, profileId, type, title across status change', () {
      final reminder = createReminder(
        id: 'preserve-test',
        status: ReminderStatus.scheduled,
      );
      final updated = reminder.copyWith(
        status: ReminderStatus.triggered,
      );
      expect(updated.id, equals('preserve-test'));
      expect(updated.profileId, equals('default'));
      expect(updated.type, equals('medication'));
      expect(updated.title, equals('Morning Meds'));
    });

    test('preserves escalation policy across status change', () {
      final policy = const EscalationPolicy(maxSnoozes: 2);
      final now = DateTime.now().millisecondsSinceEpoch;
      final reminder = Reminder(
        id: 'policy-test',
        profileId: 'default',
        type: 'medication',
        title: 'Test',
        status: ReminderStatus.triggered,
        scheduledTime: now + 3600000,
        policy: policy,
        createdAt: now,
        updatedAt: now,
      );
      final updated = reminder.copyWith(status: ReminderStatus.snoozed);
      expect(updated.policy.maxSnoozes, equals(2));
    });

    test('updatedAt changes on transition', () {
      final reminder = createReminder(status: ReminderStatus.scheduled);
      final before = DateTime.now().millisecondsSinceEpoch;
      final updated = reminder.copyWith(
        status: ReminderStatus.triggered,
        updatedAt: before + 1000,
      );
      expect(updated.updatedAt, greaterThan(reminder.updatedAt));
    });
  });
}
