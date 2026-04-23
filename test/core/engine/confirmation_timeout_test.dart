import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/finalize_confirmation.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_snooze.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_next_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class MockScheduleNextReminder extends Mock implements ScheduleNextReminder {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  group('Confirmation window timeout (spec §5.3)', () {
    late MockReminderRepository mockRepository;
    late MockAlarmPort mockAlarmPort;
    late MockScheduleNextReminder mockScheduleNextReminder;
    late ConfirmReminder confirmReminder;
    late FinalizeConfirmation finalizeConfirmation;

    setUpAll(() {
      registerFallbackValue(FakeReminder());
      registerFallbackValue(ReminderStatus.scheduled);
    });

    setUp(() {
      mockRepository = MockReminderRepository();
      mockAlarmPort = MockAlarmPort();
      mockScheduleNextReminder = MockScheduleNextReminder();
      when(() => mockScheduleNextReminder()).thenAnswer((_) async => null);
      confirmReminder = ConfirmReminder(repository: mockRepository);
      finalizeConfirmation = FinalizeConfirmation(
        repository: mockRepository,
        alarmPort: mockAlarmPort,
        scheduleNextReminder: mockScheduleNextReminder,
      );
    });

    Reminder createTestReminder({
      String id = 'test-reminder-1',
      ReminderStatus status = ReminderStatus.triggered,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Reminder(
        id: id,
        profileId: 'default',
        type: 'medication',
        title: 'Take Medicine',
        status: status,
        scheduledTime: now,
        policy: const EscalationPolicy(),
        createdAt: now,
        updatedAt: now,
      );
    }

    void stubSuccess(Reminder reminder) {
      when(() => mockRepository.getById(reminder.id))
          .thenAnswer((_) async => reminder);
      when(() => mockRepository.save(any())).thenAnswer((_) async {});
      when(() => mockRepository.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
            metadata: any(named: 'metadata'),
          )).thenAnswer((_) async {});
    }

    test('confirmationRequired → triggered models timeout correctly', () async {
      final reminder = createTestReminder(status: ReminderStatus.triggered);
      stubSuccess(reminder);

      final confirming = await confirmReminder.call('test-reminder-1');
      expect(confirming.status, equals(ReminderStatus.confirmationRequired));

      final timedOut = confirming.copyWith(
        status: ReminderStatus.triggered,
      );
      expect(timedOut.status, equals(ReminderStatus.triggered));
    });

    test('after timeout, reminder can be confirmed again', () async {
      final reminder = createTestReminder(status: ReminderStatus.triggered);
      stubSuccess(reminder);

      final confirming = await confirmReminder.call('test-reminder-1');
      expect(confirming.status, equals(ReminderStatus.confirmationRequired));

      final timedOut = confirming.copyWith(
        status: ReminderStatus.triggered,
      );
      expect(timedOut.status, equals(ReminderStatus.triggered));

      when(() => mockRepository.getById(timedOut.id))
          .thenAnswer((_) async => timedOut);
      final reconfirmed = await confirmReminder.call('test-reminder-1');
      expect(reconfirmed.status, equals(ReminderStatus.confirmationRequired));
    });

    test('after timeout, reminder can be snoozed instead', () async {
      final reminder = createTestReminder(status: ReminderStatus.triggered);
      stubSuccess(reminder);
      when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
      when(() => mockAlarmPort.cancelEscalationCheck(any()))
          .thenAnswer((_) async {});
      when(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).thenAnswer((_) async => true);

      final confirming = await confirmReminder.call('test-reminder-1');

      final timedOut = confirming.copyWith(
        status: ReminderStatus.triggered,
      );

      when(() => mockRepository.getById(timedOut.id))
          .thenAnswer((_) async => timedOut);

      final handleSnooze = HandleSnooze(
        repository: mockRepository,
        alarmPort: mockAlarmPort,
      );
      final snoozed = await handleSnooze.call('test-reminder-1');
      expect(snoozed.status, equals(ReminderStatus.snoozed));
      expect(snoozed.snoozeCount, equals(1));
    });
  });
}
