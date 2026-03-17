/// Cycle prediction domain entity.
///
/// MiniMax fills in: fields (id, profileId, predictedStartDate,
/// predictedEndDate, confidence, basedOnCycles, timestamps),
/// copyWith, equality.
library;

/// Immutable prediction for an upcoming cycle period.
class CyclePrediction {
  // TODO: MiniMax — define all fields per v2 cycle spec
  // Must include: profile_id, created_at, updated_at, sync_status, xp_value

  const CyclePrediction();
}
