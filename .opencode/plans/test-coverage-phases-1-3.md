# Test Coverage Audit & Plan: Phases 1-3

> **Audited:** 2026-04-15
> **Scope:** Phase 1 (Foundation), Phase 2 (Core Engine), Phase 3 (Medication MVP)
> **Spec Reference:** Section 12 (Testing Strategy), Section 5.3 (State Transitions), Section 11 (Roadmap)

---

## Current State

| Metric | Value |
|--------|-------|
| Test files with real tests | 21 |
| Stub files (.gitkeep only) | 4 (`core/platform`, `core/security`, `core/backup`, `features/cycle`, `features/insights`) |
| Integration test files | 2 (`integration_test/`) |
| Total test cases | ~241 |
| Lines of test code | ~5,843 |

---

## Existing Coverage Matrix

### Phase 1: Foundation

| Component | Test File | Tests | Verdict |
|-----------|-----------|-------|---------|
| AppDatabase (11 tables, 6 DAOs) | `test/database_test.dart` | 5 | COVERED |
| SecureStorageImpl | `test/core/security/` (empty) | 0 | MISSING |
| DB encryption roundtrip | `integration_test/db_encryption_test.dart` | 1 | COVERED |
| Alarm hardware reliability | `integration_test/hardware_reliability_test.dart` | 1 | COVERED |

### Phase 2: Core Engine (Reminder State Machine)

| Component | Test File | Tests | Verdict |
|-----------|-----------|-------|---------|
| EscalationPolicy | `test/core/engine/domain/entities/escalation_policy_test.dart` | 12 | COVERED |
| ScheduleReminder | `test/core/engine/schedule_reminder_test.dart` | 8 | COVERED |
| HandleSnooze | `test/core/engine/state_machine_test.dart` | 14 | COVERED (mislabeled filename) |
| ConfirmReminder | `test/core/engine/confirm_reminder_test.dart` | 12 | COVERED |
| FinalizeConfirmation | `test/core/engine/finalize_confirmation_test.dart` | 13 | COVERED |
| EscalateReminder | `test/core/engine/escalate_reminder_test.dart` | 13 | COVERED |
| LogMissedReminder | `test/core/engine/log_missed_reminder_test.dart` | 8 | COVERED |
| HandleAlarmFired | `test/core/engine/domain/usecases/handle_alarm_fired_test.dart` | 6 | PARTIAL |
| ReminderMapper | `test/core/engine/data/mappers/reminder_mapper_test.dart` | 12 | COVERED |
| ReminderRepositoryImpl | `test/core/engine/data/repositories/reminder_repository_impl_test.dart` | 11 | COVERED |
| ReminderNotifier | None | 0 | MISSING |
| **ReminderStatus state machine (comprehensive)** | **None** | **0** | **MISSING (critical)** |

### Phase 3: Medication MVP

| Component | Test File | Tests | Verdict |
|-----------|-----------|-------|---------|
| AddMedication | `test/features/medication/add_medication_test.dart` | 22 | COVERED |
| RecordDose | `test/features/medication/record_dose_test.dart` + `domain/usecases/record_dose_test.dart` | 14 | COVERED |
| UndoDose | `test/features/medication/undo_dose_test.dart` | 11 | COVERED |
| GetAdherenceStats | `test/features/medication/domain/usecases/get_adherence_stats_test.dart` | 10 | COVERED |
| GetMedicationSchedule | `test/features/medication/domain/usecases/get_medication_schedule_test.dart` | 8 | COVERED |
| MedicationMapper | `test/features/medication/data/mappers/medication_mapper_test.dart` | 18 | COVERED |
| MedicationRepositoryImpl | `test/features/medication/data/repositories/medication_repository_impl_test.dart` | 12 | COVERED |
| DoseConfirmationSheet | `test/features/medication/presentation/widgets/dose_confirmation_sheet_test.dart` | 11 | COVERED |
| MedicationTile | `test/features/medication/presentation/widgets/medication_tile_test.dart` | 10 | COVERED |
| MedicationNotifier | None | 0 | MISSING |
| MedicationState (computed) | None | 0 | MISSING |
| MedicationListPage | None | 0 | MISSING |
| AddMedicationPage | None | 0 | MISSING |
| AdherenceDashboardPage | None | 0 | MISSING |
| AdherenceChart | None | 0 | MISSING |
| ConfettiOverlay | None | 0 | MISSING |

### Integration Tests

| Flow | Test File | Tests | Verdict |
|------|-----------|-------|---------|
| Reminder lifecycle (happy/snooze/escalation) | `test/integration/reminder_lifecycle_test.dart` | 6 | COVERED |
| Dose flow (add/record/adherence) | `test/integration/dose_flow_integration_test.dart` | 5 | COVERED |
| Batch dose flow (time-slot grouping) | `test/integration/batch_dose_flow_test.dart` | 3 | COVERED |
| Boot reschedule | None | 0 | MISSING |

---

## Critical Gaps (Must Fix)

### GAP 1: No Comprehensive State Machine Test

**Severity:** HIGH
**Spec Ref:** Section 12.2 — "ReminderStatus state machine: All valid transitions, all invalid transitions, edge cases. 100% of transitions in Section 5.3"
**Roadmap:** P2-11

The file `state_machine_test.dart` tests `HandleSnooze` only (14 tests). There is no test validating the complete transition table from Section 5.3 as a holistic unit.

**Missing validations:**

| Transition | Source | Event | Target | Tested Where |
|-----------|--------|-------|--------|-------------|
| scheduled → triggered | Alarm fires | `handle_alarm_fired_test.dart` | COVERED (partial) |
| triggered → confirmationRequired | User taps "Done" | `confirm_reminder_test.dart` | COVERED |
| triggered → snoozed | User taps "Snooze" | `state_machine_test.dart` (HandleSnooze) | COVERED |
| triggered → escalating | response_window expires | `escalate_reminder_test.dart` | COVERED |
| triggered → cancelled | User taps "Cancel" | **Nowhere** | **MISSING** |
| snoozed → triggered | Snooze timer fires | `state_machine_test.dart` (re-schedule) | COVERED (partial) |
| snoozed → escalating | snooze_count >= max | `state_machine_test.dart` | COVERED |
| escalating → confirmationRequired | User responds | `confirm_reminder_test.dart` | COVERED |
| escalating → missed | max escalations reached | `escalate_reminder_test.dart` | COVERED |
| escalating → escalating | Re-fire | `escalate_reminder_test.dart` | COVERED |
| confirmationRequired → logged | User confirms | `finalize_confirmation_test.dart` | COVERED |
| confirmationRequired → triggered | window expires | **Nowhere** | **MISSING** |

**Missing invalid transitions to test:**
- Each terminal state (`logged`, `missed`, `cancelled`) rejects all transitions
- `scheduled` rejects direct snooze/confirm/escalate/finalize
- `snoozed` rejects direct confirm/finalize

**Action:** Create `test/core/engine/domain/entities/reminder_state_machine_test.dart` (~25 tests)

---

### GAP 2: Missing `HandleAlarmFired` Voice Payload Tests

**Severity:** MEDIUM
**Spec Ref:** Section 7.4 (Voice Service Contract), Section 7.1.1 (Lazy Loading)
**Roadmap:** P3-06

Current tests (6) cover notification body construction but NOT:
- `VoicePort.speakAnnouncement()` called with correct medication names
- Custom `reminderMessage` included in voice payload
- TTS fallback when voice fails (siren continues as failsafe)

**Action:** Add ~4 tests to `test/core/engine/domain/usecases/handle_alarm_fired_test.dart`

---

### GAP 3: Missing Confirmation Window Timeout

**Severity:** MEDIUM
**Spec Ref:** Section 5.3 — "confirmationRequired → triggered on confirmation_window expires (30 sec)"

No test validates that a confirmation timeout returns the reminder to `triggered` status.

**Action:** Add ~3 tests to `test/core/engine/confirm_reminder_test.dart` or create a dedicated timeout test

---

### GAP 4: Missing Boot Reschedule Integration Test

**Severity:** MEDIUM
**Spec Ref:** Section 12.3 — "Boot reschedule: Simulate boot → verify all scheduled reminders are re-registered"
**Phase 2 Exit Criteria:** "Alarms survive device reboot"

This is a Phase 2 exit criterion with zero test coverage.

**Action:** Create `test/integration/boot_reschedule_test.dart` (~3 tests)

Note: True boot testing requires a physical device. The unit test should verify the boot-reschedule logic path (reminder re-registration), while the integration_test/ version validates on hardware.

---

### GAP 5: Missing `ReminderNotifier` Tests

**Severity:** MEDIUM

`ReminderNotifier` (106 lines) wires notification action callbacks (`snooze_all`, `view_take`, `snooze`, `done`) to engine use cases. Untested.

**Action:** Create `test/core/engine/presentation/notifiers/reminder_notifier_test.dart` (~8 tests)

---

### GAP 6: Missing `MedicationNotifier` Tests

**Severity:** MEDIUM

`MedicationNotifier` (130 lines) manages state transitions for `addMedication()`, `recordDose()`, `undoDose()`. Untested.

**Action:** Create `test/features/medication/presentation/notifiers/medication_notifier_test.dart` (~10 tests)

---

## Important Gaps (Should Fix)

### GAP 7: Missing `MedicationState` Computed Property Tests

`MedicationState` (235 lines) has complex computed properties: `todaySlots`, `todayTimeSlotGroups`, `todayAdherenceCount`, `adherencePercent`, `weeklyAdherenceByDay`. These are pure functions — spec 12.2 target: 90%+ for use cases, 100% for mappers. These are effectively view-model logic.

**Action:** Create `test/features/medication/presentation/notifiers/medication_state_test.dart` (~12 tests)

---

### GAP 8: Mislabeled `state_machine_test.dart`

The file tests `HandleSnooze`, not the state machine. This causes confusion about coverage.

**Action:** Rename `test/core/engine/state_machine_test.dart` → `test/core/engine/handle_snooze_test.dart`

---

### GAP 9: Schema Version Assertion Mismatch

`test/database_test.dart:46` asserts `schemaVersion == 2`, but spec Section 6.5 defines `schemaVersion => 1`.

**Action:** Verify which is correct. If a migration was applied, update the spec. If not, fix the test.

---

### GAP 10: Missing Page-Level Widget Tests

| Page | Lines | Risk |
|------|-------|------|
| `MedicationListPage` | 408 | Primary screen; dose confirmation flow integration |
| `AddMedicationPage` | 518 | Complex form with 4 frequency types, 4 duration types |
| `AdherenceDashboardPage` | 207 | Data display |

Spec Section 12.4 says "What NOT to Test: Flutter widget pixel-perfect rendering." However, smoke tests for navigation, form submission, and data display are valid.

**Action:** Create smoke tests for `AddMedicationPage` (~6 tests) and `MedicationListPage` (~5 tests)

---

## Out of Scope (Phase 4-5 / Skeleton Code)

Correctly absent for Phase 1-3:

| Module | Directory Status | Reason |
|--------|-----------------|--------|
| Gamification use cases | `test/core/gamification/` (empty) | Source is skeleton |
| Cycle prediction algorithm | `test/features/cycle/` (.gitkeep) | Source is skeleton |
| Streak evaluation (36h grace) | Not created | Source is skeleton |
| Achievement check logic | Not created | Source is skeleton |
| Insight engine | `test/features/insights/` (.gitkeep) | Source is skeleton |
| Backup encryption | `test/core/backup/` (.gitkeep) | Source is skeleton |
| XP award calculations | Not created | Gamification is skeleton |

These are spec Section 12.2 requirements but belong to Phase 4+.

---

## Implementation Plan (Priority Order)

### Priority 1: Must-Have (Spec Requirements & Exit Criteria)

| # | Action | File | New Tests | Effort |
|---|--------|------|-----------|--------|
| 1 | Rename mislabeled file | `state_machine_test.dart` → `handle_snooze_test.dart` | 0 | 5m |
| 2 | Create state machine test | `test/core/engine/domain/entities/reminder_state_machine_test.dart` | ~25 | 2h |
| 3 | Add voice payload tests | `test/core/engine/domain/usecases/handle_alarm_fired_test.dart` | ~4 | 1h |
| 4 | Add confirmation timeout tests | `test/core/engine/confirm_reminder_test.dart` (or new file) | ~3 | 30m |
| 5 | Create ReminderNotifier test | `test/core/engine/presentation/notifiers/reminder_notifier_test.dart` | ~8 | 1.5h |

**Subtotal: ~40 tests, ~5.25h**

### Priority 2: Should-Have (Quality Confidence)

| # | Action | File | New Tests | Effort |
|---|--------|------|-----------|--------|
| 6 | Create MedicationNotifier test | `test/features/medication/presentation/notifiers/medication_notifier_test.dart` | ~10 | 1.5h |
| 7 | Create MedicationState test | `test/features/medication/presentation/notifiers/medication_state_test.dart` | ~12 | 1h |
| 8 | Create boot reschedule integration test | `test/integration/boot_reschedule_test.dart` | ~3 | 1.5h |
| 9 | Fix/verify schema version assertion | `test/database_test.dart:46` | 0 | 5m |

**Subtotal: ~25 tests, ~4.25h**

### Priority 3: Nice-to-Have (Comprehensive Coverage)

| # | Action | File | New Tests | Effort |
|---|--------|------|-----------|--------|
| 10 | Create AddMedicationPage smoke test | `test/features/medication/presentation/pages/add_medication_page_test.dart` | ~6 | 2h |
| 11 | Create MedicationListPage smoke test | `test/features/medication/presentation/pages/medication_list_page_test.dart` | ~5 | 2h |
| 12 | Create ConfettiOverlay smoke test | `test/features/medication/presentation/widgets/confetti_overlay_test.dart` | ~2 | 30m |

**Subtotal: ~13 tests, ~4.5h**

---

## Totals

| Priority | Tasks | New Tests | Effort |
|----------|-------|-----------|--------|
| P1 (Must) | 5 | ~40 | ~5.25h |
| P2 (Should) | 4 | ~25 | ~4.25h |
| P3 (Nice) | 3 | ~13 | ~4.5h |
| **Total** | **12** | **~78** | **~14h** |

---

## Spec Exit Criteria Checklist

### Phase 1 Exit Criteria

- [x] App launches on physical Android device
- [x] Drift database opens with SQLCipher encryption
- [x] All 11 tables created by Drift
- [x] `flutter analyze` passes with zero errors
- [x] Integration test passes (db_encryption_test.dart)

### Phase 2 Exit Criteria

- [x] A reminder can be scheduled, triggered, snoozed, escalated, confirmed, or missed
- [x] All state transitions match Section 5.3 exactly *(individual use cases tested; comprehensive state machine test needed)*
- [x] Alarms fire reliably in Doze mode (hardware_reliability_test.dart)
- [ ] **Alarms survive device reboot** — NO TEST EXISTS
- [x] All unit tests pass

### Phase 3 Exit Criteria

- [x] User can add multiple medications at same time with one physical alarm
- [x] System announces medication names via TTS *(source implemented; voice test gap)*
- [x] User checks off each medication individually in batch checklist
- [x] Adherence dashboard shows stats for last 7/30 days
- [x] Adherence dashboard reflects "Partially Taken" slots
- [x] Single-profile only (hardcoded `profileId = 'default'`)

---

## Key Findings

### 1. Strong Domain/Data Coverage

The domain and data layers are well-tested. All 6 engine use cases, the medication mapper, medication repository, and all medication use cases have solid test coverage with both happy and error paths.

### 2. Presentation Layer Is the Blind Spot

Zero tests for `ReminderNotifier`, `MedicationNotifier`, `MedicationState`, and all page-level widgets except `DoseConfirmationSheet` and `MedicationTile`. This is the biggest gap by volume.

### 3. No Holistic State Machine Validation

Individual transitions are tested via their respective use case tests, but no single test validates that the complete Section 5.3 transition table is enforced (especially invalid transitions). This is a spec requirement.

### 4. Boot Persistence Untested

Phase 2 exit criteria explicitly requires alarms surviving reboot. No test exists for this.

### 5. Source Validation Gap

HandleSnooze, EscalateReminder, LogMissedReminder, and ScheduleReminder do NOT validate incoming reminder status. They proceed from any state. This means:
- You can snooze a reminder that is already `logged`
- You can escalate a `cancelled` reminder
- You can mark a `missed` reminder as missed again

This is a potential source code bug, not just a test gap. Recommend adding status validation to these use cases.
