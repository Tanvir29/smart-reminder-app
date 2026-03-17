/// Abstract repository for insights persistence and generation.
///
/// MiniMax fills in: getRecent, getByType, generate, dismiss, markRead.
library;

import 'package:smart_reminder_app/features/insights/domain/entities/insight.dart';

/// Contract for insight data operations.
abstract class InsightsRepository {
  Future<List<Insight>> getRecent({int limit = 10});
  Future<List<Insight>> getByType(String type);
  Future<void> generate();
  Future<void> dismiss(String id);
  Future<void> markRead(String id);
}
