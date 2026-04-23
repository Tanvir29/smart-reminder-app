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

  /// Schedules an escalation-check alarm for [reminderId] after [delay].
  ///
  /// The escalation check alarm uses a deterministic ID derived from
  /// [reminderId] so it can be cancelled later. When this alarm fires,
  /// the handler checks the reminder's current status and escalates
  /// if no user response was received (§5.3).
  Future<bool> scheduleEscalationCheck(
    String reminderId,
    Duration delay,
  );

  /// Cancels any pending escalation-check alarm for [reminderId].
  Future<void> cancelEscalationCheck(String reminderId);

  /// Looks up the reminderId associated with an escalation alarm [alarmId].
  ///
  /// Returns `null` if [alarmId] is not an escalation-check alarm.
  /// Used by the alarm ring handler to route escalation vs. regular alarms.
  String? getReminderIdForEscalationAlarm(int alarmId);
}
