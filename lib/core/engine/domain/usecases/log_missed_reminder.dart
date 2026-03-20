/// Use case: Log a missed reminder after escalation exhaustion.
///
/// Transitions to [ReminderStatus.missed], stops all alarms/notifications,
/// and records the miss timestamp.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';

/// Marks a reminder as missed after all escalation attempts.
class LogMissedReminder {
  final ReminderRepository _repository;
  final AlarmService _alarmService;

  const LogMissedReminder({
    required ReminderRepository repository,
    required AlarmService alarmService,
  })  : _repository = repository,
        _alarmService = alarmService;

  /// Marks the reminder identified by [reminderId] as [ReminderStatus.missed].
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    // Stop any active alarm
    await _alarmService.stopAlarm(reminder.id.hashCode);

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
