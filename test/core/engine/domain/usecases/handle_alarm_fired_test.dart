import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_alarm_fired.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';
import 'package:smart_reminder_app/core/platform/voice_service.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockNotificationService extends Mock implements NotificationService {}

class MockVoiceService extends Mock implements VoiceService {}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class FakeReminder extends Fake implements Reminder {}

class FakeDoseRecord extends Fake implements DoseRecord {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderRepository mockReminderRepo;
  late MockMedicationRepository mockMedicationRepo;
  late MockNotificationService mockNotificationService;
  late MockVoiceService mockVoiceService;
  late HandleAlarmFired handleAlarmFired;

  setUpAll(() {
    registerFallbackValue(FakeReminder());
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(ReminderStatus.scheduled);
  });

  setUp(() {
    mockReminderRepo = MockReminderRepository();
    mockMedicationRepo = MockMedicationRepository();
    mockNotificationService = MockNotificationService();
    mockVoiceService = MockVoiceService();

    handleAlarmFired = HandleAlarmFired(
      reminderRepository: mockReminderRepo,
      medicationRepository: mockMedicationRepo,
      notificationService: mockNotificationService,
      voiceService: mockVoiceService,
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

  Medication createTestMedication({
    String id = 'med-1',
    String name = 'Prozac',
    String? reminderMessage = 'Take with food',
  }) {
    return Medication(
      id: id,
      profileId: 'profile-1',
      name: name,
      dosage: '10mg',
      frequency: MedicationFrequency.daily(timesOfDay: [800]),
      reminderMessage: reminderMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  DoseRecord createTestDoseRecord({
    String id = 'dose-1',
    String medicationId = 'med-1',
    String reminderId = 'reminder-1',
    DoseStatus status = DoseStatus.pending,
    int scheduledTime = 0,
  }) {
    return DoseRecord(
      id: id,
      profileId: 'profile-1',
      medicationId: medicationId,
      reminderId: reminderId,
      status: status,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  group('HandleAlarmFired', () {
    test('does nothing when no reminders found at scheduledTime', () async {
      final alarmTime = DateTime.now();
      when(() => mockReminderRepo.getByScheduledTime(any()))
          .thenAnswer((_) async => []);

      await handleAlarmFired.call(123, alarmTime);

      verifyNever(() => mockReminderRepo.updateStatus(any(), any()));
      verifyNever(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          ));
      verifyNever(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
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
      final medication = createTestMedication(name: 'Prozac');
      final doseRecord = createTestDoseRecord(
        medicationId: medication.id,
        reminderId: reminder.id,
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => [doseRecord]);
      when(() => mockMedicationRepo.getById(medication.id))
          .thenAnswer((_) async => medication);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockReminderRepo.updateStatus(
            reminder.id,
            ReminderStatus.triggered,
          )).called(1);
      verify(() => mockNotificationService.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Time for: Prozac',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
      verify(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: 'Morning Medications',
            medicationNames: ['Prozac'],
            reminderMessages: ['Take with food'],
          )).called(1);
    });

    test('processes scheduled reminder - multiple medications (batch)',
        () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        title: 'Morning Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );
      final medication1 = createTestMedication(
        id: 'med-1',
        name: 'Prozac',
        reminderMessage: 'Take with food',
      );
      final medication2 = createTestMedication(
        id: 'med-2',
        name: 'Vitamin D',
        reminderMessage: null,
      );
      final doseRecord1 = createTestDoseRecord(
        id: 'dose-1',
        medicationId: medication1.id,
        reminderId: reminder.id,
      );
      final doseRecord2 = createTestDoseRecord(
        id: 'dose-2',
        medicationId: medication2.id,
        reminderId: reminder.id,
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => [doseRecord1, doseRecord2]);
      when(() => mockMedicationRepo.getById(medication1.id))
          .thenAnswer((_) async => medication1);
      when(() => mockMedicationRepo.getById(medication2.id))
          .thenAnswer((_) async => medication2);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationService.showMedicationReminder(
            id: 123,
            title: 'Morning Medications',
            body: 'Time for: Prozac, Vitamin D',
            payload: reminder.id,
            isCritical: false,
          )).called(1);
    });

    test('adds URGENT prefix for escalating reminders', () async {
      final scheduledTime = DateTime.now();
      final reminder = createTestReminder(
        status: ReminderStatus.escalating,
        title: 'Evening Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );
      final medication = createTestMedication(name: 'Iron');
      final doseRecord = createTestDoseRecord(
        medicationId: medication.id,
        reminderId: reminder.id,
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => [doseRecord]);
      when(() => mockMedicationRepo.getById(medication.id))
          .thenAnswer((_) async => medication);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(456, scheduledTime);

      verify(() => mockNotificationService.showMedicationReminder(
            id: 456,
            title: 'URGENT: Evening Medications',
            body: 'Time for: Iron',
            payload: reminder.id,
            isCritical: true,
          )).called(1);
    });

    test('handles missing medication gracefully', () async {
      final scheduledTime = DateTime.now().add(const Duration(hours: 1));
      final reminder = createTestReminder(
        status: ReminderStatus.scheduled,
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );
      final doseRecord = createTestDoseRecord(
        medicationId: 'nonexistent-med',
        reminderId: reminder.id,
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => [doseRecord]);
      when(() => mockMedicationRepo.getById(any()))
          .thenAnswer((_) async => null);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verify(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).called(1);
    });

    test('does not call voice service when no medications found', () async {
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => []);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(123, scheduledTime);

      verifyNever(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          ));
    });

    test('processes snoozed reminder', () async {
      final scheduledTime = DateTime.now();
      final reminder = createTestReminder(
        status: ReminderStatus.snoozed,
        title: 'Afternoon Medications',
        scheduledTime: scheduledTime.millisecondsSinceEpoch,
      );
      final medication = createTestMedication(name: 'Aspirin');
      final doseRecord = createTestDoseRecord(
        medicationId: medication.id,
        reminderId: reminder.id,
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
      when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
          .thenAnswer((_) async => [doseRecord]);
      when(() => mockMedicationRepo.getById(medication.id))
          .thenAnswer((_) async => medication);
      when(() => mockNotificationService.showMedicationReminder(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
            isCritical: any(named: 'isCritical'),
          )).thenAnswer((_) async {});
      when(() => mockVoiceService.speakMedicationAnnouncement(
            slotName: any(named: 'slotName'),
            medicationNames: any(named: 'medicationNames'),
            reminderMessages: any(named: 'reminderMessages'),
          )).thenAnswer((_) async {});

      await handleAlarmFired.call(789, scheduledTime);

      verify(() => mockReminderRepo.updateStatus(
            reminder.id,
            ReminderStatus.triggered,
          )).called(1);
    });
  });
}
