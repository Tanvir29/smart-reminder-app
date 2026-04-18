import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/record_dose.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeDoseRecord extends Fake implements DoseRecord {}

void main() {
  late MockMedicationRepository mockMedRepo;
  late MockReminderRepository mockReminderRepo;
  late MockAlarmPort mockAlarmPort;
  late RecordDose recordDose;

  setUpAll(() {
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(ReminderStatus.scheduled);
  });

  setUp(() {
    mockMedRepo = MockMedicationRepository();
    mockReminderRepo = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();

    recordDose = RecordDose(
      medicationRepository: mockMedRepo,
      reminderRepository: mockReminderRepo,
      alarmPort: mockAlarmPort,
    );

    when(() => mockMedRepo.saveDoseRecord(any())).thenAnswer((_) async {});
    when(() => mockReminderRepo.updateStatus(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
  });

  final now = DateTime.now().millisecondsSinceEpoch;

  Reminder createReminder({
    String id = 'reminder-1',
    int groupDoseCount = 1,
  }) {
    return Reminder(
      id: id,
      profileId: 'default',
      type: 'medication',
      title: 'Morning Meds',
      status: ReminderStatus.triggered,
      scheduledTime: now + 3600000,
      groupDoseCount: groupDoseCount,
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  test('records a single dose and marks reminder as logged', () async {
    when(() => mockReminderRepo.getById('reminder-1'))
        .thenAnswer((_) async => createReminder());
    when(() => mockMedRepo.getDoseRecordsByReminder('reminder-1'))
        .thenAnswer((_) async => [
              DoseRecord(
                id: 'dose-1',
                profileId: 'default',
                medicationId: 'med-1',
                scheduledTime: now,
                status: DoseStatus.taken,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

    final result = await recordDose.call(
      medicationId: 'med-1',
      reminderId: 'reminder-1',
      status: DoseStatus.taken,
    );

    expect(result.status, equals(DoseStatus.taken));
    expect(result.medicationId, equals('med-1'));

    verify(() => mockReminderRepo.updateStatus(
          'reminder-1',
          ReminderStatus.logged,
        )).called(1);
    verify(() => mockAlarmPort.stopAlarm(any())).called(1);
  });

  test('does NOT log reminder when batch is partially complete', () async {
    when(() => mockReminderRepo.getById('reminder-1'))
        .thenAnswer((_) async => createReminder(groupDoseCount: 2));
    when(() => mockMedRepo.getDoseRecordsByReminder('reminder-1'))
        .thenAnswer((_) async => [
              DoseRecord(
                id: 'dose-1',
                profileId: 'default',
                medicationId: 'med-1',
                scheduledTime: now,
                status: DoseStatus.taken,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

    await recordDose.call(
      medicationId: 'med-1',
      reminderId: 'reminder-1',
      status: DoseStatus.taken,
    );

    verifyNever(() => mockReminderRepo.updateStatus(any(), any()));
    verifyNever(() => mockAlarmPort.stopAlarm(any()));
  });

  test('logs reminder when batch is fully complete after second dose',
      () async {
    when(() => mockReminderRepo.getById('reminder-1'))
        .thenAnswer((_) async => createReminder(groupDoseCount: 2));

    when(() => mockMedRepo.getDoseRecordsByReminder('reminder-1'))
        .thenAnswer((_) async => [
              DoseRecord(
                id: 'dose-1',
                profileId: 'default',
                medicationId: 'med-1',
                scheduledTime: now,
                status: DoseStatus.taken,
                createdAt: now,
                updatedAt: now,
              ),
              DoseRecord(
                id: 'dose-2',
                profileId: 'default',
                medicationId: 'med-2',
                scheduledTime: now,
                status: DoseStatus.taken,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

    await recordDose.call(
      medicationId: 'med-2',
      reminderId: 'reminder-1',
      status: DoseStatus.taken,
    );

    verify(() => mockReminderRepo.updateStatus(
          'reminder-1',
          ReminderStatus.logged,
        )).called(1);
    verify(() => mockAlarmPort.stopAlarm(any())).called(1);
  });

  test('skipped dose counts toward batch completion', () async {
    when(() => mockReminderRepo.getById('reminder-1'))
        .thenAnswer((_) async => createReminder(groupDoseCount: 2));

    when(() => mockMedRepo.getDoseRecordsByReminder('reminder-1'))
        .thenAnswer((_) async => [
              DoseRecord(
                id: 'dose-1',
                profileId: 'default',
                medicationId: 'med-1',
                scheduledTime: now,
                status: DoseStatus.taken,
                createdAt: now,
                updatedAt: now,
              ),
              DoseRecord(
                id: 'dose-2',
                profileId: 'default',
                medicationId: 'med-2',
                scheduledTime: now,
                status: DoseStatus.skipped,
                createdAt: now,
                updatedAt: now,
              ),
            ]);

    await recordDose.call(
      medicationId: 'med-2',
      reminderId: 'reminder-1',
      status: DoseStatus.skipped,
    );

    verify(() => mockReminderRepo.updateStatus(
          'reminder-1',
          ReminderStatus.logged,
        )).called(1);
    verify(() => mockAlarmPort.stopAlarm(any())).called(1);
  });

  test('creates dose record with correct fields', () async {
    when(() => mockReminderRepo.getById('reminder-1'))
        .thenAnswer((_) async => createReminder());
    when(() => mockMedRepo.getDoseRecordsByReminder('reminder-1'))
        .thenAnswer((_) async => []);

    final result = await recordDose.call(
      medicationId: 'med-1',
      reminderId: 'reminder-1',
      status: DoseStatus.taken,
      notes: 'Taken with water',
    );

    expect(result.medicationId, equals('med-1'));
    expect(result.status, equals(DoseStatus.taken));
    expect(result.notes, equals('Taken with water'));
    expect(result.actualTime, isNotNull);
    expect(result.profileId, equals('default'));
  });
}
