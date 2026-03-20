import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmService extends Mock implements AlarmService {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderRepository mockRepository;
  late MockAlarmService mockAlarmService;
  late ConfirmReminder confirmReminder;

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
    confirmReminder = ConfirmReminder(
      repository: mockRepository,
      alarmService: mockAlarmService,
    );
  });

  /// Creates a test [Reminder] in triggered state.
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

  /// Stubs all repository/alarm interactions for a successful confirm.
  void stubConfirmSuccess(Reminder reminder) {
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

  group('ConfirmReminder', () {
    test('transitions status to logged', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.logged));
    });

    test('sets completedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.completedAt, isNotNull);
      expect(result.completedAt!, greaterThanOrEqualTo(beforeCall));
    });

    test('updates updatedAt timestamp', () async {
      final beforeCall = DateTime.now().millisecondsSinceEpoch;
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('stops the active alarm', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      await confirmReminder.call('test-reminder-1');

      verify(() => mockAlarmService.stopAlarm(reminder.id.hashCode)).called(1);
    });

    test('saves the updated reminder to repository', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      await confirmReminder.call('test-reminder-1');

      final captured = verify(() => mockRepository.save(captureAny()))
          .captured
          .single as Reminder;
      expect(captured.status, equals(ReminderStatus.logged));
      expect(captured.completedAt, isNotNull);
    });

    test('logs the confirmed event', () async {
      final reminder = createTestReminder();
      stubConfirmSuccess(reminder);

      await confirmReminder.call('test-reminder-1');

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
        () => confirmReminder.call('nonexistent'),
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

      await confirmReminder.call('test-reminder-1');

      expect(callOrder, equals(['stopAlarm', 'save', 'logEvent']));
    });

    test('can confirm a snoozed reminder', () async {
      final reminder = createTestReminder(status: ReminderStatus.snoozed);
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.logged));
    });

    test('can confirm an escalating reminder', () async {
      final reminder = createTestReminder(status: ReminderStatus.escalating);
      stubConfirmSuccess(reminder);

      final result = await confirmReminder.call('test-reminder-1');

      expect(result.status, equals(ReminderStatus.logged));
    });
  });
}
