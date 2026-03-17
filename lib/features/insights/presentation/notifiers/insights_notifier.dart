/// Riverpod Notifier for insights UI state management.
///
/// v3: Replaces InsightsCubit. Uses Riverpod Notifier pattern.
/// MiniMax fills in: states (loading, loaded, generating, error),
/// methods calling domain use cases (GenerateInsights, GetInsights).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/features/insights/presentation/notifiers/insights_state.dart';

/// Manages insights UI state and delegates to domain use cases.
class InsightsNotifier extends Notifier<InsightsState> {
  // TODO: MiniMax — inject use cases (GenerateInsights, GetInsights)

  @override
  InsightsState build() => const InsightsState.initial();
}
