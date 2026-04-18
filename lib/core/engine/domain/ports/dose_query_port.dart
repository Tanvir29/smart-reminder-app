/// Port for querying dose and medication data at alarm-fire-time.
///
/// Lives in core/engine/domain so HandleAlarmFired can depend on it
/// without importing any feature module. Implemented by the medication
/// feature's repository.
abstract class DoseQueryPort {
  Future<List<DoseQueryResult>> getDoseRecordsForReminder(String reminderId);
  Future<MedicationInfo?> getMedicationInfoById(String id);
  Future<List<MedicationInfo>> getMedicationInfos(List<String> ids);
}

/// Minimal data transfer object — no feature entity dependency.
class DoseQueryResult {
  final String medicationId;
  final String status;
  const DoseQueryResult({required this.medicationId, required this.status});
}

/// Minimal medication info needed by the engine for notifications/voice.
class MedicationInfo {
  final String name;
  final String? reminderMessage;
  final bool isCritical;
  const MedicationInfo({
    required this.name,
    this.reminderMessage,
    this.isCritical = false,
  });
}
