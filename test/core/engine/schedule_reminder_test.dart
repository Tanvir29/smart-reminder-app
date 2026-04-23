import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmPort mockAlarmPort;
  late ScheduleReminder scheduleReminder;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    scheduleReminder = ScheduleReminder(
      repository: mockRepository,
      alarmPort: mockAlarmPort,
    );
  });

  /// Creates a test [Reminder] for scheduling.
  Reminder createTestReminder({
    String id = 'test-reminder-1',
    String? body = 'Time to take your vitamins',
    int? scheduledTime,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final schedTime = scheduledTime ?? now + 3600000; // 1 hour from now
    return Reminder(
      id: id,
      profileId: 'profile-1',
      type: 'medication',
      title: 'Take Medicine',
      body: body,
      status: ReminderStatus.scheduled,
      scheduledTime: schedTime,
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions for a successful schedule.
  void stubScheduleSuccess() {
    when(() => mockRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockAlarmPort.setAlarm(
        id: any(named: 'id'),
        dateTime: any(named: 'dateTime'),
        notificationTitle: any(named: 'notificationTitle'),
        notificationBody: any(named: 'notificationBody'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => mockRepository.logEvent(
        reminderId: any(named: 'reminderId'),
        eventType: any(named: 'eventType'),
        eventTimestamp: any(named: 'eventTimestamp'),
        metadata: any(named: 'metadata'),
      ),
    ).thenAnswer((_) async {});
  }

  group('ScheduleReminder', () {
    test('returns reminder with status set to scheduled', () async {
      final reminder = createTestReminder();
      stubScheduleSuccess();

      final result = await scheduleReminder.call(reminder);

      expect(result.status, equals(ReminderStatus.scheduled));
    });

    test('updates updatedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubScheduleSuccess();

      final result = await scheduleReminder.call(reminder);

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('saves the reminder to repository', () async {
      final reminder = createTestReminder();
      stubScheduleSuccess();

      await scheduleReminder.call(reminder);

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.scheduled));
      expect(captured.id, equals('test-reminder-1'));
    });

    test('sets alarm with correct id and dateTime', () async {
      final scheduledTime = DateTime.now().millisecondsSinceEpoch + 3600000;
      final reminder = createTestReminder(scheduledTime: scheduledTime);
      stubScheduleSuccess();

      await scheduleReminder.call(reminder);

      // Lazy notification: generic placeholder at schedule-time,
      // HandleAlarmFired builds dynamic content at fire-time
      verify(
        () => mockAlarmPort.setAlarm(
          id: reminder.id.hashCode,
          dateTime: DateTime.fromMillisecondsSinceEpoch(scheduledTime),
          notificationTitle: 'Medication Reminder',
          notificationBody: 'Preparing your reminder...',
        ),
      ).called(1);
    });

    test('passes generic placeholder for notificationBody (lazy construction)',
        () async {
      final reminder = createTestReminder(body: null);
      stubScheduleSuccess();

      await scheduleReminder.call(reminder);

      // Lazy notification: generic placeholder at schedule-time,
      // HandleAlarmFired builds dynamic content at fire-time
      verify(
        () => mockAlarmPort.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: 'Medication Reminder',
          notificationBody: 'Preparing your reminder...',
        ),
      ).called(1);
    });

    test('logs the scheduled event', () async {
      final reminder = createTestReminder();
      stubScheduleSuccess();

      await scheduleReminder.call(reminder);

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'scheduled',
          eventTimestamp: any(named: 'eventTimestamp'),
        ),
      ).called(1);
    });

    test('preserves all original reminder fields', () async {
      final reminder = createTestReminder();
      stubScheduleSuccess();

      final result = await scheduleReminder.call(reminder);

      expect(result.id, equals('test-reminder-1'));
      expect(result.profileId, equals('profile-1'));
      expect(result.type, equals('medication'));
      expect(result.title, equals('Take Medicine'));
      expect(result.body, equals('Time to take your vitamins'));
      expect(result.scheduledTime, equals(reminder.scheduledTime));
    });

    test('calls save before setAlarm (ordering)', () async {
      final reminder = createTestReminder();
      final callOrder = <String>[];

      when(() => mockRepository.save(any())).thenAnswer((_) async {
        callOrder.add('save');
      });
      when(
        () => mockAlarmPort.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        ),
      ).thenAnswer((_) async {
        callOrder.add('setAlarm');
        return true;
      });
      when(
        () => mockRepository.logEvent(
          reminderId: any(named: 'reminderId'),
          eventType: any(named: 'eventType'),
          eventTimestamp: any(named: 'eventTimestamp'),
          metadata: any(named: 'metadata'),
        ),
      ).thenAnswer((_) async {
        callOrder.add('logEvent');
      });

      await scheduleReminder.call(reminder);

      expect(callOrder, equals(['save', 'setAlarm', 'logEvent']));
    });
  });
}
