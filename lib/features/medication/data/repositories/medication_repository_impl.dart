/// Concrete implementation of [MedicationRepository] using Drift.
///
/// MiniMax fills in: CRUD on medications and dose_records tables.
library;

import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

/// Drift-backed medication repository.
class MedicationRepositoryImpl implements MedicationRepository {
  // TODO: MiniMax — inject AppDatabase or MedicationDao

  @override
  Future<void> save(Medication medication) async => throw UnimplementedError();

  @override
  Future<Medication?> getById(String id) async => throw UnimplementedError();

  @override
  Future<List<Medication>> getActive() async => throw UnimplementedError();

  @override
  Future<void> archive(String id) async => throw UnimplementedError();
}
