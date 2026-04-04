# Implementation Plan: Feature Branch `tulon/medication-UI` Spec Compliance

> **Created:** 2026-04-02
> **Branch:** `tulon/medication-UI` (1 commit ahead of `master`)
> **Spec Reference:** `docs/SPECIFICATION.md` v3.2.1
> **Total Estimated Effort:** ~7.5 hours

---

## Table of Contents

1. [Priority Tiers](#priority-tiers)
2. [P0 — Ship-Blocking Fixes](#p0--ship-blocking-fixes)
3. [P1 — Architecture Fixes](#p1--architecture-fixes)
4. [P2 — Spec Compliance](#p2--spec-compliance)
5. [P3 — Test Coverage](#p3--test-coverage)
6. [Execution Order](#execution-order)
7. [Files Impact Summary](#files-impact-summary)

---

## Priority Tiers

| Tier | Description | Items |
|------|-------------|-------|
| **P0** | Ship-blocking: data bugs, UX violations that break the ADHD contract | 4 |
| **P1** | Architecture: dependency rule violations, clean architecture fixes | 3 |
| **P2** | Spec compliance: missing state machine states, security fix, cleanup | 4 |
| **P3** | Test coverage: missing tests to meet spec Section 12 requirements | 5 |

---

## P0 — Ship-Blocking Fixes

### P0-1: Fix adherence dashboard data bug (weekly chart shows zeros)

**Problem:**
`AdherenceDashboardPage._computeWeeklyAdherence()` at `adherence_dashboard_page.dart:145` filters `state.todaysDoses` — which only contains today's dose records. The 7-day chart shows zeros for all past days.

**Root Cause:**
`MedicationNotifier.build()` only loads today's dose records via `getDoseRecordsInRange(med.id, todayStart, todayEnd)`. The `_computeWeeklyAdherence` method attempts to filter this single-day data across 7 days, resulting in empty arrays for days 1-6.

**Fix:**

1. Add a `weeklyDoses` field to `MedicationState`:
   ```dart
   @Default([]) List<DoseRecord> weeklyDoses,
   ```

2. In `MedicationNotifier.build()`, load 7 days of dose records:
   ```dart
   final weekStart = DateTime(now.year, now.month, now.day)
       .subtract(const Duration(days: 6))
       .millisecondsSinceEpoch;

   final allWeeklyDoses = <DoseRecord>[];
   for (final med in medications) {
     final doses = await repository.getDoseRecordsInRange(
       med.id, weekStart, todayEnd,
     );
     allWeeklyDoses.addAll(doses);
   }
   ```

3. Update `_computeWeeklyAdherence` to use `state.weeklyDoses` instead of `state.todaysDoses`.

4. Regenerate `medication_state.freezed.dart`.

**Files changed:**
- `lib/features/medication/presentation/notifiers/medication_state.dart`
- `lib/features/medication/presentation/notifiers/medication_notifier.dart`
- `lib/features/medication/presentation/pages/adherence_dashboard_page.dart`
- `lib/features/medication/presentation/notifiers/medication_state.freezed.dart` (regenerated)

**Estimated effort:** 30min

---

### P0-2: Remove "Missed" stat card from adherence dashboard

**Problem:**
The dashboard shows a prominent "Missed" stat card with red `Icons.cancel` at `adherence_dashboard_page.dart:101-106`. This violates spec Section 10.1:

> *"Progress, not perfection: Show streak counters, XP bars, percentage adherence, trend arrows. Never show 'failures.'"*

**Fix:**
Replace the "Missed" `_StatCard` with a progress-oriented "Total" card:

```dart
_StatCard(
  icon: Icons.event_note,
  color: ADHDColors.neutral,
  value: '${slots.length}',
  label: 'Total',
  theme: theme,
),
```

This shows the total number of scheduled doses for the day — factual and progress-oriented without shaming.

**Files changed:**
- `lib/features/medication/presentation/pages/adherence_dashboard_page.dart`

**Estimated effort:** 15min

---

### P0-3: Fix medication ID generation to use UUID v4

**Problem:**
`AddMedicationPage._save()` at line 414 generates `'med_$now'` (timestamp-based). Spec Section 6.3 requires:

> *"Primary keys are TEXT (UUID v4)"*

Timestamp IDs are not collision-safe under rapid creation.

**Fix:**
```dart
import 'package:uuid/uuid.dart';

// In _save():
final medication = Medication(
  id: const Uuid().v4(),  // was: 'med_$now'
  // ...
);
```

**Files changed:**
- `lib/features/medication/presentation/pages/add_medication_page.dart`

**Estimated effort:** 5min

---

### P0-4: Fix confetti delay to match spec (300ms not 400ms)

**Problem:**
`DoseConfirmationSheet._onConfirmed()` uses a 400ms delay before dismissal. Spec Section 10.1 requires:

> *"300ms confetti animation + haptic pulse + XP popup on confirmation."*

**Fix:**
Change `Future.delayed(Duration(milliseconds: 400))` to `Duration(milliseconds: 300)` in `dose_confirmation_sheet.dart`.

**Files changed:**
- `lib/features/medication/presentation/widgets/dose_confirmation_sheet.dart`

**Estimated effort:** 5min

---

## P1 — Architecture Fixes

### P1-1: Extract domain port interfaces for all platform services

**Problem:**
6 domain use cases directly import concrete platform classes (`AlarmService`, `NotificationService`, `VoiceService`), violating spec Section 2.2:

> *"Dependencies point inward ONLY. The Domain layer has ZERO dependencies on any other layer."*

**Affected use cases:**

| Use Case | Current Platform Import |
|----------|------------------------|
| `ScheduleReminder` | `AlarmService` |
| `HandleSnooze` | `AlarmService` |
| `ConfirmReminder` | `AlarmService` |
| `EscalateReminder` | `AlarmService` |
| `LogMissedReminder` | `AlarmService` |
| `HandleAlarmFired` | `NotificationService`, `VoiceService` |
| `UndoDose` (features) | `AlarmService` |

**Fix — Step 1: Create 3 port interfaces:**

```
lib/core/engine/domain/ports/
  alarm_port.dart
  notification_port.dart
  voice_port.dart
```

`alarm_port.dart`:
```dart
/// Port for hardware alarm scheduling.
/// Implemented by AlarmService in the platform layer.
abstract class AlarmPort {
  Future<bool> setAlarm({
    required int id,
    required DateTime dateTime,
    required String notificationTitle,
    required String notificationBody,
  });
  Future<bool> stopAlarm(int id);
  Future<bool> isAlarmActive(int id);
}
```

`notification_port.dart`:
```dart
/// Port for notification display.
/// Implemented by NotificationService in the platform layer.
abstract class NotificationPort {
  Future<void> showMedicationReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isCritical,
  });
  Future<void> cancel(int id);
}
```

`voice_port.dart`:
```dart
/// Port for TTS voice announcements.
/// Implemented by VoiceService in the platform layer.
abstract class VoicePort {
  Future<void> speakAnnouncement({
    required String slotName,
    List<String>? itemNames,
    List<String?>? customMessages,
  });
  Future<void> stop();
}
```

**Fix — Step 2: Make platform services implement the ports:**

```dart
class AlarmService implements AlarmPort { ... }
class NotificationService implements NotificationPort { ... }
class VoiceService implements VoicePort { ... }
```

**Fix — Step 3: Update all use cases to depend on ports:**

Replace concrete types with abstract ports in constructor parameters and private fields. For example:

```dart
// Before:
class ScheduleReminder {
  final AlarmService _alarmService;
  const ScheduleReminder({required AlarmService alarmService});
}

// After:
class ScheduleReminder {
  final AlarmPort _alarmPort;
  const ScheduleReminder({required AlarmPort alarmPort});
}
```

**Fix — Step 4: Update DI (`injection.dart`):**

The provider wiring changes from:
```dart
ScheduleReminder(alarmService: ref.watch(alarmServiceProvider))
```
to:
```dart
ScheduleReminder(alarmPort: ref.watch(alarmServiceProvider))
```

No new providers are needed — `AlarmService` already satisfies `AlarmPort` via the `implements` clause.

**Files created:** 3 (port interfaces)
**Files modified:** 10 (6 engine use cases + `UndoDose` + 3 platform services + `injection.dart`)

**Estimated effort:** 1.5h

---

### P1-2: Extract DoseQueryPort to fix engine->feature dependency

**Problem:**
`HandleAlarmFired` (in `core/engine/`) imports `MedicationRepository` from `features/medication/`. Spec Section 3.2:

> *"Reminder Engine must NOT depend on any Feature Module."*

And Section 3.3:

> *"No file in lib/core/engine/ imports from lib/features/"*

**Fix — Step 1: Create the port interface:**

```
lib/core/engine/domain/ports/dose_query_port.dart
```

```dart
/// Port for querying dose and medication data at alarm-fire-time.
///
/// Lives in core/engine/domain so HandleAlarmFired can depend on it
/// without importing any feature module. Implemented by the medication
/// feature's repository.
abstract class DoseQueryPort {
  Future<List<DoseQueryResult>> getDoseRecordsForReminder(String reminderId);
  Future<MedicationInfo?> getMedicationInfoById(String id);
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
```

**Fix — Step 2: Update `HandleAlarmFired`:**

Replace `MedicationRepository` with `DoseQueryPort`. Remove the `features/medication` import entirely.

```dart
// Before:
import '.../features/medication/domain/repositories/medication_repository.dart';
final MedicationRepository _medicationRepository;

// After:
import '.../core/engine/domain/ports/dose_query_port.dart';
final DoseQueryPort _doseQueryPort;
```

**Fix — Step 3: Implement `DoseQueryPort` in `MedicationRepositoryImpl`:**

```dart
class MedicationRepositoryImpl implements MedicationRepository, DoseQueryPort {
  @override
  Future<List<DoseQueryResult>> getDoseRecordsForReminder(String reminderId) async {
    final records = await _dao.getDoseRecordsByReminder(reminderId);
    return records.map((r) => DoseQueryResult(
      medicationId: r.medicationId,
      status: r.status,
    )).toList();
  }

  @override
  Future<MedicationInfo?> getMedicationInfoById(String id) async {
    final med = await _dao.getMedicationById(id);
    if (med == null) return null;
    return MedicationInfo(
      name: med.name,
      reminderMessage: med.reminderMessage,
      isCritical: med.isCritical,
    );
  }
}
```

**Fix — Step 4: Update DI:**

```dart
final handleAlarmFiredProvider = Provider<HandleAlarmFired>((ref) {
  return HandleAlarmFired(
    reminderRepository: ref.watch(reminderRepositoryProvider),
    doseQueryPort: ref.watch(medicationRepositoryProvider), // implements DoseQueryPort
    notificationPort: ref.watch(notificationServiceProvider),
    voicePort: ref.watch(voiceServiceProvider),
  );
});
```

**Files created:** 1 (`dose_query_port.dart`)
**Files modified:** 3 (`handle_alarm_fired.dart`, `medication_repository_impl.dart`, `injection.dart`)

**Estimated effort:** 45min

---

### P1-3: Wire `medicationRepositoryProvider` (currently throws UnimplementedError)

**Problem:**
`injection.dart:125-130` throws `UnimplementedError` for `medicationRepositoryProvider`. The `MedicationRepositoryImpl` exists and the `MedicationMapper` was added on this branch, but the provider was never wired.

**Fix:**
```dart
import '.../medication/data/repositories/medication_repository_impl.dart';
import '.../medication/data/mappers/medication_mapper.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  final databaseAsync = ref.watch(databaseProvider);
  return databaseAsync.when(
    data: (db) => MedicationRepositoryImpl(
      dao: db.medicationDao,
      mapper: MedicationMapper(),
    ),
    loading: () => throw Exception('Database not initialized'),
    error: (e, st) => throw Exception('Database error: $e'),
  );
});
```

**Files changed:**
- `lib/app/di/injection.dart`

**Estimated effort:** 10min

---

## P2 — Spec Compliance

### P2-1: Implement `confirmationRequired` state transition

**Problem:**
Spec Section 5.3 requires a `confirmationRequired` state between `triggered` and `logged`:

| From State | Event | To State |
|---|---|---|
| `triggered` | User taps "Done" | `confirmationRequired` |
| `confirmationRequired` | User confirms (interaction proof) | `logged` |
| `confirmationRequired` | confirmation_window expires (30s) | `triggered` |

The current `ConfirmReminder` use case goes directly `triggered -> logged`, skipping `confirmationRequired`.

**Fix — Step 1: Split `ConfirmReminder` into two phases:**

a) **`ConfirmReminder.call(reminderId)`** (modify existing):
   - Validate current state is `triggered` or `escalating`
   - Transition to `confirmationRequired`
   - Log event `'confirmation_requested'`
   - Return updated reminder (caller uses `policy.confirmationWindowSeconds` for timeout)

b) **Create `FinalizeConfirmation` use case** (new file):
   ```
   lib/core/engine/domain/usecases/finalize_confirmation.dart
   ```
   - Validate current state is `confirmationRequired`
   - Transition to `logged`, set `completedAt`
   - Stop alarm
   - Log event `'confirmed'`
   - TODO: Trigger gamification XP award

**Fix — Step 2: Update `DoseConfirmationSheet` flow:**

The `DoseConfirmationSheet` already implements swipe-to-confirm and tap-3x interaction proofs. The updated flow:

1. User opens `DoseConfirmationSheet` -> notifier calls `ConfirmReminder` -> `confirmationRequired`
2. User completes swipe/tap-3x -> notifier calls `FinalizeConfirmation` -> `logged`
3. Sheet dismissed without completing -> timeout returns to `triggered`

**Fix — Step 3: Add timeout handling in `ReminderNotifier`:**

When a reminder enters `confirmationRequired`, schedule a `Future.delayed` for `policy.confirmationWindowSeconds`. If the reminder is still in `confirmationRequired` when it fires, transition back to `triggered`.

**Fix — Step 4: Update DI:**

Register `finalizeConfirmationProvider` in `injection.dart`.

**Files created:** 1 (`finalize_confirmation.dart`)
**Files modified:** 5 (`confirm_reminder.dart`, `reminder_notifier.dart`, `medication_notifier.dart` or `medication_list_page.dart`, `injection.dart`, `dose_confirmation_sheet.dart`)
**Tests:** 2 (modify `confirm_reminder_test.dart`, create `finalize_confirmation_test.dart`)

**Estimated effort:** 2h

---

### P2-2: Fix passphrase generation for new installs

**Problem:**
`injection.dart:31` uses `DateTime.now().millisecondsSinceEpoch.toString()` as the encryption passphrase. Spec Section 6.2 requires:

> *"First Launch: SecureStorageImpl generates a random 32-byte passphrase using `dart:math` `Random.secure()`."*

A timestamp-based passphrase is predictable and insecure.

**Fix:**
Only affects first-launch generation. Existing passphrases are already stored in `flutter_secure_storage` and continue working unchanged.

```dart
import 'dart:convert';
import 'dart:math';

// In databaseProvider:
if (passphrase == null || passphrase.isEmpty) {
  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  passphrase = base64Url.encode(bytes);
  await storage.write('db_passphrase', passphrase);
}
```

**Files changed:**
- `lib/app/di/injection.dart`

**Estimated effort:** 10min

---

### P2-3: Clean up debug/test artifacts from production paths

**Problem:**
- `main.dart` contains `_runHardwareReliabilitySetup()` which schedules a test alarm (id=888) on every app launch
- Initial route is `/test` instead of `/medications`
- Navigation bar has a "test" destination at index 0, causing index mismatch bugs

**Fix:**

1. **`main.dart`**: Remove `_runHardwareReliabilitySetup()` call and method body. Remove `permission_handler` import if only used there.

2. **`app.dart`**:
   - Change `initialLocation: '/test'` to `initialLocation: '/medications'`
   - Remove the `/test` `GoRoute`
   - Remove "test" `NavigationDestination` from the `NavigationBar`
   - Fix `_calculateSelectedIndex` to map: `/medications` -> 0, `/cycle` -> 1, `/insights` -> 2
   - Fix `_onItemTapped` to match: 0 -> `/medications`, 1 -> `/cycle`, 2 -> `/insights`

3. **Delete** `lib/features/test_screen.dart`

The hardware reliability test functionality remains available in `integration_test/hardware_reliability_test.dart` where it belongs.

**Files changed:**
- `lib/main.dart`
- `lib/app/app.dart`

**Files deleted:**
- `lib/features/test_screen.dart`

**Estimated effort:** 20min

---

### P2-4: Fix month arithmetic overflow in AddMedicationPage

**Problem:**
`_buildCustomDuration()` in `add_medication_page.dart` adds months via `DateTime(now.year, now.month + months, now.day)`. Adding months to day 31 can create unexpected date shifts (e.g., Jan 31 + 1 month = March 3 due to Dart's DateTime overflow behavior).

**Fix:**
Add a safe month-addition helper:

```dart
DateTime _addMonths(DateTime date, int months) {
  final targetMonth = date.month + months;
  final targetYear = date.year + (targetMonth - 1) ~/ 12;
  final normalizedMonth = ((targetMonth - 1) % 12) + 1;
  final lastDayOfMonth = DateTime(targetYear, normalizedMonth + 1, 0).day;
  final clampedDay = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
  return DateTime(targetYear, normalizedMonth, clampedDay);
}
```

Use this helper in `_buildCustomDuration()` instead of raw `DateTime` arithmetic.

**Files changed:**
- `lib/features/medication/presentation/pages/add_medication_page.dart`

**Estimated effort:** 15min

---

## P3 — Test Coverage

### P3-1: Add time-slot merging test for `AddMedication`

**Gap:**
No test verifies that adding a 2nd medication at the same time-slot reuses an existing Reminder (incrementing `groupDoseCount`) instead of creating a duplicate alarm. This is a core spec requirement (Section 7.1, Section 8.1.2).

**Test cases:**
1. Two medications at 08:00 -> only 1 Reminder with `groupDoseCount: 2`
2. Two medications at different times (08:00 and 20:00) -> 2 Reminders, each with `groupDoseCount: 1`
3. Adding a 3rd medication at 08:00 -> existing Reminder updated to `groupDoseCount: 3`

**File:** `test/features/medication/add_medication_test.dart` (append to existing)

**Estimated effort:** 30min

---

### P3-2: Add gesture completion tests for DoseConfirmationSheet

**Gap:**
Widget tests verify static UI but never perform the swipe or tap-3x gestures to verify the `onConfirmed` callback fires.

**Test cases:**
1. Swipe-to-confirm: `tester.drag()` > 85% threshold -> `onConfirmed` callback fires
2. Swipe-to-confirm: `tester.drag()` < 85% threshold -> callback does NOT fire (snaps back)
3. Tap-3x: 3 sequential `tester.tap()` calls -> `onConfirmed` callback fires
4. Tap-3x: 2 taps only -> callback does NOT fire (progress shows 2/3)

**File:** `test/features/medication/presentation/widgets/dose_confirmation_sheet_test.dart` (append)

**Estimated effort:** 45min

---

### P3-3: Add weekly/interval frequency tests for AddMedication

**Gap:**
Only `daily` and `asNeeded` frequencies are tested. Spec Section 8.1.1 defines 4 frequency types.

**Test cases:**
1. Weekly frequency (Mon/Wed/Fri at 08:00) -> creates reminders only on those weekdays within the duration window
2. Interval frequency (every 8 hours) -> creates reminders at 8-hour intervals from the first time slot
3. Weekly with multiple times (Mon at 08:00, 20:00) -> correct reminder count

**File:** `test/features/medication/add_medication_test.dart` (append)

**Estimated effort:** 30min

---

### P3-4: Add `confirmationRequired` state machine tests

**Covers the new state added in P2-1.**

**Test cases:**
1. `triggered -> confirmationRequired` on user tap "Done"
2. `confirmationRequired -> logged` on confirmed interaction proof
3. `confirmationRequired -> triggered` on confirmation window timeout (30s)
4. `escalating -> confirmationRequired` on user response during escalation
5. Invalid: `scheduled -> confirmationRequired` (should throw/reject)
6. Invalid: `missed -> confirmationRequired` (terminal state, should throw)

**Files:**
- `test/core/engine/confirm_reminder_test.dart` (update existing)
- `test/core/engine/finalize_confirmation_test.dart` (new)

**Estimated effort:** 45min

---

### P3-5: Update engine tests to use port interfaces

**Covers the architecture changes from P1-1 and P1-2.**

After the port extraction, all engine tests need to mock the abstract ports instead of concrete platform services.

**Changes:**
- Replace `MockAlarmService` with `MockAlarmPort` in all engine tests
- Replace `MockNotificationService`/`MockVoiceService` with `MockNotificationPort`/`MockVoicePort` in `handle_alarm_fired_test.dart`
- Replace `MockMedicationRepository` with `MockDoseQueryPort` in `handle_alarm_fired_test.dart`
- Verify tests still pass with the abstract interfaces

**Files modified:**
- `test/core/engine/schedule_reminder_test.dart`
- `test/core/engine/state_machine_test.dart`
- `test/core/engine/confirm_reminder_test.dart`
- `test/core/engine/escalate_reminder_test.dart`
- `test/core/engine/log_missed_reminder_test.dart`
- `test/core/engine/domain/usecases/handle_alarm_fired_test.dart`

**Estimated effort:** 30min

---

## Execution Order

Tasks are ordered to minimize rework (later tasks build on earlier ones).

```
Phase A — Ship-Blockers (P0)                         ~55min
  P0-3  Fix medication ID to UUID v4                    5min
  P0-4  Fix confetti delay 400ms -> 300ms               5min
  P0-2  Remove "Missed" stat card                      15min
  P0-1  Fix adherence dashboard data bug               30min

Phase B — Architecture (P1)                        ~2h 15min
  P1-1  Extract port interfaces                       1h 30min
  P1-2  Extract DoseQueryPort                           45min
  P1-3  Wire medicationRepositoryProvider               10min
    (P1-3 depends on P1-2 since the provider now also serves as DoseQueryPort)

Phase C — Spec Compliance (P2)                     ~2h 45min
  P2-2  Fix passphrase generation                       10min
  P2-3  Clean up debug/test artifacts                   20min
  P2-4  Fix month arithmetic overflow                   15min
  P2-1  Implement confirmationRequired state             2h
    (P2-1 depends on P1-1 since ConfirmReminder uses AlarmPort)

Phase D — Tests (P3)                               ~2h 30min
  P3-5  Update engine tests for port interfaces         30min
    (P3-5 depends on P1-1)
  P3-4  confirmationRequired state tests                45min
    (P3-4 depends on P2-1)
  P3-1  Time-slot merging test                          30min
  P3-3  Weekly/interval frequency tests                 30min
  P3-2  Gesture completion tests                        45min
    (P3-2 can run in parallel with P3-1/P3-3)
```

**Total: ~7h 30min**

---

## Files Impact Summary

### New Files (6)

| File | Purpose |
|------|---------|
| `lib/core/engine/domain/ports/alarm_port.dart` | Abstract interface for alarm scheduling |
| `lib/core/engine/domain/ports/notification_port.dart` | Abstract interface for notification display |
| `lib/core/engine/domain/ports/voice_port.dart` | Abstract interface for TTS announcements |
| `lib/core/engine/domain/ports/dose_query_port.dart` | Abstract interface for dose/medication queries (breaks engine->feature dependency) |
| `lib/core/engine/domain/usecases/finalize_confirmation.dart` | Second step of confirmation flow (confirmationRequired -> logged) |
| `test/core/engine/finalize_confirmation_test.dart` | Tests for the new use case |

### Modified Files (~22)

| File | Changes |
|------|---------|
| `lib/core/engine/domain/usecases/schedule_reminder.dart` | `AlarmService` -> `AlarmPort` |
| `lib/core/engine/domain/usecases/handle_snooze.dart` | `AlarmService` -> `AlarmPort` |
| `lib/core/engine/domain/usecases/confirm_reminder.dart` | `AlarmService` -> `AlarmPort`, change to `confirmationRequired` transition |
| `lib/core/engine/domain/usecases/escalate_reminder.dart` | `AlarmService` -> `AlarmPort` |
| `lib/core/engine/domain/usecases/log_missed_reminder.dart` | `AlarmService` -> `AlarmPort` |
| `lib/core/engine/domain/usecases/handle_alarm_fired.dart` | `MedicationRepository` -> `DoseQueryPort`, `NotificationService` -> `NotificationPort`, `VoiceService` -> `VoicePort` |
| `lib/features/medication/domain/usecases/undo_dose.dart` | `AlarmService` -> `AlarmPort` |
| `lib/core/platform/alarm_service.dart` | Add `implements AlarmPort` |
| `lib/core/platform/notification_service.dart` | Add `implements NotificationPort` |
| `lib/core/platform/voice_service.dart` | Add `implements VoicePort` |
| `lib/features/medication/data/repositories/medication_repository_impl.dart` | Add `implements DoseQueryPort` |
| `lib/app/di/injection.dart` | Wire `medicationRepositoryProvider`, fix passphrase, update use case constructor args |
| `lib/features/medication/presentation/notifiers/medication_state.dart` | Add `weeklyDoses` field |
| `lib/features/medication/presentation/notifiers/medication_notifier.dart` | Load weekly data, update confirmation flow |
| `lib/features/medication/presentation/pages/adherence_dashboard_page.dart` | Use `weeklyDoses`, replace "Missed" card |
| `lib/features/medication/presentation/pages/add_medication_page.dart` | UUID v4 IDs, fix month arithmetic |
| `lib/features/medication/presentation/widgets/dose_confirmation_sheet.dart` | Fix 400ms -> 300ms, update confirmation flow |
| `lib/core/engine/presentation/notifiers/reminder_notifier.dart` | Add confirmation timeout handling |
| `lib/main.dart` | Remove debug code |
| `lib/app/app.dart` | Remove test route, fix initial location and nav indices |
| `lib/features/medication/presentation/notifiers/medication_state.freezed.dart` | Regenerated |

### Deleted Files (1)

| File | Reason |
|------|--------|
| `lib/features/test_screen.dart` | Debug screen; functionality covered by `integration_test/hardware_reliability_test.dart` |

### Test Files Modified (~8)

| File | Changes |
|------|---------|
| `test/core/engine/schedule_reminder_test.dart` | `MockAlarmService` -> `MockAlarmPort` |
| `test/core/engine/state_machine_test.dart` | `MockAlarmService` -> `MockAlarmPort` |
| `test/core/engine/confirm_reminder_test.dart` | Update for `confirmationRequired` transition, use `MockAlarmPort` |
| `test/core/engine/escalate_reminder_test.dart` | `MockAlarmService` -> `MockAlarmPort` |
| `test/core/engine/log_missed_reminder_test.dart` | `MockAlarmService` -> `MockAlarmPort` |
| `test/core/engine/domain/usecases/handle_alarm_fired_test.dart` | Use `MockDoseQueryPort`, `MockNotificationPort`, `MockVoicePort` |
| `test/features/medication/add_medication_test.dart` | Add time-slot merging + weekly/interval tests |
| `test/features/medication/presentation/widgets/dose_confirmation_sheet_test.dart` | Add gesture completion tests |

---

## Validation Checklist

After all phases are complete, verify:

- [ ] `flutter analyze` passes with zero errors
- [ ] All existing tests pass (`flutter test`)
- [ ] All new tests pass
- [ ] `build_runner` generates without errors
- [ ] No file in `lib/*/domain/` imports from `lib/*/data/` or `lib/*/platform/`
- [ ] No file in `lib/core/engine/` imports from `lib/features/`
- [ ] No file in `lib/core/gamification/` imports from `lib/features/`
- [ ] No file in `lib/features/medication/` imports from `lib/features/cycle/`
- [ ] Initial route is `/medications` (not `/test`)
- [ ] No debug alarm scheduling in `main.dart`
- [ ] Adherence dashboard shows 7-day chart with real data
- [ ] Adherence dashboard does NOT show "Missed" count
- [ ] Medication IDs are UUID v4 format
- [ ] Confirmation sheet dismisses in 300ms
- [ ] State machine includes `confirmationRequired` state
- [ ] New installs generate cryptographically secure passphrase
