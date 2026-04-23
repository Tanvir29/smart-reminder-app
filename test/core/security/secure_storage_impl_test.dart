import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/security/data/secure_storage_impl.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorageImpl', () {
    late MockFlutterSecureStorage mockStorage;
    late SecureStorageImpl secureStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      secureStorage = SecureStorageImpl(storage: mockStorage);
    });

    test('read delegates to FlutterSecureStorage', () async {
      when(() => mockStorage.read(key: 'db_passphrase'))
          .thenAnswer((_) async => 'secret_value');

      final result = await secureStorage.read('db_passphrase');

      expect(result, equals('secret_value'));
      verify(() => mockStorage.read(key: 'db_passphrase')).called(1);
    });

    test('read returns null when key not found', () async {
      when(() => mockStorage.read(key: 'missing_key'))
          .thenAnswer((_) async => null);

      final result = await secureStorage.read('missing_key');

      expect(result, isNull);
    });

    test('write delegates to FlutterSecureStorage', () async {
      when(() => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});

      await secureStorage.write('db_passphrase', 'new_secret');

      verify(() => mockStorage.write(key: 'db_passphrase', value: 'new_secret'))
          .called(1);
    });

    test('delete delegates to FlutterSecureStorage', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await secureStorage.delete('db_passphrase');

      verify(() => mockStorage.delete(key: 'db_passphrase')).called(1);
    });

    test('containsKey delegates to FlutterSecureStorage', () async {
      when(() => mockStorage.containsKey(key: 'db_passphrase'))
          .thenAnswer((_) async => true);

      final result = await secureStorage.containsKey('db_passphrase');

      expect(result, isTrue);
      verify(() => mockStorage.containsKey(key: 'db_passphrase')).called(1);
    });

    test('containsKey returns false when key absent', () async {
      when(() => mockStorage.containsKey(key: 'missing'))
          .thenAnswer((_) async => false);

      final result = await secureStorage.containsKey('missing');

      expect(result, isFalse);
    });

    test('deleteAll delegates to FlutterSecureStorage', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      await secureStorage.deleteAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}
