/// Aggregated adherence statistics over a date range.
library;

/// Read-only summary of medication adherence for a given period.
class AdherenceRecord {
  /// Number of doses taken on time.
  final int takenCount;

  /// Number of doses missed.
  final int missedCount;

  /// Number of doses skipped.
  final int skippedCount;

  /// Total number of scheduled doses in the period.
  final int totalCount;

  /// Adherence ratio: taken / (taken + missed). 0.0–1.0.
  /// Returns 1.0 if no past-due doses exist.
  final double adherencePercent;

  /// Number of consecutive days with 100% adherence (streak).
  final int currentStreakDays;

  /// Longest consecutive-days streak in the measured period.
  final int longestStreakDays;

  /// Start of the measured period (Unix ms).
  final int periodStartMs;

  /// End of the measured period (Unix ms).
  final int periodEndMs;

  /// Human-readable label for the period (e.g., "7 days", "30 days").
  final String periodLabel;

  const AdherenceRecord({
    required this.takenCount,
    required this.missedCount,
    required this.skippedCount,
    required this.totalCount,
    required this.adherencePercent,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.periodStartMs,
    required this.periodEndMs,
    required this.periodLabel,
  });

  /// Number of doses not yet resolved (still pending).
  int get pendingCount => totalCount - takenCount - missedCount - skippedCount;
}
