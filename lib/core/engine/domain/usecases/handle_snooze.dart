/// Use case: Handle a user snooze action.
///
/// Increments snooze count, calculates escalating delay, and re-schedules
/// the alarm. If max snoozes are reached, transitions to [ReminderStatus.escalating].
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

/// Handles snooze: cancels current alarm, reschedules with increasing delay.
///
/// Snooze delay formula (§5.3):
///   `delay = snoozeBaseDelayMinutes * (snoozeCount + 1)`
/// where `snoozeCount` is the value **after** incrementing.
///
/// If `snoozeCount >= maxSnoozes`, transitions to [ReminderStatus.escalating]
/// instead of [ReminderStatus.snoozed].
class HandleSnooze {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const HandleSnooze({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  /// Executes snooze logic for the reminder identified by [reminderId].
  ///
  /// Returns the updated [Reminder] with new status and snooze count.
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final newSnoozeCount = reminder.snoozeCount + 1;

    // Stop the current alarm
    await _alarmPort.stopAlarm(reminder.id.hashCode);

    // Cancel any pending escalation-check alarm
    await _alarmPort.cancelEscalationCheck(reminderId);

    // §5.3: If snoozeCount >= maxSnoozes → escalate
    if (newSnoozeCount >= reminder.policy.maxSnoozes) {
      final escalated = reminder.copyWith(
        status: ReminderStatus.escalating,
        snoozeCount: newSnoozeCount,
        updatedAt: now,
      );

      await _repository.save(escalated);
      await _repository.logEvent(
        reminderId: reminderId,
        eventType: 'escalating',
        eventTimestamp: now,
        metadata:
            'Max snoozes reached ($newSnoozeCount/${reminder.policy.maxSnoozes})',
      );

      return escalated;
    }

    // Calculate snooze delay: base * (newSnoozeCount + 1)
    final delayMinutes =
        reminder.policy.snoozeBaseDelayMinutes * (newSnoozeCount + 1);
    final newScheduledTime = now + (delayMinutes * 60 * 1000);

    final snoozed = reminder.copyWith(
      status: ReminderStatus.snoozed,
      snoozeCount: newSnoozeCount,
      scheduledTime: newScheduledTime,
      updatedAt: now,
    );

    await _repository.save(snoozed);

    // Re-schedule the alarm with new delay — use generic placeholder
    await _alarmPort.setAlarm(
      id: snoozed.id.hashCode,
      dateTime: DateTime.fromMillisecondsSinceEpoch(newScheduledTime),
      notificationTitle: 'Medication Reminder',
      notificationBody: 'Preparing your reminder...',
    );

    await _repository.logEvent(
      reminderId: reminderId,
      eventType: 'snoozed',
      eventTimestamp: now,
      metadata: 'Snooze #$newSnoozeCount, delay: ${delayMinutes}min',
    );

    return snoozed;
  }
}
