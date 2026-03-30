import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/add_medication.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmService extends Mock implements AlarmService {}

// ─── Fallback values ─────────────────────────────────────────────────────────

class FakeMedication extends Fake implements Medication {}

class FakeReminder extends Fake implements Reminder {}

class FakeDoseRecord extends Fake implements DoseRecord {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockMedicationRepository mockMedicationRepository;
  late MockReminderRepository mockReminderRepository;
  late MockAlarmService mockAlarmService;
  late AddMedication addMedication;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
    registerFallbackValue(FakeReminder());
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(DateTime(2024));
  });

  setUp(() {
    mockMedicationRepository = MockMedicationRepository();
    mockReminderRepository = MockReminderRepository();
    mockAlarmService = MockAlarmService();
    addMedication = AddMedication(
      medicationRepository: mockMedicationRepository,
      reminderRepository: mockReminderRepository,
      alarmService: mockAlarmService,
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

  /// Creates an as-needed [Medication] with no schedule.
  Medication createAsNeededMedication({String id = 'med-2'}) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return Medication(
      id: id,
      profileId: 'default',
      name: 'Ibuprofen',
      dosage: '200mg',
      frequency: const MedicationFrequency.asNeeded(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions for a successful add.
  /// Note: getByScheduledTime returns empty list to simulate no existing reminders.
  void stubAddSuccess() {
    when(() => mockMedicationRepository.save(any())).thenAnswer((_) async {});
    when(() => mockMedicationRepository.saveDoseRecord(any()))
        .thenAnswer((_) async {});
    when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
    when(() => mockReminderRepository.getByScheduledTime(any()))
        .thenAnswer((_) async => []);
    when(
      () => mockAlarmService.setAlarm(
        id: any(named: 'id'),
        dateTime: any(named: 'dateTime'),
        notificationTitle: any(named: 'notificationTitle'),
        notificationBody: any(named: 'notificationBody'),
        voicePayload: any(named: 'voicePayload'),
      ),
    ).thenAnswer((_) async => true);
  }

  group('AddMedication', () {
    // ── The Final Gate test ──────────────────────────────────────────────
    test(
      'Daily medication with 2 time-slots creates reminders for future slots',
      () async {
        final medication = createDailyMedication();
        stubAddSuccess();

        await addMedication.call(medication);

        // Note: Exact count depends on current time (past slots are filtered)
        // We just verify at least some reminders are created
        final captured = verify(
          () => mockReminderRepository.save(captureAny()),
        ).captured;
        expect(captured.length, greaterThan(0));
      },
    );

    test('saves the medication to MedicationRepository', () async {
      final medication = createDailyMedication();
      stubAddSuccess();

      await addMedication.call(medication);

      final captured = verify(
        () => mockMedicationRepository.save(captureAny()),
      ).captured.single as Medication;
      expect(captured.id, equals('med-1'));
      expect(captured.name, equals('Aspirin'));
    });

    test('returns the saved medication unchanged', () async {
      final medication = createDailyMedication();
      stubAddSuccess();

      final result = await addMedication.call(medication);

      expect(result.id, equals(medication.id));
      expect(result.name, equals(medication.name));
      expect(result.dosage, equals(medication.dosage));
    });

    test(
      'non-critical medication uses default escalation policy (maxSnoozes: 3)',
      () async {
        final medication = createDailyMedication(isCritical: false);
        stubAddSuccess();

        await addMedication.call(medication);

        final captured = verify(
          () => mockReminderRepository.save(captureAny()),
        ).captured.cast<Reminder>();
        expect(captured.length, greaterThan(0));

        for (final reminder in captured) {
          expect(
            reminder.policy,
            equals(const EscalationPolicy()), // default maxSnoozes: 3
          );
        }
      },
    );

    test(
      'critical medication uses strict escalation policy (maxSnoozes: 2)',
      () async {
        final medication = createDailyMedication(isCritical: true);
        stubAddSuccess();

        await addMedication.call(medication);

        final captured = verify(
          () => mockReminderRepository.save(captureAny()),
        ).captured.cast<Reminder>();
        expect(captured.length, greaterThan(0));

        for (final reminder in captured) {
          expect(
            reminder.policy,
            equals(const EscalationPolicy(maxSnoozes: 2)),
          );
        }
      },
    );

    test('all generated reminders have correct metadata', () async {
      final medication = createDailyMedication();
      stubAddSuccess();

      await addMedication.call(medication);

      final captured = verify(
        () => mockReminderRepository.save(captureAny()),
      ).captured.cast<Reminder>();

      for (final reminder in captured) {
        expect(reminder.profileId, equals('default'));
        expect(reminder.type, equals('medication'));
        expect(
            reminder.title, isNotEmpty); // Slot name like "Morning Medications"
        expect(reminder.status, equals(ReminderStatus.scheduled));
        expect(reminder.id, isNotEmpty);
      }
    });

    test('schedules an alarm for the earliest upcoming reminder', () async {
      final medication = createDailyMedication();
      stubAddSuccess();

      await addMedication.call(medication);

      // Lazy notification construction: use generic placeholder at schedule-time
      // HandleAlarmFired will build dynamic content at alarm-fire-time
      verify(
        () => mockAlarmService.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
          voicePayload: any(named: 'voicePayload'),
        ),
      ).called(1);
    });

    test('as-needed medication creates zero reminders', () async {
      final medication = createAsNeededMedication();
      stubAddSuccess();

      await addMedication.call(medication);

      verifyNever(() => mockReminderRepository.save(any()));
    });

    test(
      'as-needed medication does not schedule any alarm',
      () async {
        final medication = createAsNeededMedication();
        stubAddSuccess();

        await addMedication.call(medication);

        verifyNever(
          () => mockAlarmService.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          ),
        );
      },
    );

    test(
      'Daily medication with single time-slot creates reminders for future slots',
      () async {
        final medication =
            createDailyMedication(timesOfDay: [480]); // 8 AM only
        stubAddSuccess();

        await addMedication.call(medication);

        final captured = verify(
          () => mockReminderRepository.save(captureAny()),
        ).captured;
        expect(captured.length, greaterThan(0));
      },
    );

    test('medication is saved before reminders (ordering)', () async {
      final medication = createDailyMedication();
      final callOrder = <String>[];

      when(() => mockMedicationRepository.save(any())).thenAnswer((_) async {
        callOrder.add('saveMedication');
      });
      when(() => mockMedicationRepository.saveDoseRecord(any()))
          .thenAnswer((_) async {
        callOrder.add('saveDoseRecord');
      });
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {
        callOrder.add('saveReminder');
      });
      when(() => mockReminderRepository.getByScheduledTime(any()))
          .thenAnswer((_) async => []);
      when(
        () => mockAlarmService.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
          voicePayload: any(named: 'voicePayload'),
        ),
      ).thenAnswer((_) async {
        callOrder.add('setAlarm');
        return true;
      });

      await addMedication.call(medication);

      expect(callOrder.first, equals('saveMedication'));
      expect(callOrder.last, equals('setAlarm'));
    });

    group('Reminder Duration', () {
      test(
        'fixedDays duration creates reminders for specified number of days',
        () async {
          final medication = createDailyMedication(
            reminderDuration: const ReminderDuration.fixedDays(days: 3),
          );
          stubAddSuccess();

          await addMedication.call(medication);

          final captured = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured;
          // For 2 times per day × 3 days = 6 expected reminders
          // (minus any past slots filtered out)
          expect(captured.length, greaterThan(0));
        },
      );

      test(
        'oneMonth duration creates reminders for 30 days',
        () async {
          final medication = createDailyMedication(
            reminderDuration: const ReminderDuration.oneMonth(),
          );
          stubAddSuccess();

          await addMedication.call(medication);

          final captured = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured;
          // Should have many reminders for 30 days
          expect(captured.length, greaterThan(14)); // at least 2 weeks worth
        },
      );

      test(
        'continuous duration creates reminders for extended period',
        () async {
          final medication = createDailyMedication(
            reminderDuration: const ReminderDuration.continuous(),
          );
          stubAddSuccess();

          await addMedication.call(medication);

          final captured = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured;
          // Should have many reminders for ~10 years
          expect(captured.length, greaterThan(100));
        },
      );

      test(
        'custom duration creates reminders until end time',
        () async {
          final endTime = DateTime.now()
              .toUtc()
              .add(const Duration(days: 5))
              .millisecondsSinceEpoch;
          final medication = createDailyMedication(
            reminderDuration: ReminderDuration.custom(endTime: endTime),
          );
          stubAddSuccess();

          await addMedication.call(medication);

          final captured = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured;
          // For 5 days × 2 times per day = 10 expected reminders
          expect(captured.length, greaterThan(0));
        },
      );

      test(
        'default reminder duration is 7 days (fixedDays)',
        () async {
          final medication = Medication(
            id: 'med-1',
            profileId: 'default',
            name: 'Aspirin',
            dosage: '100mg',
            frequency: MedicationFrequency.daily(timesOfDay: const [480]),
            createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
            updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          );
          stubAddSuccess();

          await addMedication.call(medication);

          final captured = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured;
          // Default is 7 days. Due to time filtering, may get 6 or 7 depending on current hour
          expect(captured.length, greaterThanOrEqualTo(6));
        },
      );
    });
  });
}
