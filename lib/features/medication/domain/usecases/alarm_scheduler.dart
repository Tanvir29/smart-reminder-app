import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

class AlarmScheduler {
  final AlarmPort _alarmPort;

  const AlarmScheduler({
    required AlarmPort alarmPort,
  }) : _alarmPort = alarmPort;

  Future<void> scheduleAlarm({
    required Reminder reminder,
    required String slotName,
    String? reminderMessage,
  }) async {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      reminder.scheduledTime,
    );
    await _alarmPort.setAlarm(
      id: reminder.id.hashCode,
      dateTime: dateTime,
      notificationTitle: slotName,
      notificationBody: 'Preparing your reminder...',
    );
  }
}
