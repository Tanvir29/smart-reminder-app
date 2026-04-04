/// Riverpod AsyncNotifier for medication list and management UI state.
///
/// v3: Replaces MedicationCubit. Uses manual [AsyncNotifierProvider] pattern
/// matching [ReminderNotifier]. Delegates all logic to domain use cases.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';

/// Provider for [MedicationNotifier].
final medicationNotifierProvider =
    AsyncNotifierProvider<MedicationNotifier, MedicationState>(
  MedicationNotifier.new,
);

/// Manages medication UI state and delegates to domain use cases.
///
/// Follows the same manual [AsyncNotifier] pattern as [ReminderNotifier]:
/// reads use case providers from DI via [ref.read], uses [AsyncValue.guard]
/// for state updates. Zero business logic — all work is in use cases.
class MedicationNotifier extends AsyncNotifier<MedicationState> {
  @override
  Future<MedicationState> build() async {
    final repository = ref.read(medicationRepositoryProvider);

    final medications = await repository.getActive();

    // Load today's and this week's dose records for all active medications
    final now = DateTime.now();
    final todayStart =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6))
        .millisecondsSinceEpoch;

    final todaysDoses = <DoseRecord>[];
    final weeklyDoses = <DoseRecord>[];
    for (final med in medications) {
      // Today's doses
      final todayDoses = await repository.getDoseRecordsInRange(
        med.id,
        todayStart,
        todayEnd,
      );
      todaysDoses.addAll(todayDoses);

      // Weekly doses for the adherence chart
      final weekDoses = await repository.getDoseRecordsInRange(
        med.id,
        weekStart,
        todayEnd,
      );
      weeklyDoses.addAll(weekDoses);
    }

    return MedicationState(
      medications: medications,
      todaysDoses: todaysDoses,
      weeklyDoses: weeklyDoses,
    );
  }

  /// Adds a new medication via [AddMedication] use case.
  ///
  /// Optimistically appends the saved medication to the state list.
  Future<void> addMedication(Medication medication) async {
    final addMed = ref.read(addMedicationProvider);
    final previous = state.valueOrNull ?? const MedicationState();

    state = await AsyncValue.guard(() async {
      final saved = await addMed.call(medication);
      return previous.copyWith(
        medications: [...previous.medications, saved],
      );
    });
  }

  /// Records a dose as taken via [RecordDose] use case.
  ///
  /// Returns the created [DoseRecord] so the UI can show the 5-second
  /// undo snackbar. Sets [MedicationState.lastRecordedDose] for undo.
  Future<DoseRecord?> takeDose({
    required String medicationId,
    String reminderId = '',
  }) async {
    final recordDose = ref.read(recordDoseProvider);
    final previous = state.valueOrNull ?? const MedicationState();
    DoseRecord? recorded;

    state = await AsyncValue.guard(() async {
      recorded = await recordDose.call(
        medicationId: medicationId,
        reminderId: reminderId,
        status: DoseStatus.taken,
      );
      return previous.copyWith(
        todaysDoses: [...previous.todaysDoses, recorded!],
        lastRecordedDose: recorded,
      );
    });

    return recorded;
  }

  /// Undoes the last recorded dose within the 5-second window.
  ///
  /// Delegates to [UndoDose] use case which validates the time window.
  /// Removes the dose from [MedicationState.todaysDoses] on success.
  Future<void> undoLastDose() async {
    final undoDose = ref.read(undoDoseProvider);
    final previous = state.valueOrNull ?? const MedicationState();
    final doseToUndo = previous.lastRecordedDose;

    if (doseToUndo == null) return;

    state = await AsyncValue.guard(() async {
      await undoDose.call(doseToUndo);
      return previous.copyWith(
        todaysDoses:
            previous.todaysDoses.where((d) => d.id != doseToUndo.id).toList(),
        lastRecordedDose: null,
      );
    });
  }
}
