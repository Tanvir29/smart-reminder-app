/// State definitions for GamificationNotifier.
///
/// v3: Replaces GamificationState used by the old GamificationCubit.
/// MiniMax fills in: sealed class or union with Loading, Loaded,
/// LevelUp, AchievementUnlocked substates; holds totalXp, level,
/// currentStreak, unlockedAchievements.
library;

/// UI state for the gamification system.
class GamificationState {
  const GamificationState.initial();
}
