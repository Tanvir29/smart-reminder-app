/// Service for encrypting and decrypting backup JSON payloads.
///
/// MiniMax fills in: encrypt/decrypt methods using a key derived
/// from flutter_secure_storage, AES-256-GCM or similar.
library;

/// Handles symmetric encryption/decryption of backup data.
class BackupEncryptionService {
  // TODO: MiniMax — inject FlutterSecureStorage for key management

  /// Encrypt a plaintext JSON string and return the ciphertext bytes.
  Future<List<int>> encrypt(String plaintext) async {
    // TODO: MiniMax — implement AES encryption
    throw UnimplementedError();
  }

  /// Decrypt ciphertext bytes and return the plaintext JSON string.
  Future<String> decrypt(List<int> ciphertext) async {
    // TODO: MiniMax — implement AES decryption
    throw UnimplementedError();
  }
}
