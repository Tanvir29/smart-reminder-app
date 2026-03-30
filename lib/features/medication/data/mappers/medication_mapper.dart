/// Bidirectional mapper: Medication/DoseRecord entities <-> Drift schemas.
library;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart' as db;
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart'
    as dose;
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart'
    as med;

/// Maps between Medication/DoseRecord domain entities and Drift schemas.
class MedicationMapper {
  MedicationMapper();

  // ── Medication: DB → Entity ────────────────────────────────

  med.Medication toMedicationEntity(db.Medication schema) {
    return med.Medication(
      id: schema.id,
      profileId: schema.profileId,
      name: schema.name,
      dosage: schema.dosage,
      frequency: med.MedicationFrequency.fromJson(
        jsonDecode(schema.frequency) as Map<String, dynamic>,
      ),
      instructions: schema.instructions,
      reminderMessage: schema.reminderMessage,
      reminderDuration: med.ReminderDuration.fromJson(
        jsonDecode(schema.reminderDuration) as Map<String, dynamic>,
      ),
      isCritical: schema.isCritical,
      iconName: schema.iconName,
      colorHex: schema.colorHex,
      isActive: schema.isActive,
      createdAt: schema.createdAt,
      updatedAt: schema.updatedAt,
      archivedAt: schema.archivedAt,
      syncStatus: schema.syncStatus,
      xpValue: schema.xpValue,
    );
  }

  // ── Medication: Entity → Companion (insert) ────────────────

  db.MedicationsCompanion toMedicationSchema(med.Medication medication) {
    return db.MedicationsCompanion(
      id: Value(medication.id),
      profileId: Value(medication.profileId),
      name: Value(medication.name),
      dosage: Value(medication.dosage),
      frequency: Value(jsonEncode(medication.frequency.toJson())),
      instructions: Value(medication.instructions),
      reminderMessage: Value(medication.reminderMessage),
      reminderDuration: Value(jsonEncode(medication.reminderDuration.toJson())),
      isCritical: Value(medication.isCritical),
      iconName: Value(medication.iconName),
      colorHex: Value(medication.colorHex),
      isActive: Value(medication.isActive),
      createdAt: Value(medication.createdAt),
      updatedAt: Value(medication.updatedAt),
      archivedAt: Value(medication.archivedAt),
      syncStatus: Value(medication.syncStatus),
      xpValue: Value(medication.xpValue),
    );
  }

  // ── Medication: Entity → Data class (update/replace) ───────

  db.Medication toMedicationSchemaForUpdate(med.Medication medication) {
    return db.Medication(
      id: medication.id,
      profileId: medication.profileId,
      name: medication.name,
      dosage: medication.dosage,
      frequency: jsonEncode(medication.frequency.toJson()),
      instructions: medication.instructions,
      reminderMessage: medication.reminderMessage,
      reminderDuration: jsonEncode(medication.reminderDuration.toJson()),
      isCritical: medication.isCritical,
      iconName: medication.iconName,
      colorHex: medication.colorHex,
      isActive: medication.isActive,
      createdAt: medication.createdAt,
      updatedAt: medication.updatedAt,
      archivedAt: medication.archivedAt,
      syncStatus: medication.syncStatus,
      xpValue: medication.xpValue,
    );
  }

  // ── DoseRecord: DB → Entity ────────────────────────────────

  dose.DoseRecord toDoseEntity(db.DoseRecord schema) {
    return dose.DoseRecord(
      id: schema.id,
      profileId: schema.profileId,
      medicationId: schema.medicationId,
      scheduledTime: schema.scheduledTime,
      actualTime: schema.actualTime,
      status: dose.DoseStatus.values.firstWhere(
        (s) => s.name == schema.status,
        orElse: () => dose.DoseStatus.missed,
      ),
      reminderId: schema.reminderId,
      notes: schema.notes,
      createdAt: schema.createdAt,
      updatedAt: schema.updatedAt,
      syncStatus: schema.syncStatus,
      xpValue: schema.xpValue,
    );
  }

  // ── DoseRecord: Entity → Companion (insert) ────────────────

  db.DoseRecordsCompanion toDoseSchema(dose.DoseRecord doseRecord) {
    return db.DoseRecordsCompanion(
      id: Value(doseRecord.id),
      profileId: Value(doseRecord.profileId),
      medicationId: Value(doseRecord.medicationId),
      scheduledTime: Value(doseRecord.scheduledTime),
      actualTime: Value(doseRecord.actualTime),
      status: Value(doseRecord.status.name),
      reminderId: Value(doseRecord.reminderId),
      notes: Value(doseRecord.notes),
      createdAt: Value(doseRecord.createdAt),
      updatedAt: Value(doseRecord.updatedAt),
      syncStatus: Value(doseRecord.syncStatus),
      xpValue: Value(doseRecord.xpValue),
    );
  }

  // ── DoseRecord: Entity → Data class (update/replace) ───────

  db.DoseRecord toDoseSchemaForUpdate(dose.DoseRecord doseRecord) {
    return db.DoseRecord(
      id: doseRecord.id,
      profileId: doseRecord.profileId,
      medicationId: doseRecord.medicationId,
      scheduledTime: doseRecord.scheduledTime,
      actualTime: doseRecord.actualTime,
      status: doseRecord.status.name,
      reminderId: doseRecord.reminderId,
      notes: doseRecord.notes,
      createdAt: doseRecord.createdAt,
      updatedAt: doseRecord.updatedAt,
      syncStatus: doseRecord.syncStatus,
      xpValue: doseRecord.xpValue,
    );
  }
}
