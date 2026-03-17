/// State definitions for MedicationNotifier.
///
/// v3: Replaces MedicationState used by the old MedicationCubit.
/// MiniMax fills in: sealed class or union with Loading, Loaded,
/// Adding, Error substates; holds `List<Medication>`, adherence stats.
library;

/// UI state for the medication feature.
class MedicationState {
  const MedicationState.initial();
}
