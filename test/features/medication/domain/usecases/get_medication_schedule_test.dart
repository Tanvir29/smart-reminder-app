import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_medication_schedule.dart';

void main() {
  group('buildScheduleSlots', () {
    late int nowMs;
    late DateTime today;

    setUp(() {
      today = DateTime.now();
      nowMs = today.millisecondsSinceEpoch;
    });

    Medication createMed({
      String id = 'med-1',
      String name = 'Aspirin',
      required MedicationFrequency frequency,
      bool isActive = true,
    }) {
      return Medication(
        id: id,
        profileId: 'default',
        name: name,
        dosage: '100mg',
        frequency: frequency,
        isActive: isActive,
        createdAt: nowMs,
        updatedAt: nowMs,
      );
    }

    test('returns empty list for no medications', () {
      final slots = buildScheduleSlots(
        medications: [],
        doseRecords: [],
        date: today,
      );
      expect(slots, isEmpty);
    });

    test('skips inactive medications', () {
      final med = createMed(
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
        isActive: false,
      );

      final slots = buildScheduleSlots(
        medications: [med],
        doseRecords: [],
        date: today,
      );
      expect(slots, isEmpty);
    });

    test('expands daily frequency correctly', () {
      final med = createMed(
        frequency: MedicationFrequency.daily(timesOfDay: const [480, 1200]),
      );

      final slots = buildScheduleSlots(
        medications: [med],
        doseRecords: [],
        date: today,
      );

      expect(slots.length, equals(2));
      expect(slots[0].timeMinutes, equals(480));
      expect(slots[1].timeMinutes, equals(1200));
    });

    test('groups medications at the same time into separate slots', () {
      final med1 = createMed(
        id: 'med-1',
        name: 'Aspirin',
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
      );
      final med2 = createMed(
        id: 'med-2',
        name: 'Vitamin D',
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
      );

      final slots = buildScheduleSlots(
        medications: [med1, med2],
        doseRecords: [],
        date: today,
      );

      expect(slots.length, equals(2));
      expect(slots.every((s) => s.timeMinutes == 480), isTrue);
      expect(slots[0].medication.id, equals('med-1'));
      expect(slots[1].medication.id, equals('med-2'));
    });

    test('matches dose records within 30-minute window', () {
      final todayStart =
          DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
      final scheduledMs = todayStart + 480 * 60 * 1000;

      final med = createMed(
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
      );

      final dose = DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: scheduledMs,
        actualTime: nowMs,
        status: DoseStatus.taken,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final slots = buildScheduleSlots(
        medications: [med],
        doseRecords: [dose],
        date: today,
      );

      expect(slots.length, equals(1));
      expect(slots[0].status, equals(DoseSlotItemStatus.taken));
      expect(slots[0].doseRecord, isNotNull);
    });

    test('marks past-due slots without dose record as missed', () {
      final pastHour = DateTime.now().hour - 2;
      if (pastHour < 0) return;

      final med = createMed(
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
      );

      final slots = buildScheduleSlots(
        medications: [med],
        doseRecords: [],
        date: today,
      );

      final missedSlots =
          slots.where((s) => s.status == DoseSlotItemStatus.missed).toList();

      if (DateTime.now().hour >= 9) {
        expect(missedSlots.isNotEmpty, isTrue);
      }
    });

    test('weekly frequency only includes matching weekday', () {
      final med = createMed(
        frequency: MedicationFrequency.weekly(
          timesOfDay: const [480],
          weekDays: [today.weekday],
        ),
      );

      final slotsMatch = buildScheduleSlots(
        medications: [med],
        doseRecords: [],
        date: today,
      );
      expect(slotsMatch.length, equals(1));

      final wrongDay = today.weekday == 1 ? 2 : 1;
      final medWrongDay = createMed(
        frequency: MedicationFrequency.weekly(
          timesOfDay: const [480],
          weekDays: [wrongDay],
        ),
      );

      final slotsNoMatch = buildScheduleSlots(
        medications: [medWrongDay],
        doseRecords: [],
        date: today,
      );
      expect(slotsNoMatch, isEmpty);
    });

    test('slots are sorted chronologically', () {
      final med = createMed(
        frequency: MedicationFrequency.daily(timesOfDay: const [1200, 480]),
      );

      final slots = buildScheduleSlots(
        medications: [med],
        doseRecords: [],
        date: today,
      );

      expect(slots[0].timeMinutes, lessThan(slots[1].timeMinutes));
      expect(slots[0].timeMinutes, equals(480));
      expect(slots[1].timeMinutes, equals(1200));
    });
  });
}
