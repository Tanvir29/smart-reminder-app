/// Riverpod Notifier for medication list and management UI state.
///
/// v3: Replaces MedicationCubit. Uses Riverpod Notifier pattern.
/// MiniMax fills in: states (loading, loaded, adding, error),
/// methods calling domain use cases (AddMedication, RecordDose, etc.).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';

/// Manages medication UI state and delegates to domain use cases.
class MedicationNotifier extends Notifier<MedicationState> {
  // TODO: MiniMax — inject use cases (AddMedication, RecordDose, GetAdherenceStats, GetMedicationSchedule)

  @override
  MedicationState build() => const MedicationState.initial();
}
