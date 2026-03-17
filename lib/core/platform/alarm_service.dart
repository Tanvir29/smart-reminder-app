import 'package:alarm/alarm.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  Function(int)? onAlarmRing;

  Future<void> init() async {
    await Alarm.init();

    Alarm.ringing.listen((alarmSet) {
      for (final alarm in alarmSet.alarms) {
        if (onAlarmRing != null) {
          onAlarmRing!(alarm.id);
        }
      }
    });
  }

  Future<bool> setAlarm({
    required int id,
    required DateTime dateTime,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarms/default.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
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
    return Alarm.hasAlarm();
  }
}
