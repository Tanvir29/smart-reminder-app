import 'package:flutter_test/flutter_test.dart' hide isNotNull;
import 'package:matcher/matcher.dart' show isNotNull;
import 'package:smart_reminder_app/core/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDatabase Tests', () {
    const testPassphrase = 'test_secure_passphrase_32_chars_long';

    test('DB opens with correct passphrase', () async {
      final db = await AppDatabase.openEncrypted(testPassphrase);
      expect(db, isNotNull);

      await db.customSelect('SELECT 1').get();

      await db.close();
    });

    test('DB schema version is 1', () async {
      final db = await AppDatabase.openEncrypted(testPassphrase);
      expect(db.schemaVersion, equals(1));
      await db.close();
    });

    test('All DAOs are initialized', () async {
      final db = await AppDatabase.openEncrypted(testPassphrase);
      expect(db.profilesDao, isNotNull);
      expect(db.reminderDao, isNotNull);
      expect(db.medicationDao, isNotNull);
      expect(db.cycleDao, isNotNull);
      expect(db.gamificationDao, isNotNull);
      expect(db.appSettingsDao, isNotNull);
      await db.close();
    });
  });
}
