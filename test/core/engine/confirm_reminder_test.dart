import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  late MockReminderRepository mockRepository;
  late ConfirmReminder confirmReminder;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    confirmReminder = ConfirmReminder(
      repository: mockRepository,
    );
  });

  Reminder createTestReminder({
    String id = 'test-reminder-1',
    ReminderStatus status = ReminderStatus.triggered,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Reminder(
      id: id,
      profileId: 'profile-1',
      type: 'medication',
      title: 'Take Medicine',
      body: 'Time to take your vitamins',
      status: status,
      scheduledTime: now,
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  void stubConfirmSuccess(Reminder reminder) {
    when(() => mockRepository.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockRepository.logEvent(
        reminderId: any(named: 'reminderId'),
        eventType: any(named: 'eventType'),
        eventTimestamp: any(named: 'eventTimestamp'),
        metadata: any(named: 'metadata'),
      ),
    ).thenAnswer((_) async {});
  }

  group('ConfirmReminder (two-phase flow)', () {
    test('transitions triggered to confirmationRequired', () async {
      final reminder = createTestReminder(status: ReminderStatus.triggered);
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.confirmationRequired));
    });

    test('transitions escalating to confirmationRequired', () async {
      final reminder = createTestReminder(status: ReminderStatus.escalating);
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.confirmationRequired));
    });

    test('updates updatedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('saves the updated reminder to repository', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      await confirmReminder.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.confirmationRequired));
    });

    test('logs the confirmation_requested event', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      await confirmReminder.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'confirmation_requested',
          eventTimestamp: any(named: 'eventTimestamp'),
        ),
      ).called(1);
    });

    test('throws ArgumentError for non-existent reminder', () async {
      when(() => mockRepository.getById('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => confirmReminder.call('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws StateError when status is scheduled', () async {
      final reminder = createTestReminder(status: ReminderStatus.scheduled);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is snoozed', () async {
      final reminder = createTestReminder(status: ReminderStatus.snoozed);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is logged', () async {
      final reminder = createTestReminder(status: ReminderStatus.logged);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is missed (terminal)', () async {
      final reminder = createTestReminder(status: ReminderStatus.missed);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is confirmationRequired', () async {
      final reminder =
          createTestReminder(status: ReminderStatus.confirmationRequired);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is cancelled', () async {
      final reminder = createTestReminder(status: ReminderStatus.cancelled);
      stubConfirmSuccess(reminder);

      expect(
        () => confirmReminder.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
