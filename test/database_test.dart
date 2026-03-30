import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:matcher/matcher.dart' show isNotNull;
import 'package:smart_reminder_app/core/database/app_database.dart';
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
  });
}
