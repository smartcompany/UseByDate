import 'package:shared_preferences/shared_preferences.dart';

import 'package:use_by_date/config/api_config.dart';

class ApiSettingsService {
  ApiSettingsService._();
  static final ApiSettingsService shared = ApiSettingsService._();

  static const _apiBaseUrlKey = 'photo_api_base_url';

  Future<String> getApiBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final override = prefs.getString(_apiBaseUrlKey)?.trim();
    if (override != null && override.isNotEmpty) {
      return override.replaceAll(RegExp(r'/$'), '');
    }
    return ApiConfig.photoApiBaseUrl.replaceAll(RegExp(r'/$'), '');
  }
}
