import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/notification_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/voice_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/dose_query_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_alarm_fired.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_next_reminder.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockDoseQueryPort extends Mock implements DoseQueryPort {}

class MockNotificationPort extends Mock implements NotificationPort {}

class MockVoicePort extends Mock implements VoicePort {}

class MockAlarmPort extends Mock implements AlarmPort {}

class MockScheduleNextReminder extends Mock implements ScheduleNextReminder {}

class FakeReminder extends Fake implements Reminder {}

class FakeDoseQueryResult extends Fake implements DoseQueryResult {}

class FakeMedicationInfo extends Fake implements MedicationInfo {}

void main() {
  late MockReminderRepository mockReminderRepo;
  late MockDoseQueryPort mockDoseQueryPort;
  late MockNotificationPort mockNotificationPort;
  late MockVoicePort mockVoicePort;
  late MockAlarmPort mockAlarmPort;
  late MockScheduleNextReminder mockScheduleNextReminder;
  late HandleAlarmFired handleAlarmFired;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
    registerFallbackValue(FakeDoseQueryResult());
    registerFallbackValue(FakeMedicationInfo());
    registerFallbackValue(ReminderStatus.scheduled);
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockReminderRepo = MockReminderRepository();
    mockDoseQueryPort = MockDoseQueryPort();
    mockNotificationPort = MockNotificationPort();
    mockVoicePort = MockVoicePort();
    mockAlarmPort = MockAlarmPort();
    mockScheduleNextReminder = MockScheduleNextReminder();

    when(
      () => mockAlarmPort.scheduleEscalationCheck(any(), any()),
    ).thenAnswer((_) async => true);

    when(() => mockDoseQueryPort.getMedicationInfos(any()))
        .thenAnswer((_) async => []);

    when(() => mockScheduleNextReminder())
        .thenAnswer((_) async => null);

    handleAlarmFired = HandleAlarmFired(
      reminderRepository: mockReminderRepo,
      doseQueryPort: mockDoseQueryPort,
      notificationPort: mockNotificationPort,
      voicePort: mockVoicePort,
      alarmPort: mockAlarmPort,
      scheduleNextReminder: mockScheduleNextReminder,
    );
  });

  Reminder createTestReminder({
    String id = 'reminder-1',
    ReminderStatus status = ReminderStatus.scheduled,
    String title = 'Morning Medications',
    String? body = 'Time for your meds',
    int? scheduledTime,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Reminder(
      id: id,
      profileId: 'profile-1',
      type: 'medication',
      title: title,
      body: body,
      status: status,
      scheduledTime: scheduledTime ?? (now + 3600000),
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('HandleAlarmFired', () {
    test('does nothing when no reminders found at scheduledTime', () async {
      final alarmTime = DateTime.now();
      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => []);

      await handleAlarmFired.call(123, alarmTime);

      verifyNever(() => mockReminderRepo.updateStatus(any(), any()));
      verifyNever(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          ));
      verifyNever(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          ));
    });

    test('skips non-actionable reminder statuses', () async {
      final alarmTime = DateTime.now();
      final reminder = createTestReminder(status: ReminderStatus.logged);

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);

      await handleAlarmFired.call(123, alarmTime);

      verifyNever(() => mockReminderRepo.updateStatus(any(), any()));
    });

    test('processes scheduled reminder - single medication', () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        title: 'Morning Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async =>
              [DoseQueryResult(medicationId: 'med-1', status: 'pending')]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-1'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Prozac',
                reminderMessage: 'Take with food',
                isCritical: false,
              ));
      when(() => mockDoseQueryPort.getMedicationInfos(['med-1']))
          .thenAnswer((_) async => [
                const MedicationInfo(
                  name: 'Prozac',
                  reminderMessage: 'Take with food',
                  isCritical: false,
                ),
              ]);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockReminderRepo.updateStatus(
            reminder.id,
            ReminderStatus.triggered,
          )).called(1);
      verify(() => mockNotificationPort.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Time for: Prozac',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
      verify(() => mockVoicePort.speakAnnouncement(
            slotName: 'Morning Medications',
            itemNames: const ['Prozac'],
            customMessages: const ['Take with food'],
          )).called(1);
    });

    test('schedules escalation check after triggering', () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => []);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(
        () => mockAlarmPort.scheduleEscalationCheck(
          reminder.id,
          const Duration(seconds: 300),
        ),
      ).called(1);
    });

    test('processes scheduled reminder - multiple medications (batch)',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        title: 'Morning Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => [
                DoseQueryResult(medicationId: 'med-1', status: 'pending'),
                DoseQueryResult(medicationId: 'med-2', status: 'pending'),
              ]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-1'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Prozac',
                reminderMessage: 'Take with food',
                isCritical: false,
              ));
      when(() => mockDoseQueryPort.getMedicationInfoById('med-2'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Vitamin D',
                reminderMessage: null,
                isCritical: false,
              ));
      when(() => mockDoseQueryPort.getMedicationInfos(['med-1', 'med-2']))
          .thenAnswer((_) async => [
                const MedicationInfo(
                  name: 'Prozac',
                  reminderMessage: 'Take with food',
                  isCritical: false,
                ),
                const MedicationInfo(
                  name: 'Vitamin D',
                  reminderMessage: null,
                  isCritical: false,
                ),
              ]);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationPort.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Time for: Prozac, Vitamin D',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
    });

    test('processes escalating reminder as critical', () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.escalating,
        title: 'Morning Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async =>
              [DoseQueryResult(medicationId: 'med-1', status: 'pending')]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-1'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Iron',
                reminderMessage: null,
                isCritical: true,
              ));
      when(() => mockDoseQueryPort.getMedicationInfos(['med-1']))
          .thenAnswer((_) async => [
                const MedicationInfo(
                  name: 'Iron',
                  reminderMessage: null,
                  isCritical: true,
                ),
              ]);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationPort.showMedicationReminder(
            id: 123,
            title: 'URGENT: Morning Medications',
            body: 'Time for: Iron',
            payload: reminder.id,
            isCritical: true,
          )).called(1);
    });

    test('shows notification with fallback body when no dose records found',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => []);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationPort.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Time for your meds',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
    });

    test(
        'calls speakAnnouncement with custom reminderMessages from medications',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => [
                DoseQueryResult(medicationId: 'med-iron', status: 'pending'),
              ]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-iron'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Iron',
                reminderMessage: 'Do not take with coffee',
                isCritical: false,
              ));
      when(() => mockDoseQueryPort.getMedicationInfos(['med-iron']))
          .thenAnswer((_) async => [
                const MedicationInfo(
                  name: 'Iron',
                  reminderMessage: 'Do not take with coffee',
                  isCritical: false,
                ),
              ]);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockVoicePort.speakAnnouncement(
            slotName: 'Morning Medications',
            itemNames: const ['Iron'],
            customMessages: const ['Do not take with coffee'],
          )).called(1);
    });

    test(
        'does not call speakAnnouncement when no medications and no custom messages',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        body: null,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => []);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verifyNever(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          ));
    });

    test(
        'calls speakAnnouncement with multiple medications including null customMessages',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => [
                DoseQueryResult(medicationId: 'med-1', status: 'pending'),
                DoseQueryResult(medicationId: 'med-2', status: 'pending'),
                DoseQueryResult(medicationId: 'med-3', status: 'pending'),
              ]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-1'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Prozac',
                reminderMessage: 'Take with food',
              ));
      when(() => mockDoseQueryPort.getMedicationInfoById('med-2'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Vitamin D',
                reminderMessage: null,
              ));
      when(() => mockDoseQueryPort.getMedicationInfoById('med-3'))
          .thenAnswer((_) async => const MedicationInfo(
                name: 'Iron',
                reminderMessage: 'Do not take with dairy',
              ));
      when(() =>
              mockDoseQueryPort.getMedicationInfos(['med-1', 'med-2', 'med-3']))
          .thenAnswer((_) async => [
                const MedicationInfo(
                  name: 'Prozac',
                  reminderMessage: 'Take with food',
                ),
                const MedicationInfo(
                  name: 'Vitamin D',
                  reminderMessage: null,
                ),
                const MedicationInfo(
                  name: 'Iron',
                  reminderMessage: 'Do not take with dairy',
                ),
              ]);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockVoicePort.speakAnnouncement(
            slotName: 'Morning Medications',
            itemNames: const ['Prozac', 'Vitamin D', 'Iron'],
            customMessages: const [
              'Take with food',
              null,
              'Do not take with dairy'
            ],
          )).called(1);
    });

    test(
        'notification still shows when voice port is present but medications have no names',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        body: 'Your scheduled reminder',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => [reminder]);
      when(() => mockReminderRepo.updateStatus(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockReminderRepo.logEvent(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
          )).thenAnswer((_) async {});
      when(() => mockDoseQueryPort.getDoseRecordsForReminder(reminder.id))
          .thenAnswer((_) async => [
                DoseQueryResult(medicationId: 'med-deleted', status: 'pending'),
              ]);
      when(() => mockDoseQueryPort.getMedicationInfoById('med-deleted'))
          .thenAnswer((_) async => null);
      when(() => mockDoseQueryPort.getMedicationInfos(['med-deleted']))
          .thenAnswer((_) async => []);
      when(() => mockNotificationPort.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationPort.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Your scheduled reminder',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
      verifyNever(() => mockVoicePort.speakAnnouncement(
            slotName: any(named: 'slotName'),
            itemNames: any(named: 'itemNames'),
            customMessages: any(named: 'customMessages'),
          ));
    });
  });
}
