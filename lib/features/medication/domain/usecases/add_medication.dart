/// Use case: Add a new medication and auto-create reminders.
///
/// Persists the medication, delegates reminder generation to ReminderGenerator,
/// and schedules the earliest alarm via AlarmScheduler.
library;

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
    final slotName = _getSlotName(medication);

    await _alarmScheduler.scheduleAlarm(
      reminder: earliestReminder,
      slotName: slotName,
    );

    return medication;
  }

  String _getSlotName(Medication medication) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 9) return 'Morning Medications';
    if (hour >= 9 && hour < 12) return 'Mid-Morning Medications';
    if (hour >= 12 && hour < 14) return 'Afternoon Medications';
    if (hour >= 14 && hour < 17) return 'Late Afternoon Medications';
    if (hour >= 17 && hour < 21) return 'Evening Medications';
    return 'Night Medications';
  }
}
