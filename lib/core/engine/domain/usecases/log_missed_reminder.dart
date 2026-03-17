/// Use case: Log a missed reminder after escalation exhaustion.
///
/// MiniMax fills in: transition to missed, dismiss notifications,
/// record timestamp.
library;

/// Marks a reminder as missed after all escalation attempts.
class LogMissedReminder {
  // TODO: MiniMax — inject ReminderRepository

  const LogMissedReminder();
}
