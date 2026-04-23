import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/reminder_generator.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class FakeMedication extends Fake implements Medication {}

class FakeReminder extends Fake implements Reminder {}

class FakeDoseRecord extends Fake implements DoseRecord {}

void main() {
  late MockMedicationRepository mockMedicationRepository;
  late MockReminderRepository mockReminderRepository;
  late ReminderGenerator reminderGenerator;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
    registerFallbackValue(FakeReminder());
    registerFallbackValue(FakeDoseRecord());
  });

  setUp(() {
    mockMedicationRepository = MockMedicationRepository();
    mockReminderRepository = MockReminderRepository();
    reminderGenerator = ReminderGenerator(
      reminderRepository: mockReminderRepository,
      medicationRepository: mockMedicationRepository,
    );
  });

  Medication createDailyMedication({
    String id = 'med-1',
    List<int> timesOfDay = const [480, 1200],
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
          reminderDuration ?? const ReminderDuration.fixedDays(days: 3),
      isCritical: isCritical,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('ReminderGenerator', () {
    test('generateRemindersForMedication saves reminders for daily frequency',
        () async {
      final medication = createDailyMedication(timesOfDay: [480]);

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      verify(() => mockReminderRepository.save(any())).called(greaterThan(0));
      verify(() => mockMedicationRepository.saveDoseRecord(any()))
          .called(greaterThan(0));
    });

    test('generateRemindersForMedication saves reminders for weekly frequency',
        () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final medication = Medication(
        id: 'med-weekly',
        profileId: 'default',
        name: 'Vitamin D',
        dosage: '1000IU',
        frequency: MedicationFrequency.weekly(
          timesOfDay: const [480],
          weekDays: const [1, 3, 5],
        ),
        reminderDuration: const ReminderDuration.fixedDays(days: 14),
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      verify(() => mockReminderRepository.save(any())).called(greaterThan(0));
    });

    test(
        'generateRemindersForMedication saves reminders for interval frequency',
        () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final medication = Medication(
        id: 'med-interval',
        profileId: 'default',
        name: 'Antibiotic',
        dosage: '500mg',
        frequency: const MedicationFrequency.interval(intervalHours: 8),
        reminderDuration: const ReminderDuration.fixedDays(days: 2),
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      verify(() => mockReminderRepository.save(any())).called(greaterThan(1));
    });

    test(
        'generateRemindersForMedication saves reminders for one-time frequency',
        () async {
      final now = DateTime.now().toUtc();
      final futureMinutes = (now.hour + 2) % 24 * 60 + now.minute;
      final medication = Medication(
        id: 'med-onetime',
        profileId: 'default',
        name: 'Ibuprofen',
        dosage: '200mg',
        frequency:
            MedicationFrequency.oneTime(scheduledTimeMinutes: futureMinutes),
        reminderDuration: const ReminderDuration.fixedDays(days: 1),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      verify(() => mockReminderRepository.save(any())).called(1);
      verify(() => mockMedicationRepository.saveDoseRecord(any())).called(1);
    });

    test('non-critical medication uses default escalation policy', () async {
      final medication = createDailyMedication(isCritical: false);

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      final captured = verify(
        () => mockReminderRepository.save(captureAny()),
      ).captured.cast<Reminder>();

      for (final reminder in captured) {
        expect(reminder.policy, equals(const EscalationPolicy()));
      }
    });

    test('critical medication uses strict escalation policy', () async {
      final medication = createDailyMedication(isCritical: true);

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      final captured = verify(
        () => mockReminderRepository.save(captureAny()),
      ).captured.cast<Reminder>();

      for (final reminder in captured) {
        expect(reminder.policy, equals(const EscalationPolicy(maxSnoozes: 2)));
      }
    });

    test('time-slot merging increments groupDoseCount when reminder exists',
        () async {
      final now = DateTime.now();
      final futureHour = (now.hour + 2) % 24;
      final futureMinutes = futureHour * 60 + now.minute;
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        futureHour,
        now.minute,
      ).millisecondsSinceEpoch;

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
        scheduledTime: scheduledTime,
        groupDoseCount: 1,
        policy: const EscalationPolicy(),
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );

      when(() => mockReminderRepository.getByScheduledTime(scheduledTime))
          .thenAnswer((_) async => [existingReminder]);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      final captured = verify(
        () => mockReminderRepository.save(captureAny()),
      ).captured.cast<Reminder>();

      final updatedReminder = captured.last;
      expect(updatedReminder.groupDoseCount, equals(2));
    });

    test('getUpcomingReminders delegates to reminder repository', () async {
      final now = DateTime.now().toUtc();
      final reminders = [
        Reminder(
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
        ),
      ];

      when(() => mockReminderRepository.getUpcoming(limit: any(named: 'limit')))
          .thenAnswer((_) async => reminders);

      final result = await reminderGenerator.getUpcomingReminders();

      expect(result.length, equals(1));
      expect(result.first.id, equals('reminder-1'));
    });

    test('fixedDays duration creates correct number of reminders', () async {
      final medication = createDailyMedication(
        timesOfDay: const [480, 1200], // 2 times per day
        reminderDuration: const ReminderDuration.fixedDays(days: 2),
      );

      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {});

      await reminderGenerator.generateRemindersForMedication(
        medication: medication,
        profileId: 'default',
      );

      final captured = verify(
        () => mockReminderRepository.save(captureAny()),
      ).captured;

      // 2 times per day * 2 days = 4 reminders (assuming all in future)
      expect(captured.length, greaterThanOrEqualTo(3));
    });
  });
}
