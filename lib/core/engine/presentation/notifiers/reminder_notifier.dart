/// Riverpod Notifier for reminder UI state management.
///
/// v3: Replaces ReminderCubit. Uses Riverpod AsyncNotifier pattern.
/// MiniMax fills in: states (loading, active, snoozing, confirming,
/// completed, error), event handlers calling domain use cases.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages reminder interaction state for the UI layer.
class ReminderNotifier extends Notifier<ReminderUiState> {
  // TODO: MiniMax — inject use cases (ScheduleReminder, HandleSnooze, etc.)

  @override
  ReminderUiState build() => const ReminderUiState.initial();
}

/// UI state for reminder interactions.
class ReminderUiState {
  const ReminderUiState.initial();
}
