/// Concrete CycleRepository implementation backed by Drift.
///
/// MiniMax fills in: constructor injecting CycleDao, implement all
/// CycleRepository methods mapping between domain entities and models.
library;

import 'package:smart_reminder_app/features/cycle/domain/entities/cycle_entry.dart';
import 'package:smart_reminder_app/features/cycle/domain/entities/cycle_prediction.dart';
import 'package:smart_reminder_app/features/cycle/domain/repositories/cycle_repository.dart';

/// Drift-backed implementation of [CycleRepository].
class CycleRepositoryImpl implements CycleRepository {
  // TODO: MiniMax — inject CycleDao

  const CycleRepositoryImpl();

  @override
  Future<void> logEntry(CycleEntry entry) async {
    // TODO: MiniMax — implement
  }

  @override
  Future<CycleEntry?> getById(String id) async {
    // TODO: MiniMax — implement
    return null;
  }

  @override
  Future<List<CycleEntry>> getEntriesInRange(
    DateTime start,
    DateTime end,
  ) async {
    // TODO: MiniMax — implement
    return [];
  }

  @override
  Future<List<CyclePrediction>> getPredictions() async {
    // TODO: MiniMax — implement
    return [];
  }

  @override
  Future<void> savePrediction(CyclePrediction prediction) async {
    // TODO: MiniMax — implement
  }
}
