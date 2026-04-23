import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/notification_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/escalate_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_snooze.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_reminder.dart';
import 'package:smart_reminder_app/core/engine/presentation/notifiers/reminder_notifier.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';

class ManualMockNotificationService implements NotificationService {
  @override
  Function(String action, String? reminderId)? onActionPressed;

  @override
  Function(NotificationResponse)? onNotificationTap;

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<bool> init() async {
    return true;
  }

  @override
  Future<void> showCycleReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<void> showMedicationReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isCritical = false,
  }) async {}

  @override
  Future<void> showSystemNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}
}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockHandleSnooze extends Mock implements HandleSnooze {}

class MockEscalateReminder extends Mock implements EscalateReminder {}

class MockConfirmReminder extends Mock implements ConfirmReminder {}

class MockScheduleReminder extends Mock implements ScheduleReminder {}

class FakeReminder extends Fake implements Reminder {}

Reminder createTestReminder({
  String id = 'rem-1',
  ReminderStatus status = ReminderStatus.scheduled,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return Reminder(
    id: id,
    profileId: 'default',
    type: 'medication',
    title: 'Morning Meds',
    status: status,
    scheduledTime: now + 3600000,
    policy: const EscalationPolicy(),
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('ReminderNotifier', () {
    late ProviderContainer container;
    late ManualMockNotificationService mockNotificationService;
    late MockReminderRepository mockRepository;
    late MockHandleSnooze mockHandleSnooze;
    late MockEscalateReminder mockEscalateReminder;
    late MockConfirmReminder mockConfirmReminder;
    late MockScheduleReminder mockScheduleReminder;

    setUp(() {
      registerFallbackValue(FakeReminder());

      mockNotificationService = ManualMockNotificationService();
      mockRepository = MockReminderRepository();
      mockHandleSnooze = MockHandleSnooze();
      mockEscalateReminder = MockEscalateReminder();
      mockConfirmReminder = MockConfirmReminder();
      mockScheduleReminder = MockScheduleReminder();

      when(() => mockRepository.getScheduledBefore(any()))
          .thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          notificationServiceProvider
              .overrideWithValue(mockNotificationService),
          reminderRepositoryProvider.overrideWithValue(mockRepository),
          handleSnoozeProvider.overrideWithValue(mockHandleSnooze),
          escalateReminderProvider.overrideWithValue(mockEscalateReminder),
          confirmReminderProvider.overrideWithValue(mockConfirmReminder),
          scheduleReminderProvider.overrideWithValue(mockScheduleReminder),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> initializeNotifier() async {
      container.read(reminderNotifierProvider);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    test('snooze delegates to HandleSnooze use case', () async {
      await initializeNotifier();

      final reminder = createTestReminder(
        id: 'rem-snooze',
        status: ReminderStatus.triggered,
      );
      final snoozed = reminder.copyWith(
        status: ReminderStatus.snoozed,
        snoozeCount: 1,
      );

      when(() => mockHandleSnooze.call('rem-snooze'))
          .thenAnswer((_) async => snoozed);

      final notifier = container.read(reminderNotifierProvider.notifier);
      await notifier.snooze('rem-snooze');

      verify(() => mockHandleSnooze.call('rem-snooze')).called(1);
    });

    test('snooze auto-escalates when HandleSnooze returns escalating status',
        () async {
      await initializeNotifier();

      final reminder = createTestReminder(
        id: 'rem-auto-esc',
        status: ReminderStatus.triggered,
      );
      final escalated = reminder.copyWith(
        status: ReminderStatus.escalating,
        snoozeCount: 3,
      );
      final escalatedResult = escalated.copyWith(
        escalationCount: 1,
      );

      when(() => mockHandleSnooze.call('rem-auto-esc'))
          .thenAnswer((_) async => escalated);
      when(() => mockEscalateReminder.call('rem-auto-esc'))
          .thenAnswer((_) async => escalatedResult);

      final notifier = container.read(reminderNotifierProvider.notifier);
      await notifier.snooze('rem-auto-esc');

      verify(() => mockHandleSnooze.call('rem-auto-esc')).called(1);
      verify(() => mockEscalateReminder.call('rem-auto-esc')).called(1);
    });

    test('snooze does NOT auto-escalate when status is snoozed', () async {
      await initializeNotifier();

      final reminder = createTestReminder(
        id: 'rem-no-esc',
        status: ReminderStatus.triggered,
      );
      final snoozed = reminder.copyWith(
        status: ReminderStatus.snoozed,
        snoozeCount: 1,
      );

      when(() => mockHandleSnooze.call('rem-no-esc'))
          .thenAnswer((_) async => snoozed);

      final notifier = container.read(reminderNotifierProvider.notifier);
      await notifier.snooze('rem-no-esc');

      verify(() => mockHandleSnooze.call('rem-no-esc')).called(1);
      verifyNever(() => mockEscalateReminder.call(any()));
    });

    test('confirm delegates to ConfirmReminder use case', () async {
      await initializeNotifier();

      final reminder = createTestReminder(
        id: 'rem-confirm',
        status: ReminderStatus.triggered,
      );
      final confirmed = reminder.copyWith(
        status: ReminderStatus.confirmationRequired,
      );

      when(() => mockConfirmReminder.call('rem-confirm'))
          .thenAnswer((_) async => confirmed);

      final notifier = container.read(reminderNotifierProvider.notifier);
      await notifier.confirm('rem-confirm');

      verify(() => mockConfirmReminder.call('rem-confirm')).called(1);
    });

    test('schedule delegates to ScheduleReminder use case', () async {
      await initializeNotifier();

      final reminder = createTestReminder();
      final scheduled = reminder.copyWith(
        status: ReminderStatus.scheduled,
      );

      when(() => mockScheduleReminder.call(reminder))
          .thenAnswer((_) async => scheduled);

      final notifier = container.read(reminderNotifierProvider.notifier);
      await notifier.schedule(reminder);

      verify(() => mockScheduleReminder.call(reminder)).called(1);
    });

    test('notification action snooze_all routes to snooze', () async {
      await initializeNotifier();

      final snoozed = createTestReminder(
        id: 'rem-ns',
        status: ReminderStatus.snoozed,
      );
      when(() => mockHandleSnooze.call('rem-ns'))
          .thenAnswer((_) async => snoozed);

      final capturedCallback = mockNotificationService.onActionPressed;
      expect(capturedCallback, isNotNull);

      capturedCallback!('snooze_all', 'rem-ns');

      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockHandleSnooze.call('rem-ns')).called(1);
    });

    test('notification action view_take routes to confirm', () async {
      await initializeNotifier();

      final confirmed = createTestReminder(
        id: 'rem-vt',
        status: ReminderStatus.confirmationRequired,
      );
      when(() => mockConfirmReminder.call('rem-vt'))
          .thenAnswer((_) async => confirmed);

      final capturedCallback = mockNotificationService.onActionPressed;
      expect(capturedCallback, isNotNull);

      capturedCallback!('view_take', 'rem-vt');

      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockConfirmReminder.call('rem-vt')).called(1);
    });

    test('notification action with null reminderId does nothing', () async {
      await initializeNotifier();

      final capturedCallback = mockNotificationService.onActionPressed;
      expect(capturedCallback, isNotNull);

      capturedCallback!('snooze_all', null);

      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(() => mockHandleSnooze.call(any()));
      verifyNever(() => mockConfirmReminder.call(any()));
    });
  });
}
