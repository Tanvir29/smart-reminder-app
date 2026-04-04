/// Use case: Escalate a reminder when no response is received.
///
/// Transitions to [ReminderStatus.escalating], fires a Level 2 loud alarm,
/// and increments escalation count. If max escalations are exhausted,
/// transitions to [ReminderStatus.missed].
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

/// Escalates a reminder to more aggressive notification mode.
class EscalateReminder {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const EscalateReminder({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  /// Escalates the reminder identified by [reminderId].
  ///
  /// If escalation count exceeds [EscalationPolicy.maxEscalations],
  /// the reminder is marked as [ReminderStatus.missed] instead.
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final newEscalationCount = reminder.escalationCount + 1;

    // If max escalations exhausted → mark as missed
    if (newEscalationCount > reminder.policy.maxEscalations) {
      await _alarmPort.stopAlarm(reminder.id.hashCode);

      final missed = reminder.copyWith(
        status: ReminderStatus.missed,
        escalationCount: newEscalationCount,
        updatedAt: now,
      );

      await _repository.save(missed);
      await _repository.logEvent(
        reminderId: reminderId,
        eventType: 'missed',
        eventTimestamp: now,
        metadata: 'All escalation attempts exhausted',
      );

      return missed;
    }

    // Transition to escalating with Level 2 loud alarm
    final escalated = reminder.copyWith(
      status: ReminderStatus.escalating,
      escalationCount: newEscalationCount,
      updatedAt: now,
    );

    await _repository.save(escalated);

    // Fire Level 2 loud alarm (immediate) — HandleAlarmFired will add URGENT prefix
    await _alarmPort.setAlarm(
      id: escalated.id.hashCode,
      dateTime: DateTime.fromMillisecondsSinceEpoch(now),
      notificationTitle: 'Medication Reminder',
      notificationBody: 'Preparing your reminder...',
    );

    await _repository.logEvent(
      reminderId: reminderId,
      eventType: 'escalated',
      eventTimestamp: now,
      metadata:
          'Escalation #$newEscalationCount/${reminder.policy.maxEscalations}',
    );

    return escalated;
  }
}
