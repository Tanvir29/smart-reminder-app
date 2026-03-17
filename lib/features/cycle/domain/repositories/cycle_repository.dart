/// Abstract repository for cycle tracking persistence.
///
/// MiniMax fills in: logEntry, getEntries, getEntriesInRange,
/// getPredictions, savePrediction.
library;

import 'package:smart_reminder_app/features/cycle/domain/entities/cycle_entry.dart';
import 'package:smart_reminder_app/features/cycle/domain/entities/cycle_prediction.dart';

/// Contract for cycle data operations.
abstract class CycleRepository {
  Future<void> logEntry(CycleEntry entry);
  Future<CycleEntry?> getById(String id);
  Future<List<CycleEntry>> getEntriesInRange(DateTime start, DateTime end);
  Future<List<CyclePrediction>> getPredictions();
  Future<void> savePrediction(CyclePrediction prediction);
}
