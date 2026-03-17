import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/profiles_tables.dart';

part 'profiles_dao.g.dart';

@DriftAccessor(tables: [Profiles])
class ProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$ProfilesDaoMixin {
  ProfilesDao(super.db);

  Future<Profile?> getActiveProfile() async {
    return (db.select(profiles)
          ..where((p) => p.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Profile?> getProfileById(String id) async {
    return (db.select(
      profiles,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<List<Profile>> getAllProfiles() async {
    return db.select(profiles).get();
  }

  Future<void> createProfile(ProfilesCompanion profile) async {
    await db.into(profiles).insert(profile);
  }

  Future<void> updateProfile(Profile profile) async {
    await db.update(profiles).replace(profile);
  }

  Future<void> switchProfile(String profileId) async {
    await db.transaction(() async {
      await (db.update(profiles)..where((p) => p.isActive.equals(true))).write(
        const ProfilesCompanion(isActive: Value(false)),
      );
      await (db.update(profiles)..where((p) => p.id.equals(profileId))).write(
        const ProfilesCompanion(isActive: Value(true)),
      );
    });
  }

  Future<void> deleteProfile(String id) async {
    await (db.delete(profiles)..where((p) => p.id.equals(id))).go();
  }
}
