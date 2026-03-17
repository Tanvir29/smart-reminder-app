/// State definitions for CycleNotifier.
///
/// v3: Replaces CycleState used by the old CycleCubit.
/// MiniMax fills in: sealed class or union with Loading, Loaded,
/// Logging, Error substates; holds `List<CycleEntry>`, predictions.
library;

/// UI state for the cycle tracking feature.
class CycleState {
  const CycleState.initial();
}
