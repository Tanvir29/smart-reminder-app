/// Immutable escalation policy configuration.
///
/// Stored per-reminder (denormalized). Policy is captured at reminder
/// creation time so later setting changes don't affect in-flight reminders.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'escalation_policy.freezed.dart';

/// Controls how a reminder escalates through snooze and escalation stages.
@freezed
class EscalationPolicy with _$EscalationPolicy {
  const factory EscalationPolicy({
    @Default(3) int maxSnoozes,
    @Default(5) int snoozeBaseDelayMinutes,
    @Default(300) int responseWindowSeconds,
    @Default(3) int maxEscalations,
    @Default(600) int escalationIntervalSeconds,
    @Default(30) int confirmationWindowSeconds,
  }) = _EscalationPolicy;

  const EscalationPolicy._();
}
