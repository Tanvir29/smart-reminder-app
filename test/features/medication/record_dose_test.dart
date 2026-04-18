import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/record_dose.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockAlarmPort extends Mock implements AlarmPort {}

// ─── Fallback values ─────────────────────────────────────────────────────────

class FakeDoseRecord extends Fake implements DoseRecord {}

// ─── Helpers ─────────────────────────────────────────────────────────────────

final _now = DateTime.now().toUtc().millisecondsSinceEpoch;

Reminder _createReminder({
  String id = 'rem-1',
  int groupDoseCount = 1,
}) {
  return Reminder(
    id: id,
    profileId: 'default',
    type: 'medication',
    title: 'Morning Medications',
    status: ReminderStatus.scheduled,
    scheduledTime: _now,
    groupDoseCount: groupDoseCount,
    policy: const EscalationPolicy(),
    createdAt: _now,
    updatedAt: _now,
  );
}

DoseRecord _createDoseRecord({
  String id = 'dose-1',
  String medicationId = 'med-1',
  String reminderId = 'rem-1',
  DoseStatus status = DoseStatus.taken,
}) {
  return DoseRecord(
    id: id,
    profileId: 'default',
    medicationId: medicationId,
    scheduledTime: _now,
    actualTime: status == DoseStatus.taken ? _now : null,
    status: status,
    reminderId: reminderId,
    createdAt: _now,
    updatedAt: _now,
  );
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockMedicationRepository mockMedicationRepo;
  late MockReminderRepository mockReminderRepo;
  late MockAlarmPort mockAlarmPort;
  late RecordDose recordDose;

  setUpAll(() {
    registerFallbackValue(FakeDoseRecord());
    registerFallbackValue(ReminderStatus.logged);
  });

  setUp(() {
    mockMedicationRepo = MockMedicationRepository();
    mockReminderRepo = MockReminderRepository();
    mockAlarmPort = MockAlarmPort();
    recordDose = RecordDose(
      medicationRepository: mockMedicationRepo,
      reminderRepository: mockReminderRepo,
      alarmPort: mockAlarmPort,
    );
  });

  /// Stubs common interactions for a given reminder and existing dose records.
  void stubFor({
    required Reminder reminder,
    List<DoseRecord> existingDoseRecords = const [],
  }) {
    when(() => mockReminderRepo.getById(reminder.id))
        .thenAnswer((_) async => reminder);
    when(() => mockMedicationRepo.saveDoseRecord(any()))
        .thenAnswer((_) async {});
    when(() => mockMedicationRepo.getDoseRecordsByReminder(reminder.id))
        .thenAnswer((_) async => existingDoseRecords);
    when(() => mockReminderRepo.updateStatus(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockAlarmPort.stopAlarm(any())).thenAnswer((_) async => true);
  }

  group('RecordDose', () {
    test('always saves a DoseRecord regardless of batch completion', () async {
      final reminder = _createReminder(groupDoseCount: 3);
      // No existing records — batch is far from complete
      stubFor(reminder: reminder, existingDoseRecords: []);

      await recordDose.call(
        medicationId: 'med-1',
        reminderId: 'rem-1',
        status: DoseStatus.taken,
      );

      verify(() => mockMedicationRepo.saveDoseRecord(any())).called(1);
    });

    test(
      'single-med reminder (groupDoseCount=1): marks logged and stops alarm',
      () async {
        final reminder = _createReminder(groupDoseCount: 1);
        // After saving, getDoseRecordsByReminder returns 1 taken record
        final existingRecords = [
          _createDoseRecord(status: DoseStatus.taken),
        ];
        stubFor(reminder: reminder, existingDoseRecords: existingRecords);

        await recordDose.call(
          medicationId: 'med-1',
          reminderId: 'rem-1',
          status: DoseStatus.taken,
        );

        verify(
          () => mockReminderRepo.updateStatus('rem-1', ReminderStatus.logged),
        ).called(1);
        verify(
          () => mockAlarmPort.stopAlarm('rem-1'.hashCode),
        ).called(1);
      },
    );

    test(
      'multi-med reminder (groupDoseCount=3): 1st dose does NOT mark logged',
      () async {
        final reminder = _createReminder(groupDoseCount: 3);
        // Only 1 record exists after save — not enough
        final existingRecords = [
          _createDoseRecord(id: 'dose-1', status: DoseStatus.taken),
        ];
        stubFor(reminder: reminder, existingDoseRecords: existingRecords);

        await recordDose.call(
          medicationId: 'med-1',
          reminderId: 'rem-1',
          status: DoseStatus.taken,
        );

        verifyNever(
          () => mockReminderRepo.updateStatus(any(), any()),
        );
        verifyNever(
          () => mockAlarmPort.stopAlarm(any()),
        );
      },
    );

    test(
      'multi-med reminder (groupDoseCount=3): 3rd dose marks logged and stops alarm',
      () async {
        final reminder = _createReminder(groupDoseCount: 3);
        // 3 records exist — batch is fully resolved
        final existingRecords = [
          _createDoseRecord(
            id: 'dose-1',
            medicationId: 'med-1',
            status: DoseStatus.taken,
          ),
          _createDoseRecord(
            id: 'dose-2',
            medicationId: 'med-2',
            status: DoseStatus.taken,
          ),
          _createDoseRecord(
            id: 'dose-3',
            medicationId: 'med-3',
            status: DoseStatus.skipped,
          ),
        ];
        stubFor(reminder: reminder, existingDoseRecords: existingRecords);

        await recordDose.call(
          medicationId: 'med-3',
          reminderId: 'rem-1',
          status: DoseStatus.skipped,
        );

        verify(
          () => mockReminderRepo.updateStatus('rem-1', ReminderStatus.logged),
        ).called(1);
        verify(
          () => mockAlarmPort.stopAlarm('rem-1'.hashCode),
        ).called(1);
      },
    );

    test('skipped doses count toward batch completion', () async {
      final reminder = _createReminder(groupDoseCount: 2);
      // 2 records: 1 taken + 1 skipped — should complete the batch
      final existingRecords = [
        _createDoseRecord(id: 'dose-1', status: DoseStatus.taken),
        _createDoseRecord(id: 'dose-2', status: DoseStatus.skipped),
      ];
      stubFor(reminder: reminder, existingDoseRecords: existingRecords);

      await recordDose.call(
        medicationId: 'med-2',
        reminderId: 'rem-1',
        status: DoseStatus.skipped,
      );

      verify(
        () => mockReminderRepo.updateStatus('rem-1', ReminderStatus.logged),
      ).called(1);
    });

    test(
      'pending and missed doses do NOT count toward batch completion',
      () async {
        final reminder = _createReminder(groupDoseCount: 3);
        // 3 records but only 1 is taken, 1 is pending, 1 is missed
        // Only taken counts → recordedCount = 1, not >= 3
        final existingRecords = [
          _createDoseRecord(id: 'dose-1', status: DoseStatus.taken),
          _createDoseRecord(id: 'dose-2', status: DoseStatus.pending),
          _createDoseRecord(id: 'dose-3', status: DoseStatus.missed),
        ];
        stubFor(reminder: reminder, existingDoseRecords: existingRecords);

        await recordDose.call(
          medicationId: 'med-1',
          reminderId: 'rem-1',
          status: DoseStatus.taken,
        );

        verifyNever(
          () => mockReminderRepo.updateStatus(any(), any()),
        );
        verifyNever(
          () => mockAlarmPort.stopAlarm(any()),
        );
      },
    );

    test('returned DoseRecord has correct medicationId and status', () async {
      final reminder = _createReminder(groupDoseCount: 1);
      final existingRecords = [
        _createDoseRecord(status: DoseStatus.taken),
      ];
      stubFor(reminder: reminder, existingDoseRecords: existingRecords);

      final result = await recordDose.call(
        medicationId: 'med-42',
        reminderId: 'rem-1',
        status: DoseStatus.taken,
        notes: 'Took with food',
      );

      expect(result.medicationId, equals('med-42'));
      expect(result.status, equals(DoseStatus.taken));
      expect(result.notes, equals('Took with food'));
      expect(result.reminderId, equals('rem-1'));
      expect(result.id, isNotEmpty);
    });

    test('uses reminder scheduledTime for the DoseRecord', () async {
      final scheduledTime = DateTime(2026, 3, 28, 8, 0).millisecondsSinceEpoch;
      final reminder = _createReminder(groupDoseCount: 1).copyWith(
        scheduledTime: scheduledTime,
      );
      stubFor(
        reminder: reminder,
        existingDoseRecords: [
          _createDoseRecord(status: DoseStatus.taken),
        ],
      );

      final result = await recordDose.call(
        medicationId: 'med-1',
        reminderId: 'rem-1',
        status: DoseStatus.taken,
      );

      expect(result.scheduledTime, equals(scheduledTime));
    });

    test(
      'null reminder defaults scheduledTime to now and groupDoseCount to 1',
      () async {
        // getById returns null — edge case
        when(() => mockReminderRepo.getById('rem-missing'))
            .thenAnswer((_) async => null);
        when(() => mockMedicationRepo.saveDoseRecord(any()))
            .thenAnswer((_) async {});
        when(() => mockMedicationRepo.getDoseRecordsByReminder('rem-missing'))
            .thenAnswer(
          (_) async => [_createDoseRecord(status: DoseStatus.taken)],
        );
        when(() => mockReminderRepo.updateStatus(any(), any()))
            .thenAnswer((_) async {});
        when(() => mockAlarmPort.stopAlarm(any()))
            .thenAnswer((_) async => true);

        final result = await recordDose.call(
          medicationId: 'med-1',
          reminderId: 'rem-missing',
          status: DoseStatus.taken,
        );

        // Should still succeed — scheduledTime falls back to now
        expect(result.scheduledTime, isA<int>());
        // groupDoseCount defaults to 1, so 1 taken record → logged
        verify(
          () => mockReminderRepo.updateStatus(
            'rem-missing',
            ReminderStatus.logged,
          ),
        ).called(1);
      },
    );
  });
}
