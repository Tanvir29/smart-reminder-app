/// Use case: Record a dose as taken, missed, or skipped.
///
/// Creates a DoseRecord, updates the linked reminder status to logged,
/// and stops the current alarm.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:uuid/uuid.dart';

/// Records a dose event and syncs reminder status.
class RecordDose {
  final MedicationRepository _medicationRepository;
  final ReminderRepository _reminderRepository;
  final AlarmPort _alarmPort;

  static const _uuid = Uuid();

  const RecordDose({
    required MedicationRepository medicationRepository,
    required ReminderRepository reminderRepository,
    required AlarmPort alarmPort,
  })  : _medicationRepository = medicationRepository,
        _reminderRepository = reminderRepository,
        _alarmPort = alarmPort;

  /// Records a dose for [medicationId] linked to [reminderId].
  ///
  /// Fetches the reminder to capture its scheduledTime, creates a
  /// [DoseRecord], transitions the reminder to [ReminderStatus.logged],
  /// and stops the active alarm.
  ///
  /// Returns the created [DoseRecord] for potential undo.
  Future<DoseRecord> call({
    required String medicationId,
    required String reminderId,
    required DoseStatus status,
    String? notes,
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;

    // 1. Fetch the reminder to capture scheduledTime
    final reminder = await _reminderRepository.getById(reminderId);
    final scheduledTime = reminder?.scheduledTime ?? now;

    // 2. Create and persist the DoseRecord
    final doseRecord = DoseRecord(
      id: _uuid.v4(),
      profileId: 'default',
      medicationId: medicationId,
      scheduledTime: scheduledTime,
      actualTime: status == DoseStatus.taken ? now : null,
      status: status,
      reminderId: reminderId,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _medicationRepository.saveDoseRecord(doseRecord);

    // 3. Evaluate batch completion — only mark 'logged' when ALL medications
    //    in the time-slot have been recorded (taken or skipped).
    final groupDoseCount = reminder?.groupDoseCount ?? 1;
    final allDoseRecords =
        await _medicationRepository.getDoseRecordsByReminder(reminderId);

    final recordedCount = allDoseRecords
        .where(
          (d) => d.status == DoseStatus.taken || d.status == DoseStatus.skipped,
        )
        .length;

    if (recordedCount >= groupDoseCount) {
      await _reminderRepository.updateStatus(
        reminderId,
        ReminderStatus.logged,
      );

      // Stop the alarm only when the batch is fully resolved
      await _alarmPort.stopAlarm(reminderId.hashCode);
    }

    return doseRecord;
  }
}
