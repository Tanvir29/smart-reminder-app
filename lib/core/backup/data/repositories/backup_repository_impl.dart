/// Concrete implementation of [BackupRepository].
///
/// MiniMax fills in: exportBackup (read all DAOs → JSON → encrypt → write file),
/// importBackup (read file → decrypt → validate → write all DAOs in transaction),
/// getLastBackupMetadata (read from AppSettings).
library;

import 'package:smart_reminder_app/core/backup/domain/entities/backup_metadata.dart';
import 'package:smart_reminder_app/core/backup/domain/repositories/backup_repository.dart';

/// Implements backup export/import using Drift DAOs and encrypted JSON.
class BackupRepositoryImpl implements BackupRepository {
  // TODO: MiniMax — inject AppDatabase, BackupEncryptionService

  @override
  Future<String> exportBackup() async {
    // TODO: MiniMax — implement
    throw UnimplementedError();
  }

  @override
  Future<BackupMetadata> importBackup(String filePath) async {
    // TODO: MiniMax — implement
    throw UnimplementedError();
  }

  @override
  Future<BackupMetadata?> getLastBackupMetadata() async {
    // TODO: MiniMax — implement
    return null;
  }
}
