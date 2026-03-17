import 'package:drift/drift.dart';

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  IntColumn get scheduledTime => integer()();
  IntColumn get actualTriggerTime => integer().nullable()();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  IntColumn get escalationCount => integer().withDefault(const Constant(0))();
  TextColumn get confirmationMode =>
      text().withDefault(const Constant('swipeToConfirm'))();
  TextColumn get linkedEntityId => text().nullable()();
  TextColumn get linkedEntityType => text().nullable()();

  IntColumn get maxSnoozes => integer().withDefault(const Constant(3))();
  IntColumn get snoozeBaseDelayMinutes =>
      integer().withDefault(const Constant(5))();
  IntColumn get responseWindowSeconds =>
      integer().withDefault(const Constant(300))();
  IntColumn get maxEscalations => integer().withDefault(const Constant(3))();
  IntColumn get escalationIntervalSeconds =>
      integer().withDefault(const Constant(600))();
  IntColumn get confirmationWindowSeconds =>
      integer().withDefault(const Constant(30))();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get completedAt => integer().nullable()();
  TextColumn get cancellationReason => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}

class ReminderLogs extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get reminderId => text().references(Reminders, #id)();
  TextColumn get eventType => text()();
  IntColumn get eventTimestamp => integer()();
  TextColumn get metadata => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
