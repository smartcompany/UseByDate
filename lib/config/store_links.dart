import 'package:use_by_date/config/api_config.dart';

/// App store listing URLs and the shared applink on the API host.
abstract final class StoreLinks {
  static const androidPackageId = 'com.smartcompany.useByDate';

  static const iosAppStoreId = '6802597559';

  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  static String get appStoreUrl =>
      iosAppStoreId.isEmpty
          ? ''
          : 'https://apps.apple.com/app/id$iosAppStoreId';

  /// UA-aware store redirect (`/applink`). Prefer this when sharing the app.
  static String get applinkUrl {
    final base = ApiConfig.photoApiBaseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$base/applink';
  }

  static String shareUrls() => applinkUrl;
}
