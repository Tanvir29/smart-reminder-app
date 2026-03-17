/// Riverpod Notifier for cycle tracking UI state management.
///
/// v3: Replaces CycleCubit. Uses Riverpod Notifier pattern.
/// MiniMax fills in: states (loading, logging, viewingHistory, error),
/// methods calling domain use cases (LogCycleEntry, PredictCycle, etc.).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/features/cycle/presentation/notifiers/cycle_state.dart';

/// Manages cycle tracking UI state and delegates to domain use cases.
class CycleNotifier extends Notifier<CycleState> {
  // TODO: MiniMax — inject use cases (LogCycleEntry, PredictCycle, GetCycleHistory)

  @override
  CycleState build() => const CycleState.initial();
}
