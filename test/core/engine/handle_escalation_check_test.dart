import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_escalation_check.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmPort mockAlarmPort;
  late HandleEscalationCheck handleEscalationCheck;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
    registerFallbackValue(DateTime(2024));
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    handleEscalationCheck = HandleEscalationCheck(
      repository: mockRepository,
      alarmPort: mockAlarmPort,
    );

    when(() => mockRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockRepository.logEvent(
        reminderId: any(named: 'reminderId'),
        eventType: any(named: 'eventType'),
        eventTimestamp: any(named: 'eventTimestamp'),
        metadata: any(named: 'metadata'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockAlarmPort.cancelEscalationCheck(any()))
        .thenAnswer((_) async {});
    when(
      () => mockAlarmPort.setAlarm(
        id: any(named: 'id'),
        dateTime: any(named: 'dateTime'),
        notificationTitle: any(named: 'notificationTitle'),
        notificationBody: any(named: 'notificationBody'),
      ),
    ).thenAnswer((_) async => true);
    when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
    when(
      () => mockAlarmPort.scheduleEscalationCheck(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => true);
  });

  Reminder createTestReminder({
    String id = 'test-reminder-1',
    ReminderStatus status = ReminderStatus.triggered,
    int escalationCount = 0,
    int maxEscalations = 3,
    int escalationIntervalSeconds = 600,
    int responseWindowSeconds = 300,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Reminder(
      id: id,
      profileId: 'default',
      type: 'medication',
      title: 'Morning Medications',
      status: status,
      scheduledTime: now,
      escalationCount: escalationCount,
      policy: EscalationPolicy(
        maxEscalations: maxEscalations,
        escalationIntervalSeconds: escalationIntervalSeconds,
        responseWindowSeconds: responseWindowSeconds,
      ),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('HandleEscalationCheck', () {
    group('when reminder is in triggered state', () {
      test('transitions to escalating and increments escalationCount',
          () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        final captured = verify(() => mockRepository.save(captureAny()))
            .captured
            .single as Reminder;
        expect(captured.status, equals(ReminderStatus.escalating));
        expect(captured.escalationCount, equals(1));
      });

      test('fires a Level 2 loud alarm', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(
          () => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: 'Medication Reminder',
            notificationBody: 'Preparing your reminder...',
          ),
        ).called(1);
      });

      test('schedules next escalation check after escalation interval',
          () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
          escalationIntervalSeconds: 600,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(
          () => mockAlarmPort.scheduleEscalationCheck(
            reminder.id,
            const Duration(seconds: 600),
          ),
        ).called(1);
      });

      test('logs the escalated event', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(
          () => mockRepository.logEvent(
            reminderId: reminder.id,
            eventType: 'escalated',
            eventTimestamp: any(named: 'eventTimestamp'),
            metadata: 'Escalation #1/3',
          ),
        ).called(1);
      });
    });

    group('when reminder is in escalating state', () {
      test('increments escalationCount and stays in escalating', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.escalating,
          escalationCount: 1,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        final captured = verify(() => mockRepository.save(captureAny()))
            .captured
            .single as Reminder;
        expect(captured.status, equals(ReminderStatus.escalating));
        expect(captured.escalationCount, equals(2));
      });

      test('transitions to missed when max escalations exceeded', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.escalating,
          escalationCount: 3,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        final captured = verify(() => mockRepository.save(captureAny()))
            .captured
            .single as Reminder;
        expect(captured.status, equals(ReminderStatus.missed));
        expect(captured.escalationCount, equals(4));
      });

      test('stops alarm and cancels escalation check on missed', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.escalating,
          escalationCount: 3,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(() => mockAlarmPort.stopAlarm(reminder.id.hashCode)).called(1);
        verify(() => mockAlarmPort.cancelEscalationCheck(reminder.id))
            .called(1);
      });

      test('does not schedule next escalation check when missed', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.escalating,
          escalationCount: 3,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verifyNever(
          () => mockAlarmPort.scheduleEscalationCheck(any(), any()),
        );
      });
    });

    group('when reminder is in confirmationRequired state', () {
      test('reverts to triggered then escalates', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.confirmationRequired,
          escalationCount: 0,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        final saves = verify(() => mockRepository.save(captureAny()))
            .captured
            .cast<Reminder>();

        final reverted = saves[0];
        expect(reverted.status, equals(ReminderStatus.triggered));

        final escalated = saves[1];
        expect(escalated.status, equals(ReminderStatus.escalating));
        expect(escalated.escalationCount, equals(1));
      });

      test('logs confirmation_timeout event', () async {
        final reminder = createTestReminder(
          status: ReminderStatus.confirmationRequired,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(
          () => mockRepository.logEvent(
            reminderId: reminder.id,
            eventType: 'confirmation_timeout',
            eventTimestamp: any(named: 'eventTimestamp'),
            metadata: 'Confirmation window expired, reverting to triggered',
          ),
        ).called(1);
      });
    });

    group('when reminder is in terminal/final states', () {
      for (final status in [
        ReminderStatus.scheduled,
        ReminderStatus.snoozed,
        ReminderStatus.logged,
        ReminderStatus.missed,
        ReminderStatus.cancelled,
      ]) {
        test('cancels escalation check and does nothing else for $status',
            () async {
          final reminder = createTestReminder(status: status);
          when(() => mockRepository.getById(reminder.id))
              .thenAnswer((_) async => reminder);

          await handleEscalationCheck.call(reminder.id);

          verify(() => mockAlarmPort.cancelEscalationCheck(reminder.id))
              .called(1);
          verifyNever(() => mockRepository.save(any()));
          verifyNever(() => mockAlarmPort.setAlarm(
                id: any(named: 'id'),
                dateTime: any(named: 'dateTime'),
                notificationTitle: any(named: 'notificationTitle'),
                notificationBody: any(named: 'notificationBody'),
              ));
        });
      }
    });

    group('edge cases', () {
      test('cancels escalation check when reminder not found', () async {
        when(() => mockRepository.getById('nonexistent'))
            .thenAnswer((_) async => null);

        await handleEscalationCheck.call('nonexistent');

        verify(() => mockAlarmPort.cancelEscalationCheck('nonexistent'))
            .called(1);
      });

      test('escalation count increases sequentially across multiple checks',
          () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        final captured = verify(() => mockRepository.save(captureAny()))
            .captured
            .single as Reminder;
        expect(captured.escalationCount, equals(1));
        expect(captured.status, equals(ReminderStatus.escalating));
      });

      test(
          'first escalation check from triggered transitions to escalating with count 1',
          () async {
        final reminder = createTestReminder(
          status: ReminderStatus.triggered,
          escalationCount: 0,
          maxEscalations: 3,
        );
        when(() => mockRepository.getById(reminder.id))
            .thenAnswer((_) async => reminder);

        await handleEscalationCheck.call(reminder.id);

        verify(
          () => mockRepository.logEvent(
            reminderId: reminder.id,
            eventType: 'escalated',
            eventTimestamp: any(named: 'eventTimestamp'),
            metadata: 'Escalation #1/3',
          ),
        ).called(1);
      });
    });
  });
}
