import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setCompletionHandler(() {});
    _tts.setErrorHandler((message) {});

    _isInitialized = true;
  }

  Future<void> speakAnnouncement({
    required String slotName,
    List<String>? itemNames,
    List<String?>? customMessages,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    final items = itemNames ?? [];
    final messages = customMessages ?? [];

    if (items.isEmpty && messages.isEmpty) {
      return;
    }

    final buffer = StringBuffer();
    buffer.write('Attention: It is time for $slotName. ');

    if (items.isNotEmpty) {
      buffer.write('Please take ');

      if (items.length == 1) {
        buffer.write(items.first);
      } else if (items.length == 2) {
        buffer.write('${items[0]} and ${items[1]}');
      } else {
        for (int i = 0; i < items.length - 1; i++) {
          buffer.write('${items[i]}, ');
        }
        buffer.write('and ${items.last}');
      }
      buffer.write('.');
    }

    if (messages.isNotEmpty) {
      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i];
        if (msg != null && msg.isNotEmpty) {
            buffer.write(' $msg');
          }
        }
      }
    }

    await _tts.speak(buffer.toString());
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }
}
