/// Use case: Handle a user snooze action.
///
/// MiniMax fills in: increment snooze_count, check max_snoozes,
/// cancel old alarm, schedule new alarm with increased delay.
library;

/// Handles snooze: cancels current alarm, reschedules with delay.
class HandleSnooze {
  // TODO: MiniMax — inject ReminderRepository + AlarmChannel

  const HandleSnooze();
}
