import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_snooze.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmService extends Mock implements AlarmService {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmService mockAlarmService;
  late HandleSnooze handleSnooze;

  setUpAll(() {
    // Register fallback values for mocktail's any() matchers
    registerFallbackValue(
      Reminder(
        id: '',
        profileId: '',
        type: '',
        title: '',
        status: ReminderStatus.scheduled,
        scheduledTime: 0,
        policy: const EscalationPolicy(),
        createdAt: 0,
        updatedAt: 0,
      ),
    );
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmService = MockAlarmService();
    handleSnooze = HandleSnooze(
      repository: mockRepository,
      alarmService: mockAlarmService,
    );
  });

  /// Creates a test [Reminder] with configurable snooze state and policy.
  Reminder createTestReminder({
    String id = 'test-reminder-1',
    int snoozeCount = 0,
    int maxSnoozes = 3,
    int snoozeBaseDelayMinutes = 5,
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
      policy: EscalationPolicy(
        maxSnoozes: maxSnoozes,
        snoozeBaseDelayMinutes: snoozeBaseDelayMinutes,
      ),
      snoozeCount: snoozeCount,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions needed for a successful snooze.
  void stubSnoozeSuccess(Reminder reminder) {
    when(() => mockRepository.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockAlarmService.stopAlarm(any())).thenAnswer((_) async => true);
    when(() => mockRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockAlarmService.setAlarm(
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

  group('HandleSnooze', () {
    test('increments snoozeCount by 1 on first snooze', () async {
      final reminder = createTestReminder(snoozeCount: 0);
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      expect(result.snoozeCount, equals(1));
      expect(result.status, equals(ReminderStatus.snoozed));
    });

    test('increments snoozeCount from 1 to 2 on second snooze', () async {
      final reminder = createTestReminder(snoozeCount: 1);
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      expect(result.snoozeCount, equals(2));
      expect(result.status, equals(ReminderStatus.snoozed));
    });

    test('calculates correct delay: base * (newSnoozeCount + 1)', () async {
      // snoozeCount=1 → newSnoozeCount=2 → delay = 5 * (2+1) = 15 min
      final now = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder(
        snoozeCount: 1,
        snoozeBaseDelayMinutes: 5,
      );
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      const expectedDelayMs = 15 * 60 * 1000; // 15 minutes in milliseconds
      expect(result.scheduledTime, greaterThan(now));
      // Allow 2-second tolerance for test execution time
      expect(
        result.scheduledTime,
        closeTo(now + expectedDelayMs, 2000),
      );
    });

    test('first snooze delay: base * 2', () async {
      // snoozeCount=0 → newSnoozeCount=1 → delay = 5 * (1+1) = 10 min
      final now = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder(
        snoozeCount: 0,
        snoozeBaseDelayMinutes: 5,
      );
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      const expectedDelayMs = 10 * 60 * 1000; // 10 minutes in milliseconds
      expect(
        result.scheduledTime,
        closeTo(now + expectedDelayMs, 2000),
      );
    });

    test('transitions to escalating when snoozeCount reaches maxSnoozes',
        () async {
      // maxSnoozes=3, snoozeCount=2 → newSnoozeCount=3 → 3 >= 3 → escalate
      final reminder = createTestReminder(
        snoozeCount: 2,
        maxSnoozes: 3,
      );
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      expect(result.snoozeCount, equals(3));
      expect(result.status, equals(ReminderStatus.escalating));
    });

    test('transitions to escalating when snoozeCount exceeds maxSnoozes',
        () async {
      // maxSnoozes=2, snoozeCount=2 → newSnoozeCount=3 → 3 >= 2 → escalate
      final reminder = createTestReminder(
        snoozeCount: 2,
        maxSnoozes: 2,
      );
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      expect(result.snoozeCount, equals(3));
      expect(result.status, equals(ReminderStatus.escalating));
    });

    test('updates updatedAt timestamp on snooze', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder(snoozeCount: 0);
      stubSnoozeSuccess(reminder);

      final result = await handleSnooze.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('stops the current alarm before rescheduling', () async {
      final reminder = createTestReminder(snoozeCount: 0);
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      verify(() => mockAlarmService.stopAlarm(reminder.id.hashCode)).called(1);
    });

    test('saves the updated reminder to repository', () async {
      final reminder = createTestReminder(snoozeCount: 0);
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.snoozeCount, equals(1));
      expect(captured.status, equals(ReminderStatus.snoozed));
    });

    test('sets new alarm with correct DateTime for snoozed reminder', () async {
      final reminder = createTestReminder(
        snoozeCount: 0,
        snoozeBaseDelayMinutes: 5,
      );
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      // Lazy notification: generic placeholder at schedule-time,
      // HandleAlarmFired builds dynamic content at fire-time
      verify(
        () => mockAlarmService.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: 'Medication Reminder',
          notificationBody: 'Preparing your reminder...',
        ),
      ).called(1);
    });

    test('does NOT set a new alarm when transitioning to escalating', () async {
      final reminder = createTestReminder(
        snoozeCount: 2,
        maxSnoozes: 3,
      );
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      verifyNever(
        () => mockAlarmService.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        ),
      );
    });

    test('throws ArgumentError for non-existent reminder', () async {
      when(() => mockRepository.getById('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => handleSnooze.call('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('logs the snooze event with correct metadata', () async {
      final reminder = createTestReminder(snoozeCount: 0);
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'snoozed',
          eventTimestamp: any(named: 'eventTimestamp'),
          metadata: 'Snooze #1, delay: 10min',
        ),
      ).called(1);
    });

    test('logs escalating event when max snoozes reached', () async {
      final reminder = createTestReminder(
        snoozeCount: 2,
        maxSnoozes: 3,
      );
      stubSnoozeSuccess(reminder);

      await handleSnooze.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'escalating',
          eventTimestamp: any(named: 'eventTimestamp'),
          metadata: 'Max snoozes reached (3/3)',
        ),
      ).called(1);
    });
  });
}
