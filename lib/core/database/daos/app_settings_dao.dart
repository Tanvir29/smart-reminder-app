import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/app_settings_tables.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  Future<String?> getSetting(String key, {String profileId = 'default'}) async {
    final result =
        await (db.select(appSettings)
              ..where((s) => s.key.equals(key))
              ..where((s) => s.profileId.equals(profileId)))
            .getSingleOrNull();
    return result?.value;
  }

  Future<void> setSetting(
    String key,
    String value, {
    String profileId = 'default',
  }) async {
    await db
        .into(appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion(
            key: Value(key),
            profileId: Value(profileId),
            value: Value(value),
            createdAt: Value(DateTime.now().millisecondsSinceEpoch),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<List<AppSetting>> getAllSettings({String profileId = 'default'}) =>
      (db.select(
        appSettings,
      )..where((s) => s.profileId.equals(profileId))).get();

  Future<void> deleteSetting(String key, {String profileId = 'default'}) =>
      (db.delete(appSettings)
            ..where((s) => s.key.equals(key))
            ..where((s) => s.profileId.equals(profileId)))
          .go();

  Future<void> deleteAllSettings({String profileId = 'default'}) => (db.delete(
    appSettings,
  )..where((s) => s.profileId.equals(profileId))).go();
}
