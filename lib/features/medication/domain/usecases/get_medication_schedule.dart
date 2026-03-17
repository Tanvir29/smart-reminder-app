/// Use case: Get the medication schedule for a given date.
///
/// MiniMax fills in: read-only query returning scheduled doses for the day.
library;

/// Returns today's scheduled doses (read-only, no side effects).
class GetMedicationSchedule {
  // TODO: MiniMax — inject MedicationRepository

  const GetMedicationSchedule();
}
