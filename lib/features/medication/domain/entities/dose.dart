/// Dose record domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dose.freezed.dart';

/// Status of a single dose event.
enum DoseStatus { pending, taken, missed, skipped }

/// Records a single medication dose event. All timestamps are Unix milliseconds.
@freezed
class DoseRecord with _$DoseRecord {
  const factory DoseRecord({
    required String id,
    required String profileId,
    required String medicationId,
    required int scheduledTime,
    int? actualTime,
    required DoseStatus status,
    String? reminderId,
    String? notes,
    required int createdAt,
    required int updatedAt,
    @Default('local') String syncStatus,
    @Default(10) int xpValue,
  }) = _DoseRecord;

  const DoseRecord._();
}
