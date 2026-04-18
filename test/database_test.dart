import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:matcher/matcher.dart' show isNotNull;
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/app_database.dart' as drift_db;
import 'package:sqlite3/open.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // On Linux CI/dev, the unversioned libsqlite3.so symlink may not exist
  // (requires libsqlite3-dev). Point the FFI loader at the versioned .so
  // that is always present with the libsqlite3-0 runtime package.
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }

  group('AppDatabase Tests', () {
    late AppDatabase db;

    setUp(() {
      // Use in-memory database for unit tests — avoids path_provider
      // and SQLCipher plugin dependencies while still validating schema
      // and DAO initialization.
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('DB opens and can execute queries', () async {
      expect(db, isNotNull);

      final result = await db.customSelect('SELECT 1 AS val').get();
      expect(result.first.read<int>('val'), equals(1));
    });

    test('DB schema version is 2', () {
      expect(db.schemaVersion, equals(2));
    });

    test('All DAOs are initialized', () {
      expect(db.profilesDao, isNotNull);
      expect(db.reminderDao, isNotNull);
      expect(db.medicationDao, isNotNull);
      expect(db.cycleDao, isNotNull);
      expect(db.gamificationDao, isNotNull);
      expect(db.appSettingsDao, isNotNull);
    });

    test('All 11 tables exist in schema', () async {
      final result = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
          )
          .get();

      final tableNames = result.map((row) => row.read<String>('name')).toList();

      expect(
          tableNames,
          containsAll([
            'profiles',
            'reminders',
            'reminder_logs',
            'medications',
            'dose_records',
            'cycle_entries',
            'cycle_predictions',
            'xp_events',
            'streaks',
            'achievements',
            'app_settings',
          ]));
    });

    test('Foreign key: dose record references medication', () async {
      final now = DateTime.now().millisecondsSinceEpoch;

      await db.medicationDao.insertMedication(MedicationsCompanion(
        id: const Value('med-fk-test'),
        profileId: const Value('default'),
        name: const Value('FK Test Med'),
        dosage: const Value('10mg'),
        frequency: const Value('{"type":"daily","timesOfDay":[480]}'),
        reminderDuration: const Value('{"type":"fixedDays","days":7}'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      await db.medicationDao.recordDose(DoseRecordsCompanion(
        id: const Value('dose-fk-test'),
        profileId: const Value('default'),
        medicationId: const Value('med-fk-test'),
        scheduledTime: Value(now),
        status: const Value('taken'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      final doses =
          await db.medicationDao.getDoseRecordsByMedication('med-fk-test');
      expect(doses, hasLength(1));
      expect(doses.first.medicationId, equals('med-fk-test'));
    });

    test('Unique constraint: duplicate CycleEntry profileId+date throws',
        () async {
      final now = DateTime.now().millisecondsSinceEpoch;

      await db.cycleDao.insertCycleEntry(CycleEntriesCompanion(
        id: const Value('cycle-1'),
        profileId: const Value('default'),
        date: const Value('2026-01-15'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      expect(
        () => db.cycleDao.insertCycleEntry(CycleEntriesCompanion(
          id: const Value('cycle-2'),
          profileId: const Value('default'),
          date: const Value('2026-01-15'),
          createdAt: Value(now),
          updatedAt: Value(now),
        )),
        throwsA(anything),
      );
    });
  });
}
