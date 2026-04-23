library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/helpers/slot_name_helper.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

class ScheduleNextReminder {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const ScheduleNextReminder({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  Future<Reminder?> call() async {
    final upcoming = await _repository.getUpcoming(limit: 1);
    if (upcoming.isEmpty) return null;

    final next = upcoming.first;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(next.scheduledTime);
    final hour = dateTime.hour;

    await _alarmPort.setAlarm(
      id: next.id.hashCode,
      dateTime: dateTime,
      notificationTitle: getSlotName(hour),
      notificationBody: 'Preparing your reminder...',
    );
    return next;
  }
}
