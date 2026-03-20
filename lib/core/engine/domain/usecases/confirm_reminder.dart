/// Use case: Confirm a reminder after user interaction proof.
///
/// Transitions to [ReminderStatus.logged], records adherence timestamp,
/// stops any active alarm, and stubs gamification XP award.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';

/// Confirms a reminder and records it as completed.
class ConfirmReminder {
  final ReminderRepository _repository;
  final AlarmService _alarmService;

  const ConfirmReminder({
    required ReminderRepository repository,
    required AlarmService alarmService,
  })  : _repository = repository,
        _alarmService = alarmService;

  /// Marks the reminder as [ReminderStatus.logged], stops its alarm,
  /// and logs the confirmation event.
  Future<Reminder> call(String reminderId) async {
    final reminder = await _repository.getById(reminderId);
    if (reminder == null) {
      throw ArgumentError('Reminder not found: $reminderId');
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    // Stop any active alarm for this reminder
    await _alarmService.stopAlarm(reminder.id.hashCode);

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

    // TODO: Trigger gamification XP award (§6 — future Phase 3)
    // e.g., gamificationService.awardXp(logged.xpValue);

    return logged;
  }
}
