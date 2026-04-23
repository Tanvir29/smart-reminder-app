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
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/notification_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/voice_port.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/dose_query_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_next_reminder.dart';

/// Lazily constructs notification body and voice payload when an alarm fires.
class HandleAlarmFired {
  final ReminderRepository _reminderRepository;
  final DoseQueryPort _doseQueryPort;
  final NotificationPort _notificationPort;
  final VoicePort _voicePort;
  final AlarmPort _alarmPort;
  final ScheduleNextReminder _scheduleNextReminder;

  const HandleAlarmFired({
    required ReminderRepository reminderRepository,
    required DoseQueryPort doseQueryPort,
    required NotificationPort notificationPort,
    required VoicePort voicePort,
    required AlarmPort alarmPort,
    required ScheduleNextReminder scheduleNextReminder,
  })  : _reminderRepository = reminderRepository,
        _doseQueryPort = doseQueryPort,
        _notificationPort = notificationPort,
        _voicePort = voicePort,
        _alarmPort = alarmPort,
        _scheduleNextReminder = scheduleNextReminder;

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

      // 4. Lazily fetch medication data from DoseRecords via DoseQueryPort
      final doseQueryResults =
          await _doseQueryPort.getDoseRecordsForReminder(reminder.id);

      final medicationIds =
          doseQueryResults.map((d) => d.medicationId).toList();
      final medicationInfos =
          await _doseQueryPort.getMedicationInfos(medicationIds);

      final itemNames = <String>[];
      final customMessages = <String?>[];

      for (final medInfo in medicationInfos) {
        itemNames.add(medInfo.name);
        customMessages.add(medInfo.reminderMessage);
      }

      // 5. Build dynamic notification body (§7.3)
      final title = isEscalating ? 'URGENT: ${reminder.title}' : reminder.title;
      final body = itemNames.isEmpty
          ? reminder.body ?? 'Medication reminder'
          : 'Time for: ${itemNames.join(', ')}';

      // 6. Show notification with Snooze All / View Take action buttons
      await _notificationPort.showMedicationReminder(
        id: alarmId,
        title: title,
        body: body,
        payload: reminder.id,
        isCritical: isEscalating,
      );

      // 7. Speak announcement via TTS (§7.4)
      if (itemNames.isNotEmpty ||
          customMessages.any((m) => m != null && m.isNotEmpty)) {
        await _voicePort.speakAnnouncement(
          slotName: reminder.title,
          itemNames: itemNames,
          customMessages: customMessages,
        );
      }

      // 8. Schedule escalation-check alarm (§5.3 — response window timer)
      await _alarmPort.scheduleEscalationCheck(
        reminder.id,
        Duration(seconds: reminder.policy.responseWindowSeconds),
      );
    }

    await _scheduleNextReminder();
  }
}
