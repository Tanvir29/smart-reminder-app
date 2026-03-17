/// Concrete implementation of [ReminderRepository] using Drift DAO.
///
/// MiniMax fills in: all method implementations using ReminderDao,
/// transactional writes, automatic reminder_logs insertion on status change.
library;

import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';

/// Drift-backed reminder repository.
class ReminderRepositoryImpl implements ReminderRepository {
  // TODO: MiniMax — inject ReminderDao

  @override
  Future<void> save(Reminder reminder) async {
    throw UnimplementedError();
  }

  @override
  Future<Reminder?> getById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Reminder>> getByStatus(ReminderStatus status) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Reminder>> getScheduledBefore(int timestampMillis) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(String id, ReminderStatus newStatus) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logEvent({
    required String reminderId,
    required String eventType,
    required int eventTimestamp,
    String? metadata,
  }) async {
    throw UnimplementedError();
  }
}
