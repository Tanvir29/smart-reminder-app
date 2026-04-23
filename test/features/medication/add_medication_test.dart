import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/add_medication.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/alarm_scheduler.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/reminder_generator.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderGenerator extends Mock implements ReminderGenerator {}

class MockAlarmScheduler extends Mock implements AlarmScheduler {}

// ─── Fallback values ─────────────────────────────────────────────────────────

class FakeMedication extends Fake implements Medication {}

class FakeReminder extends Fake implements Reminder {}

class FakeDoseRecord extends Fake implements DoseRecord {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockMedicationRepository mockMedicationRepository;
  late MockReminderGenerator mockReminderGenerator;
  late MockAlarmScheduler mockAlarmScheduler;
  late AddMedication addMedication;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
    registerFallbackValue(FakeReminder());
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockMedicationRepository = MockMedicationRepository();
    mockReminderGenerator = MockReminderGenerator();
    mockAlarmScheduler = MockAlarmScheduler();
    addMedication = AddMedication(
      medicationRepository: mockMedicationRepository,
      reminderGenerator: mockReminderGenerator,
      alarmScheduler: mockAlarmScheduler,
    );
  });

  /// Creates a test [Medication] with Daily frequency at 8 AM and 8 PM.
  Medication createDailyMedication({
    String id = 'med-1',
    List<int> timesOfDay = const [480, 1200], // 8:00 AM, 8:00 PM
    bool isCritical = false,
    ReminderDuration? reminderDuration,
  }) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return Medication(
      id: id,
      profileId: 'default',
      name: 'Aspirin',
      dosage: '100mg',
      frequency: MedicationFrequency.daily(timesOfDay: timesOfDay),
      instructions: 'Take with water',
      reminderDuration:
          reminderDuration ?? const ReminderDuration.fixedDays(days: 7),
      isCritical: isCritical,
      createdAt: now,
      updatedAt: now,
    );
  }

  Medication createOneTimeMedication({String id = 'med-2'}) {
    final now = DateTime.now().toUtc();
    final futureMinutes = (now.hour + 2) % 24 * 60 + now.minute;
    return Medication(
      id: id,
      profileId: 'default',
      name: 'Ibuprofen',
      dosage: '200mg',
      frequency:
          MedicationFrequency.oneTime(scheduledTimeMinutes: futureMinutes),
      createdAt: now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
    );
  }

  /// Stubs all repository/alarm interactions for a successful add.
  /// Note: getUpcomingReminders returns empty list to simulate no existing reminders.
  void stubAddSuccess({List<Reminder> upcomingReminders = const []}) {
    when(() => mockMedicationRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockReminderGenerator.generateRemindersForMedication(
        medication: any(named: 'medication'),
        profileId: any(named: 'profileId'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockReminderGenerator.getUpcomingReminders(),
    ).thenAnswer((_) async => upcomingReminders);
    when(
      () => mockAlarmScheduler.scheduleAlarm(
        reminder: any(named: 'reminder'),
        slotName: any(named: 'slotName'),
      ),
    ).thenAnswer((_) async {});
  }

  group('AddMedication', () {
    // ── The Final Gate test ──────────────────────────────────────────────
    test(
      'Daily medication with 2 time-slots creates reminders for future slots',
      () async {
        final medication = createDailyMedication();
        final now = DateTime.now().toUtc();
        final upcomingReminder = Reminder(
          id: 'reminder-1',
          profileId: 'default',
          type: 'medication',
          title: 'Morning Medications',
          body: null,
          status: ReminderStatus.scheduled,
          scheduledTime:
              now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
          groupDoseCount: 1,
          policy: const EscalationPolicy(),
          createdAt: now.millisecondsSinceEpoch,
          updatedAt: now.millisecondsSinceEpoch,
        );
        stubAddSuccess(upcomingReminders: [upcomingReminder]);

        await addMedication.call(medication);

        verify(
          () => mockReminderGenerator.generateRemindersForMedication(
            medication: any(named: 'medication'),
            profileId: any(named: 'profileId'),
          ),
        ).called(1);
      },
    );

    test('saves the medication to MedicationRepository', () async {
      final medication = createDailyMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      await addMedication.call(medication);

      final captured = verify(
        () => mockMedicationRepository.save(captureAny()),
      ).captured.single as Medication;
      expect(captured.id, equals('med-1'));
      expect(captured.name, equals('Aspirin'));
    });

    test('returns the saved medication unchanged', () async {
      final medication = createDailyMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      final result = await addMedication.call(medication);

      expect(result.id, equals(medication.id));
      expect(result.name, equals(medication.name));
      expect(result.dosage, equals(medication.dosage));
    });

    test('delegates reminder generation to ReminderGenerator', () async {
      final medication = createDailyMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      await addMedication.call(medication);

      verify(
        () => mockReminderGenerator.generateRemindersForMedication(
          medication: medication,
          profileId: 'default',
        ),
      ).called(1);
    });

    test('schedules an alarm via AlarmScheduler', () async {
      final medication = createDailyMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      await addMedication.call(medication);

      verify(
        () => mockAlarmScheduler.scheduleAlarm(
          reminder: upcomingReminder,
          slotName: any(named: 'slotName'),
        ),
      ).called(1);
    });

    test('throws when no upcoming reminders to schedule', () async {
      final medication = createDailyMedication();
      stubAddSuccess(upcomingReminders: []);

      expect(
        () => addMedication.call(medication),
        throwsA(isA<Exception>()),
      );
    });

    test('one-time medication creates one reminder at scheduled time',
        () async {
      final medication = createOneTimeMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Evening Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      await addMedication.call(medication);

      verify(
        () => mockReminderGenerator.generateRemindersForMedication(
          medication: any(named: 'medication'),
          profileId: any(named: 'profileId'),
        ),
      ).called(1);
    });

    test('one-time medication schedules alarm', () async {
      final medication = createOneTimeMedication();
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Evening Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
      stubAddSuccess(upcomingReminders: [upcomingReminder]);

      await addMedication.call(medication);

      verify(
        () => mockAlarmScheduler.scheduleAlarm(
          reminder: any(named: 'reminder'),
          slotName: any(named: 'slotName'),
        ),
      ).called(1);
    });

    test('medication is saved before reminder generation (ordering)', () async {
      final medication = createDailyMedication();
      final callOrder = <String>[];
      final now = DateTime.now().toUtc();
      final upcomingReminder = Reminder(
        id: 'reminder-1',
        profileId: 'default',
        type: 'medication',
        title: 'Morning Medications',
        body: null,
        status: ReminderStatus.scheduled,
        scheduledTime: now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      when(() => mockMedicationRepository.save(any())).thenAnswer((_) async {
        callOrder.add('saveMedication');
      });
      when(
        () => mockReminderGenerator.generateRemindersForMedication(
          medication: any(named: 'medication'),
          profileId: any(named: 'profileId'),
        ),
      ).thenAnswer((_) async {
        callOrder.add('generateReminders');
      });
      when(
        () => mockReminderGenerator.getUpcomingReminders(),
      ).thenAnswer((_) async => [upcomingReminder]);
      when(
        () => mockAlarmScheduler.scheduleAlarm(
          reminder: any(named: 'reminder'),
          slotName: any(named: 'slotName'),
        ),
      ).thenAnswer((_) async {
        callOrder.add('scheduleAlarm');
      });

      await addMedication.call(medication);

      expect(callOrder.indexOf('saveMedication'),
          lessThan(callOrder.indexOf('generateReminders')));
      expect(callOrder.last, equals('scheduleAlarm'));
    });

    group('Reminder Duration', () {
      test(
        'fixedDays duration delegates to ReminderGenerator',
        () async {
          final medication = createDailyMedication(
            reminderDuration: const ReminderDuration.fixedDays(days: 3),
          );
          final now = DateTime.now().toUtc();
          final upcomingReminder = Reminder(
            id: 'reminder-1',
            profileId: 'default',
            type: 'medication',
            title: 'Morning Medications',
            body: null,
            status: ReminderStatus.scheduled,
            scheduledTime:
                now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
            groupDoseCount: 1,
            policy: const EscalationPolicy(),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );
          stubAddSuccess(upcomingReminders: [upcomingReminder]);

          await addMedication.call(medication);

          verify(
            () => mockReminderGenerator.generateRemindersForMedication(
              medication: any(named: 'medication'),
              profileId: any(named: 'profileId'),
            ),
          ).called(1);
        },
      );
    });

    group('Time-Slot Merging', () {
      test(
        'delegates to ReminderGenerator which handles time-slot merging',
        () async {
          final now = DateTime.now().toUtc();
          final futureHour = (now.hour + 2) % 24;
          final futureMinutes = futureHour * 60 + now.minute;

          final medication = createDailyMedication(
            timesOfDay: [futureMinutes],
            reminderDuration: const ReminderDuration.fixedDays(days: 1),
          );

          final existingReminder = Reminder(
            id: 'existing-reminder',
            profileId: 'default',
            type: 'medication',
            title: 'Morning Medications',
            body: null,
            status: ReminderStatus.scheduled,
            scheduledTime:
                now.add(const Duration(hours: 2)).millisecondsSinceEpoch,
            groupDoseCount: 1,
            policy: const EscalationPolicy(),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );

          stubAddSuccess(upcomingReminders: [existingReminder]);

          await addMedication.call(medication);

          verify(
            () => mockReminderGenerator.generateRemindersForMedication(
              medication: medication,
              profileId: 'default',
            ),
          ).called(1);
        },
      );
    });
  });
}
