import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // USE NATIVE
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/open.dart'; // REQUIRED IMPORT
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart'; // REQUIRED IMPORT

import 'tables/profiles_tables.dart';
import 'tables/reminder_tables.dart';
import 'tables/medication_tables.dart';
import 'tables/cycle_tables.dart';
import 'tables/gamification_tables.dart';
import 'tables/app_settings_tables.dart';

import 'daos/profiles_dao.dart';
import 'daos/reminder_dao.dart';
import 'daos/medication_dao.dart';
import 'daos/cycle_dao.dart';
import 'daos/gamification_dao.dart';
import 'daos/app_settings_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Profiles,
    Reminders,
    ReminderLogs,
    Medications,
    DoseRecords,
    CycleEntries,
    CyclePredictions,
    XpEvents,
    Streaks,
    Achievements,
    AppSettings,
  ],
  daos: [
    ProfilesDao,
    ReminderDao,
    MedicationDao,
    CycleDao,
    GamificationDao,
    AppSettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
      );

  static Future<AppDatabase> openEncrypted(String passphrase) async {
    // --- START OF FIX ---
    // This tells the sqlite3 package to use the SQLCipher implementation on Android
    if (Platform.isAndroid) {
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }
    // --- END OF FIX ---

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'smart_health_v1.db'));

    final executor = LazyDatabase(() async {
      return NativeDatabase(
        file,
        setup: (db) {
          db.execute("PRAGMA key = '$passphrase'");
        },
      );
    });
    return AppDatabase(executor);
  }
}
