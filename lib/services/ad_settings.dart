import 'package:flutter/foundation.dart';
import 'package:share_lib/share_lib.dart';

import 'package:use_by_date/config/api_config.dart';
import 'package:use_by_date/services/api_settings_service.dart';
import 'package:use_by_date/services/photo_add_ad_gate.dart';

/// Loads AdMob unit IDs + photo-add ad interval from `/api/settings`.
abstract final class AdSettings {
  static var _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final baseUrl = await ApiSettingsService.shared.getApiBaseUrl();
      AdService.shared.setBaseUrl(
        baseUrl.isEmpty ? ApiConfig.photoApiBaseUrl : baseUrl,
      );
      await PhotoAddAdGate.ensureSettingsLoaded();
      debugPrint('[AdSettings] initialized');
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('Ad settings load error: $error');
      debugPrint('$stackTrace');
    }
  }
}
