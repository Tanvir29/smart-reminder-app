/// Use case: Schedule a new reminder with the native AlarmManager.
///
/// Persists the reminder, sets a platform alarm, and logs the event.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

/// Schedules a reminder and registers an exact alarm.
class ScheduleReminder {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const ScheduleReminder({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  /// Persists [reminder] with status [ReminderStatus.scheduled],
  /// registers a platform alarm, and logs the scheduling event.
  Future<Reminder> call(Reminder reminder) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final scheduled = reminder.copyWith(
      status: ReminderStatus.scheduled,
      updatedAt: now,
    );

    await _repository.save(scheduled);

    // Use generic placeholder — HandleAlarmFired will construct
    // the dynamic notification body at alarm-fire-time.
    await _alarmPort.setAlarm(
      id: scheduled.id.hashCode,
      dateTime: DateTime.fromMillisecondsSinceEpoch(scheduled.scheduledTime),
      notificationTitle: 'Medication Reminder',
      notificationBody: 'Preparing your reminder...',
    );

    await _repository.logEvent(
      reminderId: scheduled.id,
      eventType: 'scheduled',
      eventTimestamp: now,
    );

    return scheduled;
  }
}
