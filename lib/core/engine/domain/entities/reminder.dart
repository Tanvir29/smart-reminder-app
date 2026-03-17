/// Reminder domain entity — immutable value object representing a scheduled reminder.
///
/// MiniMax fills in: all fields (id, type, title, body, status, scheduledTime,
/// snoozeCount, escalationCount, confirmationMode, linkedEntityId,
/// escalationPolicy fields, timestamps), copyWith method, equality.
library;

/// Immutable reminder entity. Status transitions validated in-entity.
class Reminder {
  // TODO: MiniMax — define all fields per spec §5 and §6.3.1
  // Must include: profile_id, created_at, updated_at, sync_status, xp_value

  const Reminder();
}
