/// Use case: Undo a recently recorded dose within the 5-second reversal window.
///
/// Per UX contract §10.1, users may reverse a dose recording within 5 seconds.
/// Reverts the DoseRecord status to [DoseStatus.skipped] and restores the
/// linked Reminder to [ReminderStatus.triggered] so the user can re-act.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

/// Reverses a dose recording within the 5-second undo window.
class UndoDose {
  final MedicationRepository _medicationRepository;
  final ReminderRepository _reminderRepository;
  final AlarmService _alarmService;

  /// Maximum elapsed time (in milliseconds) after recording a dose during
  /// which the action can still be reversed.
  static const undoWindowMs = 5000;

  const UndoDose({
    required MedicationRepository medicationRepository,
    required ReminderRepository reminderRepository,
    required AlarmService alarmService,
  })  : _medicationRepository = medicationRepository,
        _reminderRepository = reminderRepository,
        _alarmService = alarmService;

  /// Reverts [doseRecord] if it was created within [undoWindowMs] of now.
  ///
  /// - Marks the DoseRecord as [DoseStatus.skipped] with an undo note.
  /// - Restores the linked Reminder to [ReminderStatus.triggered].
  /// - Re-arms the alarm so the user sees the notification again.
  ///
  /// Throws [StateError] if the undo window has expired.
  Future<void> call(DoseRecord doseRecord) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final elapsed = now - doseRecord.createdAt;

    if (elapsed > undoWindowMs) {
      throw StateError(
        'Undo window expired: ${elapsed}ms elapsed (max ${undoWindowMs}ms)',
      );
    }

    // 1. Mark dose record as skipped (reversal semantic)
    final reverted = doseRecord.copyWith(
      status: DoseStatus.skipped,
      notes: 'Undone by user',
      updatedAt: now,
    );
    await _medicationRepository.updateDoseRecord(reverted);

    // 2. Restore reminder to triggered state
    if (doseRecord.reminderId != null) {
      await _reminderRepository.updateStatus(
        doseRecord.reminderId!,
        ReminderStatus.triggered,
      );

      // 3. Re-arm the alarm so the notification re-appears
      await _alarmService.setAlarm(
        id: doseRecord.reminderId!.hashCode,
        dateTime: DateTime.fromMillisecondsSinceEpoch(doseRecord.scheduledTime),
        notificationTitle: 'Medication Reminder',
        notificationBody: 'Dose undo — please take action',
      );
    }
  }
}
