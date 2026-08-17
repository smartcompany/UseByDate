import 'package:shared_preferences/shared_preferences.dart';

/// Product-spec reminder defaults shown in Settings.
abstract final class ReminderSettingsSpec {
  static const notifyDaysBefore = 1;
  static const notifyHour = 9;
  static const notifyMinute = 0;
  static const notifyDaysChoices = [0, 1, 2, 3, 5, 7];
}

class ReminderSettings {
  const ReminderSettings({
    required this.notifyDaysBefore,
    required this.notifyHour,
    required this.notifyMinute,
    required this.saveCameraToAlbum,
  });

  final int notifyDaysBefore;
  final int notifyHour;
  final int notifyMinute;
  final bool saveCameraToAlbum;

  int get notifyTimeMinutes => notifyHour * 60 + notifyMinute;
}

class ReminderSettingsService {
  ReminderSettingsService._();
  static final ReminderSettingsService shared = ReminderSettingsService._();

  static const _daysKey = 'notify_days_before';
  static const _hourKey = 'notify_hour';
  static const _minuteKey = 'notify_minute';
  static const _albumKey = 'save_camera_to_device_album';

  Future<ReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSettings(
      notifyDaysBefore:
          prefs.getInt(_daysKey) ?? ReminderSettingsSpec.notifyDaysBefore,
      notifyHour: prefs.getInt(_hourKey) ?? ReminderSettingsSpec.notifyHour,
      notifyMinute:
          prefs.getInt(_minuteKey) ?? ReminderSettingsSpec.notifyMinute,
      saveCameraToAlbum: prefs.getBool(_albumKey) ?? false,
    );
  }

  Future<void> setNotifyDaysBefore(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_daysKey, days);
  }

  Future<void> setNotifyTime({required int hour, required int minute}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
  }
}
