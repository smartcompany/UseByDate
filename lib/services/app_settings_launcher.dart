import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Opens this app's page in system Settings (permissions, etc.).
abstract final class AppSettingsLauncher {
  static Future<void> openAppSettings() async {
    try {
      final opened = await ph.openAppSettings();
      if (!opened) {
        debugPrint('[AppSettingsLauncher] openAppSettings returned false');
      }
    } catch (error, stackTrace) {
      debugPrint('[AppSettingsLauncher] open failed: $error');
      debugPrint('$stackTrace');
    }
  }
}
