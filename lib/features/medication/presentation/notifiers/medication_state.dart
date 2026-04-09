/// State definitions for MedicationNotifier.
///
/// v3: Freezed data class holding active medications, today's dose records,
/// and computed [TodayDoseSlot] view models for the dashboard.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';

part 'medication_state.freezed.dart';

/// UI state for the medication feature.
///
/// Wrapped by [AsyncValue] in [MedicationNotifier], so loading and
/// error states are handled by Riverpod automatically.
@freezed
class MedicationState with _$MedicationState {
  const MedicationState._();

  const factory MedicationState({
    @Default([]) List<Medication> medications,
    @Default([]) List<DoseRecord> todaysDoses,
    @Default([]) List<DoseRecord> weeklyDoses,
    DoseRecord? lastRecordedDose,
  }) = _MedicationState;

  /// Derives today's dose schedule sorted chronologically.
  ///
  /// Combines each active medication's frequency with any recorded
  /// dose events to produce a flat, sorted list of [TodayDoseSlot]s.
  List<TodayDoseSlot> get todaySlots {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final slots = <TodayDoseSlot>[];

    for (final med in medications) {
      if (!med.isActive) continue;

      final times = med.frequency.map(
        daily: (f) => f.timesOfDay,
        weekly: (f) {
          return f.weekDays.contains(now.weekday) ? f.timesOfDay : <int>[];
        },
        interval: (f) {
          final result = <int>[];
          final int intervalMinutes = (f.intervalHours * 60).toInt();
          for (int m = 0; m < 1440; m += intervalMinutes) {
            result.add(m);
          }
          return result;
        },
        oneTime: (f) => [f.scheduledTimeMinutes],
      );

      for (final timeMinutes in times) {
        final int scheduledMs = (todayStart + timeMinutes * 60 * 1000).toInt();

        // Match dose record within a 30-minute window
        DoseRecord? matchingDose;
        for (final d in todaysDoses) {
          if (d.medicationId == med.id &&
              (d.scheduledTime - scheduledMs).abs() < 30 * 60 * 1000) {
            matchingDose = d;
            break;
          }
        }

        final DoseSlotStatus slotStatus;
        if (matchingDose != null) {
          slotStatus = matchingDose.status == DoseStatus.taken
              ? DoseSlotStatus.taken
              : DoseSlotStatus.missed;
        } else if (timeMinutes <= nowMinutes - 15) {
          // 15-minute grace period before marking as missed
          slotStatus = DoseSlotStatus.missed;
        } else {
          slotStatus = DoseSlotStatus.upcoming;
        }

        slots.add(
          TodayDoseSlot(
            medication: med,
            scheduledTimeMinutes: timeMinutes,
            scheduledTimeMs: scheduledMs,
            status: slotStatus,
            doseRecord: matchingDose,
            reminderId: matchingDose?.reminderId,
          ),
        );
      }
    }

    slots.sort(
      (a, b) => a.scheduledTimeMinutes.compareTo(b.scheduledTimeMinutes),
    );
    return slots;
  }

  /// Today's adherence percentage (0.0 – 1.0).
  ///
  /// Only considers slots that are past due (taken + missed).
  /// Returns 1.0 if no slots are past due yet.
  double get adherencePercent {
    final slots = todaySlots;
    final taken = slots.where((s) => s.status == DoseSlotStatus.taken).length;
    final missed = slots.where((s) => s.status == DoseSlotStatus.missed).length;
    final total = taken + missed;
    if (total == 0) return 1.0;
    return taken / total;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// View models
// ──────────────────────────────────────────────────────────────────────────────

/// Status of a dose slot in the Today's Dashboard.
enum DoseSlotStatus { taken, missed, upcoming }

/// View model for a single dose slot in the Today's Dashboard.
///
/// Not a Freezed class — it's a lightweight, read-only projection
/// computed from [MedicationState.todaySlots].
class TodayDoseSlot {
  final Medication medication;

  /// Minutes from midnight (e.g., 480 = 8:00 AM).
  final int scheduledTimeMinutes;

  /// Unix milliseconds for the scheduled time today.
  final int scheduledTimeMs;

  final DoseSlotStatus status;
  final DoseRecord? doseRecord;

  /// Linked reminder ID for the two-phase confirmation flow.
  final String? reminderId;

  const TodayDoseSlot({
    required this.medication,
    required this.scheduledTimeMinutes,
    required this.scheduledTimeMs,
    required this.status,
    this.doseRecord,
    this.reminderId,
  });

  /// Whether this medication requires the tap-3× challenge (§5.5).
  bool get isCritical => medication.isCritical;

  /// Human-readable scheduled time (e.g., "8:00 AM").
  String get formattedTime {
    final hours = scheduledTimeMinutes ~/ 60;
    final minutes = scheduledTimeMinutes % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHours = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '$displayHours:${minutes.toString().padLeft(2, '0')} $period';
  }
}
