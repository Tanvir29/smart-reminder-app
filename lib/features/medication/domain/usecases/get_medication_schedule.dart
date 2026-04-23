/// Use case: Get today's medication schedule grouped by time slot.
///
/// Returns a list of [TimeSlotGroup]s, each representing a unique
/// scheduled time with all medications due at that time. Supports
/// the Batch Checklist UI (§10.1).
///
/// Also exposes [buildScheduleSlots] — the shared pure computation
/// used by both this use case and [MedicationState.todaySlots].
library;

import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Shared types & pure computation
// ──────────────────────────────────────────────────────────────────────────────

/// Status of an individual medication item within a schedule.
enum DoseSlotItemStatus { taken, missed, skipped, upcoming }

/// A computed schedule slot pairing a medication with its dose status
/// for a specific time on a given date.
///
/// Produced by [buildScheduleSlots] — the single source of truth for
/// frequency-to-times expansion, dose-record matching, and status
/// derivation. Both [GetMedicationSchedule] and [MedicationState]
/// consume this and project into their own view models.
class ScheduleSlot {
  final Medication medication;
  final int timeMinutes;
  final int scheduledMs;
  final DoseRecord? doseRecord;
  final DoseSlotItemStatus status;

  const ScheduleSlot({
    required this.medication,
    required this.timeMinutes,
    required this.scheduledMs,
    this.doseRecord,
    required this.status,
  });
}

/// Pure function: expands [medications] into a flat list of [ScheduleSlot]s
/// for [date], matched against [doseRecords], sorted chronologically.
///
/// Shared by [GetMedicationSchedule.call] (async, loads data from repos)
/// and [MedicationState.todaySlots] (sync, works from in-memory state).
List<ScheduleSlot> buildScheduleSlots({
  required List<Medication> medications,
  required List<DoseRecord> doseRecords,
  required DateTime date,
}) {
  final now = DateTime.now();
  final nowMinutes = now.hour * 60 + now.minute;
  final isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  final dateStart =
      DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

  final slots = <ScheduleSlot>[];

  for (final med in medications) {
    if (!med.isActive) continue;

    final times = med.frequency.map(
      daily: (f) => f.timesOfDay,
      weekly: (f) {
        return f.weekDays.contains(date.weekday) ? f.timesOfDay : <int>[];
      },
      interval: (f) {
        final result = <int>[];
        final intervalMinutes = (f.intervalHours * 60).toInt();
        for (int m = 0; m < 1440; m += intervalMinutes) {
          result.add(m);
        }
        return result;
      },
      oneTime: (f) => [f.scheduledTimeMinutes],
    );

    for (final timeMinutes in times) {
      final scheduledMs = (dateStart + timeMinutes * 60 * 1000).toInt();

      DoseRecord? matchingDose;
      for (final d in doseRecords) {
        if (d.medicationId == med.id &&
            (d.scheduledTime - scheduledMs).abs() < 30 * 60 * 1000) {
          matchingDose = d;
          break;
        }
      }

      DoseSlotItemStatus itemStatus;
      if (matchingDose != null) {
        switch (matchingDose.status) {
          case DoseStatus.taken:
            itemStatus = DoseSlotItemStatus.taken;
          case DoseStatus.missed:
            itemStatus = DoseSlotItemStatus.missed;
          case DoseStatus.skipped:
            itemStatus = DoseSlotItemStatus.skipped;
          case DoseStatus.pending:
            itemStatus = DoseSlotItemStatus.upcoming;
        }
      } else if (isToday && timeMinutes <= nowMinutes - 15) {
        itemStatus = DoseSlotItemStatus.missed;
      } else {
        itemStatus = DoseSlotItemStatus.upcoming;
      }

      slots.add(ScheduleSlot(
        medication: med,
        timeMinutes: timeMinutes,
        scheduledMs: scheduledMs,
        doseRecord: matchingDose,
        status: itemStatus,
      ));
    }
  }

  slots.sort((a, b) => a.timeMinutes.compareTo(b.timeMinutes));
  return slots;
}

// ──────────────────────────────────────────────────────────────────────────────
// Time-slot group view models
// ──────────────────────────────────────────────────────────────────────────────

/// A single medication within a time-slot group.
class SlotMedicationItem {
  final Medication medication;
  final DoseRecord? doseRecord;
  final DoseSlotItemStatus status;

  const SlotMedicationItem({
    required this.medication,
    this.doseRecord,
    required this.status,
  });

  bool get isCritical => medication.isCritical;

  String get name => medication.name;

  String get dosage => medication.dosage;
}

/// Aggregate status for a time-slot group.
enum TimeSlotGroupStatus {
  /// All medications in the slot are taken/skipped.
  completed,

  /// Some medications taken, others still upcoming or missed.
  partiallyTaken,

  /// No medications taken yet; slot is in the future.
  upcoming,

  /// All medications are past due with none taken.
  allMissed,
}

/// A group of medications sharing the same scheduled time.
///
/// This is the view model for the grouped home page and batch
/// checklist sheet. One physical alarm maps to one [TimeSlotGroup].
class TimeSlotGroup {
  /// Minutes from midnight (e.g., 480 = 8:00 AM).
  final int scheduledTimeMinutes;

  /// Unix milliseconds for the scheduled time on the target date.
  final int scheduledTimeMs;

  /// All medication items due at this time.
  final List<SlotMedicationItem> items;

  /// The linked reminder ID (all items share the same reminder).
  final String? reminderId;

  /// The group dose count from the reminder.
  final int groupDoseCount;

  const TimeSlotGroup({
    required this.scheduledTimeMinutes,
    required this.scheduledTimeMs,
    required this.items,
    this.reminderId,
    this.groupDoseCount = 1,
  });

  /// Human-readable scheduled time (e.g., "8:00 AM").
  String get formattedTime {
    final hours = scheduledTimeMinutes ~/ 60;
    final minutes = scheduledTimeMinutes % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHours = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '$displayHours:${minutes.toString().padLeft(2, '0')} $period';
  }

  /// Aggregated status computed from individual item statuses.
  TimeSlotGroupStatus get status {
    if (items.isEmpty) return TimeSlotGroupStatus.upcoming;

    final resolvedCount = items
        .where(
          (i) =>
              i.status == DoseSlotItemStatus.taken ||
              i.status == DoseSlotItemStatus.skipped,
        )
        .length;
    final missedCount =
        items.where((i) => i.status == DoseSlotItemStatus.missed).length;

    if (resolvedCount == items.length) return TimeSlotGroupStatus.completed;
    if (resolvedCount > 0) return TimeSlotGroupStatus.partiallyTaken;
    if (missedCount == items.length) return TimeSlotGroupStatus.allMissed;
    return TimeSlotGroupStatus.upcoming;
  }

  /// Whether the group has any critical medication.
  bool get hasCritical => items.any((i) => i.isCritical);

  /// Number of items resolved (taken or consciously skipped).
  int get completedCount => items
      .where(
        (i) =>
            i.status == DoseSlotItemStatus.taken ||
            i.status == DoseSlotItemStatus.skipped,
      )
      .length;
}

// ──────────────────────────────────────────────────────────────────────────────
// Use case
// ──────────────────────────────────────────────────────────────────────────────

/// Returns today's scheduled doses grouped by shared time slot.
///
/// Read-only query — no side effects. Groups medications by their
/// scheduled time so the UI can render one card per time slot and
/// the batch checklist sheet can show per-item checkboxes.
class GetMedicationSchedule {
  final MedicationRepository _medicationRepository;
  final ReminderRepository _reminderRepository;

  const GetMedicationSchedule({
    required MedicationRepository medicationRepository,
    required ReminderRepository reminderRepository,
  })  : _medicationRepository = medicationRepository,
        _reminderRepository = reminderRepository;

  /// Returns [TimeSlotGroup]s for [date], sorted chronologically.
  ///
  /// Each group contains all medications scheduled at the same time,
  /// along with any existing dose records for those medications.
  Future<List<TimeSlotGroup>> call(DateTime date) async {
    final medications = await _medicationRepository.getActive();
    if (medications.isEmpty) return [];

    final dateStart =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final dateEnd = DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;

    final doseRecords = <DoseRecord>[];
    for (final med in medications) {
      final records = await _medicationRepository.getDoseRecordsInRange(
        med.id,
        dateStart,
        dateEnd,
      );
      doseRecords.addAll(records);
    }

    final rawSlots = buildScheduleSlots(
      medications: medications,
      doseRecords: doseRecords,
      date: date,
    );

    final timeSlotMap = <int, List<ScheduleSlot>>{};
    for (final slot in rawSlots) {
      timeSlotMap.putIfAbsent(slot.timeMinutes, () => []).add(slot);
    }

    final groups = <TimeSlotGroup>[];
    for (final entry in timeSlotMap.entries) {
      final timeMinutes = entry.key;
      final pending = entry.value;

      String? reminderId;
      int groupDoseCount = pending.length;

      for (final p in pending) {
        final rid = p.doseRecord?.reminderId;
        if (rid != null && rid.isNotEmpty) {
          reminderId = rid;
          break;
        }
      }

      if (reminderId == null) {
        final reminders = await _reminderRepository
            .getByScheduledTime(pending.first.scheduledMs);
        if (reminders.isNotEmpty) {
          reminderId = reminders.first.id;
          groupDoseCount = reminders.first.groupDoseCount;
        }
      }

      groups.add(
        TimeSlotGroup(
          scheduledTimeMinutes: timeMinutes,
          scheduledTimeMs: pending.first.scheduledMs,
          items: pending
              .map((p) => SlotMedicationItem(
                    medication: p.medication,
                    doseRecord: p.doseRecord,
                    status: p.status,
                  ))
              .toList(),
          reminderId: reminderId,
          groupDoseCount: groupDoseCount,
        ),
      );
    }

    return groups;
  }
}
