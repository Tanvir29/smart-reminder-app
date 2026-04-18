import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';

void main() {
  group('MedicationState', () {
    final now = DateTime.now();
    final dateStart =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    Medication createTestMedication({
      String id = 'med-1',
      String name = 'Aspirin',
      List<int> timesOfDay = const [480],
      bool isCritical = false,
    }) {
      return Medication(
        id: id,
        profileId: 'default',
        name: name,
        dosage: '100mg',
        frequency: MedicationFrequency.daily(timesOfDay: timesOfDay),
        isCritical: isCritical,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
    }

    DoseRecord createTestDoseRecord({
      String id = 'dose-1',
      String medicationId = 'med-1',
      required int scheduledTime,
      DoseStatus status = DoseStatus.taken,
    }) {
      return DoseRecord(
        id: id,
        profileId: 'default',
        medicationId: medicationId,
        scheduledTime: scheduledTime,
        status: status,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
      );
    }

    group('todaySlots', () {
      test('returns empty list when no medications', () {
        const state = MedicationState();
        expect(state.todaySlots, isEmpty);
      });

      test('maps taken dose record to taken slot status', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med = createTestMedication();
        final dose = createTestDoseRecord(
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );

        final state = MedicationState(
          medications: [med],
          todaysDoses: [dose],
        );

        final slots = state.todaySlots;
        expect(slots, hasLength(1));
        expect(slots.first.status, equals(DoseSlotStatus.taken));
        expect(slots.first.medication.id, equals('med-1'));
        expect(slots.first.scheduledTimeMinutes, equals(480));
      });

      test('maps missed dose record to missed slot status', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med = createTestMedication();
        final dose = createTestDoseRecord(
          scheduledTime: scheduledMs,
          status: DoseStatus.missed,
        );

        final state = MedicationState(
          medications: [med],
          todaysDoses: [dose],
        );

        final slots = state.todaySlots;
        expect(slots, hasLength(1));
        expect(slots.first.status, equals(DoseSlotStatus.missed));
      });

      test('maps skipped dose record to missed slot status', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med = createTestMedication();
        final dose = createTestDoseRecord(
          scheduledTime: scheduledMs,
          status: DoseStatus.skipped,
        );

        final state = MedicationState(
          medications: [med],
          todaysDoses: [dose],
        );

        final slots = state.todaySlots;
        expect(slots.first.status, equals(DoseSlotStatus.missed));
      });

      test('expands daily frequency into multiple slots', () {
        final med = createTestMedication(timesOfDay: [480, 1200]);

        final state = MedicationState(medications: [med]);

        final slots = state.todaySlots;
        expect(slots, hasLength(2));
        expect(slots[0].scheduledTimeMinutes, equals(480));
        expect(slots[1].scheduledTimeMinutes, equals(1200));
      });

      test('sorts slots chronologically', () {
        final med = createTestMedication(timesOfDay: [1200, 480]);

        final state = MedicationState(medications: [med]);

        final slots = state.todaySlots;
        expect(slots[0].scheduledTimeMinutes,
            lessThan(slots[1].scheduledTimeMinutes));
      });
    });

    group('adherencePercent', () {
      test('returns 1.0 when no past-due slots exist', () {
        final med = createTestMedication(timesOfDay: [1439]);

        final state = MedicationState(medications: [med]);

        expect(state.adherencePercent, equals(1.0));
      });

      test('returns 1.0 when all slots are taken', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med = createTestMedication();
        final dose = createTestDoseRecord(scheduledTime: scheduledMs);

        final state = MedicationState(
          medications: [med],
          todaysDoses: [dose],
        );

        expect(state.adherencePercent, equals(1.0));
      });

      test('returns 0.0 when all slots are missed', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med = createTestMedication();
        final dose = createTestDoseRecord(
          scheduledTime: scheduledMs,
          status: DoseStatus.missed,
        );

        final state = MedicationState(
          medications: [med],
          todaysDoses: [dose],
        );

        expect(state.adherencePercent, equals(0.0));
      });

      test('calculates correct ratio for mixed slots', () {
        final scheduledMs1 = dateStart + 480 * 60 * 1000;
        final scheduledMs2 = dateStart + 720 * 60 * 1000;
        final med = createTestMedication(timesOfDay: [480, 720]);
        final takenDose = createTestDoseRecord(
          id: 'dose-1',
          scheduledTime: scheduledMs1,
          status: DoseStatus.taken,
        );
        final missedDose = createTestDoseRecord(
          id: 'dose-2',
          medicationId: 'med-1',
          scheduledTime: scheduledMs2,
          status: DoseStatus.missed,
        );

        final state = MedicationState(
          medications: [med],
          todaysDoses: [takenDose, missedDose],
        );

        expect(state.adherencePercent, equals(0.5));
      });
    });

    group('todayGroups', () {
      test('returns empty list when no medications', () {
        const state = MedicationState();
        expect(state.todayGroups, isEmpty);
      });

      test('groups medications at same scheduled time', () {
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
            id: 'med-2', name: 'Ibuprofen', timesOfDay: [480]);

        final state = MedicationState(medications: [med1, med2]);

        final groups = state.todayGroups;
        expect(groups, hasLength(1));
        expect(groups.first.slots, hasLength(2));
        expect(groups.first.scheduledTimeMinutes, equals(480));
      });

      test('separates medications at different times', () {
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
            id: 'med-2', name: 'Ibuprofen', timesOfDay: [1200]);

        final state = MedicationState(medications: [med1, med2]);

        final groups = state.todayGroups;
        expect(groups, hasLength(2));
        expect(groups[0].scheduledTimeMinutes, equals(480));
        expect(groups[1].scheduledTimeMinutes, equals(1200));
      });

      test('reports partiallyTaken status when some slots taken', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
            id: 'med-2', name: 'Ibuprofen', timesOfDay: [480]);
        final takenDose = createTestDoseRecord(
          id: 'dose-1',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );

        final state = MedicationState(
          medications: [med1, med2],
          todaysDoses: [takenDose],
        );

        final groups = state.todayGroups;
        expect(groups, hasLength(1));
        expect(groups.first.status, equals(DoseSlotStatus.partiallyTaken));
      });

      test('reports taken status when all slots taken', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
            id: 'med-2', name: 'Ibuprofen', timesOfDay: [480]);
        final dose1 = createTestDoseRecord(
          id: 'dose-1',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );
        final dose2 = createTestDoseRecord(
          id: 'dose-2',
          medicationId: 'med-2',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );

        final state = MedicationState(
          medications: [med1, med2],
          todaysDoses: [dose1, dose2],
        );

        final groups = state.todayGroups;
        expect(groups.first.status, equals(DoseSlotStatus.taken));
      });
    });

    group('GroupedDoseSlot', () {
      test('hasCritical returns true when any medication is critical', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
          id: 'med-2',
          name: 'Insulin',
          timesOfDay: [480],
          isCritical: true,
        );
        final dose1 = createTestDoseRecord(
          id: 'dose-1',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );
        final dose2 = createTestDoseRecord(
          id: 'dose-2',
          medicationId: 'med-2',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );

        final state = MedicationState(
          medications: [med1, med2],
          todaysDoses: [dose1, dose2],
        );

        final groups = state.todayGroups;
        expect(groups.first.hasCritical, isTrue);
      });

      test('medicationNames joins names with comma', () {
        final scheduledMs = dateStart + 480 * 60 * 1000;
        final med1 = createTestMedication(id: 'med-1', timesOfDay: [480]);
        final med2 = createTestMedication(
          id: 'med-2',
          name: 'Ibuprofen',
          timesOfDay: [480],
        );
        final dose1 = createTestDoseRecord(
          id: 'dose-1',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );
        final dose2 = createTestDoseRecord(
          id: 'dose-2',
          medicationId: 'med-2',
          scheduledTime: scheduledMs,
          status: DoseStatus.taken,
        );

        final state = MedicationState(
          medications: [med1, med2],
          todaysDoses: [dose1, dose2],
        );

        final groups = state.todayGroups;
        expect(groups.first.medicationNames, contains('Aspirin'));
        expect(groups.first.medicationNames, contains('Ibuprofen'));
      });
    });
  });
}
