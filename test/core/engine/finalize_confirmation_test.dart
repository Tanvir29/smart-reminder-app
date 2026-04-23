import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/finalize_confirmation.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_next_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class MockScheduleNextReminder extends Mock implements ScheduleNextReminder {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmPort mockAlarmPort;
  late MockScheduleNextReminder mockScheduleNextReminder;
  late FinalizeConfirmation finalizeConfirmation;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    mockScheduleNextReminder = MockScheduleNextReminder();
    when(() => mockScheduleNextReminder()).thenAnswer((_) async => null);
    finalizeConfirmation = FinalizeConfirmation(
      repository: mockRepository,
      alarmPort: mockAlarmPort,
      scheduleNextReminder: mockScheduleNextReminder,
    );

    when(() => mockAlarmPort.cancelEscalationCheck(any()))
        .thenAnswer((_) async {});
  });

  Reminder createTestReminder({
    String id = 'test-reminder-1',
    ReminderStatus status = ReminderStatus.confirmationRequired,
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

  void stubFinalizeSuccess(Reminder reminder) {
    when(() => mockRepository.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
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

  group('FinalizeConfirmation', () {
    test('transitions confirmationRequired to logged', () async {
      final reminder =
          createTestReminder(status: ReminderStatus.confirmationRequired);
      stubFinalizeSuccess(reminder);

      final result = await finalizeConfirmation.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.logged));
    });

    test('sets completedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubFinalizeSuccess(reminder);

      final result = await finalizeConfirmation.call('test-reminder-1');

      expect(result.completedAt, isNotNull);
      expect(result.completedAt!, greaterThanOrEqualTo(beforeCall));
    });

    test('updates updatedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubFinalizeSuccess(reminder);

      final result = await finalizeConfirmation.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('stops the active alarm', () async {
      final reminder = createTestReminder();
      stubFinalizeSuccess(reminder);

      await finalizeConfirmation.call('test-reminder-1');

      verify(() => mockAlarmPort.stopAlarm(reminder.id.hashCode)).called(1);
    });

    test('saves the updated reminder to repository', () async {
      final reminder = createTestReminder();
      stubFinalizeSuccess(reminder);

      await finalizeConfirmation.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.logged));
      expect(captured.completedAt, isNotNull);
    });

    test('logs the confirmed event', () async {
      final reminder = createTestReminder();
      stubFinalizeSuccess(reminder);

      await finalizeConfirmation.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'confirmed',
          eventTimestamp: any(named: 'eventTimestamp'),
        ),
      ).called(1);
    });

    test('throws ArgumentError for non-existent reminder', () async {
      when(() => mockRepository.getById('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => finalizeConfirmation.call('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws StateError when status is triggered', () async {
      final reminder = createTestReminder(status: ReminderStatus.triggered);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is escalating', () async {
      final reminder = createTestReminder(status: ReminderStatus.escalating);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is logged', () async {
      final reminder = createTestReminder(status: ReminderStatus.logged);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is missed (terminal)', () async {
      final reminder = createTestReminder(status: ReminderStatus.missed);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is scheduled', () async {
      final reminder = createTestReminder(status: ReminderStatus.scheduled);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is snoozed', () async {
      final reminder = createTestReminder(status: ReminderStatus.snoozed);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when status is cancelled', () async {
      final reminder = createTestReminder(status: ReminderStatus.cancelled);
      stubFinalizeSuccess(reminder);

      expect(
        () => finalizeConfirmation.call('test-reminder-1'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
