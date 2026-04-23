# Fix: Alarm & Notification Not Working on Android 15

**Date:** 2026-04-23
**Status:** In Progress
**Priority:** Critical
**Reported:** User tested on Android 15 physical device

---

## Problem Statement

User set a medication reminder for 9:30 AM. The alarm fires, audio plays, a notification appears — but:
1. The alarm fires at the **wrong time** (UTC instead of local timezone)
2. There is **no option to close/snooze** the alarm from the notification
3. User had to **kill all background apps** to stop the alarm tone

---

## Root Cause Analysis

### Bug 1: Timezone Mismatch (CRITICAL)
**File:** `lib/features/medication/domain/usecases/reminder_generator.dart`

All 4 time-slot creation methods use `DateTime.utc()` to build scheduled times:
```dart
// Line 32
final now = DateTime.now().toUtc(); // ← startDate is UTC

// Lines 157, 189, 239
final scheduledDateTime = DateTime.utc(  // ← creates UTC time
  date.year, date.month, date.day,
  minutesFromMidnight ~/ 60,
  minutesFromMidnight % 60,
);
```

**Impact:** A UTC+6 user setting 9:30 AM local gets an alarm at 9:30 AM UTC = 3:30 PM local. A UTC-5 user gets 9:30 AM UTC = 4:30 AM local. The `minutesFromMidnight` value (e.g., 570 for 9:30) is resolved against UTC, not the user's timezone.

**Fix:** Use `DateTime(...)` (local constructor) instead of `DateTime.utc(...)`, and use `DateTime.now()` instead of `DateTime.now().toUtc()` for the start date.

### Bug 2: No Dismiss/Stop Button on Alarm Notification (CRITICAL)
**File:** `lib/core/platform/alarm_service.dart:58-61`

The alarm package's `NotificationSettings` has empty title/body and no `stopButton`:
```dart
notificationSettings: NotificationSettings(
    title: '',       // ← invisible notification
    body: '',        // ← invisible notification
    // stopButton is null → NO stop button shown
),
```

The alarm package (`alarm` v5.2.1) supports a `stopButton` property on `NotificationSettings` that renders a native Android button. When null (default), **no button is shown**. The alarm plays indefinitely with no way to dismiss it from the notification shade.

The stop button is handled entirely in native Kotlin (`AlarmReceiver → AlarmService.handleStopAlarmCommand`) — it works even when the Flutter engine is killed.

**Fix:** Pass meaningful `title`/`body` and set `stopButton: 'Dismiss'`.

### Bug 3: Notification ID Conflict (HIGH)
**File:** `lib/core/engine/domain/usecases/handle_alarm_fired.dart:111`

`handleAlarmFired` shows a `flutter_local_notifications` notification using the **same ID** as the alarm package's foreground service notification (`reminder.id.hashCode`). On Android, the alarm package creates a foreground service notification with this ID via `startForeground(id, notification)`. When `flutter_local_notifications` tries to update this notification with medication content and action buttons, the update may silently fail on Android 15 because:
- Foreground service notifications are "sticky" and managed by the system
- Updating a foreground service notification's channel (from `alarm_plugin_channel` to `medication_reminders`) may not work on Android 15
- The action buttons (Snooze All, View/Take) may not render on the updated notification

Result: user sees the alarm notification (from the package) but NOT the medication notification with snooze/take buttons.

**Fix:** Use the same notification ID but ensure the `flutter_local_notifications` notification includes a "Dismiss" action alongside "Snooze All" and "Take". This way:
- If the update succeeds → single notification with all 3 buttons
- If the update fails → alarm package's notification still has Dismiss button (from Bug 2 fix)

---

## Fix Plan

### Phase 1: Timezone Fix
**File:** `lib/features/medication/domain/usecases/reminder_generator.dart`

| Line | Current | Fixed |
|------|---------|-------|
| 32   | `final now = DateTime.now().toUtc();` | `final now = DateTime.now();` |
| 157  | `DateTime.utc(date.year, date.month, date.day, ...)` | `DateTime(date.year, date.month, date.day, ...)` |
| 189  | `DateTime.utc(date.year, date.month, date.day, ...)` | `DateTime(date.year, date.month, date.day, ...)` |
| 239  | `DateTime.utc(date.year, date.month, date.day, ...)` | `DateTime(date.year, date.month, date.day, ...)` |

**Note:** `nowMillis` comparison still works correctly because `.millisecondsSinceEpoch` is always UTC epoch regardless of the DateTime's `isUtc` flag. The `scheduledTime` stored in the database remains timezone-independent (epoch ms).

**Edge case verification:**
- UTC+6 user at 8:00 AM local → `now` = April 23 local → `DateTime(2026, 4, 23, 9, 30)` = 9:30 AM local → epoch = 3:30 AM UTC → `3:30 AM UTC > 2:00 AM UTC` ✓ slot created
- UTC-5 user at 8:00 PM local → `now` = April 22 local → `DateTime(2026, 4, 22, 9, 30)` = 9:30 AM local = 2:30 PM UTC → `2:30 PM UTC April 22 < 1:00 AM UTC April 23` → skipped (correct, already past)
- Next day: `DateTime(2026, 4, 23, 9, 30)` = 9:30 AM local April 23 = 2:30 PM UTC April 23 → created ✓

### Phase 2: Alarm Notification — Dismiss Button + Meaningful Text
**File:** `lib/core/platform/alarm_service.dart`

Change `setAlarm()` method's `NotificationSettings`:
```dart
// BEFORE (lines 58-61)
notificationSettings: NotificationSettings(
    title: '',
    body: '',
),

// AFTER
notificationSettings: NotificationSettings(
    title: notificationTitle,
    body: notificationBody,
    stopButton: 'Dismiss',
),
```

**Why this works:** The alarm package's `NotificationService.kt` (line 91-94) renders the stop button natively:
```kotlin
if (it.stopButton != null) {
    notificationBuilder.addAction(0, it.stopButton, stopPendingIntent)
}
```
The `stopPendingIntent` calls `AlarmReceiver` with `ACTION_ALARM_STOP`, which triggers `AlarmService.handleStopAlarmCommand()` → stops audio, vibration, and foreground service. All native — no Flutter dependency.

### Phase 3: Medication Notification — Add Dismiss Action + Same ID
**File:** `lib/core/platform/notification_service.dart`

Add a third action button to the medication notification channel:
```dart
actions: const [
    AndroidNotificationAction('dismiss', 'Dismiss'),
    AndroidNotificationAction('snooze_all', 'Snooze'),
    AndroidNotificationAction('view_take', 'Take'),
],
```

### Phase 4: Handle Dismiss Action in main.dart
**File:** `lib/main.dart`

Add handler for the 'dismiss' action in the `onActionPressed` callback:
```dart
notificationService.onActionPressed = (String action, String? reminderId) async {
    if (reminderId == null) return;
    switch (action) {
        case 'dismiss':
            // Stop the alarm audio — reminder stays in 'triggered' state
            // for the user to take/snooze when they open the app
            final reminder = await reminderRepository.getById(reminderId);
            if (reminder != null) {
                await alarmService.stopAlarm(reminder.id.hashCode);
            }
        case 'snooze_all':
        case 'snooze':
            await handleSnooze.call(reminderId);
        case 'view_take':
        case 'done':
            final reminder = await reminderRepository.getById(reminderId);
            if (reminder != null &&
                (reminder.status == ReminderStatus.triggered ||
                    reminder.status == ReminderStatus.confirmationRequired)) {
                await confirmReminder.call(reminderId);
            }
    }
};
```

### Phase 5: Verify Notification ID Alignment
**File:** `lib/core/engine/domain/usecases/handle_alarm_fired.dart`

The current code uses `alarmId` (which is `reminder.id.hashCode`) for the notification ID. This is the SAME ID as the alarm package's foreground service notification. This is intentional — `flutter_local_notifications` updates the foreground notification with medication content and action buttons.

**No change needed** — just verify this works after the other fixes.

---

## Files Modified (Summary)

| # | File | Change |
|---|------|--------|
| 1 | `lib/features/medication/domain/usecases/reminder_generator.dart` | `DateTime.utc()` → `DateTime()`, `DateTime.now().toUtc()` → `DateTime.now()` |
| 2 | `lib/core/platform/alarm_service.dart` | Add title/body/stopButton to `NotificationSettings` |
| 3 | `lib/core/platform/notification_service.dart` | Add 'dismiss' action button |
| 4 | `lib/main.dart` | Handle 'dismiss' action in onActionPressed |

---

## Testing Checklist

- [ ] Set a reminder 1-2 minutes in the future → verify it fires at the correct LOCAL time
- [ ] When alarm fires → notification shows medication name (not empty)
- [ ] Notification has "Dismiss" button → tapping it stops the alarm audio
- [ ] Notification has "Snooze" button → tapping it snoozes the reminder
- [ ] Notification has "Take" button → tapping it confirms the medication
- [ ] Kill the app (swipe away from recents) → set reminder → alarm still fires
- [ ] Kill the app → alarm fires → Dismiss button still works (native fallback)
- [ ] Test in UTC+ timezone (e.g., UTC+6) → alarm fires at correct local time
- [ ] Test in UTC- timezone (e.g., UTC-5) → alarm fires at correct local time

---

## Deferred Issues — Implementation Plans

---

### Deferred 1: No Next-Alarm Scheduling After Fire

**Severity:** CRITICAL (only the first reminder per medication ever fires)
**Files:** `handle_alarm_fired.dart`, `finalize_confirmation.dart`, `log_missed_reminder.dart`, `alarm_port.dart`, `reminder_repository.dart`

#### Problem

The alarm chain has a single entry point: `AddMedication.call()` schedules the earliest upcoming reminder's alarm via `AlarmScheduler.scheduleAlarm()`. After that alarm fires, NO code schedules the next upcoming reminder's alarm. The chain is broken.

**Current flow (broken):**
```
AddMedication → schedules alarm for Reminder #1
Reminder #1 fires → handleAlarmFired → notification shown → escalation check
                       ↑ NO scheduling of Reminder #2
User confirms → finalizeConfirmation → stops alarm → NO scheduling of next
User misses → logMissedReminder → stops alarm → NO scheduling of next
```

**Required flow:**
```
AddMedication → schedules alarm for Reminder #1
Reminder #1 fires → handleAlarmFired → notification → schedule NEXT upcoming alarm
User confirms → finalizeConfirmation → stops alarm → schedule NEXT upcoming alarm
User misses → logMissedReminder → stops alarm → schedule NEXT upcoming alarm
User snoozes → handleSnooze → re-schedules SAME reminder (already works ✓)
Escalation → handleEscalationCheck → re-triggers SAME reminder (already works ✓)
```

#### Implementation Plan

**Step 1: Add `scheduleNextUpcomingAlarm()` method to `AlarmPort`**

File: `lib/core/engine/domain/ports/alarm_port.dart`

Add a new method:
```dart
/// Queries the database for the next upcoming reminder in 'scheduled' status
/// and schedules its alarm. Returns the scheduled Reminder or null if none found.
Future<Reminder?> scheduleNextUpcomingAlarm();
```

**Step 2: Implement in `AlarmService`**

File: `lib/core/platform/alarm_service.dart`

The `AlarmService` needs access to `ReminderRepository` and `AlarmScheduler` (or the scheduling logic directly). Two approaches:

**Approach A (Recommended): Create a `ScheduleNextReminder` use case**

Create a new use case that encapsulates "find and schedule the next upcoming reminder":

File: `lib/core/engine/domain/usecases/schedule_next_reminder.dart`
```dart
class ScheduleNextReminder {
  final ReminderRepository _repository;
  final AlarmPort _alarmPort;

  const ScheduleNextReminder({
    required ReminderRepository repository,
    required AlarmPort alarmPort,
  });

  /// Finds the next upcoming 'scheduled' reminder and sets its alarm.
  /// Returns the reminder that was scheduled, or null if none found.
  Future<Reminder?> call() async {
    final upcoming = await _repository.getUpcoming(limit: 1);
    if (upcoming.isEmpty) return null;

    final next = upcoming.first;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(next.scheduledTime);
    final hour = dateTime.hour;

    await _alarmPort.setAlarm(
      id: next.id.hashCode,
      dateTime: dateTime,
      notificationTitle: _slotNameForHour(hour),
      notificationBody: 'Preparing your reminder...',
    );
    return next;
  }

  String _slotNameForHour(int hour) {
    if (hour >= 5 && hour < 9) return 'Morning Medications';
    if (hour >= 9 && hour < 12) return 'Mid-Morning Medications';
    if (hour >= 12 && hour < 14) return 'Afternoon Medications';
    if (hour >= 14 && hour < 17) return 'Late Afternoon Medications';
    if (hour >= 17 && hour < 21) return 'Evening Medications';
    return 'Night Medications';
  }
}
```

**Step 3: Wire in DI**

File: `lib/app/di/injection.dart`

```dart
final scheduleNextReminderProvider = Provider<ScheduleNextReminder>((ref) {
  return ScheduleNextReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});
```

**Step 4: Call from terminal-state handlers**

After any action that completes a reminder lifecycle, call `scheduleNextReminder`:

| Handler | File | When to call |
|---------|------|--------------|
| `HandleAlarmFired.call()` | `handle_alarm_fired.dart:133` | After the for-loop completes (all reminders at this time slot processed) |
| `FinalizeConfirmation.call()` | `finalize_confirmation.dart:49-52` | After stopping the alarm and canceling escalation |
| `LogMissedReminder.call()` | `log_missed_reminder.dart:33-36` | After stopping the alarm and canceling escalation |

Add `ScheduleNextReminder` as a dependency to each of these use cases (constructor injection).

**Step 5: Handle alarm ID collision**

The `AlarmService.setAlarm()` already checks for existing alarms with the same ID (line 43-46):
```dart
final existingAlarms = await Alarm.getAlarms();
if (existingAlarms.any((a) => a.id == id)) {
  return true; // Already scheduled
}
```

This means calling `scheduleNextReminder` when the snoozed/escalating reminder's alarm is still active won't create a duplicate. The next scheduled reminder won't be scheduled until the current one's alarm is fully cleaned up.

**However:** After `handleAlarmFired` runs, the current alarm is still technically "ringing" (audio playing). The next upcoming reminder won't have the same alarm ID (different `reminder.id.hashCode`), so it WILL be scheduled. This is correct — we want to prepare the next alarm while the current one is still active.

**Step 6: Boot recovery**

`Alarm.init()` calls `checkAlarm()` which re-schedules saved alarms from the `alarm` package's persistent storage. But this only recovers alarms that were already set — not the next ones in the chain. After a reboot, only the most recently scheduled alarm survives. The `ScheduleNextReminder` chain will resume after that alarm fires.

For full boot recovery, add a startup hook in `main.dart`:
```dart
// After alarmService.init()
final scheduleNext = container.read(scheduleNextReminderProvider);
final upcoming = await container.read(reminderRepositoryProvider).getUpcoming(limit: 1);
if (upcoming.isNotEmpty) {
  final isActive = await alarmService.isAlarmActive(upcoming.first.id.hashCode);
  if (!isActive) {
    await scheduleNext.call(); // Re-schedule if lost after reboot
  }
}
```

#### Files Modified

| # | File | Change |
|---|------|--------|
| 1 | NEW `lib/core/engine/domain/usecases/schedule_next_reminder.dart` | New use case |
| 2 | `lib/app/di/injection.dart` | Register provider |
| 3 | `lib/core/engine/domain/usecases/handle_alarm_fired.dart` | Add dependency + call after processing |
| 4 | `lib/core/engine/domain/usecases/finalize_confirmation.dart` | Add dependency + call after finalizing |
| 5 | `lib/core/engine/domain/usecases/log_missed_reminder.dart` | Add dependency + call after logging miss |
| 6 | `lib/main.dart` | Boot recovery hook after init |

---

### Deferred 2: Escalation State Not Persisted

**Severity:** HIGH (escalation alarms silently dropped after app restart)
**Files:** `alarm_service.dart`, `main.dart`, `reminder_repository.dart`

#### Problem

`AlarmService` stores the mapping between escalation alarm IDs and reminder IDs in two in-memory maps:

```dart
// alarm_service.dart:11-12
final Map<int, String> _escalationAlarmToReminderId = {};
final Map<String, int> _reminderIdToEscalationAlarmId = {};
```

When the app process is killed (Android does this aggressively), these maps are lost. If an escalation alarm fires after restart, `getReminderIdForEscalationAlarm()` returns null, and the escalation is treated as a regular alarm — `handleAlarmFired` is called instead of `handleEscalationCheck`.

#### Implementation Plan

**Approach: Reconstruct state from database on startup**

Since escalation alarm IDs are deterministic (`reminderId.hashCode.abs() % 2000000000 + 2000000000`), we can reconstruct the maps by querying the database for reminders that should have active escalation checks.

**Step 1: Add recovery method to `AlarmService`**

File: `lib/core/platform/alarm_service.dart`

```dart
/// Reconstructs escalation alarm mappings for reminders that are in
/// triggered/escalating status (i.e., have active escalation checks).
void recoverEscalationState(List<String> reminderIdsWithActiveEscalation) {
  for (final reminderId in reminderIdsWithActiveEscalation) {
    final alarmId = _escalationAlarmIdFor(reminderId);
    _escalationAlarmToReminderId[alarmId] = reminderId;
    _reminderIdToEscalationAlarmId[reminderId] = alarmId;
  }
}
```

**Step 2: Query for active escalation reminders in `main.dart`**

After database initialization, query for reminders in `triggered` or `escalating` status:

```dart
// main.dart — after alarmService.init()
final activeEscalationReminderIds = await reminderRepository
    .getIdsByStatuses({'triggered', 'escalating'});
alarmService.recoverEscalationState(activeEscalationReminderIds);
```

**Step 3: Add repository method**

File: `lib/core/engine/domain/repositories/reminder_repository.dart`

```dart
Future<List<String>> getIdsByStatuses(Set<String> statuses);
```

File: `lib/core/engine/data/repositories/reminder_repository_impl.dart`

```dart
@override
Future<List<String>> getIdsByStatuses(Set<String> statuses) async {
  final schemas = await _dao.getRemindersByStatuses(statuses.toList());
  return schemas.map((s) => s.id).toList();
}
```

File: `lib/core/database/daos/reminder_dao.dart`

```dart
Future<List<ReminderSchema>> getRemindersByStatuses(List<String> statuses) =>
    (db.select(reminders)..where((r) => r.status.isIn(statuses))).get();
```

**Step 4: Handle the alarm-fire routing for unrecognized escalation alarms**

When `getReminderIdForEscalationAlarm()` returns null but the alarm ID is in the escalation range (>= 2000000000), treat it as a potential escalation alarm:

File: `lib/core/platform/alarm_service.dart`

Add to `init()`:
```dart
Alarm.ringing.listen((alarmSet) {
  for (final alarm in alarmSet.alarms) {
    if (onAlarmRing != null) {
      onAlarmRing!(alarm.id, alarm.dateTime);
    }
  }
});
```

File: `lib/main.dart` — enhance the routing:

```dart
alarmService.onAlarmRing = (int alarmId, DateTime alarmDateTime) {
  var reminderId = alarmService.getReminderIdForEscalationAlarm(alarmId);
  if (reminderId != null) {
    handleEscalationCheck.call(reminderId);
  } else if (alarmId >= 2000000000) {
    // Escalation alarm whose mapping was lost after restart.
    // Try to find the reminder by the deterministic ID relationship.
    // The alarm ID = (reminderId.hashCode.abs() % 2000000000) + 2000000000
    // We can't reverse hashCode, but we can query the DB for triggered/escalating reminders
    // and try to find the one whose escalation alarm ID matches.
    _recoverAndHandleEscalation(alarmId);
  } else {
    handleAlarmFired.call(alarmId, alarmDateTime);
  }
};
```

For the recovery helper, add a method in `main.dart`:
```dart
Future<void> _recoverAndHandleEscalation(int alarmId) async {
  // Query all triggered/escalating reminders
  final active = await reminderRepository.getIdsByStatuses(
    {'triggered', 'escalating'},
  );
  for (final reminderId in active) {
    final expectedAlarmId = (reminderId.hashCode.abs() % 2000000000) + 2000000000;
    if (expectedAlarmId == alarmId) {
      // Found the match — update the in-memory maps
      alarmService.recoverEscalationState([reminderId]);
      await handleEscalationCheck.call(reminderId);
      return;
    }
  }
  // If no match found, treat as regular alarm (fallback)
  handleAlarmFired.call(alarmId, DateTime.now());
}
```

#### Files Modified

| # | File | Change |
|---|------|--------|
| 1 | `lib/core/platform/alarm_service.dart` | Add `recoverEscalationState()` method |
| 2 | `lib/core/engine/domain/repositories/reminder_repository.dart` | Add `getIdsByStatuses()` |
| 3 | `lib/core/engine/data/repositories/reminder_repository_impl.dart` | Implement `getIdsByStatuses()` |
| 4 | `lib/core/database/daos/reminder_dao.dart` | Add `getRemindersByStatuses()` query |
| 5 | `lib/main.dart` | Recovery on startup + enhanced routing logic |

---

### Deferred 3: Runtime Permission Checks

**Severity:** HIGH (alarms silently fail if permissions revoked)
**Files:** NEW `lib/core/platform/permission_service.dart`, `alarm_service.dart`, `notification_service.dart`, `main.dart`, `injection.dart`

#### Problem

The app declares permissions in `AndroidManifest.xml` but never checks them at runtime:
- `POST_NOTIFICATIONS` (Android 13+) — requested via `flutter_local_notifications` but denial is not handled
- `SCHEDULE_EXACT_ALARM` (Android 12+) — never checked; can be revoked by user in Settings
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` — declared but never requested

The `permission_handler` package (`^12.0.1`) is listed in `pubspec.yaml` but is **never imported** anywhere in the codebase.

#### Implementation Plan

**Step 1: Create `PermissionService`**

File: NEW `lib/core/platform/permission_service.dart`

```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  Future<bool> canScheduleExactAlarms() async {
    if (!await Permission.scheduleExactAlarm.isGranted) {
      // SCHEDULE_EXACT_ALARM can't be requested at runtime.
      // Must redirect user to Settings.
      await openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> requestBatteryOptimizationExemption() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isGranted) return true;
    final result = await Permission.ignoreBatteryOptimizations.request();
    return result.isGranted;
  }

  Future<Map<Permission, bool>> checkAllCritical() async {
    return {
      Permission.notification: await Permission.notification.status.isGranted,
      Permission.scheduleExactAlarm: await Permission.scheduleExactAlarm.status.isGranted,
      Permission.ignoreBatteryOptimizations:
          await Permission.ignoreBatteryOptimizations.status.isGranted,
    };
  }
}
```

**Step 2: Wire in DI**

File: `lib/app/di/injection.dart`

```dart
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});
```

**Step 3: Check permissions on app startup**

File: `lib/main.dart`

After service initialization, check critical permissions:
```dart
final permissionService = container.read(permissionServiceProvider);
final permissions = await permissionService.checkAllCritical();

if (!permissions[Permission.notification]!) {
  // Show dialog explaining notification permission is required
  // Then request
  await permissionService.requestNotificationPermission();
}

if (!permissions[Permission.scheduleExactAlarm]!) {
  // Show dialog redirecting to Settings
  // await permissionService.canScheduleExactAlarms(); // opens Settings
}

// Request battery optimization exemption (non-blocking, best-effort)
await permissionService.requestBatteryOptimizationExemption();
```

**Step 4: Pre-flight check before scheduling alarms**

File: `lib/core/platform/alarm_service.dart`

In `setAlarm()`, add a permission check before `Alarm.set()`:
```dart
Future<bool> setAlarm({...}) async {
  // Pre-flight: check exact alarm permission
  final canSchedule = await Permission.scheduleExactAlarm.status.isGranted;
  if (!canSchedule) {
    // Fall back to inexact alarm or notify user
    return false;
  }
  // ... existing code ...
}
```

**Step 5: Handle notification permission denial gracefully**

File: `lib/core/platform/notification_service.dart`

Update `init()` to return permission status and handle denial:
```dart
Future<bool> init() async {
  // ... existing initialization ...

  final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  final granted = await androidPlugin?.requestNotificationsPermission();
  return granted ?? false;
}
```

#### Files Modified

| # | File | Change |
|---|------|--------|
| 1 | NEW `lib/core/platform/permission_service.dart` | Permission checking service |
| 2 | `lib/app/di/injection.dart` | Register provider |
| 3 | `lib/main.dart` | Permission checks on startup |
| 4 | `lib/core/platform/alarm_service.dart` | Pre-flight permission check in `setAlarm()` |
| 5 | `lib/core/platform/notification_service.dart` | Return permission status from `init()` |

---

### Deferred 4: Slot Name Based on Current Hour

**Severity:** MEDIUM (wrong notification title, not functional breakage)
**Files:** `add_medication.dart`

#### Problem

`AddMedication._getSlotName()` uses `DateTime.now().hour` instead of the reminder's scheduled hour:

```dart
// add_medication.dart:51-59
String _getSlotName(Medication medication) {
  final hour = DateTime.now().hour; // ← WRONG: uses current time
  // ...
}
```

Meanwhile, `ReminderGenerator._getSlotName(int hour)` correctly uses the scheduled hour:
```dart
// reminder_generator.dart:138-145
String _getSlotName(int hour) { // ← CORRECT: uses scheduled hour
  // ...
}
```

**Impact:** If user adds medication at 8 AM for a 6 PM dose, the alarm notification shows "Morning Medications" instead of "Evening Medications".

#### Implementation Plan

**Step 1: Fix `AddMedication._getSlotName` to use reminder's scheduled hour**

File: `lib/features/medication/domain/usecases/add_medication.dart`

Change line 41-42 from:
```dart
final slotName = _getSlotName(medication);
```
to:
```dart
final slotName = _getSlotName(earliestReminder.scheduledTime);
```

And change the method from:
```dart
String _getSlotName(Medication medication) {
  final hour = DateTime.now().hour;
  // ...
}
```
to:
```dart
String _getSlotName(int scheduledTimeMillis) {
  final hour = DateTime.fromMillisecondsSinceEpoch(scheduledTimeMillis).hour;
  // ...
}
```

This makes it consistent with `ReminderGenerator._getSlotName(int hour)` — both now use the scheduled time's hour.

#### Files Modified

| # | File | Change |
|---|------|--------|
| 1 | `lib/features/medication/domain/usecases/add_medication.dart` | Change `_getSlotName` to accept `int scheduledTimeMillis`, use `earliestReminder.scheduledTime` |

---

### Deferred 6: Battery Optimization Not Requested

**Severity:** HIGH (Android may kill exact alarms for non-whitelisted apps)
**Files:** Covered by Deferred 3 (`PermissionService`)

#### Problem

`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` is declared in `AndroidManifest.xml` but no code requests it. Android's battery optimization can defer or kill exact alarms, causing missed medication doses.

#### Implementation Plan

This is fully addressed in **Deferred 3: Runtime Permission Checks** — the `PermissionService.requestBatteryOptimizationExemption()` method handles it:

```dart
Future<bool> requestBatteryOptimizationExemption() async {
  final status = await Permission.ignoreBatteryOptimizations.status;
  if (status.isGranted) return true;
  final result = await Permission.ignoreBatteryOptimizations.request();
  return result.isGranted;
}
```

Called on startup in `main.dart` as part of the permission check flow.

**Timing:** Best-effort, non-blocking. Should be requested AFTER the user has interacted with the app for a while (not on first launch), as Google Play policies discourage requesting battery optimization exemption immediately.

**Suggested approach:** Request on the 3rd app launch or after the user adds their first medication. Use `FlutterSecureStorage` to track a "launch count" or "has medications" flag.

#### Files Modified

| # | File | Change |
|---|------|--------|
| 1 | NEW `lib/core/platform/permission_service.dart` | Already covered in Deferred 3 |
| 2 | `lib/main.dart` | Already covered in Deferred 3 |
