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
import 'package:sqlite3/open.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }

  group('Full Dose Flow Integration Test (P3-10)', () {
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

    test(
        'complete dose flow: add medication -> record dose -> verify adherence',
        () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      final medication = med_entity.Medication(
        id: 'med-test-001',
        profileId: 'default',
        name: 'Vitamin D',
        dosage: '1000 IU',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        instructions: 'Take with food',
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medication);

      final saved = await repository.getById('med-test-001');
      expect(saved, isNotNull);
      expect(saved!.name, equals('Vitamin D'));
      expect(saved.dosage, equals('1000 IU'));
      expect(saved.isActive, isTrue);

      final scheduledTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;
      final doseRecord = dose_entity.DoseRecord(
        id: 'dose-001',
        profileId: 'default',
        medicationId: 'med-test-001',
        scheduledTime: scheduledTime,
        actualTime: nowMs,
        status: dose_entity.DoseStatus.taken,
        reminderId: 'reminder-001',
        notes: 'Taken with breakfast',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(doseRecord);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final doses = await repository.getDoseRecordsInRange(
        'med-test-001',
        todayStart,
        todayEnd,
      );

      expect(doses.length, equals(1));
      expect(doses.first.status, equals(dose_entity.DoseStatus.taken));
      expect(doses.first.medicationId, equals('med-test-001'));
      expect(doses.first.notes, equals('Taken with breakfast'));

      final adherenceResult = _calculateAdherence(doses);
      expect(adherenceResult, equals(100.0));
    });

    test('dose flow with missed dose shows correct adherence', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      final medication = med_entity.Medication(
        id: 'med-test-002',
        profileId: 'default',
        name: 'Iron Supplement',
        dosage: '65mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        instructions: 'Take on empty stomach',
        isCritical: true,
        xpValue: 15,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medication);

      final scheduledTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;

      final missedDose = dose_entity.DoseRecord(
        id: 'dose-002',
        profileId: 'default',
        medicationId: 'med-test-002',
        scheduledTime: scheduledTime,
        actualTime: null,
        status: dose_entity.DoseStatus.missed,
        reminderId: 'reminder-002',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(missedDose);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final doses = await repository.getDoseRecordsInRange(
        'med-test-002',
        todayStart,
        todayEnd,
      );

      final adherenceResult = _calculateAdherence(doses);
      expect(adherenceResult, equals(0.0));
    });

    test('dose flow with mixed doses calculates correct adherence', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      final medication = med_entity.Medication(
        id: 'med-test-003',
        profileId: 'default',
        name: 'Multi Vitamin',
        dosage: '1 tablet',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480, 1200]),
        instructions: 'Twice daily with meals',
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medication);

      final morningTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;
      final eveningTime =
          DateTime(now.year, now.month, now.day, 20, 0).millisecondsSinceEpoch;

      final morningDose = dose_entity.DoseRecord(
        id: 'dose-003a',
        profileId: 'default',
        medicationId: 'med-test-003',
        scheduledTime: morningTime,
        actualTime: morningTime,
        status: dose_entity.DoseStatus.taken,
        reminderId: 'reminder-003a',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      final eveningDose = dose_entity.DoseRecord(
        id: 'dose-003b',
        profileId: 'default',
        medicationId: 'med-test-003',
        scheduledTime: eveningTime,
        actualTime: null,
        status: dose_entity.DoseStatus.missed,
        reminderId: 'reminder-003b',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(morningDose);
      await repository.saveDoseRecord(eveningDose);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      final doses = await repository.getDoseRecordsInRange(
        'med-test-003',
        todayStart,
        todayEnd,
      );

      expect(doses.length, equals(2));

      final takenCount =
          doses.where((d) => d.status == dose_entity.DoseStatus.taken).length;
      final totalCount = doses.length;
      final adherenceResult = (takenCount / totalCount) * 100;

      expect(adherenceResult, equals(50.0));
    });

    test('archived medication does not appear in active list', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      final activeMed = med_entity.Medication(
        id: 'med-active',
        profileId: 'default',
        name: 'Active Med',
        dosage: '10mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(activeMed);

      final activeMeds = await repository.getActive();
      expect(activeMeds.length, equals(1));
      expect(activeMeds.first.name, equals('Active Med'));

      await repository.archive('med-active');

      final afterArchive = await repository.getActive();
      expect(afterArchive.length, equals(0));
    });

    test('dose can be updated (e.g., changed from missed to taken)', () async {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      final medication = med_entity.Medication(
        id: 'med-test-004',
        profileId: 'default',
        name: 'Test Med',
        dosage: '50mg',
        frequency:
            med_entity.MedicationFrequency.daily(timesOfDay: const [480]),
        isCritical: false,
        xpValue: 10,
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.save(medication);

      final scheduledTime =
          DateTime(now.year, now.month, now.day, 8, 0).millisecondsSinceEpoch;

      final dose = dose_entity.DoseRecord(
        id: 'dose-004',
        profileId: 'default',
        medicationId: 'med-test-004',
        scheduledTime: scheduledTime,
        actualTime: null,
        status: dose_entity.DoseStatus.missed,
        reminderId: 'reminder-004',
        createdAt: nowMs,
        updatedAt: nowMs,
      );

      await repository.saveDoseRecord(dose);

      final todayStart =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

      var doses = await repository.getDoseRecordsInRange(
        'med-test-004',
        todayStart,
        todayEnd,
      );

      expect(doses.first.status, equals(dose_entity.DoseStatus.missed));

      final updatedDose = doses.first.copyWith(
        status: dose_entity.DoseStatus.taken,
        actualTime: nowMs,
        updatedAt: nowMs,
      );

      await repository.updateDoseRecord(updatedDose);

      doses = await repository.getDoseRecordsInRange(
        'med-test-004',
        todayStart,
        todayEnd,
      );

      expect(doses.first.status, equals(dose_entity.DoseStatus.taken));
      expect(doses.first.actualTime, isNotNull);
    });
  });
}

double _calculateAdherence(List<dose_entity.DoseRecord> doses) {
  if (doses.isEmpty) return 0.0;

  final takenCount =
      doses.where((d) => d.status == dose_entity.DoseStatus.taken).length;
  return (takenCount / doses.length) * 100;
}
