import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/log_missed_reminder.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmService extends Mock implements AlarmService {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmService mockAlarmService;
  late LogMissedReminder logMissedReminder;

  setUpAll(() {
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
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockAlarmService = MockAlarmService();
    logMissedReminder = LogMissedReminder(
      repository: mockRepository,
      alarmService: mockAlarmService,
    );
  });

  /// Creates a test [Reminder] in escalating state.
  Reminder createTestReminder({
    String id = 'test-reminder-1',
    ReminderStatus status = ReminderStatus.escalating,
    int escalationCount = 3,
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
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions for a successful log-missed.
  void stubLogMissedSuccess(Reminder reminder) {
    when(() => mockRepository.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockAlarmService.stopAlarm(any())).thenAnswer((_) async => true);
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

  group('LogMissedReminder', () {
    test('transitions status to missed', () async {
      final reminder = createTestReminder();
      stubLogMissedSuccess(reminder);

      final result = await logMissedReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.missed));
    });

    test('updates updatedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubLogMissedSuccess(reminder);

      final result = await logMissedReminder.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('stops the active alarm', () async {
      final reminder = createTestReminder();
      stubLogMissedSuccess(reminder);

      await logMissedReminder.call('test-reminder-1');

      verify(() => mockAlarmService.stopAlarm(reminder.id.hashCode)).called(1);
    });

    test('saves the updated reminder to repository', () async {
      final reminder = createTestReminder();
      stubLogMissedSuccess(reminder);

      await logMissedReminder.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.missed));
    });

    test('logs the missed event', () async {
      final reminder = createTestReminder();
      stubLogMissedSuccess(reminder);

      await logMissedReminder.call('test-reminder-1');

      verify(
        () => mockRepository.logEvent(
          reminderId: 'test-reminder-1',
          eventType: 'missed',
          eventTimestamp: any(named: 'eventTimestamp'),
        ),
      ).called(1);
    });

    test('throws ArgumentError for non-existent reminder', () async {
      when(() => mockRepository.getById('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => logMissedReminder.call('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('stops alarm before saving (ordering)', () async {
      final reminder = createTestReminder();
      final callOrder = <String>[];

      when(() => mockRepository.getById(reminder.id))
          .thenAnswer((_) async => reminder);
      when(() => mockAlarmService.stopAlarm(any())).thenAnswer((_) async {
        callOrder.add('stopAlarm');
        return true;
      });
      when(() => mockRepository.save(any())).thenAnswer((_) async {
        callOrder.add('save');
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

      await logMissedReminder.call('test-reminder-1');

      expect(callOrder, equals(['stopAlarm', 'save', 'logEvent']));
    });

    test('preserves escalationCount from original reminder', () async {
      final reminder = createTestReminder(escalationCount: 5);
      stubLogMissedSuccess(reminder);

      final result = await logMissedReminder.call('test-reminder-1');

      expect(result.escalationCount, equals(5));
    });
  });
}
