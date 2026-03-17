/// Dose record domain entity.
///
/// MiniMax fills in: fields (id, medicationId, scheduledTime, actualTime,
/// status, reminderId, notes), DoseStatus enum.
library;

/// Status of a single dose event.
enum DoseStatus { taken, missed, skipped }

/// Records a single medication dose event.
class DoseRecord {
  // TODO: MiniMax — define all fields per spec §8.1.1
  // Must include: profile_id, created_at, updated_at, sync_status, xp_value

  const DoseRecord();
}
