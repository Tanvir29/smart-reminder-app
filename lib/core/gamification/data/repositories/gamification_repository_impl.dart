/// Concrete GamificationRepository implementation backed by Drift.
///
/// MiniMax fills in: constructor injecting GamificationDao, implement all
/// GamificationRepository methods for XP, streaks, and achievements.
library;

import 'package:smart_reminder_app/core/gamification/domain/entities/xp_event.dart';
import 'package:smart_reminder_app/core/gamification/domain/entities/achievement.dart';
import 'package:smart_reminder_app/core/gamification/domain/entities/streak.dart';
import 'package:smart_reminder_app/core/gamification/domain/repositories/gamification_repository.dart';

/// Drift-backed implementation of [GamificationRepository].
class GamificationRepositoryImpl implements GamificationRepository {
  // TODO: MiniMax — inject GamificationDao

  const GamificationRepositoryImpl();

  @override
  Future<void> recordXpEvent(XpEvent event) async {
    // TODO: MiniMax — implement
  }

  @override
  Future<int> getTotalXp(String profileId) async {
    // TODO: MiniMax — implement
    return 0;
  }

  @override
  Future<Streak?> getCurrentStreak(String profileId) async {
    // TODO: MiniMax — implement
    return null;
  }

  @override
  Future<List<Achievement>> getUnlockedAchievements(String profileId) async {
    // TODO: MiniMax — implement
    return [];
  }

  @override
  Future<void> unlockAchievement(
    String profileId,
    Achievement achievement,
  ) async {
    // TODO: MiniMax — implement
  }

  @override
  Future<void> updateStreak(Streak streak) async {
    // TODO: MiniMax — implement
  }
}
