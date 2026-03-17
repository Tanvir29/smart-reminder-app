import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }

  group('SQLCipher Encryption Proof', () {
    const correctKey = '32_char_very_secret_passphrase_!';
    const wrongKey = 'wrong_passphrase_00000000000000';

    testWidgets('Verify database is encrypted and rejects wrong key',
        (tester) async {
      final db1 = await AppDatabase.openEncrypted(correctKey);
      await db1.into(db1.profiles).insert(ProfilesCompanion.insert(
            id: 'user_1',
            name: 'Secure User',
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ));
      await db1.close();
      print('✅ Data written with correct key.');

      final db2 = await AppDatabase.openEncrypted(wrongKey);

      bool failedAsExpected = false;
      try {
        await db2.select(db2.profiles).get();
      } catch (e) {
        failedAsExpected = true;
        print('✅ Access Denied as expected. Error: $e');
      }

      expect(failedAsExpected, isTrue,
          reason: 'SECURITY FAILURE: Database opened with wrong key!');
      await db2.close();
    });
  });
}
