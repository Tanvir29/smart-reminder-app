/// Use case: Handle an alarm firing — lazy notification + voice construction.
///
/// When a hardware alarm fires, this use case:
/// 1. Queries the database by scheduledTime to find the matching reminder(s).
/// 2. Fetches associated DoseRecords and Medication entities.
/// 3. Builds a dynamic notification body ("Time for: Prozac, Vitamin D").
/// 4. Calls NotificationService.showMedicationReminder with action buttons.
/// 5. Calls VoiceService.speakMedicationAnnouncement with TTS data.
/// 6. Transitions the reminder from scheduled → triggered.
///
/// This implements the LAZY approach: all notification/voice data is
/// constructed at alarm-fire-time from the database, not cached at
/// schedule-time. This avoids synchronization nightmares when medications
/// are edited/deleted/renamed.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';
import 'package:smart_reminder_app/core/platform/voice_service.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

/// Lazily constructs notification body and voice payload when an alarm fires.
class HandleAlarmFired {
  final ReminderRepository _reminderRepository;
  final MedicationRepository _medicationRepository;
  final NotificationService _notificationService;
  final VoiceService _voiceService;

  const HandleAlarmFired({
    required ReminderRepository reminderRepository,
    required MedicationRepository medicationRepository,
    required NotificationService notificationService,
    required VoiceService voiceService,
  })  : _reminderRepository = reminderRepository,
        _medicationRepository = medicationRepository,
        _notificationService = notificationService,
        _voiceService = voiceService;

  /// Statuses that should be processed when the alarm fires.
  static const _actionableStatuses = {
    ReminderStatus.scheduled,
    ReminderStatus.snoozed,
    ReminderStatus.escalating,
  };

  /// Called when a hardware alarm fires.
  ///
  /// [alarmId] — the alarm's integer ID.
  /// [alarmDateTime] — the alarm's scheduled DateTime (from AlarmSettings).
  ///
  /// Uses [alarmDateTime] to query the database for reminders at that
  /// exact scheduledTime, then lazily constructs the notification body
  /// and voice payload from the current medication data.
  Future<void> call(int alarmId, DateTime alarmDateTime) async {
    final scheduledTime = alarmDateTime.millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Find reminders at this scheduled time
    final reminders =
        await _reminderRepository.getByScheduledTime(scheduledTime);

    if (reminders.isEmpty) return;

    // 2. Process each actionable reminder at this time slot
    for (final reminder in reminders) {
      if (!_actionableStatuses.contains(reminder.status)) continue;

      final isEscalating = reminder.status == ReminderStatus.escalating;

      // 3. Transition to triggered
      await _reminderRepository.updateStatus(
        reminder.id,
        ReminderStatus.triggered,
      );
      await _reminderRepository.logEvent(
        reminderId: reminder.id,
        eventType: 'triggered',
        eventTimestamp: now,
      );

      // 4. Lazily fetch medication data from DoseRecords
      final doseRecords =
          await _medicationRepository.getDoseRecordsByReminder(reminder.id);

      final itemNames = <String>[];
      final customMessages = <String?>[];

      for (final dose in doseRecords) {
        final medication =
            await _medicationRepository.getById(dose.medicationId);
        if (medication != null) {
          itemNames.add(medication.name);
          customMessages.add(medication.reminderMessage);
        }
      }

      // 5. Build dynamic notification body (§7.3)
      final title = isEscalating ? 'URGENT: ${reminder.title}' : reminder.title;
      final body = itemNames.isEmpty
          ? reminder.body ?? 'Medication reminder'
          : 'Time for: ${itemNames.join(', ')}';

      // 6. Show notification with Snooze All / View Take action buttons
      await _notificationService.showMedicationReminder(
        id: alarmId,
        title: title,
        body: body,
        payload: reminder.id,
        isCritical: isEscalating,
      );

      // 7. Speak announcement via TTS (§7.4)
      if (itemNames.isNotEmpty ||
          customMessages.any((m) => m != null && m.isNotEmpty)) {
        await _voiceService.speakAnnouncement(
          slotName: reminder.title,
          itemNames: itemNames,
          customMessages: customMessages,
        );
      }
    }
  }
}
