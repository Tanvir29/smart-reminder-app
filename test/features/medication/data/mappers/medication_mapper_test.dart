import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/data/mappers/medication_mapper.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart'
    as dose;
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart'
    as med;
import 'package:smart_reminder_app/core/database/app_database.dart' as db;

void main() {
  late MedicationMapper mapper;

  setUp(() {
    mapper = MedicationMapper();
  });

  final now = DateTime.now().millisecondsSinceEpoch;

  db.Medication createTestDbMedication({
    String id = 'med-1',
    String profileId = 'default',
    String name = 'Aspirin',
    String dosage = '100mg',
    String frequency = '{"timesOfDay":[480,1200],"runtimeType":"daily"}',
    String? instructions = 'Take with water',
    String? reminderMessage,
    String reminderDuration = '{"days":7,"runtimeType":"fixedDays"}',
    bool isCritical = false,
    String iconName = 'pill',
    String colorHex = '#4CAF50',
    bool isActive = true,
    int? archivedAt,
  }) {
    return db.Medication(
      id: id,
      profileId: profileId,
      name: name,
      dosage: dosage,
      frequency: frequency,
      instructions: instructions,
      reminderMessage: reminderMessage,
      reminderDuration: reminderDuration,
      isCritical: isCritical,
      iconName: iconName,
      colorHex: colorHex,
      isActive: isActive,
      createdAt: now,
      updatedAt: now,
      archivedAt: archivedAt,
      syncStatus: 'local',
      xpValue: 10,
    );
  }

  db.DoseRecord createTestDbDoseRecord({
    String id = 'dose-1',
    String profileId = 'default',
    String medicationId = 'med-1',
    int scheduledTime = 1700000000000,
    int? actualTime,
    String status = 'taken',
    String? reminderId,
    String? notes,
  }) {
    return db.DoseRecord(
      id: id,
      profileId: profileId,
      medicationId: medicationId,
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      status: status,
      reminderId: reminderId,
      notes: notes,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'local',
      xpValue: 10,
    );
  }

  group('MedicationMapper.toMedicationEntity', () {
    test('maps all scalar fields', () {
      final schema = createTestDbMedication();

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.id, equals('med-1'));
      expect(entity.profileId, equals('default'));
      expect(entity.name, equals('Aspirin'));
      expect(entity.dosage, equals('100mg'));
      expect(entity.instructions, equals('Take with water'));
      expect(entity.isCritical, isFalse);
      expect(entity.iconName, equals('pill'));
      expect(entity.colorHex, equals('#4CAF50'));
      expect(entity.isActive, isTrue);
      expect(entity.syncStatus, equals('local'));
      expect(entity.xpValue, equals(10));
    });

    test('deserializes DailyFrequency from JSON', () {
      final schema = createTestDbMedication(
          frequency: '{"timesOfDay":[480,1200],"runtimeType":"daily"}');

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.frequency, isA<med.DailyFrequency>());
      final daily = entity.frequency as med.DailyFrequency;
      expect(daily.timesOfDay, equals([480, 1200]));
    });

    test('deserializes WeeklyFrequency from JSON', () {
      final schema = createTestDbMedication(
        frequency:
            '{"timesOfDay":[480],"weekDays":[1,3,5],"runtimeType":"weekly"}',
      );

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.frequency, isA<med.WeeklyFrequency>());
      final weekly = entity.frequency as med.WeeklyFrequency;
      expect(weekly.timesOfDay, equals([480]));
      expect(weekly.weekDays, equals([1, 3, 5]));
    });

    test('deserializes IntervalFrequency from JSON', () {
      final schema = createTestDbMedication(
          frequency: '{"intervalHours":8,"runtimeType":"interval"}');

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.frequency, isA<med.IntervalFrequency>());
      final interval = entity.frequency as med.IntervalFrequency;
      expect(interval.intervalHours, equals(8));
    });

    test('deserializes OneTimeFrequency from JSON', () {
      final schema = createTestDbMedication(
        frequency: '{"scheduledTimeMinutes":480,"runtimeType":"oneTime"}',
      );

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.frequency, isA<med.OneTimeFrequency>());
      final oneTime = entity.frequency as med.OneTimeFrequency;
      expect(oneTime.scheduledTimeMinutes, equals(480));
    });

    test('deserializes ReminderDuration fixedDays', () {
      final schema = createTestDbMedication(
          reminderDuration: '{"days":14,"runtimeType":"fixedDays"}');

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.reminderDuration, isA<med.FixedDaysDuration>());
      final dur = entity.reminderDuration as med.FixedDaysDuration;
      expect(dur.days, equals(14));
    });

    test('deserializes ReminderDuration oneMonth', () {
      final schema = createTestDbMedication(
          reminderDuration: '{"runtimeType":"oneMonth"}');

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.reminderDuration, isA<med.OneMonthDuration>());
    });

    test('deserializes ReminderDuration continuous', () {
      final schema = createTestDbMedication(
          reminderDuration: '{"runtimeType":"continuous"}');

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.reminderDuration, isA<med.ContinuousDuration>());
    });

    test('deserializes ReminderDuration custom', () {
      final schema = createTestDbMedication(
        reminderDuration: '{"endTime":1700000000000,"runtimeType":"custom"}',
      );

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.reminderDuration, isA<med.CustomDuration>());
      final custom = entity.reminderDuration as med.CustomDuration;
      expect(custom.endTime, equals(1700000000000));
    });

    test('handles nullable fields as null', () {
      final schema = createTestDbMedication(
        instructions: null,
        reminderMessage: null,
        archivedAt: null,
      );

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.instructions, isNull);
      expect(entity.reminderMessage, isNull);
      expect(entity.archivedAt, isNull);
    });

    test('handles nullable fields with values', () {
      final schema = createTestDbMedication(
        reminderMessage: 'Take with food',
        archivedAt: 1700000000000,
      );

      final entity = mapper.toMedicationEntity(schema);

      expect(entity.reminderMessage, equals('Take with food'));
      expect(entity.archivedAt, equals(1700000000000));
    });
  });

  group('MedicationMapper.toMedicationSchemaForUpdate', () {
    test('produces data class with all entity fields', () {
      final entity = med.Medication(
        id: 'med-1',
        profileId: 'default',
        name: 'Aspirin',
        dosage: '100mg',
        frequency: med.MedicationFrequency.daily(timesOfDay: const [480]),
        instructions: 'Take with water',
        reminderDuration: const med.ReminderDuration.fixedDays(days: 7),
        createdAt: now,
        updatedAt: now,
      );

      final schema = mapper.toMedicationSchemaForUpdate(entity);

      expect(schema.id, equals('med-1'));
      expect(schema.name, equals('Aspirin'));
      expect(schema.dosage, equals('100mg'));
      expect(schema.instructions, equals('Take with water'));
    });

    test('serializes frequency as valid JSON', () {
      final entity = med.Medication(
        id: 'med-1',
        profileId: 'default',
        name: 'Test',
        dosage: '50mg',
        frequency: med.MedicationFrequency.daily(timesOfDay: const [480]),
        createdAt: now,
        updatedAt: now,
      );

      final schema = mapper.toMedicationSchemaForUpdate(entity);

      final json = jsonDecode(schema.frequency) as Map<String, dynamic>;
      expect(json['runtimeType'], equals('daily'));
      expect(json['timesOfDay'], equals([480]));
    });

    test('serializes reminderDuration as valid JSON', () {
      final entity = med.Medication(
        id: 'med-1',
        profileId: 'default',
        name: 'Test',
        dosage: '50mg',
        frequency: med.MedicationFrequency.daily(timesOfDay: const [480]),
        reminderDuration: const med.ReminderDuration.fixedDays(days: 14),
        createdAt: now,
        updatedAt: now,
      );

      final schema = mapper.toMedicationSchemaForUpdate(entity);

      final json = jsonDecode(schema.reminderDuration) as Map<String, dynamic>;
      expect(json['runtimeType'], equals('fixedDays'));
      expect(json['days'], equals(14));
    });
  });

  group('MedicationMapper.toDoseEntity', () {
    test('maps DoseStatus from string for all valid statuses', () {
      for (final status in dose.DoseStatus.values) {
        final schema = createTestDbDoseRecord(status: status.name);
        final entity = mapper.toDoseEntity(schema);
        expect(entity.status, equals(status));
      }
    });

    test('defaults to missed for unknown status string', () {
      final schema = createTestDbDoseRecord(status: 'invalid_status');

      final entity = mapper.toDoseEntity(schema);

      expect(entity.status, equals(dose.DoseStatus.missed));
    });

    test('maps all scalar fields', () {
      final schema = createTestDbDoseRecord(
        actualTime: now,
        reminderId: 'rem-1',
        notes: 'Taken with food',
      );

      final entity = mapper.toDoseEntity(schema);

      expect(entity.id, equals('dose-1'));
      expect(entity.medicationId, equals('med-1'));
      expect(entity.scheduledTime, equals(1700000000000));
      expect(entity.actualTime, equals(now));
      expect(entity.reminderId, equals('rem-1'));
      expect(entity.notes, equals('Taken with food'));
    });
  });

  group('MedicationMapper round-trip', () {
    test('frequency survives entity → schema → entity round-trip', () {
      final original = med.Medication(
        id: 'med-rt',
        profileId: 'default',
        name: 'RoundTrip',
        dosage: '200mg',
        frequency: med.MedicationFrequency.weekly(
          timesOfDay: const [480, 1200],
          weekDays: const [1, 3, 5],
        ),
        reminderDuration:
            const med.ReminderDuration.custom(endTime: 1700000000000),
        createdAt: now,
        updatedAt: now,
      );

      final schema = mapper.toMedicationSchemaForUpdate(original);
      final dbMed = db.Medication(
        id: schema.id,
        profileId: schema.profileId,
        name: schema.name,
        dosage: schema.dosage,
        frequency: schema.frequency,
        instructions: schema.instructions,
        reminderMessage: schema.reminderMessage,
        reminderDuration: schema.reminderDuration,
        isCritical: schema.isCritical,
        iconName: schema.iconName,
        colorHex: schema.colorHex,
        isActive: schema.isActive,
        createdAt: schema.createdAt,
        updatedAt: schema.updatedAt,
        archivedAt: schema.archivedAt,
        syncStatus: schema.syncStatus,
        xpValue: schema.xpValue,
      );
      final roundTripped = mapper.toMedicationEntity(dbMed);

      expect(roundTripped.frequency, isA<med.WeeklyFrequency>());
      final weekly = roundTripped.frequency as med.WeeklyFrequency;
      expect(weekly.timesOfDay, equals([480, 1200]));
      expect(weekly.weekDays, equals([1, 3, 5]));

      expect(roundTripped.reminderDuration, isA<med.CustomDuration>());
      final custom = roundTripped.reminderDuration as med.CustomDuration;
      expect(custom.endTime, equals(1700000000000));
    });
  });
}
