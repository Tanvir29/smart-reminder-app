/// Riverpod Notifier for gamification UI state management.
///
/// v3: Replaces GamificationCubit. Uses Riverpod Notifier pattern.
/// MiniMax fills in: states (loading, loaded, levelUp, achievementUnlocked),
/// methods calling domain use cases (AwardXp, EvaluateStreak, CheckAchievements).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/core/gamification/presentation/notifiers/gamification_state.dart';

/// Manages gamification UI state including XP, streaks, and achievements.
class GamificationNotifier extends Notifier<GamificationState> {
  // TODO: MiniMax — inject use cases (AwardXp, EvaluateStreak, CheckAchievements)

  @override
  GamificationState build() => const GamificationState.initial();
}
