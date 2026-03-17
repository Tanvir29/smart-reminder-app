/// Use case: Escalate a reminder when no response is received.
///
/// MiniMax fills in: fire escalation notification, increment escalation_count,
/// check max_escalations, transition to missed if exhausted.
library;

/// Escalates a reminder to more aggressive notification mode.
class EscalateReminder {
  // TODO: MiniMax — inject ReminderRepository + AlarmChannel

  const EscalateReminder();
}
