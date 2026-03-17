/// Streak domain entity with 36-hour ADHD grace period.
///
/// MiniMax fills in: fields (id, profileId, currentStreak, longestStreak,
/// lastActivityAt, graceWindowHours), streak calculation logic.
library;

/// Tracks consecutive-day streaks with ADHD-friendly grace period.
class Streak {
  // TODO: MiniMax — define fields
  // CRITICAL: 36-hour grace period (not 24h) per ADHD spec

  const Streak();
}
