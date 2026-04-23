import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_adherence_stats.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepo;
  late GetAdherenceStats useCase;

  setUp(() {
    mockRepo = MockMedicationRepository();
    useCase = GetAdherenceStats(repository: mockRepo);
  });

  final now = DateTime.now();
  final nowMs = now.millisecondsSinceEpoch;

  Medication createMed({String id = 'med-1'}) {
    return Medication(
      id: id,
      profileId: 'default',
      name: 'Test Med',
      dosage: '10mg',
      frequency: MedicationFrequency.daily(timesOfDay: const [480]),
      createdAt: nowMs,
      updatedAt: nowMs,
    );
  }

  DoseRecord createDose({
    String id = 'dose-1',
    String medicationId = 'med-1',
    required DoseStatus status,
    int? actualTime,
    int? scheduledTime,
  }) {
    return DoseRecord(
      id: id,
      profileId: 'default',
      medicationId: medicationId,
      scheduledTime: scheduledTime ??
          DateTime(now.year, now.month, now.day, 8).millisecondsSinceEpoch,
      actualTime: actualTime,
      status: status,
      createdAt: nowMs,
      updatedAt: nowMs,
    );
  }

  group('GetAdherenceStats', () {
    test('returns empty stats when no medications', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => []);

      final result = await useCase.call(days: 7);

      expect(result.takenCount, equals(0));
      expect(result.missedCount, equals(0));
      expect(result.totalCount, equals(0));
      expect(result.adherencePercent, equals(1.0));
      expect(result.currentStreakDays, equals(0));
      expect(result.longestStreakDays, equals(0));
    });

    test('computes correct counts for mixed doses', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(id: 'd1', status: DoseStatus.taken),
                createDose(id: 'd2', status: DoseStatus.taken),
                createDose(id: 'd3', status: DoseStatus.missed),
                createDose(id: 'd4', status: DoseStatus.skipped),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.takenCount, equals(2));
      expect(result.missedCount, equals(1));
      expect(result.skippedCount, equals(1));
      expect(result.totalCount, equals(4));
      expect(result.adherencePercent, closeTo(2 / 4, 0.001));
    });

    test('returns 0% adherence when all doses are skipped', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(id: 'd1', status: DoseStatus.skipped),
                createDose(id: 'd2', status: DoseStatus.skipped),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.adherencePercent, equals(0.0));
    });

    test('returns 100% adherence when all doses are taken', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(id: 'd1', status: DoseStatus.taken),
                createDose(id: 'd2', status: DoseStatus.taken),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.adherencePercent, equals(1.0));
    });
  });

  group('Streak computation (36h gap-based)', () {
    test('streak is 0 when no doses taken', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(id: 'd1', status: DoseStatus.missed),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.currentStreakDays, equals(0));
      expect(result.longestStreakDays, equals(0));
    });

    test('single taken dose gives streak of 1', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(
                  id: 'd1',
                  status: DoseStatus.taken,
                  actualTime: nowMs,
                ),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.currentStreakDays, equals(1));
      expect(result.longestStreakDays, equals(1));
    });

    test('consecutive doses within 36h continue the streak', () async {
      final time1 = nowMs - 24 * 60 * 60 * 1000;
      final time2 = nowMs;

      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(
                  id: 'd1',
                  status: DoseStatus.taken,
                  actualTime: time1,
                ),
                createDose(
                  id: 'd2',
                  status: DoseStatus.taken,
                  actualTime: time2,
                ),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.currentStreakDays, equals(2));
      expect(result.longestStreakDays, equals(2));
    });

    test('gap > 36h between taken doses breaks the streak', () async {
      final time1 = nowMs - 48 * 60 * 60 * 1000;
      final time2 = nowMs;

      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(
                  id: 'd1',
                  status: DoseStatus.taken,
                  actualTime: time1,
                ),
                createDose(
                  id: 'd2',
                  status: DoseStatus.taken,
                  actualTime: time2,
                ),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.currentStreakDays, equals(1));
      expect(result.longestStreakDays, equals(1));
    });

    test('skipped doses do not break or extend the streak', () async {
      final time1 = nowMs - 24 * 60 * 60 * 1000;
      final time2 = nowMs;

      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(
                  id: 'd1',
                  status: DoseStatus.taken,
                  actualTime: time1,
                ),
                createDose(
                  id: 'd2',
                  status: DoseStatus.skipped,
                ),
                createDose(
                  id: 'd3',
                  status: DoseStatus.taken,
                  actualTime: time2,
                ),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.currentStreakDays, equals(2));
      expect(result.longestStreakDays, equals(2));
    });

    test('longest streak tracks peak across breaks', () async {
      when(() => mockRepo.getActive()).thenAnswer((_) async => [createMed()]);
      when(() => mockRepo.getDoseRecordsInRange(any(), any(), any()))
          .thenAnswer((_) async => [
                createDose(
                  id: 'd1',
                  status: DoseStatus.taken,
                  actualTime: nowMs - 100 * 60 * 60 * 1000,
                ),
                createDose(
                  id: 'd2',
                  status: DoseStatus.taken,
                  actualTime: nowMs - 76 * 60 * 60 * 1000,
                ),
                createDose(
                  id: 'd3',
                  status: DoseStatus.taken,
                  actualTime: nowMs - 52 * 60 * 60 * 1000,
                ),
                createDose(
                  id: 'd4',
                  status: DoseStatus.taken,
                  actualTime: nowMs - 10 * 60 * 60 * 1000,
                ),
                createDose(
                  id: 'd5',
                  status: DoseStatus.taken,
                  actualTime: nowMs,
                ),
              ]);

      final result = await useCase.call(days: 7);

      expect(result.longestStreakDays, equals(3));
      expect(result.currentStreakDays, equals(2));
    });
  });
}
