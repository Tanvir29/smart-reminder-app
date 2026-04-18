/// Use case: Log a missed reminder after escalation exhaustion.
///
/// Transitions to [ReminderStatus.missed], stops all alarms/notifications,
/// and records the miss timestamp.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

/// Marks a reminder as missed after all escalation attempts.
class LogMissedReminder {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const LogMissedReminder({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  /// Marks the reminder identified by [reminderId] as [ReminderStatus.missed].
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    // Stop any active alarm
    await _alarmPort.stopAlarm(reminder.id.hashCode);

    // Cancel any pending escalation-check alarm
    await _alarmPort.cancelEscalationCheck(reminderId);

    final missed = reminder.copyWith(
      status: ReminderStatus.missed,
      updatedAt: now,
    );

    await _repository.save(missed);

    await _repository.logEvent(
      reminderId: reminderId,
      eventType: 'missed',
      eventTimestamp: now,
    );

    return missed;
  }
}
