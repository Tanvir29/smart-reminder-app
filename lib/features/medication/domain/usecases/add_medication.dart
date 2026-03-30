/// Use case: Add a new medication and auto-create reminders.
///
/// Persists the medication, generates reminders based on the medication's
/// reminderDuration (7 days, 1 month, continuous, or custom end date),
/// applies escalation policy, and schedules the earliest upcoming alarm.
/// Implements time-slot grouping where multiple medications at the same time
/// share a single Reminder.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:uuid/uuid.dart';

/// Creates a medication and its associated reminders with time-slot grouping.
class AddMedication {
  final MedicationRepository _medicationRepository;
  final ReminderRepository _reminderRepository;
  final AlarmService _alarmService;

  static const _uuid = Uuid();
  static const _oneMonthDays = 30;
  static const _continuousDays = 365 * 10; // 10 years for "continuous"

  const AddMedication({
    required MedicationRepository medicationRepository,
    required ReminderRepository reminderRepository,
    required AlarmService alarmService,
  })  : _medicationRepository = medicationRepository,
        _reminderRepository = reminderRepository,
        _alarmService = alarmService;

  /// Persists [medication], generates [Reminder] entities based on
  /// the medication's reminderDuration field, and schedules the earliest
  /// upcoming alarm.
  ///
  /// Returns the saved medication.
  Future<Medication> call(Medication medication) async {
    await _medicationRepository.save(medication);

    final policy = medication.isCritical
        ? const EscalationPolicy(maxSnoozes: 2)
        : const EscalationPolicy();

    final now = DateTime.now().toUtc();
    final durationDays = _calculateDurationDays(medication.reminderDuration);

    await _generateAndSaveReminders(
      medication: medication,
      policy: policy,
      startDate: now,
      durationDays: durationDays,
    );

    return medication;
  }

  int _calculateDurationDays(ReminderDuration duration) {
    return duration.map(
      fixedDays: (d) => d.days,
      oneMonth: (_) => _oneMonthDays,
      continuous: (_) => _continuousDays,
      custom: (d) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        final diff = d.endTime - now;
        return (diff / (24 * 60 * 60 * 1000)).ceil();
      },
    );
  }

  Future<void> _generateAndSaveReminders({
    required Medication medication,
    required EscalationPolicy policy,
    required DateTime startDate,
    required int durationDays,
  }) async {
    final nowMillis = startDate.millisecondsSinceEpoch;

    final generatedReminders = medication.frequency.map(
      daily: (daily) => _createTimeSlots(
        timesOfDay: daily.timesOfDay,
        startDate: startDate,
        nowMillis: nowMillis,
        durationDays: durationDays,
      ),
      weekly: (weekly) => _createWeeklyTimeSlots(
        timesOfDay: weekly.timesOfDay,
        weekDays: weekly.weekDays,
        startDate: startDate,
        nowMillis: nowMillis,
        durationDays: durationDays,
      ),
      interval: (interval) => _createIntervalTimeSlots(
        intervalHours: interval.intervalHours,
        startDate: startDate,
        nowMillis: nowMillis,
        durationDays: durationDays,
      ),
      asNeeded: (_) => <_TimeSlotData>[],
    );

    Reminder? earliestReminder;
    String? earliestSlotName;

    for (final slotData in generatedReminders) {
      final existingReminders = await _reminderRepository.getByScheduledTime(
        slotData.scheduledTime,
      );

      Reminder reminder;
      if (existingReminders.isNotEmpty) {
        final existing = existingReminders.first;
        reminder = existing.copyWith(
          groupDoseCount: existing.groupDoseCount + 1,
          updatedAt: nowMillis,
        );
        await _reminderRepository.save(reminder);
      } else {
        final slotName = _getSlotName(slotData.hour);
        reminder = Reminder(
          id: _uuid.v4(),
          profileId: 'default',
          type: 'medication',
          title: slotName,
          body: null,
          status: ReminderStatus.scheduled,
          scheduledTime: slotData.scheduledTime,
          groupDoseCount: 1,
          policy: policy,
          createdAt: nowMillis,
          updatedAt: nowMillis,
        );
        await _reminderRepository.save(reminder);
      }

      final doseRecord = DoseRecord(
        id: _uuid.v4(),
        profileId: 'default',
        medicationId: medication.id,
        scheduledTime: slotData.scheduledTime,
        status: DoseStatus.pending,
        reminderId: reminder.id,
        createdAt: nowMillis,
        updatedAt: nowMillis,
      );
      await _medicationRepository.saveDoseRecord(doseRecord);

      if (earliestReminder == null) {
        earliestReminder = reminder;
        earliestSlotName = _getSlotName(slotData.hour);
      }
    }

    if (earliestReminder != null) {
      await _scheduleAlarm(
        reminder: earliestReminder,
        slotName: earliestSlotName!,
        medicationName: medication.name,
        reminderMessage: medication.reminderMessage,
      );
    }
  }

  String _getSlotName(int hour) {
    if (hour >= 5 && hour < 9) return 'Morning Medications';
    if (hour >= 9 && hour < 12) return 'Mid-Morning Medications';
    if (hour >= 12 && hour < 14) return 'Afternoon Medications';
    if (hour >= 14 && hour < 17) return 'Late Afternoon Medications';
    if (hour >= 17 && hour < 21) return 'Evening Medications';
    return 'Night Medications';
  }

  Future<void> _scheduleAlarm({
    required Reminder reminder,
    required String slotName,
    required String medicationName,
    String? reminderMessage,
  }) async {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(reminder.scheduledTime);
    // Use generic placeholders — HandleAlarmFired will construct
    // the dynamic notification body at alarm-fire-time.
    await _alarmService.setAlarm(
      id: reminder.id.hashCode,
      dateTime: dateTime,
      notificationTitle: slotName,
      notificationBody: 'Preparing your reminder...',
      voicePayload: VoicePayload(
        slotName: slotName,
        itemNames: [medicationName],
        customMessages: [reminderMessage],
      ),
    );
  }

  List<_TimeSlotData> _createTimeSlots({
    required List<int> timesOfDay,
    required DateTime startDate,
    required int nowMillis,
    required int durationDays,
  }) {
    final slots = <_TimeSlotData>[];
    for (var dayOffset = 0; dayOffset < durationDays; dayOffset++) {
      final date = startDate.add(Duration(days: dayOffset));
      for (final minutesFromMidnight in timesOfDay) {
        final scheduledDateTime = DateTime.utc(
          date.year,
          date.month,
          date.day,
          minutesFromMidnight ~/ 60,
          minutesFromMidnight % 60,
        );
        if (scheduledDateTime.millisecondsSinceEpoch > nowMillis) {
          slots.add(_TimeSlotData(
            scheduledTime: scheduledDateTime.millisecondsSinceEpoch,
            hour: scheduledDateTime.hour,
          ));
        }
      }
    }
    return slots;
  }

  List<_TimeSlotData> _createWeeklyTimeSlots({
    required List<int> timesOfDay,
    required List<int> weekDays,
    required DateTime startDate,
    required int nowMillis,
    required int durationDays,
  }) {
    final slots = <_TimeSlotData>[];
    for (var dayOffset = 0; dayOffset < durationDays; dayOffset++) {
      final date = startDate.add(Duration(days: dayOffset));
      if (!weekDays.contains(date.weekday)) continue;
      for (final minutesFromMidnight in timesOfDay) {
        final scheduledDateTime = DateTime.utc(
          date.year,
          date.month,
          date.day,
          minutesFromMidnight ~/ 60,
          minutesFromMidnight % 60,
        );
        if (scheduledDateTime.millisecondsSinceEpoch > nowMillis) {
          slots.add(_TimeSlotData(
            scheduledTime: scheduledDateTime.millisecondsSinceEpoch,
            hour: scheduledDateTime.hour,
          ));
        }
      }
    }
    return slots;
  }

  List<_TimeSlotData> _createIntervalTimeSlots({
    required int intervalHours,
    required DateTime startDate,
    required int nowMillis,
    required int durationDays,
  }) {
    final slots = <_TimeSlotData>[];
    final endDate = startDate.add(Duration(days: durationDays));
    var nextTime = startDate;
    while (nextTime.isBefore(endDate)) {
      if (nextTime.millisecondsSinceEpoch > nowMillis) {
        slots.add(_TimeSlotData(
          scheduledTime: nextTime.millisecondsSinceEpoch,
          hour: nextTime.hour,
        ));
      }
      nextTime = nextTime.add(Duration(hours: intervalHours));
    }
    return slots;
  }
}

class _TimeSlotData {
  final int scheduledTime;
  final int hour;

  _TimeSlotData({
    required this.scheduledTime,
    required this.hour,
  });
}
