/// Port for TTS voice announcements.
///
/// Implemented by VoiceService in the platform layer.
/// This abstraction allows domain use cases to depend on a contract
/// rather than the concrete VoiceService implementation.
abstract class VoicePort {
  /// Speaks a medication announcement via TTS.
  ///
  /// [slotName] - the time slot name (e.g., "Morning", "Evening")
  /// [itemNames] - list of medication names to announce
  /// [customMessages] - optional custom reminder messages for each medication
  Future<void> speakAnnouncement({
    required String slotName,
    List<String>? itemNames,
    List<String?>? customMessages,
  });

  /// Stops any currently playing TTS audio.
  Future<void> stop();
}