import 'package:shared_preferences/shared_preferences.dart';

/// Preference: also save camera captures into the system Photos / Gallery app.
abstract final class CameraAlbumSettings {
  static const _key = 'save_camera_to_device_album';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
