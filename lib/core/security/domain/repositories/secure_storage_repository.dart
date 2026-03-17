/// Abstract interface for secure key-value storage.
///
/// v2: Backed by [flutter_secure_storage], replaces custom KeystoreChannel.
/// MiniMax fills in: method signatures for read/write/delete/hasKey.
library;

/// Contract for secure storage operations.
abstract class SecureStorageRepository {
  /// Read a value by key. Returns null if not found.
  Future<String?> read(String key);

  /// Write a key-value pair.
  Future<void> write(String key, String value);

  /// Delete a key.
  Future<void> delete(String key);

  /// Check if a key exists.
  Future<bool> containsKey(String key);

  /// Delete all stored values.
  Future<void> deleteAll();
}
