/// Port for notification display.
///
/// Implemented by NotificationService in the platform layer.
/// This abstraction allows domain use cases to depend on a contract
/// rather than the concrete NotificationService implementation.
abstract class NotificationPort {
  /// Shows a medication reminder notification.
  ///
  /// [id] - unique identifier for the notification
  /// [title] - notification title (e.g., "Medication Reminder" or "URGENT: ...")
  /// [body] - notification body (e.g., "Time for: Aspirin, Vitamin D")
  /// [payload] - optional payload data passed when user taps the notification
  /// [isCritical] - whether this is a critical/urgent notification
  Future<void> showMedicationReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isCritical = false,
  });

  /// Cancels a previously shown notification.
  Future<void> cancel(int id);
}