import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/undo_dose.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeDoseRecord extends Fake implements DoseRecord {}

void main() {
  late MockMedicationRepository mockMedicationRepo;
  late MockReminderRepository mockReminderRepo;
  late MockAlarmPort mockAlarmPort;
  late UndoDose undoDose;

  setUpAll(() {
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(DateTime(2024));
    registerFallbackValue(ReminderStatus.scheduled);
  });

  setUp(() {
    mockMedicationRepo = MockMedicationRepository();
    mockReminderRepo = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    undoDose = UndoDose(
      medicationRepository: mockMedicationRepo,
      reminderRepository: mockReminderRepo,
      alarmPort: mockAlarmPort,
    );
  });

  DoseRecord createTestDoseRecord({
    String id = 'dose-1',
    String medicationId = 'med-1',
    String? reminderId = 'rem-1',
    DoseStatus status = DoseStatus.taken,
    int? createdAt,
    int scheduledTime = 1700000000000,
  }) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return DoseRecord(
      id: id,
      profileId: 'default',
      medicationId: medicationId,
      scheduledTime: scheduledTime,
      actualTime: status == DoseStatus.taken ? now : null,
      status: status,
      reminderId: reminderId,
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  void stubUndoSuccess() {
    when(() => mockMedicationRepo.updateDoseRecord(any()))
        .thenAnswer((_) async {});
    when(() => mockReminderRepo.updateStatus(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockAlarmPort.setAlarm(
          id: any(named: 'id'),
          dateTime: any(named: 'dateTime'),
          notificationTitle: any(named: 'notificationTitle'),
          notificationBody: any(named: 'notificationBody'),
        )).thenAnswer((_) async => true);
  }

  group('UndoDose', () {
    test('reverts dose status to skipped', () async {
      final dose = createTestDoseRecord(status: DoseStatus.taken);
      stubUndoSuccess();

      await undoDose.call(dose);

      final captured =
          verify(() => mockMedicationRepo.updateDoseRecord(captureAny()))
              .captured
              .single as DoseRecord;
      expect(captured.status, equals(DoseStatus.skipped));
    });

    test('sets undo note on reverted dose', () async {
      final dose = createTestDoseRecord(status: DoseStatus.taken);
      stubUndoSuccess();

      await undoDose.call(dose);

      final captured =
          verify(() => mockMedicationRepo.updateDoseRecord(captureAny()))
              .captured
              .single as DoseRecord;
      expect(captured.notes, equals('Undone by user'));
    });

    test('restores reminder to triggered status', () async {
      final dose = createTestDoseRecord(
        reminderId: 'rem-1',
        status: DoseStatus.taken,
      );
      stubUndoSuccess();

      await undoDose.call(dose);

      verify(() => mockReminderRepo.updateStatus(
            'rem-1',
            ReminderStatus.triggered,
          )).called(1);
    });

    test('re-arms the alarm after undo', () async {
      final dose = createTestDoseRecord(
        reminderId: 'rem-1',
        scheduledTime: 1700000000000,
        status: DoseStatus.taken,
      );
      stubUndoSuccess();

      await undoDose.call(dose);

      verify(() => mockAlarmPort.setAlarm(
            id: 'rem-1'.hashCode,
            dateTime: DateTime.fromMillisecondsSinceEpoch(1700000000000),
            notificationTitle: 'Medication Reminder',
            notificationBody: 'Dose undo — please take action',
          )).called(1);
    });

    test('succeeds within 5-second undo window', () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final dose = createTestDoseRecord(createdAt: now - 3000);
      stubUndoSuccess();

      await undoDose.call(dose);

      verify(() => mockMedicationRepo.updateDoseRecord(any())).called(1);
    });

    test('throws StateError when undo window has expired', () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final dose = createTestDoseRecord(
        createdAt: now - UndoDose.undoWindowMs - 1000,
      );

      expect(
        () => undoDose.call(dose),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when undo window is past boundary', () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final dose = createTestDoseRecord(
        createdAt: now - UndoDose.undoWindowMs - 1,
      );

      expect(
        () => undoDose.call(dose),
        throwsA(isA<StateError>()),
      );
    });

    test('does not update reminder when reminderId is null', () async {
      final dose = createTestDoseRecord(reminderId: null);
      stubUndoSuccess();

      await undoDose.call(dose);

      verifyNever(() => mockReminderRepo.updateStatus(any(), any()));
      verifyNever(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          ));
    });

    test('still updates dose record when reminderId is null', () async {
      final dose = createTestDoseRecord(reminderId: null);
      stubUndoSuccess();

      await undoDose.call(dose);

      verify(() => mockMedicationRepo.updateDoseRecord(any())).called(1);
    });

    test('updates updatedAt timestamp on reverted dose', () async {
      final beforeCall = DateTime.now().toUtc().millisecondsSinceEpoch;
      final dose = createTestDoseRecord();
      stubUndoSuccess();

      await undoDose.call(dose);

      final captured =
          verify(() => mockMedicationRepo.updateDoseRecord(captureAny()))
              .captured
              .single as DoseRecord;
      expect(captured.updatedAt, greaterThanOrEqualTo(beforeCall));
    });

    test('preserves all other dose fields during undo', () async {
      final dose = createTestDoseRecord(
        id: 'dose-42',
        medicationId: 'med-99',
        scheduledTime: 1700000000000,
      );
      stubUndoSuccess();

      await undoDose.call(dose);

      final captured =
          verify(() => mockMedicationRepo.updateDoseRecord(captureAny()))
              .captured
              .single as DoseRecord;
      expect(captured.id, equals('dose-42'));
      expect(captured.medicationId, equals('med-99'));
      expect(captured.scheduledTime, equals(1700000000000));
    });
  });
}
