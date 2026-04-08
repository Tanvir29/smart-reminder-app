import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/escalate_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmPort mockAlarmPort;
  late EscalateReminder escalateReminder;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    escalateReminder = EscalateReminder(
      repository: mockRepository,
      alarmPort: mockAlarmPort,
    );
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmPort = MockAlarmService();
    escalateReminder = EscalateReminder(
      repository: mockRepository,
      alarmService: mockAlarmPort,
    );
  });

  /// Creates a test [Reminder] with configurable escalation state.
  Reminder createTestReminder({
    String id = 'test-reminder-1',
    int escalationCount = 0,
    int maxEscalations = 3,
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
      escalationCount: escalationCount,
      policy: EscalationPolicy(maxEscalations: maxEscalations),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions for a successful escalation.
  void stubEscalateSuccess(Reminder reminder) {
    when(() => mockRepository.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
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

  group('EscalateReminder', () {
    test('increments escalationCount by 1', () async {
      final reminder = createTestReminder(escalationCount: 0);
      stubEscalateSuccess(reminder);

      final result = await escalateReminder.call('test-reminder-1');

      expect(result.escalationCount, equals(1));
    });

    test('sets status to escalating when under max escalations', () async {
      final reminder =
          createTestReminder(escalationCount: 0, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      final result = await escalateReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.escalating));
    });

    test('fires Level 2 loud alarm (HandleAlarmFired adds URGENT prefix)',
        () async {
      final reminder = createTestReminder(escalationCount: 0);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      // Lazy notification: generic placeholder at schedule-time,
      // HandleAlarmFired adds "URGENT:" prefix at fire-time
      verify(
        () => mockAlarmPort.setAlarm(
          id: reminder.id.hashCode,
          dateTime: any(named: 'dateTime'),
          notificationTitle: 'Medication Reminder',
          notificationBody: 'Preparing your reminder...',
        ),
      ).called(1);
    });

    test('logs the escalated event with correct metadata', () async {
      final reminder =
          createTestReminder(escalationCount: 1, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'escalated',
          eventTimestamp: any(named: 'eventTimestamp'),
          metadata: 'Escalation #2/3',
        ),
      ).called(1);
    });

    test('transitions to missed when escalation count exceeds max', () async {
      // maxEscalations=3, escalationCount=3 → newCount=4 → 4 > 3 → missed
      final reminder =
          createTestReminder(escalationCount: 3, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      final result = await escalateReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.missed));
      expect(result.escalationCount, equals(4));
    });

    test('stops alarm when transitioning to missed', () async {
      final reminder =
          createTestReminder(escalationCount: 3, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      verify(() => mockAlarmPort.stopAlarm(reminder.id.hashCode)).called(1);
    });

    test('does NOT set a new alarm when transitioning to missed', () async {
      final reminder =
          createTestReminder(escalationCount: 3, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      verifyNever(
        () => mockAlarmPort.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        ),
      );
    });

    test('logs missed event when max escalations exhausted', () async {
      final reminder =
          createTestReminder(escalationCount: 3, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'missed',
          eventTimestamp: any(named: 'eventTimestamp'),
          metadata: 'All escalation attempts exhausted',
        ),
      ).called(1);
    });

    test('updates updatedAt timestamp on escalation', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder(escalationCount: 0);
      stubEscalateSuccess(reminder);

      final result = await escalateReminder.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('updates updatedAt timestamp when transitioning to missed', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder =
          createTestReminder(escalationCount: 3, maxEscalations: 3);
      stubEscalateSuccess(reminder);

      final result = await escalateReminder.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('throws ArgumentError for non-existent reminder', () async {
      when(() => mockRepository.getById('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => escalateReminder.call('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('saves the escalated reminder to repository', () async {
      final reminder = createTestReminder(escalationCount: 0);
      stubEscalateSuccess(reminder);

      await escalateReminder.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.escalating));
      expect(captured.escalationCount, equals(1));
    });

    test(
        'uses generic placeholder for alarm notificationBody (lazy construction)',
        () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final reminder = Reminder(
        id: 'test-null-body',
        profileId: 'profile-1',
        type: 'medication',
        title: 'Take Medicine',
        body: null,
        status: ReminderStatus.triggered,
        scheduledTime: now,
        policy: const EscalationPolicy(),
        createdAt: now,
        updatedAt: now,
      );
      stubEscalateSuccess(reminder);
      when(() => mockRepository.getById('test-null-body'))
          .thenAnswer((_) async => reminder);

      await escalateReminder.call('test-null-body');

      // Lazy notification: generic placeholder at schedule-time
      verify(
        () => mockAlarmPort.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: 'Medication Reminder',
          notificationBody: 'Preparing your reminder...',
        ),
      ).called(1);
    });
  });
}
