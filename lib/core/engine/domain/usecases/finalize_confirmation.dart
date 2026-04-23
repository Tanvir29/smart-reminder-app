/// Use case: Finalize a confirmation after user interaction proof.
///
/// Transitions from [ReminderStatus.confirmationRequired] to [ReminderStatus.logged],
/// records adherence timestamp, stops any active alarm, and stubs gamification XP award.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_next_reminder.dart';

/// Finalizes a confirmation after the user has proven interaction.
///
/// This is the second step in the two-phase confirmation flow:
/// 1. [ConfirmReminder] transitions triggered -> confirmationRequired
/// 2. [FinalizeConfirmation] transitions confirmationRequired -> logged
///
/// Per spec §5.3: The confirmationRequired state requires interaction proof
/// (swipe-to-confirm or tap-3x) within the confirmationWindowSeconds (default 30s).
class FinalizeConfirmation {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;
  final ScheduleNextReminder _scheduleNextReminder;

  const FinalizeConfirmation({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
    required ScheduleNextReminder scheduleNextReminder,
  })  : _repository = repository,
        _alarmPort = alarmPort,
        _scheduleNextReminder = scheduleNextReminder;

  /// Finalizes the confirmation, transitioning from [ReminderStatus.confirmationRequired]
  /// to [ReminderStatus.logged].
  ///
  /// Throws [StateError] if the reminder is not in confirmationRequired status.
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    if (reminder.status != ReminderStatus.confirmationRequired) {
      throw StateError(
        'Invalid state transition: expected confirmationRequired, got ${reminder.status}',
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    // Stop any active alarm for this reminder
    await _alarmPort.stopAlarm(reminder.id.hashCode);

    // Cancel any pending escalation-check alarm
    await _alarmPort.cancelEscalationCheck(reminderId);

    final logged = reminder.copyWith(
      status: ReminderStatus.logged,
      completedAt: now,
      updatedAt: now,
    );

    await _repository.save(logged);

    await _repository.logEvent(
      reminderId: reminderId,
      eventType: 'confirmed',
      eventTimestamp: now,
    );

    await _scheduleNextReminder();

    return logged;
  }
}
