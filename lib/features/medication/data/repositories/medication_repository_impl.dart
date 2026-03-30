/// Concrete implementation of [MedicationRepository] using Drift.
library;

import 'package:smart_reminder_app/core/database/daos/medication_dao.dart';
import 'package:smart_reminder_app/features/medication/data/mappers/medication_mapper.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

/// Drift-backed medication repository.
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationDao _dao;
  final MedicationMapper _mapper;

  MedicationRepositoryImpl(this._dao, this._mapper);

  // ── Medication CRUD ────────────────────────────────────────

  @override
  Future<void> save(Medication medication) async {
    final existing = await _dao.getMedicationById(medication.id);
    if (existing != null) {
      await _dao.updateMedication(
        _mapper.toMedicationSchemaForUpdate(medication),
      );
    } else {
      await _dao.insertMedication(_mapper.toMedicationSchema(medication));
    }
  }

  @override
  Future<Medication?> getById(String id) async {
    final schema = await _dao.getMedicationById(id);
    return schema != null ? _mapper.toMedicationEntity(schema) : null;
  }

  @override
  Future<List<Medication>> getActive() async {
    final schemas = await _dao.getActiveMedications();
    return schemas.map(_mapper.toMedicationEntity).toList();
  }

  @override
  Future<void> archive(String id) async {
    await _dao.archiveMedication(id);
  }

  // ── DoseRecord operations ──────────────────────────────────

  @override
  Future<void> saveDoseRecord(DoseRecord doseRecord) async {
    await _dao.recordDose(_mapper.toDoseSchema(doseRecord));
  }

  @override
  Future<void> updateDoseRecord(DoseRecord doseRecord) async {
    await _dao.updateDoseRecord(_mapper.toDoseSchemaForUpdate(doseRecord));
  }

  @override
  Future<List<DoseRecord>> getDoseRecordsByMedication(
    String medicationId,
  ) async {
    final schemas = await _dao.getDoseRecordsByMedication(medicationId);
    return schemas.map(_mapper.toDoseEntity).toList();
  }

  @override
  Future<List<DoseRecord>> getDoseRecordsInRange(
    String medicationId,
    int startTime,
    int endTime,
  ) async {
    final schemas = await _dao.getDoseRecordsInRange(
      medicationId,
      DateTime.fromMillisecondsSinceEpoch(startTime),
      DateTime.fromMillisecondsSinceEpoch(endTime),
    );
    return schemas.map(_mapper.toDoseEntity).toList();
  }

  @override
  Future<List<DoseRecord>> getDoseRecordsByReminder(String reminderId) async {
    final schemas = await _dao.getDoseRecordsByReminder(reminderId);
    return schemas.map(_mapper.toDoseEntity).toList();
  }
}
