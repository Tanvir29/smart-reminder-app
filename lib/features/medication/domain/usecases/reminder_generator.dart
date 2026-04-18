import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:uuid/uuid.dart';

class ReminderGenerator {
  final ReminderRepository _reminderRepository;
  final MedicationRepository _medicationRepository;

  static const _uuid = Uuid();
  static const _oneMonthDays = 30;
  static const _continuousDays = 365 * 10;

  const ReminderGenerator({
    required ReminderRepository reminderRepository,
    required MedicationRepository medicationRepository,
  })  : _reminderRepository = reminderRepository,
        _medicationRepository = medicationRepository;

  Future<List<Reminder>> getUpcomingReminders() async {
    return _reminderRepository.getUpcoming();
  }

  Future<void> generateRemindersForMedication({
    required Medication medication,
    required String profileId,
  }) async {
    final now = DateTime.now().toUtc();
    final durationDays = _calculateDurationDays(medication.reminderDuration);

    await _generateAndSaveReminders(
      medication: medication,
      profileId: profileId,
      startDate: now,
      durationDays: durationDays,
    );
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
    required String profileId,
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
      oneTime: (oneTime) => _createOneTimeSlot(
        scheduledTimeMinutes: oneTime.scheduledTimeMinutes,
        startDate: startDate,
        nowMillis: nowMillis,
      ),
    );

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
          profileId: profileId,
          type: 'medication',
          title: slotName,
          body: null,
          status: ReminderStatus.scheduled,
          scheduledTime: slotData.scheduledTime,
          groupDoseCount: 1,
          policy: medication.isCritical
              ? const EscalationPolicy(maxSnoozes: 2)
              : const EscalationPolicy(),
          createdAt: nowMillis,
          updatedAt: nowMillis,
        );
        await _reminderRepository.save(reminder);
      }

      final doseRecord = DoseRecord(
        id: _uuid.v4(),
        profileId: profileId,
        medicationId: medication.id,
        scheduledTime: slotData.scheduledTime,
        status: DoseStatus.pending,
        reminderId: reminder.id,
        createdAt: nowMillis,
        updatedAt: nowMillis,
      );
      await _medicationRepository.saveDoseRecord(doseRecord);
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
          slots.add(
            _TimeSlotData(
              scheduledTime: scheduledDateTime.millisecondsSinceEpoch,
              hour: scheduledDateTime.hour,
            ),
          );
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
          slots.add(
            _TimeSlotData(
              scheduledTime: scheduledDateTime.millisecondsSinceEpoch,
              hour: scheduledDateTime.hour,
            ),
          );
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
        slots.add(
          _TimeSlotData(
            scheduledTime: nextTime.millisecondsSinceEpoch,
            hour: nextTime.hour,
          ),
        );
      }
      nextTime = nextTime.add(Duration(hours: intervalHours));
    }
    return slots;
  }

  List<_TimeSlotData> _createOneTimeSlot({
    required int scheduledTimeMinutes,
    required DateTime startDate,
    required int nowMillis,
  }) {
    final slots = <_TimeSlotData>[];
    final date = startDate;
    final scheduledDateTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      scheduledTimeMinutes ~/ 60,
      scheduledTimeMinutes % 60,
    );
    if (scheduledDateTime.millisecondsSinceEpoch > nowMillis) {
      slots.add(
        _TimeSlotData(
          scheduledTime: scheduledDateTime.millisecondsSinceEpoch,
          hour: scheduledDateTime.hour,
        ),
      );
    }
    return slots;
  }
}

class _TimeSlotData {
  final int scheduledTime;
  final int hour;

  _TimeSlotData({required this.scheduledTime, required this.hour});
}
