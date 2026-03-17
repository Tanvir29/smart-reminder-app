/// Metadata entity for encrypted backup files.
///
/// MiniMax fills in: fields (appVersion, createdAt, profileCount,
/// tableCounts map, checksum), fromJson/toJson, validation.
library;

/// Describes the contents and provenance of a backup archive.
class BackupMetadata {
  // TODO: MiniMax — add fields: appVersion, createdAt, profileCount,
  //   tableCounts (Map<String, int>), checksum (String)
  const BackupMetadata();
}
