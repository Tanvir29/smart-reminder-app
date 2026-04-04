/// Port for hardware alarm scheduling.
///
/// Implemented by AlarmService in the platform layer.
/// This abstraction allows domain use cases to depend on a contract
/// rather than the concrete AlarmService implementation.
abstract class AlarmPort {
  /// Schedules an exact alarm at [dateTime].
  ///
  /// Returns `true` if the alarm was successfully scheduled.
  Future<bool> setAlarm({
    required int id,
    required DateTime dateTime,
    required String notificationTitle,
    required String notificationBody,
  });

  /// Stops/cancels a previously scheduled alarm.
  ///
  /// Returns `true` if the alarm was successfully stopped.
  Future<bool> stopAlarm(int id);

  /// Checks whether an alarm with the given [id] is currently active/scheduled.
  Future<bool> isAlarmActive(int id);
}