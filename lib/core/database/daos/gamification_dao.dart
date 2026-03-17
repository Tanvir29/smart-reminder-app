import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/gamification_tables.dart';

part 'gamification_dao.g.dart';

@DriftAccessor(tables: [XpEvents, Streaks, Achievements])
class GamificationDao extends DatabaseAccessor<AppDatabase>
    with _$GamificationDaoMixin {
  GamificationDao(super.db);

  Future<void> recordXpEvent(XpEventsCompanion event) =>
      db.into(xpEvents).insert(event);

  Future<int> getTotalXp(String profileId) async {
    final events = await (db.select(
      xpEvents,
    )..where((e) => e.profileId.equals(profileId))).get();
    int total = 0;
    for (final event in events) {
      total += event.xpAmount;
    }
    return total;
  }

  Future<List<XpEvent>> getXpEventsByProfile(String profileId) =>
      (db.select(xpEvents)
            ..where((e) => e.profileId.equals(profileId))
            ..orderBy([(e) => OrderingTerm.desc(e.createdAt)]))
          .get();

  Future<List<XpEvent>> getXpEventsBySource(
    String profileId,
    String sourceEntityId,
    String sourceEntityType,
  ) =>
      (db.select(xpEvents)
            ..where((e) => e.profileId.equals(profileId))
            ..where((e) => e.sourceEntityId.equals(sourceEntityId))
            ..where((e) => e.sourceEntityType.equals(sourceEntityType)))
          .get();

  Future<Streak?> getStreak(String profileId, String streakType) =>
      (db.select(streaks)
            ..where((s) => s.profileId.equals(profileId))
            ..where((s) => s.streakType.equals(streakType)))
          .getSingleOrNull();

  Future<List<Streak>> getAllStreaks(String profileId) =>
      (db.select(streaks)..where((s) => s.profileId.equals(profileId))).get();

  Future<void> createStreak(StreaksCompanion streak) =>
      db.into(streaks).insert(streak);

  Future<void> updateStreak(Streak streak) =>
      db.update(streaks).replace(streak);

  Future<List<Achievement>> getAchievements(String profileId) =>
      (db.select(achievements)
            ..where((a) => a.profileId.equals(profileId))
            ..orderBy([(a) => OrderingTerm.asc(a.title)]))
          .get();

  Future<List<Achievement>> getLockedAchievements(String profileId) =>
      (db.select(achievements)
            ..where((a) => a.profileId.equals(profileId))
            ..where((a) => a.unlockedAt.isNull()))
          .get();

  Future<List<Achievement>> getUnlockedAchievements(String profileId) =>
      (db.select(achievements)
            ..where((a) => a.profileId.equals(profileId))
            ..where((a) => a.unlockedAt.isNotNull()))
          .get();

  Future<Achievement?> getAchievementByKey(
    String profileId,
    String achievementKey,
  ) =>
      (db.select(achievements)
            ..where((a) => a.profileId.equals(profileId))
            ..where((a) => a.achievementKey.equals(achievementKey)))
          .getSingleOrNull();

  Future<void> unlockAchievement(String id, int timestamp) async {
    await (db.update(achievements)..where((a) => a.id.equals(id))).write(
      AchievementsCompanion(
        unlockedAt: Value(timestamp),
        updatedAt: Value(timestamp),
      ),
    );
  }

  Future<void> seedAchievements(
    List<AchievementsCompanion> achievementList,
  ) async {
    await db.batch((batch) {
      batch.insertAll(
        achievements,
        achievementList,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }
}
