import 'package:smart_reminder_app/core/database/daos/reminder_dao.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderDao _dao;
  final ReminderMapper _mapper;

  ReminderRepositoryImpl({
    required ReminderDao dao,
    required ReminderMapper mapper,
  })  : _dao = dao,
        _mapper = mapper;

  @override
  Future<void> save(Reminder reminder) async {
    final schema = _mapper.toSchema(reminder);
    await _dao.upsertReminder(schema);
  }

  @override
  Future<Reminder?> getById(String id) async {
    final schema = await _dao.getReminderById(id);
    if (schema == null) return null;
    return _mapper.toEntity(schema);
  }

  @override
  Future<List<Reminder>> getByStatus(ReminderStatus status) async {
    final schemas = await _dao.getRemindersByStatus(status.name);
    return schemas.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<Reminder>> getScheduledBefore(int timestampMillis) async {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final schemas = await _dao.getScheduledRemindersBefore(dateTime);
    return schemas.map(_mapper.toEntity).toList();
  }

  @override
  Future<void> updateStatus(String id, ReminderStatus newStatus) async {
    final existing = await _dao.getReminderById(id);
    if (existing == null) return;

    final entity = _mapper.toEntity(existing);
    final updatedEntity = entity.copyWith(
      status: newStatus,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final updatedSchema = _mapper.toSchemaForUpdate(updatedEntity);
    await _dao.updateReminder(updatedSchema);
  }

  @override
  Future<void> logEvent({
    required String reminderId,
    required String eventType,
    required int eventTimestamp,
    String? metadata,
  }) async {
    final log = _mapper.toLogCompanion(
      reminderId: reminderId,
      eventType: eventType,
      eventTimestamp: eventTimestamp,
      metadata: metadata,
    );
    await _dao.logReminderEvent(log);
  }
}
