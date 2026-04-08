/// Use case: Request confirmation for a reminder.
///
/// Transitions to [ReminderStatus.confirmationRequired], starting the
/// confirmation window. The user must then prove interaction (swipe/tap-3x)
/// within the confirmation window (default 30s).
///
/// This is step 1 of the two-phase confirmation flow:
/// 1. [ConfirmReminder] transitions triggered -> confirmationRequired
/// 2. [FinalizeConfirmation] transitions confirmationRequired -> logged
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';

/// Requests confirmation, transitioning the reminder to confirmationRequired.
///
/// Per spec §5.3: The user taps "Done" to enter confirmationRequired,
/// then must prove interaction within confirmationWindowSeconds (default 30s).
class ConfirmReminder {
  final ReminderRepository _repository;

  const ConfirmReminder({
    required ReminderRepository repository,
  })  : _repository = repository;

  /// Transitions the reminder to [ReminderStatus.confirmationRequired],
  /// starting the confirmation window.
  ///
  /// Returns the updated reminder with the confirmation timestamp.
  /// The caller is responsible for starting the confirmation window timer.
  ///
  /// Throws [StateError] if the reminder is not in triggered or escalating status.
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    if (reminder.status != ReminderStatus.triggered &&
        reminder.status != ReminderStatus.escalating) {
      throw StateError(
        'Invalid state: cannot confirm from ${reminder.status}',
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    final confirming = reminder.copyWith(
      status: ReminderStatus.confirmationRequired,
      updatedAt: now,
    );

    await _repository.save(confirming);

    await _repository.logEvent(
      reminderId: reminderId,
      eventType: 'confirmation_requested',
      eventTimestamp: now,
    );

    return confirming;
  }
}
