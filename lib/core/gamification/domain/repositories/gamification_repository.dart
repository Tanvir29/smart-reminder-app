/// Abstract repository for gamification data operations.
///
/// MiniMax fills in: methods for XP recording, streak updates,
/// achievement unlocking, leaderboard queries.
library;

import 'package:smart_reminder_app/core/gamification/domain/entities/xp_event.dart';
import 'package:smart_reminder_app/core/gamification/domain/entities/achievement.dart';
import 'package:smart_reminder_app/core/gamification/domain/entities/streak.dart';

/// Contract for gamification persistence.
abstract class GamificationRepository {
  Future<void> recordXpEvent(XpEvent event);
  Future<int> getTotalXp(String profileId);
  Future<Streak?> getCurrentStreak(String profileId);
  Future<List<Achievement>> getUnlockedAchievements(String profileId);
  Future<void> unlockAchievement(String profileId, Achievement achievement);
  Future<void> updateStreak(Streak streak);
}
