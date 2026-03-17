/// Use case: import app data from an encrypted JSON backup.
///
/// MiniMax fills in: call() method that picks file via file_picker,
/// decrypts via BackupEncryptionService, validates structure,
/// and writes rows to all DAOs inside a transaction.
library;

import 'package:smart_reminder_app/core/backup/domain/entities/backup_metadata.dart';

/// Orchestrates a full encrypted backup import.
class ImportBackup {
  // TODO: MiniMax — inject BackupRepository

  /// Execute the import from the given file path.
  /// Returns metadata describing what was imported.
  Future<BackupMetadata> call(String filePath) async {
    // TODO: MiniMax — implement
    throw UnimplementedError();
  }
}
