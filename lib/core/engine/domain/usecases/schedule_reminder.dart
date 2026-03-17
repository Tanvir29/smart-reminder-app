/// Use case: Schedule a new reminder with the native AlarmManager.
///
/// MiniMax fills in: call() method that creates reminder entity,
/// persists it, and calls AlarmChannel.scheduleExactAlarm().
library;

/// Schedules a reminder and registers an exact alarm.
class ScheduleReminder {
  // TODO: MiniMax — inject ReminderRepository + AlarmChannel

  const ScheduleReminder();
}
