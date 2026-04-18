import 'package:alarm/alarm.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';

class AlarmService implements AlarmPort {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  static const int _escalationIdOffset = 2000000000;

  final Map<int, String> _escalationAlarmToReminderId = {};
  final Map<String, int> _reminderIdToEscalationAlarmId = {};

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

  int _escalationAlarmIdFor(String reminderId) {
    return (reminderId.hashCode.abs() % _escalationIdOffset) +
        _escalationIdOffset;
  }

  Future<bool> setAlarm({
    required int id,
    required DateTime dateTime,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    final existingAlarms = await Alarm.getAlarms();
    if (existingAlarms.any((a) => a.id == id)) {
      return true;
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarms/file_example_MP3_1MG.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 3),
      ),
      notificationSettings: NotificationSettings(
        title: '',
        body: '',
      ),
    );

    return await Alarm.set(alarmSettings: alarmSettings);
  }

  @override
  Future<bool> scheduleEscalationCheck(
    String reminderId,
    Duration delay,
  ) async {
    final alarmId = _escalationAlarmIdFor(reminderId);

    await cancelEscalationCheck(reminderId);

    final dateTime = DateTime.now().add(delay);

    _escalationAlarmToReminderId[alarmId] = reminderId;
    _reminderIdToEscalationAlarmId[reminderId] = alarmId;

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: dateTime,
      assetAudioPath: '',
      loopAudio: false,
      vibrate: false,
      volumeSettings: VolumeSettings.fixed(volume: 0.0),
      notificationSettings: NotificationSettings(
        title: 'Escalation Check',
        body: reminderId,
      ),
    );

    return await Alarm.set(alarmSettings: alarmSettings);
  }

  @override
  Future<void> cancelEscalationCheck(String reminderId) async {
    final existingAlarmId = _reminderIdToEscalationAlarmId[reminderId];
    if (existingAlarmId != null) {
      await Alarm.stop(existingAlarmId);
      _escalationAlarmToReminderId.remove(existingAlarmId);
      _reminderIdToEscalationAlarmId.remove(reminderId);
    }
  }

  @override
  String? getReminderIdForEscalationAlarm(int alarmId) {
    return _escalationAlarmToReminderId[alarmId];
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
    _escalationAlarmToReminderId.clear();
    _reminderIdToEscalationAlarmId.clear();
  }
}
