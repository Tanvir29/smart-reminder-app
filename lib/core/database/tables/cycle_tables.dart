import 'package:drift/drift.dart';

class CycleEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get date => text()();
  TextColumn get flowIntensity => text().nullable()();
  TextColumn get symptoms => text().nullable()();
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
  List<Set<Column>> get uniqueKeys => [
    {profileId, date},
  ];
}

class CyclePredictions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().withDefault(const Constant('default'))();
  TextColumn get predictedStart => text()();
  TextColumn get predictedEnd => text()();
  RealColumn get confidence => real()();
  TextColumn get algorithmVersion => text()();
  IntColumn get basedOnCycles => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get invalidatedAt => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('local'))();

  @override
  Set<Column> get primaryKey => {id};
}
