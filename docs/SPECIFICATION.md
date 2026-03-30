# Smart Health Reminder - Technical Specification

> **Version:** 3.2.1
> **Status:** AUTHORITATIVE - This document is the single source of truth.
> **Last Updated:** 2026-03-29
> **Target Platform:** Android-first (iOS port planned via interface abstraction)

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Module Dependency Graph](#3-module-dependency-graph)
4. [Directory Structure](#4-directory-structure)
5. [Smart Reminder Engine - State Machine](#5-smart-reminder-engine---state-machine)
6. [Database Schema & Security](#6-database-schema--security)
7. [Alarm & Notification Strategy](#7-alarm--notification-strategy)
8. [Module Specifications](#8-module-specifications)
9. [Gamification Engine](#9-gamification-engine)
10. [ADHD-Friendly UX Contract](#10-adhd-friendly-ux-contract)
11. [Implementation Roadmap](#11-implementation-roadmap)
12. [Testing Strategy](#12-testing-strategy)
13. [Glossary](#13-glossary)
- [Appendix A: pubspec.yaml Dependencies (v3)](#appendix-a-pubspecyaml-dependencies-v3)
- [Appendix B: Future iOS Port Strategy](#appendix-b-future-ios-port-strategy)

---

## 1. Product Overview

### 1.1 Vision

Smart Health Reminder is a **fully offline, privacy-first** mobile health assistant. It tracks medication adherence, menstrual cycles, and generates behavioral insights — all without accounts, servers, or data leaving the device. A built-in **gamification engine** provides ADHD-friendly dopamine reinforcement through XP, streaks, and achievements.

### 1.2 Design Philosophy

| Principle | Rationale |
|---|---|
| **Offline-first** | Zero network dependency. All logic runs on-device. No analytics SDKs. |
| **ADHD-friendly** | Escalating reminders, dopamine-positive feedback, minimal decision fatigue. |
| **Privacy-first** | SQLCipher encryption via Drift ORM. Keys in `flutter_secure_storage`. No cloud sync. |
| **Modular** | Each feature module is independently testable and replaceable. |
| **Agent-buildable** | Every component has a single responsibility with explicit contracts. |
| **Brutal MVP** | Schema built for the grand vision (all 11 tables on day 1), but code only implements single-profile pill reminders until Phase 3 is done. Ship the narrowest vertical first. |

### 1.3 Target User Persona

- Adults managing daily medications or supplements.
- Users tracking menstrual cycles without trusting cloud-based apps.
- Users with ADHD or executive function challenges who need persistent, escalating reminders.

### 1.4 Version History

#### v2 Changes from v1

| Area | v1 | v2 | Rationale |
|---|---|---|---|
| Database ORM | Raw `sqflite_sqlcipher` with manual SQL | **Drift** + `drift_sqflite` + `sqflite_sqlcipher` | Type-safe queries, compile-time SQL validation, generated DAOs |
| Security / Key Management | Custom `KeystoreChannel.kt` via MethodChannel | **`flutter_secure_storage`** | Eliminates ~200 lines of custom crypto Kotlin. Platform handles Keystore/Keychain. |
| Multi-profile | Not supported | Every table has `profile_id` column | Future-proofing. Single-profile hardcoded until beyond Phase 5. |
| Gamification | Not present | XP system, streaks (36h ADHD grace), achievements | Dopamine reinforcement for habit formation |
| Roadmap | 4 phases | **5 phases** | Gamification+Cycle split into its own phase |
| MethodChannels | 2 (`alarm` + `keystore`) | **1** (`alarm` only) | `flutter_secure_storage` handles keystore natively |
| Tables | 7 tables (raw SQL) | **11 tables** (Drift Dart classes) | Added gamification tables + multi-profile columns |

#### v3.2.1 Changes from v3.2

| Area | v3.2 | v3.2.1 | Rationale |
|---|---|---|---|
| Custom Duration | Date picker | **Duration picker** — days/weeks/months | More intuitive UI. Users select "3 months" instead of picking a specific date. |

#### v3.2 Changes from v3.1

| Area | v3.1 | v3.2 | Rationale |
|---|---|---|---|
| Reminder Duration | Hardcoded 7-day buffer | **User-selectable duration** — 7 days, 1 month, Until I turn it off, or Custom end date | Allows users to set medication reminders for specific durations. Continuous option for long-term meds. |

#### v3.1 Changes from v3

| Area | v3 | v3.1 | Rationale |
|---|---|---|---|
| Notification Construction | Not explicitly defined | **Lazy Loading** — notification body & voice payload built at fire-time, not schedule-time | Ensures medication changes made between schedule-time and fire-time are reflected. User directive: "Go Lazy, not Eager". |
| Time-Slot Grouping | Implemented | **Explicit contract** — multiple meds at same time share ONE Reminder entry | Prevents alarm fatigue. Single hardware alarm per unique timestamp. |

#### v3 Changes from v2

| Area | v2 | v3 | Rationale |
|---|---|---|---|
| State Management | `flutter_bloc` (Cubit) + `riverpod` (DI) | **Riverpod-only** (`Notifier`/`AsyncNotifier`) | Eliminates "state soup" from two reactive systems. Single paradigm. Easier for AI agents. |
| Alarm Scheduling | Custom Kotlin `AlarmManagerChannel.kt` + `AlarmReceiver.kt` + `BootReceiver.kt` + `ReminderForegroundService.kt` via MethodChannel | **`alarm` Flutter package** | Hardware-level reliability with zero custom native code. Package handles AlarmManager, WakeLock, boot persistence, foreground service internally. |
| Notifications | Custom Kotlin notification channels in `ReminderForegroundService.kt` | **`flutter_local_notifications`** | Notification channels, action buttons (Snooze/Done), full-screen intents — all from Dart. Zero custom MethodChannels. |
| Native Code | 4 Kotlin files, 1 MethodChannel, custom receivers/services | **Zero custom Kotlin.** `MainActivity.kt` is vanilla `FlutterActivity`. | Eliminates ~400 lines of bug-prone native bridge code. |
| Data Safety | No backup/restore | **Encrypted JSON export/import** via `share_plus` + `file_picker` | Essential since cloud-sync is deferred. Users need a way to protect their data. |
| Presentation Layer | `cubit/` directories with `*_cubit.dart` files | `notifiers/` directories with `*_notifier.dart` files | Naming reflects Riverpod conventions. |
| Dependencies | `flutter_bloc`, `bloc_test`, no `riverpod_generator` | **Removed** `flutter_bloc`/`bloc_test`. **Added** `alarm`, `flutter_local_notifications`, `share_plus`, `file_picker`, `riverpod_generator`. **Moved** `freezed_annotation` to runtime deps. | Cleaner dependency tree. `freezed_annotation` annotations appear in runtime code, not just codegen. |

---

## 2. Architecture Overview

### 2.1 Layer Definitions (Simplified Clean Architecture)

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION                        │
│   (Widgets, Pages, Riverpod Notifiers)               │
├─────────────────────────────────────────────────────┤
│                     DOMAIN                           │
│   (Entities, UseCases, Repository Interfaces)        │
├─────────────────────────────────────────────────────┤
│                      DATA                            │
│   (Repository Impls, Drift DAOs, DTOs, Mappers)      │
├─────────────────────────────────────────────────────┤
│                    PLATFORM                          │
│   (alarm package, flutter_local_notifications,       │
│    flutter_secure_storage, Drift + SQLCipher)        │
└─────────────────────────────────────────────────────┘
```

### 2.2 Dependency Rule

**Dependencies point inward ONLY.** The Domain layer has ZERO dependencies on any other layer. It defines repository interfaces that the Data layer implements. The Presentation layer depends on Domain (via use cases), never on Data directly.

> **Architectural Note:** This rule is non-negotiable. If a coding agent imports a Data-layer class into the Domain layer, the build must be treated as broken. The Domain layer uses only Dart core types and its own entities. This prevents coupling the business logic to any storage mechanism, making future migrations safe.

### 2.3 State Management Decision

| Layer | Tool | Rationale |
|---|---|---|
| Feature-level state | `riverpod` (`Notifier` / `AsyncNotifier`) | Predictable, testable, single reactive paradigm. State classes use `freezed` for immutable union types. |
| Cross-cutting state | `riverpod` | Dependency injection + reactive rebuild for global concerns (theme, locale, DB readiness). |
| Navigation | `go_router` | Declarative, deep-link ready, works with Riverpod. |

> **Architectural Note (v3):** The v2 approach of mixing `flutter_bloc` (Cubits) with Riverpod (DI) created two competing reactive systems. v3 uses **Riverpod exclusively** — `Notifier`/`AsyncNotifier` classes replace all Cubits. State classes use `freezed` for immutable union types. The coding agent must NOT add `flutter_bloc` or any Bloc-related package.

---

## 3. Module Dependency Graph

### 3.1 Module Map

```
┌──────────────────────────────────────────────────────────────────┐
│                         APP SHELL                                │
│                    (main.dart, routing, DI)                       │
│                            │                                     │
│              ┌─────────────┼─────────────┐                       │
│              ▼             ▼             ▼                        │
│     ┌──────────────┐ ┌──────────┐ ┌────────────┐                │
│     │  Medication   │ │  Cycle   │ │  Insight   │                │
│     │   Module      │ │  Module  │ │  Engine    │                │
│     └──────┬───────┘ └─────┬────┘ └─────┬──────┘                │
│            │               │             │                       │
│            ▼               ▼             ▼                       │
│     ┌─────────────────────────────────────────────┐              │
│     │          SMART REMINDER ENGINE               │              │
│     │  (State Machine, Scheduling, Escalation)     │              │
│     └───────────────────┬─────────────────────────┘              │
│                         │                                        │
│              ┌──────────┼──────────┐                             │
│              ▼          ▼          ▼                              │
│     ┌────────────┐ ┌──────────┐ ┌─────────────────┐             │
│     │ Gamification│ │ Security │ │ Platform Bridge  │             │
│     │  Engine     │ │ Layer    │ │ (Native Kotlin)  │             │
│     └────────────┘ └──────────┘ └─────────────────┘             │
└──────────────────────────────────────────────────────────────────┘
```

### 3.2 Dependency Rules (Enforced)

| Module | May Depend On | Must NOT Depend On |
|---|---|---|
| `Medication Module` | Reminder Engine, Gamification Engine, Security Layer | Cycle Module, Insight Engine |
| `Cycle Module` | Reminder Engine, Gamification Engine, Security Layer | Medication Module, Insight Engine |
| `Insight Engine` | Security Layer (read-only DAO access) | Reminder Engine, Medication, Cycle, Gamification |
| `Gamification Engine` | Security Layer, Database (Drift DAOs) | Any Feature Module, Reminder Engine |
| `Reminder Engine` | Security Layer, Platform Bridge | Any Feature Module |
| `Security Layer` | `flutter_secure_storage` | Any module above it |
| `Platform Bridge` | Nothing (leaf node) | Everything |

> **Architectural Note:** The Gamification Engine is a *core* module, not a feature. Feature modules call into it (e.g., `AwardXp` use case) when actions complete. The Gamification Engine never calls into features. It only reads/writes its own tables (`xp_events`, `streaks`, `achievements`).

### 3.3 Circular Dependency Prevention

The coding agent MUST validate the following invariant before any PR:

```bash
# No file in lib/*/domain/ imports from lib/*/data/ or lib/*/platform/
# No file in lib/features/medication/ imports from lib/features/cycle/
# No file in lib/features/cycle/ imports from lib/features/medication/
# No file in lib/core/engine/ imports from lib/features/
# No file in lib/core/gamification/ imports from lib/features/
```

Violation of any rule above is a **build-breaking defect**.

---

## 4. Directory Structure

```
lib/
├── main.dart                          # Entry point, DI init, App widget
├── app/
│   ├── app.dart                       # MaterialApp + GoRouter config
│   ├── di/
│   │   └── injection.dart             # Riverpod ProviderScope setup
│   └── theme/
│       ├── app_theme.dart             # Light/dark theme definitions
│       └── adhd_colors.dart           # High-contrast ADHD palette
│
├── core/
│   ├── backup/                        # Encrypted JSON export/import (v3)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── backup_metadata.dart
│   │   │   ├── repositories/
│   │   │   │   └── backup_repository.dart    # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── export_backup.dart
│   │   │       └── import_backup.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── backup_repository_impl.dart
│   │       └── services/
│   │           └── backup_encryption_service.dart
│   │
│   ├── database/                      # Drift ORM layer
│   │   ├── app_database.dart          # @DriftDatabase annotation, includes all tables+DAOs
│   │   ├── tables/
│   │   │   ├── profiles_tables.dart   # Profiles Drift table class
│   │   │   ├── reminder_tables.dart   # Reminders + ReminderLogs Drift table classes
│   │   │   ├── medication_tables.dart # Medications + DoseRecords Drift table classes
│   │   │   ├── cycle_tables.dart      # CycleEntries + CyclePredictions Drift table classes
│   │   │   ├── gamification_tables.dart # XpEvents + Streaks + Achievements Drift table classes
│   │   │   └── app_settings_tables.dart # AppSettings Drift table class
│   │   └── daos/
│   │       ├── profiles_dao.dart      # Drift DAO for profile operations
│   │       ├── reminder_dao.dart      # Drift DAO for reminder operations
│   │       ├── medication_dao.dart    # Drift DAO for medication operations
│   │       ├── cycle_dao.dart         # Drift DAO for cycle operations
│   │       ├── gamification_dao.dart  # Drift DAO for gamification operations
│   │       └── app_settings_dao.dart  # Drift DAO for app settings operations
│   │
│   ├── engine/                        # Smart Reminder Engine
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── reminder.dart
│   │   │   │   ├── reminder_state.dart     # Enum + state machine
│   │   │   │   └── escalation_policy.dart
│   │   │   ├── repositories/
│   │   │   │   └── reminder_repository.dart  # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── schedule_reminder.dart
│   │   │       ├── handle_snooze.dart
│   │   │       ├── escalate_reminder.dart
│   │   │       ├── confirm_reminder.dart
│   │   │       └── log_missed_reminder.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── reminder_repository_impl.dart
│   │   │   ├── datasources/
│   │   │   │   └── reminder_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── reminder_model.dart       # DTO for Drift
│   │   │   └── mappers/
│   │   │       └── reminder_mapper.dart
│   │   └── presentation/
│   │       ├── notifiers/
│   │       │   └── reminder_notifier.dart     # Riverpod Notifier
│   │       └── widgets/
│   │           ├── reminder_card.dart
│   │           └── snooze_dialog.dart
│   │
│   ├── gamification/                  # Gamification Engine
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── xp_event.dart
│   │   │   │   ├── achievement.dart
│   │   │   │   └── streak.dart
│   │   │   ├── repositories/
│   │   │   │   └── gamification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── award_xp.dart
│   │   │       ├── evaluate_streak.dart
│   │   │       └── check_achievements.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── gamification_repository_impl.dart
│   │   │   └── mappers/
│   │   │       └── gamification_mapper.dart
│   │   └── presentation/
│   │       ├── notifiers/
│   │       │   ├── gamification_notifier.dart  # Riverpod Notifier
│   │       │   └── gamification_state.dart
│   │       └── widgets/
│   │           ├── xp_progress_bar.dart
│   │           ├── streak_badge.dart
│   │           └── achievement_card.dart
│   │
│   ├── security/
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── secure_storage_repository.dart  # Abstract interface
│   │   └── data/
│   │       └── secure_storage_impl.dart  # flutter_secure_storage wrapper
│   │
│   └── platform/
│       ├── alarm_service.dart            # Wrapper around `alarm` package (v3)
│       └── notification_service.dart     # Wrapper around `flutter_local_notifications` (v3)
│
├── features/
│   ├── medication/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── medication.dart
│   │   │   │   ├── dose.dart
│   │   │   │   └── adherence_record.dart
│   │   │   ├── repositories/
│   │   │   │   └── medication_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_medication.dart
│   │   │       ├── record_dose.dart
│   │   │       ├── get_adherence_stats.dart
│   │   │       └── get_medication_schedule.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── medication_repository_impl.dart
│   │   │   ├── datasources/
│   │   │   │   └── medication_local_datasource.dart
│   │   │   └── models/
│   │   │       └── medication_model.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── medication_list_page.dart
│   │       │   ├── add_medication_page.dart
│   │       │   └── adherence_dashboard_page.dart
│   │       ├── notifiers/
│   │       │   ├── medication_notifier.dart    # Riverpod Notifier
│   │       │   └── medication_state.dart
│   │       └── widgets/
│   │           ├── medication_tile.dart
│   │           ├── dose_confirmation_sheet.dart
│   │           └── adherence_chart.dart
│   │
│   ├── cycle/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── cycle_entry.dart
│   │   │   │   └── cycle_prediction.dart
│   │   │   ├── repositories/
│   │   │   │   └── cycle_repository.dart
│   │   │   └── usecases/
│   │   │       ├── log_cycle_entry.dart
│   │   │       ├── predict_cycle.dart
│   │   │       └── get_cycle_history.dart
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── cycle_repository_impl.dart
│   │   │   ├── datasources/
│   │   │   │   └── cycle_local_datasource.dart
│   │   │   └── models/
│   │   │       ├── cycle_entry_model.dart
│   │   │       └── cycle_prediction_model.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── cycle_log_page.dart
│   │       │   └── cycle_calendar_page.dart
│   │       ├── notifiers/
│   │       │   ├── cycle_notifier.dart         # Riverpod Notifier
│   │       │   └── cycle_state.dart
│   │       └── widgets/
│   │           ├── cycle_phase_indicator.dart
│   │           └── symptom_selector.dart
│   │
│   └── insights/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── insight.dart
│       │   ├── repositories/
│       │   │   └── insights_repository.dart
│       │   └── usecases/
│       │       ├── generate_insights.dart
│       │       └── get_insights.dart
│       ├── data/
│       │   ├── repositories/
│       │   │   └── insights_repository_impl.dart
│       │   └── datasources/
│       │       └── insights_local_datasource.dart
│       └── presentation/
│           ├── pages/
│           │   └── insights_page.dart
│           ├── notifiers/
│           │   ├── insights_notifier.dart      # Riverpod Notifier
│           │   └── insights_state.dart
│           └── widgets/
│               └── insight_card.dart
│
android/
├── app/src/main/kotlin/com/smarthealth/smart_reminder_app/
│   └── MainActivity.kt                # Vanilla FlutterActivity (v3 — zero custom native code)
│
test/
├── core/
│   ├── engine/
│   │   ├── domain/usecases/
│   │   └── data/repositories/
│   ├── gamification/
│   │   └── domain/usecases/
│   ├── security/
│   ├── backup/
│   └── platform/
├── features/
│   ├── medication/
│   ├── cycle/
│   └── insights/
└── integration/
    └── reminder_flow_test.dart
```

> **Architectural Note:** The `core/database/` directory centralizes all Drift table definitions and DAOs. Feature modules do NOT define their own tables. All 11 tables live under `core/database/tables/` and all 6 DAOs under `core/database/daos/`. This ensures a single `AppDatabase` class manages the entire schema. The `core/backup/` directory (v3) provides encrypted JSON export/import for data safety.

---

## 5. Smart Reminder Engine - State Machine

### 5.1 States

```dart
enum ReminderStatus {
  scheduled,         // Future alarm set. Waiting for trigger time.
  triggered,         // Alarm fired. Notification shown. Awaiting user action.
  snoozed,           // User requested delay. Re-scheduled with escalation increment.
  escalating,        // Max snoozes reached OR no response. Aggressive notification mode.
  confirmationRequired, // User tapped "Done" but confirmation logic demands proof.
  logged,            // Successfully confirmed. Adherence recorded.
  missed,            // Escalation exhausted. No confirmation. Logged as missed.
  cancelled,         // User or system cancelled this reminder instance.
}
```

### 5.2 State Transition Diagram

```
                    ┌──────────────┐
         ┌─────────│  SCHEDULED   │
         │         └──────┬───────┘
         │                │ [alarm fires at scheduled_time]
         │                ▼
         │         ┌──────────────┐
         │    ┌───▶│  TRIGGERED   │◀──────────────────┐
         │    │    └──┬───┬───┬───┘                    │
         │    │       │   │   │                        │
         │    │       │   │   │ [user taps "Done"]     │
         │    │       │   │   ▼                        │
         │    │       │   │ ┌─────────────────────┐    │
         │    │       │   │ │ CONFIRMATION_REQUIRED│    │
         │    │       │   │ └──┬──────────────┬───┘    │
         │    │       │   │    │              │        │
         │    │       │   │    │[confirmed]   │[rejected/timeout]
         │    │       │   │    ▼              │        │
         │    │       │   │ ┌────────┐        │        │
         │    │       │   │ │ LOGGED │        │        │
         │    │       │   │ └────────┘        │        │
         │    │       │   │                   ▼        │
         │    │       │   │         [back to TRIGGERED]│
         │    │       │   │                            │
         │    │       │   │ [no response within window]│
         │    │       │   ▼                            │
         │    │       │ ┌─────────────┐                │
         │    │       │ │ ESCALATING  │────────────────┘
         │    │       │ └──┬──────┬───┘  [user responds
         │    │       │    │      │       during escalation]
         │    │       │    │      │
         │    │       │    │      │ [max_escalations_reached
         │    │       │    │      │  AND no response]
         │    │       │    │      ▼
         │    │       │    │   ┌────────┐
         │    │       │    │   │ MISSED │
         │    │       │    │   └────────┘
         │    │       │    │
         │    │       │    │ [escalation fires new alarm]
         │    │       │    └──────────────────────┘
         │    │       │
         │    │       │ [user taps "Snooze"]
         │    │       ▼
         │    │    ┌──────────────┐
         │    │    │   SNOOZED    │
         │    │    └──────┬───────┘
         │    │           │ [snooze_count < max_snoozes:
         │    │           │  re-schedule with delay]
         │    └───────────┘
         │
         │ [user cancels]
         ▼
  ┌──────────────┐
  │  CANCELLED   │
  └──────────────┘
```

### 5.3 Transition Rules (Exhaustive)

| From State | Event | To State | Side Effects |
|---|---|---|---|
| `scheduled` | Alarm fires | `triggered` | Show notification. Start response_window timer (default: 5 min). |
| `triggered` | User taps "Done" | `confirmationRequired` | Show confirmation UI. Start confirmation_window timer (30 sec). |
| `triggered` | User taps "Snooze" | `snoozed` | Increment snooze_count. If snooze_count >= max_snoozes, go to `escalating` instead. |
| `triggered` | response_window expires | `escalating` | Fire escalation notification (vibration + sound + full-screen intent). |
| `triggered` | User taps "Cancel" | `cancelled` | Log cancellation reason. Dismiss notification. |
| `snoozed` | Snooze timer fires | `triggered` | Re-show notification. Snooze delay = base_delay * (snooze_count + 1). |
| `snoozed` | snooze_count >= max_snoozes | `escalating` | Transition directly. Do not re-snooze. |
| `escalating` | User responds (Done) | `confirmationRequired` | Show confirmation UI. |
| `escalating` | escalation_count >= max_escalations | `missed` | Log as missed. Record timestamp. Dismiss all notifications. |
| `escalating` | Escalation timer fires | `escalating` | Re-fire notification with increasing urgency. Increment escalation_count. |
| `confirmationRequired` | User confirms (interaction proof) | `logged` | Record adherence. **Award XP via Gamification Engine.** Show dopamine feedback (animation + sound). Dismiss notification. |
| `confirmationRequired` | confirmation_window expires | `triggered` | Return to triggered. "We didn't catch that, please confirm again." |
| `logged` | — | Terminal | No further transitions. |
| `missed` | — | Terminal | No further transitions. |
| `cancelled` | — | Terminal | No further transitions. |

> **Note:** The `logged` transition now has an additional side effect: calling `AwardXp` from the Gamification Engine. This is the primary XP earning mechanism.

### 5.4 Escalation Policy Entity

```dart
/// Immutable configuration for how a reminder escalates.
class EscalationPolicy {
  /// Number of snoozes allowed before auto-escalation.
  final int maxSnoozes;             // Default: 3

  /// Base snooze delay in minutes. Actual = base * (snooze_count + 1).
  final int snoozeBaseDelayMinutes; // Default: 5

  /// Seconds to wait for user response before escalating.
  final int responseWindowSeconds;  // Default: 300 (5 minutes)

  /// Number of escalation attempts before marking as missed.
  final int maxEscalations;         // Default: 3

  /// Seconds between escalation attempts.
  final int escalationIntervalSeconds; // Default: 600 (10 minutes)

  /// Seconds for confirmation interaction proof.
  final int confirmationWindowSeconds; // Default: 30
}
```

> **Architectural Note:** The escalation policy is an entity, not a config file. It is stored per-reminder in the database (denormalized). This allows the Medication Module to set aggressive policies (max_snoozes=2 for critical meds) while the Cycle Module can set gentle policies (max_snoozes=5). The coding agent must NEVER hardcode escalation values.

### 5.5 Confirmation Modes

| Mode | Description | Use Case |
|---|---|---|
| `tapOnce` | Single tap on "Confirm" button. | Low-importance reminders. |
| `swipeToConfirm` | Swipe gesture required. | Default for medications. |
| `interactionChallenge` | Simple micro-task (e.g., "Tap the pill icon 3 times"). | Critical medications where accidental confirm must be prevented. |

---

## 6. Database Schema & Security

### 6.1 Security Architecture (Simplified)

```
┌──────────────────────────────────────────────────────┐
│                 Flutter (Dart)                        │
│                                                      │
│  ┌─────────────┐     ┌────────────────────────────┐  │
│  │ Repository   │────▶│ Drift ORM                  │  │
│  │ Impl         │     │ (drift + drift_sqflite     │  │
│  │              │     │  + sqflite_sqlcipher)       │  │
│  └─────────────┘     └───────────┬────────────────┘  │
│                                  │                   │
│                    [encryption key from]              │
│                                  │                   │
│  ┌──────────────────────────────▼──────────────────┐ │
│  │       SecureStorageImpl                          │ │
│  │  (flutter_secure_storage)                        │ │
│  │  Uses Android Keystore / iOS Keychain internally │ │
│  └──────────────────────────────────────────────────┘ │
│                                                      │
│               NO CUSTOM NATIVE CODE NEEDED           │
└──────────────────────────────────────────────────────┘
```

### 6.2 Key Management Flow 

1. **First Launch:** `SecureStorageImpl` generates a random 32-byte passphrase using `dart:math` `Random.secure()`.
2. **Storage:** The passphrase is stored via `flutter_secure_storage`, which uses Android Keystore (hardware-backed if available) or iOS Keychain internally.
3. **DB Open:** Drift's `drift_sqflite` backend is configured with `sqflite_sqlcipher` and the passphrase is passed to `openDatabase(password: passphrase)`.
4. **Subsequent Launches:** The passphrase is retrieved from `flutter_secure_storage` and passed to Drift.

> **Architectural Note:** The v1 approach of writing custom Kotlin Keystore code was error-prone and untestable from Dart. `flutter_secure_storage` provides the same hardware-backed key protection with zero custom native code. The coding agent must NEVER store the passphrase in SharedPreferences, a file, or any non-secure storage.

### 6.3 Drift ORM Strategy

All tables are defined as Dart classes extending `Table`. Drift generates type-safe companion classes, data classes, and DAOs at build time via `build_runner`.

**Key conventions:**
- Every table MUST have these columns: `profile_id`, `created_at`, `updated_at`
- Tables that participate in sync MUST also have: `sync_status`
- Tables whose actions earn XP MUST also have: `xp_value`
- `profile_id` defaults to `'default'` until multi-profile is implemented (Phase 5)
- Primary keys are `TEXT` (UUID v4)
- Timestamps are `INTEGER` (Unix milliseconds)
- JSON data stored as `TEXT`

### 6.4 Database Tables (11 Total — Drift Dart Classes)
To support grouping, the `Reminders` table is decoupled from specific medications. It now acts as a Time-Slot Index.
#### 6.4.1 `Reminders` Table (Modified)
Removed: `linkedEntityId`, `linkedEntityType`.
Added: `groupDoseCount`.

```dart
class Reminders extends Table {
  TextColumn get id => text()();               // UUID v4, primary key
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get type => text()();             // 'medication', 'cycle', 'custom'
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  IntColumn get scheduledTime => integer()();  // Unix ms, The "Master Timestamp" for the group
  IntColumn get groupDoseCount => integer()(); // Number of medications due at this time
  IntColumn get actualTriggerTime => integer().nullable()();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  IntColumn get escalationCount => integer().withDefault(const Constant(0))();
  TextColumn get confirmationMode => text().withDefault(const Constant('swipeToConfirm'))();

  // Denormalized escalation policy, Escalation policy remains (shared by all meds in this slot)
  IntColumn get maxSnoozes => integer().withDefault(const Constant(3))();
  IntColumn get snoozeBaseDelayMinutes => integer().withDefault(const Constant(5))();
  IntColumn get responseWindowSeconds => integer().withDefault(const Constant(300))();
  IntColumn get maxEscalations => integer().withDefault(const Constant(3))();
  IntColumn get escalationIntervalSeconds => integer().withDefault(const Constant(600))();
  IntColumn get confirmationWindowSeconds => integer().withDefault(const Constant(30))();

  // Multi-profile + sync columns
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
  TextColumn get cancellationReason => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 6.4.2 `ReminderLogs` Table

```dart
class ReminderLogs extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get reminderId => text().references(Reminders, #id)();
  TextColumn get eventType => text()();        // 'triggered', 'snoozed', 'escalated', etc.
  IntColumn get eventTimestamp => integer()();
  TextColumn get metadata => text().nullable()(); // JSON blob
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 6.4.3 `Medications` Table (Modified)
Added: `reminderMessage`, `reminderDuration`.

```dart
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get frequency => text()();        // JSON: {"type":"daily","times":["08:00","20:00"]}
  TextColumn get instructions => text().nullable()();
  TextColumn get reminderMessage => text().nullable()(); // The text to be spoken by TTS
  TextColumn get reminderDuration => text()(); // JSON: {"type":"fixedDays","days":7} | {"type":"oneMonth"} | {"type":"continuous"} | {"type":"custom","endTime":1234567890}
  BoolColumn get isCritical => boolean().withDefault(const Constant(false))();
  TextColumn get iconName => text().withDefault(const Constant('pill'))();
  TextColumn get colorHex => text().withDefault(const Constant('#4CAF50'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get archivedAt => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}
```

##### 6.4.3.1 ReminderDuration Options

| Type | JSON | Description |
|---|---|---|
| `fixedDays` | `{"type":"fixedDays","days":7}` | Fixed duration (default: 7 days) |
| `oneMonth` | `{"type":"oneMonth"}` | Reminders active for 30 days |
| `continuous` | `{"type":"continuous"}` | Reminders continue until manually turned off |
| `custom` | `{"type":"custom","endTime":1234567890}` | User selects custom duration (days/weeks/months). Stored as Unix ms endTime calculated from current time + duration |

> **Note:** The `reminderDuration` field determines how many reminders are generated when adding a medication. The AddMedication use case calculates the end time based on this field and generates dose records for each scheduled time within that duration.

#### 6.4.4 `DoseRecords` Table

```dart
class DoseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get medicationId => text().references(Medications, #id)();
  IntColumn get scheduledTime => integer()();
  IntColumn get actualTime => integer().nullable()();
  TextColumn get status => text()();           // 'taken', 'missed', 'skipped'
  TextColumn get reminderId => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 6.4.5 `CycleEntries` Table

```dart
class CycleEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get date => text()();             // ISO 8601: 'YYYY-MM-DD'
  TextColumn get flowIntensity => text().nullable()();
  TextColumn get symptoms => text().nullable()(); // JSON array
  TextColumn get notes => text().nullable()();
  BoolColumn get isPeriodDay => boolean().withDefault(const Constant(false))();
  IntColumn get cycleNumber => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(5))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{profileId, date}];
}
```

#### 6.4.6 `CyclePredictions` Table

```dart
class CyclePredictions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get predictedStart => text()();   // ISO 8601 date
  TextColumn get predictedEnd => text()();
  RealColumn get confidence => real()();       // 0.0 to 1.0
  TextColumn get algorithmVersion => text()();
  IntColumn get basedOnCycles => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get invalidatedAt => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 6.4.7 `XpEvents` Table 

```dart
class XpEvents extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get action => text()();           // 'dose_taken', 'cycle_logged', 'streak_maintained'
  IntColumn get xpAmount => integer()();       // Points earned
  TextColumn get sourceEntityId => text().nullable()(); // FK to originating record
  TextColumn get sourceEntityType => text().nullable()(); // 'dose_record', 'cycle_entry'
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 6.4.8 `Streaks` Table

```dart
class Streaks extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get streakType => text()();       // 'medication_adherence', 'cycle_logging'
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  IntColumn get longestCount => integer().withDefault(const Constant(0))();
  IntColumn get lastActivityAt => integer()(); // Unix ms — used for 36h grace period check
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{profileId, streakType}];
}
```

#### 6.4.9 `Achievements` Table 

```dart
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get achievementKey => text()();   // 'first_dose', '7_day_streak', '100_xp', etc.
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get iconName => text()();
  IntColumn get unlockedAt => integer().nullable()(); // Null = locked
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{profileId, achievementKey}];
}
```

#### 6.4.10 `AppSettings` Table

```dart
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get value => text()();            // JSON-encoded value
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key, profileId};
}
```

#### 6.4.11 `Profiles` Table

```dart
class Profiles extends Table {
  TextColumn get id => text()();               // UUID v4, primary key
  TextColumn get name => text()();             // Display name
  TextColumn get avatarIcon => text().nullable()(); // Material icon name
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get pinHash => text().nullable()(); // Optional PIN lock
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 6.5 AppDatabase Class

```dart
@DriftDatabase(
  tables: [
    Profiles,
    Reminders, ReminderLogs,
    Medications, DoseRecords,
    CycleEntries, CyclePredictions,
    XpEvents, Streaks, Achievements,
    AppSettings,
  ],
  daos: [ProfilesDao, ReminderDao, MedicationDao, CycleDao, GamificationDao, AppSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
  );
}
```

> **Architectural Note:** The coding agent must NOT write raw SQL for table creation. Drift generates all DDL from the Dart table classes. The `schemaVersion` starts at 1. Future migrations use Drift's `onUpgrade` with stepped migrations. Never alter a released migration.

### 6.6 Migration Strategy

- Drift handles migrations via `MigrationStrategy.onUpgrade` with version stepping.
- Schema changes are additive — never drop columns in production.
- Each migration step is a method that describes the delta from version N to N+1.
- The `drift_dev` package can generate migration test utilities.

---

## 7. Alarm, Notification & Voice Strategy

### 7.1 Architecture (v3.1 — Time-Slot Grouping & Voice Support)

v3.1 pivots from a 1:1 Medication-to-Alarm model to a **Time-Slot Grouping** model. This prevents "alarm fatigue" and allows for aggregated voice announcements.

| Package | Responsibility |
|---|---|
| `alarm` (^5.2.0) | Hardware-level exact alarm scheduling. Manages the system-level siren/audio for a unique timestamp. |
| `flutter_local_notifications` | Batch notification display. Lists all medications due at the specific time with batch-level action buttons. |
| `flutter_tts` (^4.2.2) | **Voice Engine:** Verbally announces medication names and custom reminder messages during the alarm trigger phase. |

> **v3.1 Design Pivot:** A "Reminder" entry in the database now represents a **Unique Timestamp**. If multiple medications are scheduled for the same minute, only ONE physical alarm is registered. The notification and voice engine dynamically pull all associated `DoseRecords` for that timestamp.

### 7.1.1 Lazy Loading Principle (Go Lazy, Not Eager)

> **CRITICAL DESIGN RULE:** Notification bodies and voice payloads are constructed at **alarm-fire time**, NOT at schedule-time. This ensures medication name changes, dose changes, reminders, or cancellations are reflected in the reminder when it fires.

| Aspect | Eager (WRONG) | Lazy (CORRECT) |
|--------|---------------|----------------|
| **Notification Body** | Built when scheduling, stored in `Reminders.body` | Query database at fire-time to build "Time for: [Med A], [Med B]" |
| **Voice Payload** | Pre-computed TTS text stored at schedule | Query `Medications.reminderMessage` at fire-time |
| **Medication List** | Stored as JSON in Reminder at schedule | Query `DoseRecords` + `Medications` tables at fire-time |

**Why Lazy Loading Matters:**
- User changes medication name at 7:55 AM → notification at 8:00 AM reflects the change
- User deletes a medication scheduled for 8:00 AM → only remaining meds appear
- User edits custom voice message → the new message is spoken

**Implementation Contract:**
```dart
// WRONG: Eager construction at schedule-time
Future<void> scheduleReminder(Medication med) async {
  final body = "Time for ${med.name}"; // ❌ Baked in
  await saveToDb(reminderBody: body);
}

// CORRECT: Lazy construction at fire-time  
Future<void> onAlarmFired(int timestamp) async {
  final doseRecords = await queryDoseRecordsForTimestamp(timestamp);
  final meds = await queryMedicationsForDoseRecords(doseRecords);
  final body = "Time for: ${meds.map((m) => m.name).join(", ")}"; // ✅ Built now
  await showNotification(body: body);
}
```

### 7.2 Alarm Service Contract (Grouped)

```dart
/// Handles hardware-level scheduling for unique time slots.
class AlarmService {
  // Responsibilities:
  // - Ensure only one hardware alarm exists per unique timestamp.
  // - Schedule alarms via Alarm.set() using high-priority audio.
  // - Stop specific alarms when the associated batch is confirmed.
  // - Implement volume escalation and looping (§5.3).
}
```

### 7.3 Notification Service Contract

```dart
/// Dart wrapper around `flutter_local_notifications`.
///Handles grouped notification UI and shade actions.
/// Handles notification display, channels, and action buttons.
class NotificationService {
  // Stub — MiniMax fills in implementation.
  //
  // Responsibilities:
  // - Initialize notification channels (medication, cycle, system)
  // - Build dynamic notification bodies (e.g., "Time for: Prozac, Vitamin D, Iron").
  // - Show notifications with action buttons (Snooze, Done)
  // - Handle notification action callbacks
  // - Force full-screen intent for any batch containing an 'isCritical' medication.
}
```

### 7.4 Voice Service Contract (NEW)

```dart
/// Text-to-Speech engine for audio reminders.
class VoiceService {
  // Responsibilities:
  // - Initialize TTS engine with clear, moderate-speed ADHD-friendly settings.
  // - Construct speech: "Attention: It is time for [Slot Name]. Please take [Med A] and [Med B]."
  // - Speak the 'reminderMessage' (§6.4.3) defined for each medication in the batch.
  // - Fallback: If TTS fails, the siren alarm continues as a secondary failsafe.
}
```

### 7.5 Notification Channel Definitions

| Channel ID | Name | Importance | Usage |
|---|---|---|---|
| `medication_reminders` | Medication Reminders | High | Grouped dose reminders with action buttons. |
| `cycle_reminders` | Cycle Reminders | Default | Cycle tracking reminders |
| `system` | System | Low | Backup completion, streak notifications |

### 7.6 Notification Action Buttons

Each medication reminder notification includes two action buttons:

| Action | Button Text | Behavior |
|---|---|---|
| Snooze | "Snooze All" | Reschedules the entire time-slot batch per the `EscalationPolicy`. Increments snooze count. |
| Done | "View/Take" | Opens the Batch Checklist UI (§10.1). Direct batch confirmation from the notification shade is disabled to ensure user     accountability. |

> **Architectural Note:** The `alarm` package uses `setAlarmClock()` internally — the ONLY AlarmManager API fully exempt from Doze mode, App Standby Buckets, and battery optimization across all Android versions. The coding agent must NEVER use `WorkManager` or `JobScheduler` for time-critical alarms.

> **Architectural Note:** When iOS support is added, both `alarm` and `flutter_local_notifications` already support iOS natively. Zero platform-specific Dart code is needed. See Appendix B.

> **Voice Logic Note:** The voice reminder acts as a cognitive aid. The physical alarm provides the urgency, while the Voice Service provides the "externalized" instruction required for ADHD executive function support.

---

## 8. Module Specifications

### 8.1 Medication Module

#### 8.1.1 Entities

```dart
class Medication {
  final String id;
  final String profileId;
  final String name;
  final String dosage;
  final MedicationFrequency frequency;
  final String? instructions;
  final bool isCritical;
  final String iconName;
  final String colorHex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
}

class MedicationFrequency {
  final FrequencyType type;          // daily, weekly, asNeeded, custom
  final List<TimeOfDay> dailyTimes;  // For daily: [08:00, 20:00]
  final List<int>? weekDays;         // For weekly: [1, 3, 5] (Mon, Wed, Fri)
  final int? intervalHours;          // For custom interval
}

class DoseRecord {
  final String id;
  final String profileId;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final DoseStatus status;           // taken, missed, skipped
  final String? reminderId;
  final String? notes;
  final int xpValue;
}
```

#### 8.1.2 Use Cases (v3.1 — Time-Slot Aware)

| Use Case | Input | Output | Side Effects |
|---|---|---|---|
| `AddMedication` | `Medication` entity | `Medication` with ID | **Time-Slot Upsert:** Searches for existing `Reminder` timestamps. Creates/Updates time-slots for 7 days. Creates linked `DoseRecords`. Updates hardware `AlarmService` with voice payload. |
| `RecordDose` | `doseRecordId`, `status`, `timestamp` | `DoseRecord` | Updates `DoseRecord`. Evaluates parent `Reminder` status (marks `logged` only if full batch is taken). Stops physical alarm if current batch is cleared. **Awards XP.** |
| `GetAdherenceStats` | `medicationId`, `DateRange` | `AdherenceReport` | None (read-only). |
| `GetMedicationSchedule` | `date` | `List<TimeSlotSchedule>` | Returns medications grouped by shared `scheduledTime` to support the **Batch Checklist UI**. |

> **Architectural Note:** `AddMedication` remains the ONLY entry point for reminder creation. It now implements **Time-Slot logic**: if a user adds a new medication at 08:00 AM and a `Reminder` already exists for that time, the use case links the new `DoseRecord` to the existing `Reminder` rather than creating a duplicate hardware alarm.The coding agent must NOT create reminders from the UI layer directly. The use case creates the medication record AND calls `ScheduleReminder` from the engine.

> **Voice Integration Note:** When `AddMedication` or `HandleSnooze` triggers the `AlarmService`, it must pass the `reminderMessage` (§6.4.3) and medication names as a payload. This ensures the `VoiceService` has the necessary strings to announce at trigger time without performing a database read during the high-urgency alarm firing sequence.

### 8.2 Menstrual Cycle Module

#### 8.2.1 Prediction Algorithm (Offline)

```
Algorithm: Weighted Moving Average (v1)

Input:
  - Last N completed cycles (default N=6, minimum N=3)
  - Each cycle has a length in days (start-to-start)

Process:
  1. Calculate cycle lengths: L1, L2, ..., LN (most recent = LN)
  2. Apply weights: W = [1, 1, 2, 2, 3, 3] (recent cycles weighted more)
     - If fewer cycles, truncate weights from the left
  3. Weighted average: predicted_length = sum(Li * Wi) / sum(Wi)
  4. Round to nearest integer
  5. Predicted start = last_period_start + predicted_length
  6. Confidence = 1.0 - (std_dev / mean)
     - Clamp to [0.3, 0.95] range
     - If std_dev > 7 days, confidence capped at 0.5

Output:
  - CyclePrediction entity with predicted_start, predicted_end (start + 5 days default),
    confidence score, algorithm version tag

Edge Cases:
  - < 3 completed cycles: No prediction generated. UI shows "Need more data."
  - Cycle length < 18 or > 45 days: Flag as outlier, exclude from calculation, log warning.
  - All cycles are outliers: Fall back to 28-day default with confidence = 0.3.
```

> **Architectural Note:** The prediction algorithm is a pure function with zero side effects. It must NOT read from the database — the use case provides the data. This makes it trivially testable.

#### 8.2.2 Use Cases

| Use Case | Input | Output | Side Effects |
|---|---|---|---|
| `LogCycleEntry` | `CycleEntry` | `CycleEntry` with ID | Auto-calculates `cycle_number`. Invalidates stale predictions. **Awards XP via Gamification Engine.** |
| `PredictCycle` | None (reads history) | `CyclePrediction` | Stores prediction in `cycle_predictions` table. |
| `GetCycleHistory` | `DateRange` | `List<CycleEntry>` | None (read-only). |

### 8.3 Insight Engine

#### 8.3.1 Pattern Detection (Offline)

The Insight Engine runs on-device, triggered by user navigation to the insights page or by a daily background task.

**Detectable Patterns :**

| Pattern | Detection Logic | User-Facing Insight |
|---|---|---|
| Consistent miss time | > 60% of missed doses occur at the same time-of-day slot | "You tend to miss your evening doses. Consider setting an earlier reminder." |
| Improving streak | 7+ consecutive days with 100% adherence | "Great streak! You've taken all medications for 7 days straight." |
| Weekend drop | Adherence on Sat/Sun is > 20% lower than weekdays | "Your weekend adherence drops. Try linking meds to a weekend routine." |
| Cycle-medication correlation | Missed doses increase in the 3 days before predicted period start | "You tend to miss doses around your period. This is common." |
| XP milestone | Total XP crosses a threshold (100, 500, 1000) | "You've earned 500 XP! You're building great habits." |

> **Architectural Note:** The Insight Engine must NEVER generate insights that could be perceived as medical advice. All insights are behavioral observations. The coding agent must use observational language ("You tend to...", "We noticed...") and NEVER use imperative medical language ("You should take...", "Increase your dosage...").

---

## 9. Gamification Engine

### 9.1 Overview

The Gamification Engine provides **dopamine reinforcement** for ADHD users through three mechanisms:

1. **XP (Experience Points):** Earned by completing actions. Accumulates over time.
2. **Streaks:** Consecutive-day counters with a **36-hour ADHD grace period**.
3. **Achievements:** One-time unlockable milestones.

### 9.2 XP System

| Action | XP Earned | Notes |
|---|---|---|
| Dose taken (on time) | 10 XP | Within response window |
| Dose taken (after snooze) | 5 XP | Reduced reward, but still positive |
| Cycle entry logged | 5 XP | Per day logged |
| Streak day maintained | 2 XP | Bonus per streak day |
| Achievement unlocked | 25 XP | One-time bonus |

> **Design Note:** XP values are stored per-record in the `xp_value` column. The `AwardXp` use case creates an `XpEvent` row and updates the running total. XP is never subtracted — missed doses simply don't earn XP. This follows the "progress, not perfection" ADHD UX principle.

### 9.3 Streak System with 36-Hour ADHD Grace Period

Standard streak systems use a 24-hour window: miss one day and the streak resets. This is punishing for ADHD users who may have variable schedules.

**Smart Health Reminder uses a 36-hour grace period:**

```
Normal day:      ┌─────── 24h ───────┐
                 Day 1 action    Day 2 action
                 
ADHD grace:      ┌─────────── 36h ───────────┐
                 Day 1 action         Day 2 action (up to 12h late)
```

**`EvaluateStreak` logic:**

```
Input: streak record, current timestamp

1. Calculate hours since last_activity_at
2. If hours <= 36:
     streak is ALIVE — increment current_count
     update longest_count if current > longest
3. If hours > 36:
     streak is BROKEN — reset current_count to 1
     longest_count unchanged
4. Update last_activity_at to current timestamp
```

> **Architectural Note:** The 36-hour window is a conscious design choice, not a bug. The coding agent must NOT "fix" it to 24 hours. The extra 12 hours accounts for shifted sleep schedules, weekend irregularity, and executive function variability.

### 9.4 Achievements 

| Achievement Key | Title | Trigger Condition |
|---|---|---|
| `first_dose` | First Step | Record first dose |
| `7_day_streak` | One Week Strong | 7-day medication streak |
| `30_day_streak` | Monthly Champion | 30-day medication streak |
| `100_xp` | Rising Star | Accumulate 100 XP |
| `500_xp` | Health Hero | Accumulate 500 XP |
| `first_cycle_log` | Cycle Tracker | Log first cycle entry |
| `perfect_week` | Perfect Week | 100% adherence for 7 consecutive days |

> **Design Note:** Achievements are seeded in the database on first launch (all with `unlockedAt = null`). The `CheckAchievements` use case runs after every XP-earning action and checks all locked achievements against current state. When an achievement unlocks, it shows a celebratory UI overlay.

### 9.5 Gamification Repository Interface

```dart
abstract class GamificationRepository {
  Future<void> recordXpEvent(XpEvent event);
  Future<int> getTotalXp(String profileId);
  Future<Streak> getOrCreateStreak(String profileId, String streakType);
  Future<void> updateStreak(Streak streak);
  Future<List<Achievement>> getAchievements(String profileId);
  Future<void> unlockAchievement(String achievementId, int timestamp);
  Future<List<Achievement>> getLockedAchievements(String profileId);
}
```

---

## 10. ADHD-Friendly UX Contract

### 10.1 Core UX Rules

These rules are non-negotiable and override aesthetic preferences. Any UI implementation that violates these is a product failure.

| Rule | Implementation | Why |
|---|---|---|
| **Single primary action per screen** | Every page has at most ONE prominent CTA button. | Decision fatigue is the #1 enemy of ADHD task completion. |
| **Progress, not perfection** | Show streak counters, XP bars, percentage adherence, trend arrows. Never show "failures." | Shame-based feedback causes app abandonment. |
| **Escalating urgency in notifications** | Stage 1: Gentle chime. Stage 2: Vibration + sound. Stage 3: Full-screen overlay + looped audio. | Users with ADHD often dismiss initial notifications unconsciously. |
| **Instant feedback on completion** | 300ms confetti animation + haptic pulse + XP popup on confirmation. | Dopamine reward reinforces the habit loop. |
| **Minimal text, maximum icons** | Use iconography and color-coding over text labels where possible. | Reduces cognitive parsing overhead. |
| **No multi-step forms** | Adding a medication is a single scrollable form, not a wizard. | Multi-step flows have catastrophic abandonment rates for ADHD users. |
| **Undo over confirm** | "Dose taken" is immediate with a 5-second undo toast, not a "Are you sure?" dialog. | Confirmation dialogs interrupt flow and cause decision paralysis. |
| **36-hour streak grace** | Streaks use 36-hour windows, not 24-hour. | Shifted schedules shouldn't punish users. See Section 9.3. |
| **Individual Batch Checkout** | Grouped reminders must show a **Checklist**, not a "Take All" button. | **[NEW]** ADHD users often log all meds as "taken" even if they only swallowed one. Force a per-item check. |
| **Audio Externalization** | Use Text-to-Speech (TTS) to announce specific medication names. | **[NEW]** Reduces "Time Blindness." Hearing "Take your Prozac" is more effective than a generic beep. |

### 10.2 Audio & Voice Interaction

The voice reminder is not a "nice-to-have" feature; it is a cognitive externalization tool.

1.  **Announcement Sequence:** The physical siren/alarm plays first, followed by the Voice Service announcing the specific medication list.
2.  **Voice Clarity:** TTS must be set to a distinct, clear pitch with no background music to ensure the instruction is isolated from the environment.
3.  **Dynamic Messaging:** If a medication has a `reminderMessage` (§6.4.3), it must be spoken after the medication name (e.g., "Take Iron. Note: Do not take with coffee").

### 10.3 Color System

```dart
/// ADHD-optimized high-contrast palette
class ADHDColors {
  // Status colors (high contrast, colorblind-safe)
  static const taken = Color(0xFF2E7D32);       // Deep green
  static const missed = Color(0xFFC62828);       // Deep red
  static const snoozed = Color(0xFFEF6C00);     // Deep orange
  static const upcoming = Color(0xFF1565C0);     // Deep blue
  static const neutral = Color(0xFF424242);      // Dark grey

  // Background (low-stimulus)
  static const background = Color(0xFFFAFAFA);  // Near-white
  static const surface = Color(0xFFFFFFFF);      // White
  static const darkBackground = Color(0xFF121212); // True dark

  // Accent (dopamine trigger - used sparingly)
  static const reward = Color(0xFFFFD600);       // Bright gold (celebrations only)

  // Gamification (NEW in v2)
  static const xpBar = Color(0xFF7C4DFF);       // Purple (XP progress)
  static const streakActive = Color(0xFFFF6D00);  // Orange (active streak)
  static const achievementGold = Color(0xFFFFAB00); // Amber (unlocked achievement)
}
```

> **Architectural Note:** The `reward` color is ONLY used for the confirmation animation (300ms confetti burst). The `xpBar`, `streakActive`, and `achievementGold` colors are only used in their respective gamification widgets. Overuse of high-dopamine colors leads to habituation.

---

## 11. Implementation Roadmap

### Brutal MVP Philosophy

> **Ship the narrowest vertical first.** The database schema is built for the grand vision (all 11 tables on day 1), but code only implements single-profile pill reminders until Phase 3 is done. Multi-profile, cycle tracking, and insights are built on a proven foundation.

### Phase 1: Foundation (Secure Storage + Drift ORM + Project Scaffolding)

**Goal:** A runnable app shell with encrypted Drift database and `flutter_secure_storage` integration.

| Task ID | Task | Dependencies | Est. Effort |
|---|---|---|---|
| P1-01 | Set up directory structure per Section 4 | None | 1h |
| P1-02 | Add pubspec.yaml dependencies (v3 list) | P1-01 | 30m |
| P1-03 | Define all 11 Drift table classes | P1-02 | 3h |
| P1-04 | Define all 6 Drift DAOs (stubs) | P1-03 | 2h |
| P1-05 | Implement `AppDatabase` with Drift | P1-04 | 2h |
| P1-06 | Implement `SecureStorageImpl` (passphrase management) | P1-02 | 1h |
| P1-07 | Connect Drift to SQLCipher with secure passphrase | P1-05, P1-06 | 2h |
| P1-08 | Create `AlarmService` + `NotificationService` + `VoiceService` stubs (platform layer) | P1-01 | 1h |
| P1-09 | Create backup module stubs (export/import) | P1-02 | 1h |
| P1-10 | Create Riverpod `ProviderScope` + GoRouter setup | P1-07 | 2h |
| P1-11 | Run `build_runner` to generate Drift code | P1-05 | 30m |
| P1-12 | Write integration test: DB opens with encryption | P1-07 | 2h |

**Phase 1 Exit Criteria:**
- App launches on a physical Android device.
- Drift database opens with SQLCipher encryption via `flutter_secure_storage` passphrase.
- All 11 tables created by Drift.
- `flutter analyze` passes with zero errors.
- Integration test passes.

### Phase 2: The Core Engine (Alarm Package + State Machine)

**Goal:** A fully functional reminder engine with `alarm` package reliability.

| Task ID | Task | Dependencies | Est. Effort |
|---|---|---|---|
| P2-01 | Implement `AlarmService` (alarm package wrapper) | P1-08 | 1h |
| P2-02 | Implement `Reminder` entity + `ReminderStatus` enum | P1-01 | 1h |
| P2-03 | Implement `EscalationPolicy` entity | P2-02 | 30m |
| P2-04 | Implement `ReminderRepository` interface | P2-02 | 30m |
| P2-05 | Implement `ReminderDao` with Drift | P1-05 | 3h |
| P2-06 | Implement `ReminderRepositoryImpl` | P2-04, P2-05 | 3h |
| P2-07 | Implement `ReminderMapper` | P2-02 | 1h |
| P2-08 | Implement core use cases (5 files) | P2-06 | 4h |
| P2-09 | Connect use cases to `alarm` package + `NotificationService` | P2-08, P2-01 | 2h |
| P2-10 | Implement `ReminderNotifier` (Riverpod) | P2-08 | 2h |
| P2-11 | Write unit tests for state machine | P2-02 | 3h |
| P2-12 | Write unit tests for use cases | P2-08 | 3h |

**Phase 2 Exit Criteria:**
- A reminder can be scheduled, triggered, snoozed, escalated, confirmed, or missed.
- All state transitions match Section 5.3 exactly.
- Alarms fire reliably in Doze mode on a physical device.
- Alarms survive device reboot.
- All unit tests pass.

### Phase 3: Medication MVP (Grouped Alarms & Voice Logic)

**Goal:** A user can add medications, receive consolidated alarms for shared time slots, hear a voice reminder, and confirm doses via a batch checklist. This is the Brutal MVP — the first shippable vertical.

| Task ID | Task | Dependencies | Est. Effort |
|---|---|---|---|
| P3-01 | Implement `Medication` + `DoseRecord` entities(inc. `reminderMessage`) | P1-01 | 1h |
| P3-02 | Implement `MedicationRepository` interface | P3-01 | 30m |
| P3-03 | Implement `MedicationDao` with Drift | P1-05 | 3h |
| P3-04 | Implement `MedicationRepositoryImpl` | P3-02, P3-03 | 3h |
| P3-05 | Implement Medication use cases(Time-Slot Aware): AddMedication, RecordDose (4 files) | P3-04, P2-08 | 4h |
| P3-06 | Create and Implement `VoiceService` (TTS implementation) |	P1-08	| 2h
| P3-07 | Implement Medication UI (3 pages, 3 widgets) | P3-05 | 8h |
| P3-08 | Implement Batch Dose Confirmation Sheet (Checklist UI) | P2-10, P3-06 | 4h |
| P3-08 | Implement Home page (today's reminders grouped by timestamp) | P2-10 | 3h |
| P3-09 | Write unit tests for Medication use cases, Grouping Logic & Partial Completion | P3-05 | 2h |
| P3-10 | Write integration test: full dose batch flow (Alarms -> Checklist -> Logs) | P3-08 | 3h |

**Phase 3 Exit Criteria:**
- User can add multiple medications at the same time and trigger only one physical alarm.
- The system correctly announces medication names via Text-to-Speech when the alarm fires.
- The user is forced to check off each medication individually in a checklist before the alarm can be fully silenced (Batch Checkout).
- Adherence dashboard shows stats for last 7/30 days.
- Adherence dashboard correctly reflects "Partially Taken" slots if only some items in a batch are checked.
- Single-profile only (hardcoded `profileId = 'default'`).
- This is the **Brutal MVP** — shippable at this point.


> Architectural Note: Task P3-05 is the core engine update. The logic must shift from "Medication-centric" to "Time-slot centric." AddMedication must look for an existing Reminder for the target scheduledTime and increment the groupDoseCount rather than scheduling a redundant hardware alarm.

> UX Warning: The Batch Confirmation Sheet (P3-08) must strictly follow the ADHD contract. No "Take All" button is permitted. Each checkbox must trigger a haptic pulse to provide discrete dopamine rewards for every pill swallowed.

### Phase 4: Gamification + Cycle Tracking

**Goal:** XP system, streaks, achievements, and menstrual cycle logging with prediction.

| Task ID | Task | Dependencies | Est. Effort |
|---|---|---|---|
| P4-01 | Implement `XpEvent`, `Streak`, `Achievement` entities | P1-01 | 1h |
| P4-02 | Implement `GamificationRepository` interface + impl | P4-01, P1-05 | 3h |
| P4-03 | Implement `GamificationDao` with Drift | P1-05 | 3h |
| P4-04 | Implement gamification use cases (3 files) | P4-02 | 3h |
| P4-05 | Integrate XP awarding into `RecordDose` + `ConfirmReminder` | P4-04, P3-05 | 2h |
| P4-06 | Implement gamification UI (3 widgets + notifier) | P4-04 | 4h |
| P4-07 | Seed initial achievements on first launch | P4-03 | 1h |
| P4-08 | Implement `CycleEntry` + `CyclePrediction` entities | P1-01 | 1h |
| P4-09 | Implement cycle prediction algorithm (pure function) | P4-08 | 2h |
| P4-10 | Implement `CycleRepository` interface + impl | P4-08, P1-05 | 3h |
| P4-11 | Implement `CycleDao` with Drift | P1-05 | 3h |
| P4-12 | Implement Cycle use cases (3 files) | P4-10, P4-09 | 3h |
| P4-13 | Implement Cycle UI (2 pages, 2 widgets + notifier) | P4-12 | 6h |
| P4-14 | Write unit tests for gamification | P4-04 | 2h |
| P4-15 | Write unit tests for cycle prediction | P4-09 | 2h |

**Phase 4 Exit Criteria:**
- XP is earned on dose confirmation and cycle logging.
- Streaks use the 36-hour ADHD grace period.
- Achievements unlock and show celebratory UI.
- Cycle prediction matches Section 8.2.1 exactly.
- All unit tests pass.

### Phase 5: Polish, Insights & Multi-Profile Prep

**Goal:** Insight engine, settings, performance optimization, and multi-profile groundwork.

| Task ID | Task | Dependencies | Est. Effort |
|---|---|---|---|
| P5-01 | Implement Insight Engine (pattern detection) | P3-05, P4-12 | 4h |
| P5-02 | Implement Insights UI (1 page, 1 widget + notifier) | P5-01 | 3h |
| P5-03 | Implement Settings page | P1-05 | 2h |
| P5-04 | Implement notification action handling (Snooze/Done from notification) | P2-09 | 3h |
| P5-05 | ADHD theme polish (light/dark, confetti animation) | P1-10 | 3h |
| P5-06 | Performance profiling + DB index optimization | All | 3h |
| P5-07 | Full E2E integration test | All | 4h |
| P5-08 | Multi-profile UI prep (profile switcher placeholder) | P1-05 | 2h |

**Phase 5 Exit Criteria:**
- Complete, navigable UI with all pages functional.
- ADHD UX rules from Section 10.1 are verifiable by manual inspection.
- Insight engine detects at least one pattern with test data.
- E2E test passes on physical device.
- No jank (<16ms frame time) on medication list with 20+ items.
- `profile_id` column is used consistently but only `'default'` value exists.

---

## 12. Testing Strategy

### 12.1 Test Pyramid

```
         ╱╲
        ╱  ╲        E2E Tests (2-3 critical flows)
       ╱────╲
      ╱      ╲      Integration Tests (DB, Alarm Package, Backup)
     ╱────────╲
    ╱          ╲    Unit Tests (Entities, UseCases, Algorithms)
   ╱────────────╲
```

### 12.2 Unit Test Requirements

| Component | Required Tests | Coverage Target |
|---|---|---|
| `ReminderStatus` state machine | All valid transitions, all invalid transitions, edge cases | 100% of transitions in Section 5.3 |
| `EscalationPolicy` calculations | Snooze delay math, boundary conditions | 100% |
| Cycle prediction algorithm | Normal input, edge cases (<3 cycles, outliers, all outliers) | 100% of branches |
| Streak evaluation (36h grace) | Within grace, outside grace, boundary at 36h | 100% |
| XP award calculations | All action types, correct amounts | 100% |
| Achievement check logic | Each achievement trigger condition | 100% |
| Use cases | Happy path + error path for each use case | 90%+ |
| Mappers | Round-trip mapping (entity → model → entity) | 100% |

### 12.3 Integration Test Requirements

| Test | What It Validates |
|---|---|
| DB encryption roundtrip | Open DB with passphrase via `flutter_secure_storage`, write data, close, reopen → data intact. |
| Drift table creation | All 11 tables created successfully. |
| Alarm scheduling | Schedule alarm via `alarm` package, verify alarm is registered and fires. |
| Full reminder lifecycle | Schedule → Trigger → Snooze → Trigger → Confirm → Verify DB state + XP awarded. |
| Boot reschedule | Simulate boot → verify all scheduled reminders are re-registered. |
| Streak grace period | Confirm dose at 35h → streak alive. Confirm at 37h → streak reset. |
| Backup export/import | Export encrypted JSON via `share_plus`, re-import via `file_picker` → all data intact. |

### 12.4 What NOT to Test

- Flutter widget pixel-perfect rendering (too brittle, too slow).
- Third-party package internals (e.g., `sqflite_sqlcipher` encryption logic, `flutter_secure_storage` Keystore interaction, `alarm` package AlarmManager internals).
- Android OS behavior (e.g., "does Doze mode actually defer alarms?").
- Drift-generated code (trust the code generator).

---

## 13. Glossary

| Term | Definition |
|---|---|
| **Reminder** | A scheduled event tracked by the Smart Reminder Engine. It has a lifecycle (state machine). |
| **Dose** | A single instance of medication intake, linked to a reminder. |
| **Cycle Entry** | A single day's record in the menstrual cycle log. |
| **Escalation** | The process of increasing notification urgency when a user doesn't respond. |
| **Confirmation Mode** | The interaction method required to mark a reminder as completed. |
| **Passphrase** | The encryption key used to open the SQLCipher database. Stored in `flutter_secure_storage`. |
| **Insight** | A behavioral observation generated by the Insight Engine from local data. |
| **Adherence** | The percentage of scheduled doses that were actually taken. |
| **Critical Medication** | A medication flagged by the user as important, triggering aggressive escalation policies. |
| **XP (Experience Points)** | Points earned by completing health actions. Accumulates, never decreases. |
| **Streak** | Consecutive days of activity with a 36-hour ADHD grace period. |
| **Achievement** | A one-time unlockable milestone triggered by reaching specific thresholds. |
| **Drift** | Type-safe ORM for SQLite/SQLCipher in Dart. Generates DAOs and data classes from table definitions. |
| **Brutal MVP** | Philosophy of building the full schema but only implementing the narrowest functional vertical first. |
| **ADHD Grace Period** | The 36-hour (not 24-hour) window used for streak evaluation, accounting for variable schedules. |
| **Profile** | A user identity container. All tables have `profile_id`. Single-profile (`'default'`) until Phase 5. |

---

## Appendix A: pubspec.yaml Dependencies (v3)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management (Riverpod-only — v3)
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Routing
  go_router: ^14.2.7

  # Database (Drift ORM + SQLCipher encryption)
  drift: ^2.22.1
  drift_sqflite: ^2.0.1
  sqflite_sqlcipher: ^3.1.0+1
  path_provider: ^2.1.4

  # Security (replaces custom Keystore MethodChannel)
  flutter_secure_storage: ^9.2.4

  # Alarms & Notifications & flutter tts (v3.1 — replaces custom Kotlin AlarmManager)
  alarm: ^5.1.5
  flutter_local_notifications: ^18.0.1
  flutter_tts: ^4.2.2. 

  # Backup / Export / Import (v3 — data safety)
  share_plus: ^10.1.4
  file_picker: ^8.1.6

  # Utilities
  uuid: ^4.4.2
  equatable: ^2.0.5
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  intl: ^0.19.0

  # Icons
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.22.1
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  mockito: ^5.4.4
  mocktail: ^1.0.4
  riverpod_generator: ^2.4.3
```

> **v3 Changes from v2:** Removed `flutter_bloc` and `bloc_test`. Added `alarm`, `flutter_local_notifications`, `share_plus`, `file_picker`, `riverpod_generator`. Moved `freezed_annotation` from dev_dependencies to dependencies (annotations appear in runtime code).

> **Architectural Note:** The coding agent must NOT add packages beyond this list without explicit approval. Every additional package increases the attack surface, maintenance burden, and risk of version conflicts.

---

## Appendix B: Future iOS Port Strategy

v3 uses cross-platform Flutter packages, making iOS support significantly simpler than v2:

| Package | Android | iOS | Notes |
|---|---|---|---|
| `alarm` | AlarmManager + ForegroundService | UNNotificationCenter | Handled internally by package |
| `flutter_local_notifications` | NotificationManager | UNUserNotificationCenter | Handled internally by package |
| `flutter_secure_storage` | Android Keystore | iOS Keychain | Already cross-platform |
| `share_plus` | Android share intent | iOS UIActivityViewController | Already cross-platform |
| `file_picker` | Android file picker | iOS document picker | Already cross-platform |
| Drift + SQLCipher | Same | Same | Pure Dart + FFI |

When iOS support is added:

1. No custom Swift code is needed — all packages already support iOS.
2. `flutter_secure_storage` already supports iOS Keychain — no additional work needed.
3. The `platform/` directory in Dart remains unchanged — `AlarmService` and `NotificationService` wrap cross-platform packages.
4. The only iOS-specific work is configuring `Info.plist` entries for notification permissions and background modes.

> **Architectural Note:** v3 eliminates the Platform layer's role as a native-bridge abstraction. Instead, it wraps cross-platform Flutter packages. This means iOS support requires zero new Dart code — only configuration files. The coding agent must NEVER import platform-specific packages directly; always use the wrappers in `core/platform/`.

---

*End of Specification v3. This document governs all implementation decisions. Any deviation requires a documented amendment with rationale.*
