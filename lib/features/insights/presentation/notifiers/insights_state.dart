/// State definitions for InsightsNotifier.
///
/// v3: Replaces InsightsState used by the old InsightsCubit.
/// MiniMax fills in: sealed class or union with Loading, Loaded,
/// Generating, Error substates; holds `List<Insight>`.
library;

/// UI state for the insights feature.
class InsightsState {
  const InsightsState.initial();
}
