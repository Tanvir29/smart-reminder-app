import 'package:alarm/alarm.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

class VoicePayload {
  final String slotName;
  final List<String> itemNames;
  final List<String?> customMessages;

  VoicePayload({
    required this.slotName,
    List<String>? itemNames,
    List<String?>? customMessages,
  })  : itemNames = itemNames ?? [],
        customMessages = customMessages ?? [];
}

class AlarmService implements AlarmPort {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  Function(int, DateTime)? onAlarmRing;

  Future<void> init() async {
    await Alarm.init();

    Alarm.ringing.listen((alarmSet) {
      for (final alarm in alarmSet.alarms) {
        if (onAlarmRing != null) {
          onAlarmRing!(alarm.id, alarm.dateTime);
        }
      }
    });
  }

  int _generateGroupedAlarmId(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 60000;
  }

  Future<bool> setAlarm({
    required int id,
    required DateTime dateTime,
    required String notificationTitle,
    required String notificationBody,
    VoicePayload? voicePayload,
  }) async {
    final alarmId =
        voicePayload != null ? _generateGroupedAlarmId(dateTime) : id;

    final existingAlarms = await Alarm.getAlarms();
    if (existingAlarms.any((a) => a.id == alarmId)) {
      return true;
    }

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarms/file_example_MP3_1MG.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 3),
      ),
      notificationSettings: NotificationSettings(
        title: notificationTitle,
        body: notificationBody,
        stopButton: 'Stop',
      ),
    );

    return await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<bool> stopAlarm(int id) async {
    return await Alarm.stop(id);
  }

  Future<List<AlarmSettings>> getAlarms() async {
    return Alarm.getAlarms();
  }

  Future<bool> isAlarmActive(int id) async {
    final alarms = await Alarm.getAlarms();
    return alarms.any((a) => a.id == id);
  }

  Future<void> stopAllAlarms() async {
    final alarms = await Alarm.getAlarms();
    for (final alarm in alarms) {
      await Alarm.stop(alarm.id);
    }
  }
}
