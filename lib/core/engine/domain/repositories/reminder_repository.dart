/// Abstract repository interface for reminder persistence.
///
/// Domain layer owns this interface. Data layer provides the implementation.
/// MiniMax fills in: method signatures with proper return types.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

/// Contract for reminder data operations.
abstract class ReminderRepository {
  /// Persist a new or updated reminder.
  Future<void> save(Reminder reminder);

  /// Retrieve a reminder by its ID.
  Future<Reminder?> getById(String id);

  /// Get all reminders with the given status.
  Future<List<Reminder>> getByStatus(ReminderStatus status);

  /// Get all reminders scheduled before the given timestamp.
  Future<List<Reminder>> getScheduledBefore(int timestampMillis);

  /// Get reminders at a specific scheduled time (for time-slot grouping).
  Future<List<Reminder>> getByScheduledTime(int scheduledTime);

  /// Get upcoming scheduled reminders (sorted by scheduledTime ascending).
  Future<List<Reminder>> getUpcoming({int limit = 10});

  /// Update a reminder's status.
  Future<void> updateStatus(String id, ReminderStatus newStatus);

  /// Append an event to the reminder_logs table.
  Future<void> logEvent({
    required String reminderId,
    required String eventType,
    required int eventTimestamp,
    String? metadata,
  });
}
