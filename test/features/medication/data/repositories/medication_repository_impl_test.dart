import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/database/app_database.dart' as db;
import 'package:smart_reminder_app/core/database/daos/medication_dao.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/dose_query_port.dart';
import 'package:smart_reminder_app/features/medication/data/mappers/medication_mapper.dart';
import 'package:smart_reminder_app/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart'
    as dose;
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart'
    as med;

class MockMedicationDao extends Mock implements MedicationDao {}

class MockMedicationMapper extends Mock implements MedicationMapper {}

class FakeDbMedication extends Fake implements db.Medication {}

class FakeDbDoseRecord extends Fake implements db.DoseRecord {}

class FakeMedicationsCompanion extends Fake
    implements db.MedicationsCompanion {}

class FakeDoseRecordsCompanion extends Fake
    implements db.DoseRecordsCompanion {}

class FakeMedication extends Fake implements med.Medication {}

class FakeDoseRecord extends Fake implements dose.DoseRecord {}

void main() {
  late MockMedicationDao mockDao;
  late MockMedicationMapper mockMapper;
  late MedicationRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeDbMedication());
    registerFallbackValue(FakeDbDoseRecord());
    registerFallbackValue(FakeMedicationsCompanion());
    registerFallbackValue(FakeDoseRecordsCompanion());
    registerFallbackValue(FakeMedication());
    registerFallbackValue(FakeDoseRecord());
  });

  setUp(() {
    mockDao = MockMedicationDao();
    mockMapper = MockMedicationMapper();
    repository = MedicationRepositoryImpl(mockDao, mockMapper);
  });

  final now = DateTime.now().millisecondsSinceEpoch;

  med.Medication createTestMedication({String id = 'med-1'}) {
    return med.Medication(
      id: id,
      profileId: 'default',
      name: 'Aspirin',
      dosage: '100mg',
      frequency: med.MedicationFrequency.daily(timesOfDay: const [480]),
      createdAt: now,
      updatedAt: now,
    );
  }

  db.Medication createDbMedication(
      {String id = 'med-1', String name = 'Aspirin'}) {
    return db.Medication(
      id: id,
      profileId: 'default',
      name: name,
      dosage: '100mg',
      frequency: '{"type":"daily","timesOfDay":[480]}',
      reminderDuration: '{"type":"fixedDays","days":7}',
      isCritical: false,
      iconName: 'pill',
      colorHex: '#4CAF50',
      isActive: true,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'local',
      xpValue: 10,
    );
  }

  group('MedicationRepositoryImpl.save', () {
    test('inserts new medication when not in DB', () async {
      final entity = createTestMedication();
      final companion = db.MedicationsCompanion(
        id: Value('med-1'),
        name: Value('Aspirin'),
      );

      when(() => mockDao.getMedicationById('med-1'))
          .thenAnswer((_) async => null);
      when(() => mockMapper.toMedicationSchema(entity)).thenReturn(companion);
      when(() => mockDao.insertMedication(companion)).thenAnswer((_) async {});

      await repository.save(entity);

      verify(() => mockDao.insertMedication(companion)).called(1);
      verifyNever(() => mockDao.updateMedication(any()));
    });

    test('updates existing medication when already in DB', () async {
      final entity = createTestMedication();
      final dbMed = createDbMedication();

      when(() => mockDao.getMedicationById('med-1'))
          .thenAnswer((_) async => dbMed);
      when(() => mockMapper.toMedicationSchemaForUpdate(entity))
          .thenReturn(dbMed);
      when(() => mockDao.updateMedication(dbMed)).thenAnswer((_) async {});

      await repository.save(entity);

      verify(() => mockDao.updateMedication(dbMed)).called(1);
      verifyNever(() => mockDao.insertMedication(any()));
    });
  });

  group('MedicationRepositoryImpl.getById', () {
    test('returns null for non-existent medication', () async {
      when(() => mockDao.getMedicationById('missing'))
          .thenAnswer((_) async => null);

      final result = await repository.getById('missing');

      expect(result, isNull);
    });

    test('returns mapped entity for existing medication', () async {
      final dbMed = createDbMedication();
      final expected = createTestMedication();

      when(() => mockDao.getMedicationById('med-1'))
          .thenAnswer((_) async => dbMed);
      when(() => mockMapper.toMedicationEntity(dbMed)).thenReturn(expected);

      final result = await repository.getById('med-1');

      expect(result, equals(expected));
    });
  });

  group('MedicationRepositoryImpl.getActive', () {
    test('maps all active medications through mapper', () async {
      final dbMed1 = createDbMedication(id: 'med-1', name: 'A');
      final dbMed2 = createDbMedication(id: 'med-2', name: 'B');
      final entity1 = createTestMedication(id: 'med-1');
      final entity2 = createTestMedication(id: 'med-2');

      when(() => mockDao.getActiveMedications())
          .thenAnswer((_) async => [dbMed1, dbMed2]);
      when(() => mockMapper.toMedicationEntity(dbMed1)).thenReturn(entity1);
      when(() => mockMapper.toMedicationEntity(dbMed2)).thenReturn(entity2);

      final result = await repository.getActive();

      expect(result, hasLength(2));
      expect(result[0].id, equals('med-1'));
      expect(result[1].id, equals('med-2'));
    });
  });

  group('MedicationRepositoryImpl.archive', () {
    test('delegates to DAO', () async {
      when(() => mockDao.archiveMedication('med-1')).thenAnswer((_) async {});

      await repository.archive('med-1');

      verify(() => mockDao.archiveMedication('med-1')).called(1);
    });
  });

  group('MedicationRepositoryImpl DoseRecord operations', () {
    test('saveDoseRecord maps and delegates to DAO', () async {
      final entity = dose.DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: now,
        status: dose.DoseStatus.taken,
        createdAt: now,
        updatedAt: now,
      );
      final companion = db.DoseRecordsCompanion(id: Value('dose-1'));

      when(() => mockMapper.toDoseSchema(entity)).thenReturn(companion);
      when(() => mockDao.recordDose(companion)).thenAnswer((_) async {});

      await repository.saveDoseRecord(entity);

      verify(() => mockDao.recordDose(companion)).called(1);
    });

    test('updateDoseRecord maps via toDoseSchemaForUpdate', () async {
      final entity = dose.DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: now,
        status: dose.DoseStatus.taken,
        createdAt: now,
        updatedAt: now,
      );
      final dbRecord = db.DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: now,
        status: 'taken',
        createdAt: now,
        updatedAt: now,
        syncStatus: 'local',
        xpValue: 10,
      );

      when(() => mockMapper.toDoseSchemaForUpdate(entity)).thenReturn(dbRecord);
      when(() => mockDao.updateDoseRecord(dbRecord)).thenAnswer((_) async {});

      await repository.updateDoseRecord(entity);

      verify(() => mockDao.updateDoseRecord(dbRecord)).called(1);
    });

    test('getDoseRecordsByReminder delegates and maps', () async {
      final dbRecord = db.DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: now,
        status: 'taken',
        createdAt: now,
        updatedAt: now,
        syncStatus: 'local',
        xpValue: 10,
      );

      when(() => mockDao.getDoseRecordsByReminder('rem-1'))
          .thenAnswer((_) async => [dbRecord]);
      when(() => mockMapper.toDoseEntity(dbRecord)).thenReturn(
        dose.DoseRecord(
          id: 'dose-1',
          profileId: 'default',
          medicationId: 'med-1',
          scheduledTime: now,
          status: dose.DoseStatus.taken,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final result = await repository.getDoseRecordsByReminder('rem-1');

      expect(result, hasLength(1));
      expect(result.first.id, equals('dose-1'));
    });
  });

  group('MedicationRepositoryImpl DoseQueryPort', () {
    test('getDoseRecordsForReminder returns DoseQueryResult list', () async {
      final dbRecord = db.DoseRecord(
        id: 'dose-1',
        profileId: 'default',
        medicationId: 'med-1',
        scheduledTime: now,
        status: 'taken',
        createdAt: now,
        updatedAt: now,
        syncStatus: 'local',
        xpValue: 10,
      );

      when(() => mockDao.getDoseRecordsByReminder('rem-1'))
          .thenAnswer((_) async => [dbRecord]);

      final results = await (repository as DoseQueryPort)
          .getDoseRecordsForReminder('rem-1');

      expect(results, hasLength(1));
      expect(results.first.medicationId, equals('med-1'));
      expect(results.first.status, equals('taken'));
    });

    test('getMedicationInfoById returns MedicationInfo', () async {
      final dbMed = db.Medication(
        id: 'med-1',
        profileId: 'default',
        name: 'Prozac',
        dosage: '20mg',
        frequency: '{}',
        reminderDuration: '{}',
        reminderMessage: 'Take with food',
        isCritical: true,
        iconName: 'pill',
        colorHex: '#4CAF50',
        isActive: true,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'local',
        xpValue: 10,
      );

      when(() => mockDao.getMedicationById('med-1'))
          .thenAnswer((_) async => dbMed);

      final info =
          await (repository as DoseQueryPort).getMedicationInfoById('med-1');

      expect(info, isNotNull);
      expect(info!.name, equals('Prozac'));
      expect(info.reminderMessage, equals('Take with food'));
      expect(info.isCritical, isTrue);
    });

    test('getMedicationInfoById returns null for non-existent', () async {
      when(() => mockDao.getMedicationById('missing'))
          .thenAnswer((_) async => null);

      final info =
          await (repository as DoseQueryPort).getMedicationInfoById('missing');

      expect(info, isNull);
    });
  });
}
