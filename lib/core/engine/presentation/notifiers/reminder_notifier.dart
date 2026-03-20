/// Riverpod AsyncNotifier for reminder state management.
///
/// v3: Manages `List<Reminder>` via AsyncNotifier. Delegates snooze/confirm
/// actions to domain use cases. Wires notification callbacks on init.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

/// Provider for the [ReminderNotifier].
final reminderNotifierProvider =
    AsyncNotifierProvider<ReminderNotifier, List<Reminder>>(
  ReminderNotifier.new,
);

/// Manages today's reminders and handles snooze/confirm user actions.
///
/// On initialization:
/// - Loads all reminders scheduled before end of today from the repository.
/// - Wires [NotificationService.onActionPressed] to route Snooze/Done button
///   taps to the appropriate use case.
class ReminderNotifier extends AsyncNotifier<List<Reminder>> {
  @override
  Future<List<Reminder>> build() async {
    final repository = ref.read(reminderRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);

    // Wire notification action buttons → use cases
    notificationService.onActionPressed = (String action, String? reminderId) {
      if (reminderId == null) return;
      switch (action) {
        case 'snooze':
          snooze(reminderId);
        case 'done':
          confirm(reminderId);
      }
    };

    // Clean up callback when notifier is disposed
    ref.onDispose(() {
      notificationService.onActionPressed = null;
    });

    // Load today's reminders (scheduled before end of day)
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;

    return repository.getScheduledBefore(endOfDay);
  }

  /// Handles a user snooze action on the reminder identified by [id].
  ///
  /// Delegates to [HandleSnooze] use case. If max snoozes are reached and
  /// the reminder transitions to [ReminderStatus.escalating], automatically
  /// chains [EscalateReminder] to fire the Level 2 loud alarm.
  Future<void> snooze(String id) async {
    final handleSnooze = ref.read(handleSnoozeProvider);
    final previous = state.valueOrNull ?? [];

    state = await AsyncValue.guard(() async {
      var updated = await handleSnooze.call(id);

      // If max snoozes reached → auto-escalate to fire Level 2 alarm (§5.4)
      if (updated.status == ReminderStatus.escalating) {
        final escalateReminder = ref.read(escalateReminderProvider);
        updated = await escalateReminder.call(id);
      }

      return previous.map<Reminder>((r) => r.id == id ? updated : r).toList();
    });
  }

  /// Handles a user confirm ("Done") action on the reminder identified by [id].
  ///
  /// Delegates to [ConfirmReminder] use case which transitions the reminder
  /// to [ReminderStatus.logged], stops the alarm, and records adherence.
  Future<void> confirm(String id) async {
    final confirmReminder = ref.read(confirmReminderProvider);
    final previous = state.valueOrNull ?? [];

    state = await AsyncValue.guard(() async {
      final updated = await confirmReminder.call(id);
      return previous.map<Reminder>((r) => r.id == id ? updated : r).toList();
    });
  }

  /// Schedules a new reminder via [ScheduleReminder] use case and adds it
  /// to the current state list.
  Future<void> schedule(Reminder reminder) async {
    final scheduleReminder = ref.read(scheduleReminderProvider);
    final previous = state.valueOrNull ?? [];

    state = await AsyncValue.guard(() async {
      final scheduled = await scheduleReminder.call(reminder);
      return [...previous, scheduled];
    });
  }
}
