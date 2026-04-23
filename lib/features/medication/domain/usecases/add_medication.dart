/// Use case: Add a new medication and auto-create reminders.
///
/// Persists the medication, delegates reminder generation to ReminderGenerator,
/// and schedules the earliest alarm via AlarmScheduler.
library;

import 'package:smart_reminder_app/core/engine/domain/helpers/slot_name_helper.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/alarm_scheduler.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/reminder_generator.dart';

class AddMedication {
  final MedicationRepository _medicationRepository;
  final ReminderGenerator _reminderGenerator;
  final AlarmScheduler _alarmScheduler;

  const AddMedication({
    required MedicationRepository medicationRepository,
    required ReminderGenerator reminderGenerator,
    required AlarmScheduler alarmScheduler,
  })  : _medicationRepository = medicationRepository,
        _reminderGenerator = reminderGenerator,
        _alarmScheduler = alarmScheduler;

  Future<Medication> call(Medication medication) async {
    const profileId = 'default';

    await _medicationRepository.save(medication);

    await _reminderGenerator.generateRemindersForMedication(
      medication: medication,
      profileId: profileId,
    );

    final upcomingReminders = await _reminderGenerator.getUpcomingReminders();
    if (upcomingReminders.isEmpty) {
      throw Exception('No upcoming reminders to schedule');
    }

    final earliestReminder = upcomingReminders.first;
    final hour =
        DateTime.fromMillisecondsSinceEpoch(earliestReminder.scheduledTime)
            .hour;
    final slotName = getSlotName(hour);

    await _alarmScheduler.scheduleAlarm(
      reminder: earliestReminder,
      slotName: slotName,
    );

    return medication;
  }
}
