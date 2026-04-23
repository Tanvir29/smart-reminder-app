/// Use case: Get adherence statistics for all medications over a date range.
///
/// Read-only query — no side effects. Returns [AdherenceRecord] with
/// taken/missed/skipped counts, percentage, and streak information.
library;

import 'package:smart_reminder_app/features/medication/domain/entities/adherence_record.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';

class GetAdherenceStats {
  final MedicationRepository _repository;

  const GetAdherenceStats({required MedicationRepository repository})
      : _repository = repository;

  /// Returns adherence stats for the last [days] days (including today).
  Future<AdherenceRecord> call({required int days}) async {
    final now = DateTime.now();
    final periodEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final periodStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));

    final periodStartMs = periodStart.millisecondsSinceEpoch;
    final periodEndMs = periodEnd.millisecondsSinceEpoch;

    final medications = await _repository.getActive();
    if (medications.isEmpty) {
      return AdherenceRecord(
        takenCount: 0,
        missedCount: 0,
        skippedCount: 0,
        totalCount: 0,
        adherencePercent: 1.0,
        currentStreakDays: 0,
        longestStreakDays: 0,
        periodStartMs: periodStartMs,
        periodEndMs: periodEndMs,
        periodLabel: '$days day${days != 1 ? 's' : ''}',
      );
    }

    final allDoses = <DoseRecord>[];
    for (final med in medications) {
      final records = await _repository.getDoseRecordsInRange(
        med.id,
        periodStartMs,
        periodEndMs,
      );
      allDoses.addAll(records);
    }

    final takenCount =
        allDoses.where((d) => d.status == DoseStatus.taken).length;
    final missedCount =
        allDoses.where((d) => d.status == DoseStatus.missed).length;
    final skippedCount =
        allDoses.where((d) => d.status == DoseStatus.skipped).length;
    final totalCount = allDoses.length;

    final resolved = takenCount + missedCount + skippedCount;
    final adherencePercent = resolved == 0 ? 1.0 : takenCount / resolved;

    final streaks = _computeStreaks(allDoses);

    return AdherenceRecord(
      takenCount: takenCount,
      missedCount: missedCount,
      skippedCount: skippedCount,
      totalCount: totalCount,
      adherencePercent: adherencePercent,
      currentStreakDays: streaks.current,
      longestStreakDays: streaks.longest,
      periodStartMs: periodStartMs,
      periodEndMs: periodEndMs,
      periodLabel: '$days day${days != 1 ? 's' : ''}',
    );
  }

  /// Computes current and longest consecutive-day adherence streaks.
  ///
  /// A day counts toward the streak if all doses for that day are taken
  /// or skipped (no missed). Uses the 36-hour ADHD grace window from
  /// the spec — doses due within the last 36 hours are not yet "missed."
  _Streaks _computeStreaks(List<DoseRecord> doses) {
    const graceMs = 36 * 60 * 60 * 1000;

    final takenDoses = doses
        .where((d) => d.status == DoseStatus.taken)
        .map((d) => d.actualTime ?? d.scheduledTime)
        .toList()
      ..sort();

    if (takenDoses.isEmpty) {
      return const _Streaks(current: 0, longest: 0);
    }

    int longestStreak = 1;
    int runningStreak = 1;

    for (int i = 1; i < takenDoses.length; i++) {
      final gap = takenDoses[i] - takenDoses[i - 1];
      if (gap <= graceMs) {
        runningStreak++;
        if (runningStreak > longestStreak) {
          longestStreak = runningStreak;
        }
      } else {
        runningStreak = 1;
      }
    }

    int currentStreak = 1;
    for (int i = takenDoses.length - 1; i > 0; i--) {
      final gap = takenDoses[i] - takenDoses[i - 1];
      if (gap <= graceMs) {
        currentStreak++;
      } else {
        break;
      }
    }

    return _Streaks(current: currentStreak, longest: longestStreak);
  }
}

class _Streaks {
  final int current;
  final int longest;
  const _Streaks({required this.current, required this.longest});
}
