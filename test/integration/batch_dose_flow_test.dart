import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/features/medication/data/mappers/medication_mapper.dart';
import 'package:smart_reminder_app/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart'
    as dose_entity;
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart'
    as med_entity;
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_medication_schedule.dart';
import 'package:sqlite3/open.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }

  group('Batch Dose Flow Integration Test (P3-10)', () {
    late AppDatabase db;
    late MedicationMapper mapper;
    late MedicationRepository repository;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      mapper = MedicationMapper();
      repository = MedicationRepositoryImpl(db.medicationDao, mapper);
    });

    tearDown(() async {
      await db.close();
    });

    test('two medications at same time share one time-slot group', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;
      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

      final medA = med_entity.Medication(
        id: 'med-batch-a',
        profileId: 'default',
        name: 'Prozac',
        dosage: '20mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final medB = med_entity.Medication(
        id: 'med-batch-b',
        profileId: 'default',
        name: 'Vitamin D',
        dosage: '1000 IU',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medA);
      await repository.save(medB);

      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final slots = buildScheduleSlots(
        medications: [medA, medB],
        doseRecords: [],
        date: now,
      );

      expect(slots.length, equals(2));

      final eightAmSlots = slots.where((s) => s.timeMinutes == 480).toList();
      expect(eightAmSlots.length, equals(2));
      expect(
        eightAmSlots.map((s) => s.medication.id).toSet(),
        equals({'med-batch-a', 'med-batch-b'}),
      );
    });

    test('recording one dose in a batch does not resolve the batch', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;
      final scheduledTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;

      final medA = med_entity.Medication(
        id: 'med-partial-a',
        profileId: 'default',
        name: 'Iron',
        dosage: '65mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final medB = med_entity.Medication(
        id: 'med-partial-b',
        profileId: 'default',
        name: 'Vitamin C',
        dosage: '500mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medA);
      await repository.save(medB);

      final doseA = dose_entity.DoseRecord(
        id: 'dose-partial-a',
        profileId: 'default',
        medicationId: 'med-partial-a',
        scheduledTime: scheduledTime,
        actualTime: nowMs,
        status: dose_entity.DoseStatus.taken,
        reminderId: 'reminder-batch-1',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(doseA);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final allDoses = <dose_entity.DoseRecord>[];
      for (final med in [medA, medB]) {
        allDoses.addAll(
          await repository.getDoseRecordsInRange(
            med.id,
            todayStart,
            todayEnd,
          ),
        );
      }

      final takenCount = allDoses
          .where((d) =>
              d.status == dose_entity.DoseStatus.taken ||
              d.status == dose_entity.DoseStatus.skipped)
          .length;

      expect(takenCount, equals(1));
      expect(allDoses.length, equals(1));
    });

    test('recording all doses in a batch fully resolves the batch', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;
      final scheduledTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;

      final medA = med_entity.Medication(
        id: 'med-full-a',
        profileId: 'default',
        name: 'Zinc',
        dosage: '15mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final medB = med_entity.Medication(
        id: 'med-full-b',
        profileId: 'default',
        name: 'Magnesium',
        dosage: '400mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medA);
      await repository.save(medB);

      final doseA = dose_entity.DoseRecord(
        id: 'dose-full-a',
        profileId: 'default',
        medicationId: 'med-full-a',
        scheduledTime: scheduledTime,
        actualTime: nowMs,
        status: dose_entity.DoseStatus.taken,
        reminderId: 'reminder-batch-2',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final doseB = dose_entity.DoseRecord(
        id: 'dose-full-b',
        profileId: 'default',
        medicationId: 'med-full-b',
        scheduledTime: scheduledTime,
        actualTime: nowMs,
        status: dose_entity.DoseStatus.taken,
        reminderId: 'reminder-batch-2',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(doseA);
      await repository.saveDoseRecord(doseB);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final allDoses = <dose_entity.DoseRecord>[];
      for (final med in [medA, medB]) {
        allDoses.addAll(
          await repository.getDoseRecordsInRange(
            med.id,
            todayStart,
            todayEnd,
          ),
        );
      }

      expect(allDoses.length, equals(2));

      final takenCount = allDoses
          .where((d) => d.status == dose_entity.DoseStatus.taken)
          .length;
      expect(takenCount, equals(2));

      final resolvedCount = allDoses
          .where((d) =>
              d.status == dose_entity.DoseStatus.taken ||
              d.status == dose_entity.DoseStatus.skipped)
          .length;
      expect(resolvedCount, equals(2));

      final slots = buildScheduleSlots(
        medications: [medA, medB],
        doseRecords: allDoses,
        date: now,
      );

      final eightAmSlots = slots.where((s) => s.timeMinutes == 480).toList();
      expect(eightAmSlots.length, equals(2));
      expect(
        eightAmSlots.every((s) => s.status == DoseSlotItemStatus.taken),
        isTrue,
      );
    });
  });
}
