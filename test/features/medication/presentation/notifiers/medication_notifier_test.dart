import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/add_medication.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/record_dose.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/undo_dose.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockAddMedication extends Mock implements AddMedication {}

class MockRecordDose extends Mock implements RecordDose {}

class MockUndoDose extends Mock implements UndoDose {}

class FakeMedication extends Fake implements Medication {}

class FakeDoseRecord extends Fake implements DoseRecord {}

void main() {
  group('MedicationNotifier', () {
    late ProviderContainer container;
    late MockMedicationRepository mockRepository;
    late MockAddMedication mockAddMed;
    late MockRecordDose mockRecordDose;
    late MockUndoDose mockUndoDose;

    final now = DateTime.now().millisecondsSinceEpoch;

    Medication createTestMedication({
      String id = 'med-1',
      String name = 'Aspirin',
    }) {
      return Medication(
        id: id,
        profileId: 'default',
        name: name,
        dosage: '100mg',
        frequency: const MedicationFrequency.daily(timesOfDay: [480]),
        createdAt: now,
        updatedAt: now,
      );
    }

    DoseRecord createTestDoseRecord({
      String id = 'dose-1',
      String medicationId = 'med-1',
      DoseStatus status = DoseStatus.taken,
    }) {
      return DoseRecord(
        id: id,
        profileId: 'default',
        medicationId: medicationId,
        scheduledTime: now,
        status: status,
        createdAt: now,
        updatedAt: now,
      );
    }

    setUpAll(() {
      registerFallbackValue(FakeMedication());
      registerFallbackValue(FakeDoseRecord());
      registerFallbackValue(DoseStatus.taken);
    });

    setUp(() {
      mockRepository = MockMedicationRepository();
      mockAddMed = MockAddMedication();
      mockRecordDose = MockRecordDose();
      mockUndoDose = MockUndoDose();

      when(() => mockRepository.getActive()).thenAnswer((_) async => []);
      when(() => mockRepository.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          medicationRepositoryProvider.overrideWithValue(mockRepository),
          addMedicationProvider.overrideWithValue(mockAddMed),
          recordDoseProvider.overrideWithValue(mockRecordDose),
          undoDoseProvider.overrideWithValue(mockUndoDose),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> initializeNotifier() async {
      container.read(medicationNotifierProvider);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    test('build loads active medications and dose records', () async {
      final med1 = createTestMedication(id: 'med-1');
      final med2 = createTestMedication(id: 'med-2');
      final dose = createTestDoseRecord(id: 'dose-1', medicationId: 'med-1');

      when(() => mockRepository.getActive())
          .thenAnswer((_) async => [med1, med2]);
      when(() => mockRepository.getDoseRecordsInRange('med-1', any(), any()))
          .thenAnswer((_) async => [dose]);
      when(() => mockRepository.getDoseRecordsInRange('med-2', any(), any()))
          .thenAnswer((_) async => []);

      container.read(medicationNotifierProvider);
      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(medicationNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.medications, hasLength(2));
      expect(state.todaysDoses, hasLength(1));
      expect(state.todaysDoses.first.id, equals('dose-1'));
    });

    test('build returns empty state when no medications', () async {
      await initializeNotifier();

      final state = container.read(medicationNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.medications, isEmpty);
      expect(state.todaysDoses, isEmpty);
      expect(state.weeklyDoses, isEmpty);
    });

    test('addMedication delegates to AddMedication use case', () async {
      await initializeNotifier();

      final med = createTestMedication();
      when(() => mockAddMed.call(med)).thenAnswer((_) async => med);

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.addMedication(med);

      verify(() => mockAddMed.call(med)).called(1);
    });

    test('addMedication appends saved medication to state', () async {
      await initializeNotifier();

      final med = createTestMedication();
      when(() => mockAddMed.call(med)).thenAnswer((_) async => med);

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.addMedication(med);

      final state = container.read(medicationNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.medications, hasLength(1));
      expect(state.medications.first.id, equals('med-1'));
    });

    test('addMedication sets error state on use case failure', () async {
      await initializeNotifier();

      final med = createTestMedication();
      when(() => mockAddMed.call(med)).thenThrow(Exception('Save failed'));

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.addMedication(med);

      expect(container.read(medicationNotifierProvider).hasError, isTrue);
    });

    test('takeDose delegates to RecordDose with correct parameters', () async {
      await initializeNotifier();

      final dose = createTestDoseRecord();
      when(() => mockRecordDose.call(
            medicationId: 'med-1',
            reminderId: 'rem-1',
            status: DoseStatus.taken,
          )).thenAnswer((_) async => dose);

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.takeDose(medicationId: 'med-1', reminderId: 'rem-1');

      verify(() => mockRecordDose.call(
            medicationId: 'med-1',
            reminderId: 'rem-1',
            status: DoseStatus.taken,
          )).called(1);
    });

    test('takeDose returns recorded dose and updates state', () async {
      await initializeNotifier();

      final dose = createTestDoseRecord();
      when(() => mockRecordDose.call(
            medicationId: any(named: 'medicationId'),
            reminderId: any(named: 'reminderId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => dose);

      final notifier = container.read(medicationNotifierProvider.notifier);
      final result =
          await notifier.takeDose(medicationId: 'med-1', reminderId: 'rem-1');

      expect(result, equals(dose));

      final state = container.read(medicationNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.todaysDoses, contains(dose));
      expect(state.lastRecordedDose, equals(dose));
    });

    test('undoLastDose delegates to UndoDose and clears state', () async {
      await initializeNotifier();

      final dose = createTestDoseRecord();
      when(() => mockRecordDose.call(
            medicationId: any(named: 'medicationId'),
            reminderId: any(named: 'reminderId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => dose);
      when(() => mockUndoDose.call(any())).thenAnswer((_) async {});

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.takeDose(medicationId: 'med-1');
      await notifier.undoLastDose();

      verify(() => mockUndoDose.call(any())).called(1);

      final state = container.read(medicationNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.todaysDoses.where((d) => d.id == 'dose-1'), isEmpty);
      expect(state.lastRecordedDose, isNull);
    });

    test('undoLastDose does nothing when no lastRecordedDose', () async {
      await initializeNotifier();

      final notifier = container.read(medicationNotifierProvider.notifier);
      await notifier.undoLastDose();

      verifyNever(() => mockUndoDose.call(any()));
    });
  });
}
