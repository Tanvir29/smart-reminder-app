/// State definitions for MedicationNotifier.
///
/// v3: Freezed data class holding active medications, today's dose records,
/// and computed [TodayDoseSlot] view models for the dashboard.
/// Includes grouped time-slot view model [TimeSlotGroup] for batch UI.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_medication_schedule.dart';

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
    @Default([]) List<DoseRecord> thirtyDayDoses,
    DoseRecord? lastRecordedDose,
  }) = _MedicationState;

  /// Derives today's dose schedule sorted chronologically.
  ///
  /// Delegates frequency expansion, dose-record matching, and status
  /// derivation to [buildScheduleSlots], then projects into [TodayDoseSlot]s.
  List<TodayDoseSlot> get todaySlots {
    final rawSlots = buildScheduleSlots(
      medications: medications,
      doseRecords: todaysDoses,
      date: DateTime.now(),
    );

    return rawSlots
        .map((s) => TodayDoseSlot(
              medication: s.medication,
              scheduledTimeMinutes: s.timeMinutes,
              scheduledTimeMs: s.scheduledMs,
              status: _toSlotStatus(s.status),
              doseRecord: s.doseRecord,
              reminderId: s.doseRecord?.reminderId,
            ))
        .toList();
  }

  static DoseSlotStatus _toSlotStatus(DoseSlotItemStatus s) => switch (s) {
        DoseSlotItemStatus.taken => DoseSlotStatus.taken,
        DoseSlotItemStatus.missed => DoseSlotStatus.missed,
        DoseSlotItemStatus.skipped => DoseSlotStatus.missed,
        DoseSlotItemStatus.upcoming => DoseSlotStatus.upcoming,
      };

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

  double get thirtyDayAdherencePercent {
    final taken = thirtyDayDoses.where((d) => d.status == 'taken').length;
    final missed = thirtyDayDoses.where((d) => d.status == 'missed').length;
    final total = taken + missed;
    if (total == 0) return 1.0;
    return taken / total;
  }

  /// Today's dose schedule grouped by time slot.
  ///
  /// Returns [GroupedDoseSlot]s sorted chronologically, each containing
  /// all medications due at the same time. Supports the batch checklist UI.
  List<GroupedDoseSlot> get todayGroups {
    final slots = todaySlots;
    if (slots.isEmpty) return [];

    final Map<int, List<TodayDoseSlot>> bucketMap = {};
    for (final slot in slots) {
      bucketMap.putIfAbsent(slot.scheduledTimeMinutes, () => []).add(slot);
    }

    final sortedKeys = bucketMap.keys.toList()..sort();
    return sortedKeys.map((timeMinutes) {
      final groupSlots = bucketMap[timeMinutes]!;
      return GroupedDoseSlot.fromSlots(groupSlots);
    }).toList();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// View models
// ──────────────────────────────────────────────────────────────────────────────

/// Status of a dose slot in the Today's Dashboard.
enum DoseSlotStatus { taken, missed, upcoming, partiallyTaken }

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

// ──────────────────────────────────────────────────────────────────────────────
// Grouped view model
// ──────────────────────────────────────────────────────────────────────────────

/// View model for a time-slot group containing multiple medications.
///
/// Wraps a list of [TodayDoseSlot]s sharing the same scheduled time.
/// Computed [DoseSlotStatus] reflects the aggregate batch state:
/// - [DoseSlotStatus.taken] if ALL medications are taken.
/// - [DoseSlotStatus.partiallyTaken] if SOME but not all are taken.
/// - [DoseSlotStatus.upcoming] if none are taken and not past due.
/// - [DoseSlotStatus.missed] if all are past due with none taken.
class GroupedDoseSlot {
  /// Minutes from midnight (e.g., 480 = 8:00 AM).
  final int scheduledTimeMinutes;

  /// Unix milliseconds for the scheduled time today.
  final int scheduledTimeMs;

  /// Individual dose slots in this group.
  final List<TodayDoseSlot> slots;

  /// The shared reminder ID (non-null if reminder was created).
  final String? reminderId;

  const GroupedDoseSlot({
    required this.scheduledTimeMinutes,
    required this.scheduledTimeMs,
    required this.slots,
    this.reminderId,
  });

  /// Constructs from a list of slots sharing the same scheduled time.
  factory GroupedDoseSlot.fromSlots(List<TodayDoseSlot> slots) {
    if (slots.isEmpty) {
      return const GroupedDoseSlot(
        scheduledTimeMinutes: 0,
        scheduledTimeMs: 0,
        slots: [],
      );
    }
    return GroupedDoseSlot(
      scheduledTimeMinutes: slots.first.scheduledTimeMinutes,
      scheduledTimeMs: slots.first.scheduledTimeMs,
      slots: slots,
      reminderId: slots
          .firstWhere((s) => s.reminderId != null, orElse: () => slots.first)
          .reminderId,
    );
  }

  /// Aggregate status for the group.
  DoseSlotStatus get status {
    if (slots.isEmpty) return DoseSlotStatus.upcoming;

    final takenCount = slots
        .where(
          (s) => s.status == DoseSlotStatus.taken,
        )
        .length;
    final upcomingCount = slots
        .where(
          (s) => s.status == DoseSlotStatus.upcoming,
        )
        .length;

    if (takenCount == slots.length) return DoseSlotStatus.taken;
    if (takenCount > 0) return DoseSlotStatus.partiallyTaken;
    if (upcomingCount == slots.length) return DoseSlotStatus.upcoming;
    return DoseSlotStatus.missed;
  }

  /// Number of medications in this group.
  int get count => slots.length;

  /// Number of medications already taken.
  int get takenCount =>
      slots.where((s) => s.status == DoseSlotStatus.taken).length;

  /// Whether the group has any critical medication.
  bool get hasCritical => slots.any((s) => s.isCritical);

  /// Human-readable scheduled time (e.g., "8:00 AM").
  String get formattedTime {
    final hours = scheduledTimeMinutes ~/ 60;
    final minutes = scheduledTimeMinutes % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHours = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '$displayHours:${minutes.toString().padLeft(2, '0')} $period';
  }

  /// Comma-separated medication names for the group.
  String get medicationNames => slots.map((s) => s.medication.name).join(', ');
}
