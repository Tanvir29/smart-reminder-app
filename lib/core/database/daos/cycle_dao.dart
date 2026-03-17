import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/cycle_tables.dart';

part 'cycle_dao.g.dart';

@DriftAccessor(tables: [CycleEntries, CyclePredictions])
class CycleDao extends DatabaseAccessor<AppDatabase> with _$CycleDaoMixin {
  CycleDao(super.db);

  Future<List<CycleEntry>> getAllCycleEntries() =>
      db.select(cycleEntries).get();

  Future<CycleEntry?> getCycleEntryById(String id) => (db.select(
    cycleEntries,
  )..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<CycleEntry?> getCycleEntryByDate(String profileId, String date) =>
      (db.select(cycleEntries)
            ..where((c) => c.profileId.equals(profileId))
            ..where((c) => c.date.equals(date)))
          .getSingleOrNull();

  Future<List<CycleEntry>> getCycleEntriesByProfile(String profileId) =>
      (db.select(cycleEntries)
            ..where((c) => c.profileId.equals(profileId))
            ..orderBy([(c) => OrderingTerm.desc(c.date)]))
          .get();

  Future<List<CycleEntry>> getCycleEntriesInRange(
    String profileId,
    String startDate,
    String endDate,
  ) =>
      (db.select(cycleEntries)
            ..where((c) => c.profileId.equals(profileId))
            ..where((c) => c.date.isBiggerOrEqualValue(startDate))
            ..where((c) => c.date.isSmallerOrEqualValue(endDate))
            ..orderBy([(c) => OrderingTerm.asc(c.date)]))
          .get();

  Future<void> insertCycleEntry(CycleEntriesCompanion entry) =>
      db.into(cycleEntries).insert(entry);

  Future<void> updateCycleEntry(CycleEntry entry) =>
      db.update(cycleEntries).replace(entry);

  Future<void> deleteCycleEntry(String id) =>
      (db.delete(cycleEntries)..where((c) => c.id.equals(id))).go();

  Future<void> savePrediction(CyclePredictionsCompanion prediction) =>
      db.into(cyclePredictions).insert(prediction);

  Future<void> updatePrediction(CyclePrediction prediction) =>
      db.update(cyclePredictions).replace(prediction);

  Future<CyclePrediction?> getCurrentPrediction(String profileId) =>
      (db.select(cyclePredictions)
            ..where((p) => p.profileId.equals(profileId))
            ..where((p) => p.invalidatedAt.isNull())
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<CyclePrediction>> getPredictions(String profileId) =>
      (db.select(cyclePredictions)
            ..where((p) => p.profileId.equals(profileId))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();

  Future<void> invalidatePrediction(String id) async {
    await (db.update(cyclePredictions)..where((p) => p.id.equals(id))).write(
      CyclePredictionsCompanion(
        invalidatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
