/// Insight domain entity representing a generated health insight.
///
/// MiniMax fills in: fields (id, profileId, type, title, body,
/// severity, relatedFeature, actionable, timestamps), copyWith, equality.
library;

/// Immutable insight entity generated from cross-feature analysis.
class Insight {
  // TODO: MiniMax — define all fields per v2 insights spec
  // Must include: profile_id, created_at, updated_at, sync_status, xp_value

  const Insight();
}
