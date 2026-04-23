import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/medication_tables.dart';

part 'medication_dao.g.dart';

@DriftAccessor(tables: [Medications, DoseRecords])
class MedicationDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationDaoMixin {
  MedicationDao(super.db);

  Future<List<Medication>> getAllMedications() => db.select(medications).get();

  Future<Medication?> getMedicationById(String id) =>
      (db.select(medications)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<List<Medication>> getMedicationsByIds(List<String> ids) =>
      (db.select(medications)..where((m) => m.id.isIn(ids))).get();

  Future<List<Medication>> getActiveMedications() =>
      (db.select(medications)..where((m) => m.isActive.equals(true))).get();

  Future<List<Medication>> getMedicationsByProfile(String profileId) =>
      (db.select(
        medications,
      )..where((m) => m.profileId.equals(profileId)))
          .get();

  Future<void> insertMedication(MedicationsCompanion medication) =>
      db.into(medications).insert(medication);

  Future<void> updateMedication(Medication medication) =>
      db.update(medications).replace(medication);

  Future<void> archiveMedication(String id) async {
    final medication = await getMedicationById(id);
    if (medication != null) {
      await db.update(medications).replace(
            medication.copyWith(
              isActive: false,
              archivedAt: Value(DateTime.now().millisecondsSinceEpoch),
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
    }
  }

  Future<void> deleteMedication(String id) =>
      (db.delete(medications)..where((m) => m.id.equals(id))).go();

  Future<void> recordDose(DoseRecordsCompanion doseRecord) =>
      db.into(doseRecords).insert(doseRecord);

  Future<void> updateDoseRecord(DoseRecord doseRecord) =>
      db.update(doseRecords).replace(doseRecord);

  Future<List<DoseRecord>> getDoseRecordsByMedication(String medicationId) =>
      (db.select(doseRecords)
            ..where((d) => d.medicationId.equals(medicationId))
            ..orderBy([(d) => OrderingTerm.desc(d.scheduledTime)]))
          .get();

  Future<List<DoseRecord>> getDoseRecordsInRange(
    String medicationId,
    DateTime start,
    DateTime end,
  ) =>
      (db.select(doseRecords)
            ..where((d) => d.medicationId.equals(medicationId))
            ..where(
              (d) => d.scheduledTime.isBiggerOrEqualValue(
                start.millisecondsSinceEpoch,
              ),
            )
            ..where(
              (d) => d.scheduledTime.isSmallerOrEqualValue(
                end.millisecondsSinceEpoch,
              ),
            )
            ..orderBy([(d) => OrderingTerm.desc(d.scheduledTime)]))
          .get();

  Future<List<DoseRecord>> getAllDoseRecords() => db.select(doseRecords).get();

  Future<List<DoseRecord>> getDoseRecordsByReminder(String reminderId) =>
      (db.select(doseRecords)
            ..where((d) => d.reminderId.equals(reminderId))
            ..orderBy([(d) => OrderingTerm.desc(d.scheduledTime)]))
          .get();
}
