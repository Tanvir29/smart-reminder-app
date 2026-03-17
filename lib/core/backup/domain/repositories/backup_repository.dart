/// Repository contract for backup export/import operations.
///
/// MiniMax fills in: exportBackup, importBackup, getLastBackupMetadata
/// method signatures with proper return types.
library;

import 'package:smart_reminder_app/core/backup/domain/entities/backup_metadata.dart';

/// Abstract interface for backup persistence operations.
abstract class BackupRepository {
  /// Export all app data to an encrypted JSON file.
  /// Returns the file path of the created backup.
  Future<String> exportBackup();

  /// Import app data from an encrypted JSON backup file.
  /// Returns metadata about the imported backup.
  Future<BackupMetadata> importBackup(String filePath);

  /// Retrieve metadata from the most recent backup, if any.
  Future<BackupMetadata?> getLastBackupMetadata();
}
