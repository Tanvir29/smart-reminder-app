/// Use case: Log a daily cycle entry.
///
/// MiniMax fills in: call() that persists entry via CycleRepository,
/// awards XP, and triggers prediction recalculation if enough data.
library;

/// Logs a cycle tracking entry for the current day.
class LogCycleEntry {
  // TODO: MiniMax — inject CycleRepository + GamificationRepository

  const LogCycleEntry();
}
