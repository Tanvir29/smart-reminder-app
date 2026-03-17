/// Abstract repository for medication persistence.
///
/// MiniMax fills in: save, getById, getActive, archive, getAdherenceData.
library;

import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';

/// Contract for medication data operations.
abstract class MedicationRepository {
  Future<void> save(Medication medication);
  Future<Medication?> getById(String id);
  Future<List<Medication>> getActive();
  Future<void> archive(String id);
}
