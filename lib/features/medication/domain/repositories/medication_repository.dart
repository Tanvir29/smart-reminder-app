/// Abstract repository for medication persistence.
library;

import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';

/// Contract for medication data operations.
abstract class MedicationRepository {
  // ── Medication CRUD ────────────────────────────────────────
  Future<void> save(Medication medication);
  Future<Medication?> getById(String id);
  Future<List<Medication>> getActive();
  Future<void> archive(String id);

  // ── DoseRecord operations ──────────────────────────────────
  Future<void> saveDoseRecord(DoseRecord doseRecord);
  Future<void> updateDoseRecord(DoseRecord doseRecord);
  Future<List<DoseRecord>> getDoseRecordsByMedication(String medicationId);
  Future<List<DoseRecord>> getDoseRecordsByReminder(String reminderId);
  Future<List<DoseRecord>> getDoseRecordsInRange(
    String medicationId,
    int startTime,
    int endTime,
  );
}
