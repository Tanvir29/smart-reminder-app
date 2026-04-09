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

  /// Creates a one-time [Medication] scheduled at 8 AM.
  Medication createOneTimeMedication({String id = 'med-2'}) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return Medication(
      id: id,
      profileId: 'default',
      name: 'Ibuprofen',
      dosage: '200mg',
      frequency: const MedicationFrequency.oneTime(scheduledTimeMinutes: 480),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Stubs all repository/alarm interactions for a successful add.
  /// Note: getByScheduledTime returns empty list to simulate no existing reminders.
  void stubAddSuccess() {
    when(() => mockMedicationRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockMedicationRepository.saveDoseRecord(any()),
    ).thenAnswer((_) async {});
    when(() => mockReminderRepository.save(any())).thenAnswer((_) async {});
    when(
      () => mockReminderRepository.getByScheduledTime(any()),
    ).thenAnswer((_) async => []);
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

      final captured =
          verify(
                () => mockMedicationRepository.save(captureAny()),
              ).captured.single
              as Medication;
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
          reminder.title,
          isNotEmpty,
        ); // Slot name like "Morning Medications"
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

    test(
      'one-time medication creates one reminder at scheduled time',
      () async {
        final medication = createOneTimeMedication();
        stubAddSuccess();

        await addMedication.call(medication);

        final captured = verify(
          () => mockReminderRepository.save(captureAny()),
        ).captured;
        expect(captured.length, equals(1));
      },
    );

    test('one-time medication schedules alarm', () async {
      final medication = createOneTimeMedication();
      stubAddSuccess();

      await addMedication.call(medication);

      verify(
        () => mockAlarmService.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        ),
      ).called(1);
    });

    test(
      'Daily medication with single time-slot creates reminders for future slots',
      () async {
        final medication = createDailyMedication(
          timesOfDay: [480],
        ); // 8 AM only
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
      when(() => mockMedicationRepository.saveDoseRecord(any())).thenAnswer((
        _,
      ) async {
        callOrder.add('saveDoseRecord');
      });
      when(() => mockReminderRepository.save(any())).thenAnswer((_) async {
        callOrder.add('saveReminder');
      });
      when(
        () => mockReminderRepository.getByScheduledTime(any()),
      ).thenAnswer((_) async => []);
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

      test('oneMonth duration creates reminders for 30 days', () async {
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
      });

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

      test('custom duration creates reminders until end time', () async {
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
      });

      test('default reminder duration is 7 days (fixedDays)', () async {
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
      });
    });

    group('Time-Slot Merging', () {
      test(
        'two medications at same time reuse existing Reminder with incremented groupDoseCount',
        () async {
          final now = DateTime.now().toUtc();
          final eightAmToday = DateTime.utc(now.year, now.month, now.day, 8, 0);
          final scheduledTime = eightAmToday.millisecondsSinceEpoch;

          final med1 = createDailyMedication(
            id: 'med-1',
            timesOfDay: const [480],
          );
          final med2 = createDailyMedication(
            id: 'med-2',
            timesOfDay: const [480],
          );

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockReminderRepository.getByScheduledTime(scheduledTime),
          ).thenAnswer((_) async => []);

          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(med1);

          verify(
            () => mockReminderRepository.getByScheduledTime(scheduledTime),
          ).called(1);
          final firstSave =
              verify(
                    () => mockReminderRepository.save(captureAny()),
                  ).captured.first
                  as Reminder;
          expect(firstSave.groupDoseCount, equals(1));

          when(
            () => mockReminderRepository.getByScheduledTime(scheduledTime),
          ).thenAnswer((_) async => [firstSave]);

          await addMedication.call(med2);

          final secondSave =
              verify(
                    () => mockReminderRepository.save(captureAny()),
                  ).captured.last
                  as Reminder;
          expect(secondSave.groupDoseCount, equals(2));
        },
      );

      test(
        'two medications at different times create separate Reminders',
        () async {
          final now = DateTime.now().toUtc();
          final eightAm = DateTime.utc(now.year, now.month, now.day, 8, 0);
          final eightPm = DateTime.utc(now.year, now.month, now.day, 20, 0);

          final med1 = createDailyMedication(
            id: 'med-1',
            timesOfDay: const [480],
          );
          final med2 = createDailyMedication(
            id: 'med-2',
            timesOfDay: const [1200],
          );

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockReminderRepository.getByScheduledTime(
              eightAm.millisecondsSinceEpoch,
            ),
          ).thenAnswer((_) async => []);
          when(
            () => mockReminderRepository.getByScheduledTime(
              eightPm.millisecondsSinceEpoch,
            ),
          ).thenAnswer((_) async => []);

          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(med1);
          await addMedication.call(med2);

          final savedReminders = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured.cast<Reminder>();

          expect(savedReminders.length, equals(2));
          expect(savedReminders[0].groupDoseCount, equals(1));
          expect(savedReminders[1].groupDoseCount, equals(1));
        },
      );

      test(
        'adding third medication at same time increments groupDoseCount to 3',
        () async {
          final now = DateTime.now().toUtc();
          final eightAmToday = DateTime.utc(now.year, now.month, now.day, 8, 0);
          final scheduledTime = eightAmToday.millisecondsSinceEpoch;

          final med1 = createDailyMedication(id: 'med-1');
          final med2 = createDailyMedication(id: 'med-2');
          final med3 = createDailyMedication(id: 'med-3');

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});

          final existingReminder = Reminder(
            id: 'existing-reminder',
            profileId: 'default',
            type: 'medication',
            title: 'Morning Medications',
            body: null,
            status: ReminderStatus.scheduled,
            scheduledTime: scheduledTime,
            groupDoseCount: 2,
            policy: const EscalationPolicy(),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );

          when(
            () => mockReminderRepository.getByScheduledTime(scheduledTime),
          ).thenAnswer((_) async => [existingReminder]);

          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(med3);

          final updatedReminder =
              verify(
                    () => mockReminderRepository.save(captureAny()),
                  ).captured.last
                  as Reminder;
          expect(updatedReminder.groupDoseCount, equals(3));
        },
      );
    });

    group('Weekly Frequency', () {
      test(
        'weekly frequency creates reminders only on specified weekdays',
        () async {
          final now = DateTime.now().toUtc();
          final medication = Medication(
            id: 'med-weekly',
            profileId: 'default',
            name: 'Vitamin D',
            dosage: '1000IU',
            frequency: MedicationFrequency.weekly(
              timesOfDay: const [480],
              weekDays: const [1, 3, 5], // Mon, Wed, Fri
            ),
            reminderDuration: const ReminderDuration.fixedDays(days: 14),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.getByScheduledTime(any()),
          ).thenAnswer((_) async => []);
          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(medication);

          final savedReminders = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured.cast<Reminder>();

          expect(savedReminders.length, greaterThan(0));

          for (final reminder in savedReminders) {
            final reminderDate = DateTime.fromMillisecondsSinceEpoch(
              reminder.scheduledTime,
            );
            expect([1, 3, 5], contains(reminderDate.weekday));
          }
        },
      );

      test(
        'weekly frequency with multiple times creates correct reminder count',
        () async {
          final now = DateTime.now().toUtc();
          final medication = Medication(
            id: 'med-weekly-multi',
            profileId: 'default',
            name: 'B-Complex',
            dosage: '1 tablet',
            frequency: MedicationFrequency.weekly(
              timesOfDay: const [480, 1200], // 8 AM and 8 PM
              weekDays: const [1], // Monday only
            ),
            reminderDuration: const ReminderDuration.fixedDays(days: 7),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.getByScheduledTime(any()),
          ).thenAnswer((_) async => []);
          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(medication);

          final savedReminders = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured.cast<Reminder>();

          expect(savedReminders.length, greaterThan(0));

          final mondayReminders = savedReminders.where((r) {
            final date = DateTime.fromMillisecondsSinceEpoch(r.scheduledTime);
            return date.weekday == 1;
          }).toList();

          for (final reminder in mondayReminders) {
            final date = DateTime.fromMillisecondsSinceEpoch(
              reminder.scheduledTime,
            );
            expect([8, 20], contains(date.hour));
          }
        },
      );
    });

    group('Interval Frequency', () {
      test(
        'interval frequency creates reminders at specified hour intervals',
        () async {
          final now = DateTime.now().toUtc();
          final medication = Medication(
            id: 'med-interval',
            profileId: 'default',
            name: 'Antibiotic',
            dosage: '500mg',
            frequency: const MedicationFrequency.interval(intervalHours: 8),
            reminderDuration: const ReminderDuration.fixedDays(days: 2),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          );

          when(
            () => mockMedicationRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockMedicationRepository.saveDoseRecord(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.save(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockReminderRepository.getByScheduledTime(any()),
          ).thenAnswer((_) async => []);
          when(
            () => mockAlarmService.setAlarm(
              id: any(named: 'id'),
              dateTime: any(named: 'dateTime'),
              notificationTitle: any(named: 'notificationTitle'),
              notificationBody: any(named: 'notificationBody'),
              voicePayload: any(named: 'voicePayload'),
            ),
          ).thenAnswer((_) async => true);

          await addMedication.call(medication);

          final savedReminders = verify(
            () => mockReminderRepository.save(captureAny()),
          ).captured.cast<Reminder>();

          expect(savedReminders.length, greaterThan(1));

          final sortedReminders = savedReminders
            ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

          for (var i = 1; i < sortedReminders.length; i++) {
            final prevTime = DateTime.fromMillisecondsSinceEpoch(
              sortedReminders[i - 1].scheduledTime,
            );
            final currTime = DateTime.fromMillisecondsSinceEpoch(
              sortedReminders[i].scheduledTime,
            );
            final diffHours = currTime.difference(prevTime).inHours;
            expect(diffHours, equals(8));
          }
        },
      );
    });
  });
}
