/// Reminder lifecycle states for the state machine.
///
/// See spec §5.1 for full state definitions and §5.3 for transition rules.
library;

/// All possible states in the reminder lifecycle.
enum ReminderStatus {
  /// Future alarm set. Waiting for trigger time.
  scheduled,

  /// Alarm fired. Notification shown. Awaiting user action.
  triggered,

  /// User requested delay. Re-scheduled with escalation increment.
  snoozed,

  /// Max snoozes reached OR no response. Aggressive notification mode.
  escalating,

  /// User tapped "Done" but confirmation logic demands proof.
  confirmationRequired,

  /// Successfully confirmed. Adherence recorded.
  logged,

  /// Escalation exhausted. No confirmation. Logged as missed.
  missed,

  /// User or system cancelled this reminder instance.
  cancelled,
}
