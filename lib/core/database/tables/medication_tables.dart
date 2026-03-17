import 'package:drift/drift.dart';

class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get frequency => text()();
  TextColumn get instructions => text().nullable()();
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

class DoseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get medicationId => text().references(Medications, #id)();
  IntColumn get scheduledTime => integer()();
  IntColumn get actualTime => integer().nullable()();
  TextColumn get status => text()();
  TextColumn get reminderId => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}
