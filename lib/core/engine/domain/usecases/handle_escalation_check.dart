import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

class HandleEscalationCheck {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const HandleEscalationCheck({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  })  : _repository = repository,
        _alarmPort = alarmPort;

  Future<void> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      await _alarmPort.cancelEscalationCheck(reminderId);
      return;
    }

    switch (reminder.status) {
      case ReminderStatus.triggered:
        await _escalate(reminder);

      case ReminderStatus.confirmationRequired:
        await _revertAndEscalate(reminder);

      case ReminderStatus.escalating:
        await _escalate(reminder);

      case ReminderStatus.scheduled:
      case ReminderStatus.snoozed:
      case ReminderStatus.logged:
      case ReminderStatus.missed:
      case ReminderStatus.cancelled:
        await _alarmPort.cancelEscalationCheck(reminderId);
    }
  }

  Future<void> _escalate(Reminder reminder) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final newEscalationCount = reminder.escalationCount + 1;

    if (newEscalationCount > reminder.policy.maxEscalations) {
      await _alarmPort.stopAlarm(reminder.id.hashCode);
      await _alarmPort.cancelEscalationCheck(reminder.id);

      final missed = reminder.copyWith(
        status: ReminderStatus.missed,
        escalationCount: newEscalationCount,
        updatedAt: now,
      );

      await _repository.save(missed);
      await _repository.logEvent(
        reminderId: reminder.id,
        eventType: 'missed',
        eventTimestamp: now,
        metadata: 'All escalation attempts exhausted',
      );
      return;
    }

    final escalated = reminder.copyWith(
      status: ReminderStatus.escalating,
      escalationCount: newEscalationCount,
      updatedAt: now,
    );

    await _repository.save(escalated);

    await _alarmPort.setAlarm(
      id: escalated.id.hashCode,
      dateTime: DateTime.fromMillisecondsSinceEpoch(now),
      notificationTitle: 'Medication Reminder',
      notificationBody: 'Preparing your reminder...',
    );

    await _repository.logEvent(
      reminderId: reminder.id,
      eventType: 'escalated',
      eventTimestamp: now,
      metadata:
          'Escalation #$newEscalationCount/${reminder.policy.maxEscalations}',
    );

    await _alarmPort.scheduleEscalationCheck(
      reminder.id,
      Duration(seconds: reminder.policy.escalationIntervalSeconds),
    );
  }

  Future<void> _revertAndEscalate(Reminder reminder) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final reverted = reminder.copyWith(
      status: ReminderStatus.triggered,
      updatedAt: now,
    );

    await _repository.save(reverted);
    await _repository.logEvent(
      reminderId: reminder.id,
      eventType: 'confirmation_timeout',
      eventTimestamp: now,
      metadata: 'Confirmation window expired, reverting to triggered',
    );

    await _escalate(reverted);
  }
}
