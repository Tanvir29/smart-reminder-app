import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/alarm_scheduler.dart';

class MockAlarmPort extends Mock implements AlarmPort {}

void main() {
  late MockAlarmPort mockAlarmPort;
  late AlarmScheduler alarmScheduler;

  setUp(() {
    mockAlarmPort = MockAlarmPort();
    alarmScheduler = AlarmScheduler(
      alarmPort: mockAlarmPort,
    );
  });

  group('AlarmScheduler', () {
    test('scheduleAlarm calls alarmPort.setAlarm with correct parameters',
        () async {
      final now = DateTime.now();
      final scheduledTime = now.add(const Duration(hours: 2));
      final reminder = Reminder(
        id: 'reminder-123',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      when(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).thenAnswer((_) async => true);

      await alarmScheduler.scheduleAlarm(
        reminder: reminder,
        slotName: 'Morning Medications',
      );

      verify(() => mockAlarmPort.setAlarm(
            id: reminder.id.hashCode,
            dateTime: any(named: 'dateTime'),
            notificationTitle: 'Morning Medications',
            notificationBody: 'Preparing your reminder...',
          )).called(1);
    });

    test('scheduleAlarm uses reminder id hashCode as alarm id', () async {
      final now = DateTime.now();
      final reminder = Reminder(
        id: 'my-unique-reminder-id',
        profileId: 'default',
        type: 'medication',
        title: 'Evening Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 3)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      when(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).thenAnswer((_) async => true);

      await alarmScheduler.scheduleAlarm(
        reminder: reminder,
        slotName: 'Evening Medications',
      );

      final captured = verify(
        () => mockAlarmPort.setAlarm(
          id: captureAny(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        ),
      ).captured.first as int;

      expect(captured, equals(reminder.id.hashCode));
    });

    test('scheduleAlarm converts scheduledTime to DateTime', () async {
      final now = DateTime.now();
      final scheduledTime = DateTime(now.year, now.month, now.day, 10, 30);
      final reminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      DateTime? capturedDateTime;

      when(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).thenAnswer((invocation) async {
        capturedDateTime =
            invocation.namedArguments[const Symbol('dateTime')] as DateTime?;
        return true;
      });

      await alarmScheduler.scheduleAlarm(
        reminder: reminder,
        slotName: 'Morning Medications',
      );

      expect(capturedDateTime, isNotNull);
      expect(capturedDateTime!.hour, equals(10));
      expect(capturedDateTime!.minute, equals(30));
    });
  });
}
