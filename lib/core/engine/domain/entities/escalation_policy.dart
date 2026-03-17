/// Immutable escalation policy configuration.
///
/// Stored per-reminder (denormalized). Policy is captured at reminder
/// creation time so later setting changes don't affect in-flight reminders.
library;

/// Controls how a reminder escalates through snooze and escalation stages.
class EscalationPolicy {
  /// Number of snoozes allowed before auto-escalation. Default: 3.
  final int maxSnoozes;

  /// Base snooze delay in minutes. Actual = base * (snooze_count + 1). Default: 5.
  final int snoozeBaseDelayMinutes;

  /// Seconds to wait for user response before escalating. Default: 300.
  final int responseWindowSeconds;

  /// Number of escalation attempts before marking as missed. Default: 3.
  final int maxEscalations;

  /// Seconds between escalation attempts. Default: 600.
  final int escalationIntervalSeconds;

  /// Seconds for confirmation interaction proof. Default: 30.
  final int confirmationWindowSeconds;

  const EscalationPolicy({
    this.maxSnoozes = 3,
    this.snoozeBaseDelayMinutes = 5,
    this.responseWindowSeconds = 300,
    this.maxEscalations = 3,
    this.escalationIntervalSeconds = 600,
    this.confirmationWindowSeconds = 30,
  });
}
