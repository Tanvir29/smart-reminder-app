/// Use case: export all app data as an encrypted JSON backup.
///
/// MiniMax fills in: call() method that reads all DAOs, serializes
/// to JSON, encrypts via BackupEncryptionService, writes to temp file,
/// and triggers share_plus share sheet.
library;

/// Orchestrates a full encrypted backup export.
class ExportBackup {
  // TODO: MiniMax — inject BackupRepository

  /// Execute the export and return the backup file path.
  Future<String> call() async {
    // TODO: MiniMax — implement
    throw UnimplementedError();
  }
}
