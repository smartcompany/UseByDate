import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:use_by_date/data/database.dart';
import 'package:use_by_date/l10n/app_localizations.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';

typedef NotificationTapCallback = void Function(int productId);

/// 백그라운드 알림 탭 핸들러 — top-level 함수이어야 함
@pragma('vm:entry-point')
void _handleBackgroundResponse(NotificationResponse response) {
  // 백그라운드에서 탭 처리는 별도 isolate이므로 여기서는 최소 처리
  debugPrint('[ExpiryNotificationService] background tap: ${response.payload}');
}

class ExpiryNotificationService {
  ExpiryNotificationService._();
  static final ExpiryNotificationService shared = ExpiryNotificationService._();

  static const _channelId = 'expiry_reminders';
  static const _channelName = 'Expiry reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _timeZoneReady = false;

  NotificationTapCallback? onTap;
  AppLocalizations? _l10n;

  Future<void> initialize({
    required AppLocalizations l10n,
    NotificationTapCallback? onTap,
  }) async {
    _l10n = l10n;
    this.onTap = onTap;

    if (!_timeZoneReady) {
      tz_data.initializeTimeZones();
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName.identifier));
      _timeZoneReady = true;
      debugPrint('[Notify] timezone initialized=${timezoneName.identifier}');
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    // iOS UNUserNotificationCenter delegate 등록 — 매 앱 기동 시 호출 필요
    final ok = await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse: _handleBackgroundResponse,
    );
    debugPrint('[Notify] initialize result=$ok');
  }

  void updateLocalizations(AppLocalizations l10n) {
    _l10n = l10n;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      debugPrint('[Notify] Android permission granted=$granted');
      if (granted != true) return false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[Notify] iOS permission granted=$granted');
      if (granted != true) return false;
    }
    return true;
  }

  /// 현재 OS에 예약된 알림 목록을 로그로 출력합니다.
  Future<void> logPendingNotifications({String reason = 'snapshot'}) async {
    final pending = await _plugin.pendingNotificationRequests();
    debugPrint('[Notify] pendingCount=${pending.length} reason=$reason');
    for (final n in pending) {
      debugPrint('[Notify] pending id=${n.id} title="${n.title}" body="${n.body}"');
    }
  }

  Future<int?> launchProductId() async {
    final launch = await _plugin.getNotificationAppLaunchDetails();
    debugPrint(
      '[Notify] launchDetails didLaunch=${launch?.didNotificationLaunchApp} '
      'payload=${launch?.notificationResponse?.payload}',
    );
    if (launch?.didNotificationLaunchApp != true) return null;
    return _parseProductId(launch?.notificationResponse?.payload);
  }

  Future<void> scheduleForProduct(
    Product product,
    ReminderSettings settings,
  ) async {
    await cancelForProduct(product.id);
    if (!product.notifyEnabled) {
      debugPrint('[Notify] id=${product.id} notifyEnabled=false, skipped');
      return;
    }

    final expiry = parseIsoDate(product.expiryDate);
    if (expiry == null) {
      debugPrint('[Notify] id=${product.id} expiryDate parse failed: "${product.expiryDate}"');
      return;
    }

    final fireDate = DateTime(
      expiry.year,
      expiry.month,
      expiry.day,
    ).subtract(Duration(days: settings.notifyDaysBefore));
    // 로컬 시간 기준으로 예약 (기기 시간대 변경 고려 불필요)
    final scheduled = tz.TZDateTime.from(
      DateTime(
        fireDate.year,
        fireDate.month,
        fireDate.day,
        settings.notifyHour,
        settings.notifyMinute,
      ),
      tz.local,
    );
    final now = tz.TZDateTime.now(tz.local);
    debugPrint('[Notify] id=${product.id} "${product.name}" '
        'expiry=${product.expiryDate} daysBefore=${settings.notifyDaysBefore} '
        'scheduled=$scheduled now=$now isPast=${scheduled.isBefore(now)}');
    if (scheduled.isBefore(now)) {
      debugPrint('[Notify] id=${product.id} scheduled is in the past → skipped');
      return;
    }

    final l10n = _l10n;
    if (l10n == null) {
      debugPrint('[Notify] l10n not set, skipped');
      return;
    }

    final body = settings.notifyDaysBefore == 0
        ? l10n.notificationBodyOnDay(product.name)
        : l10n.notificationBodyBefore(product.name, settings.notifyDaysBefore);

    try {
      await _plugin.zonedSchedule(
        id: product.id,
        title: l10n.notificationTitle,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: l10n.settingsNotificationsSubtitle,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBanner: true,
            presentList: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: product.id.toString(),
      );
      debugPrint('[Notify] id=${product.id} zonedSchedule OK at $scheduled');
      await logPendingNotifications(reason: 'after schedule ${product.id}');
    } catch (error, stackTrace) {
      debugPrint('[Notify] schedule failed: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> cancelForProduct(int productId) {
    return _plugin.cancel(id: productId);
  }

  Future<void> rescheduleAll(
    List<Product> products,
    ReminderSettings settings,
  ) async {
    await _plugin.cancelAll();
    for (final product in products) {
      await scheduleForProduct(product, settings);
    }
    await logPendingNotifications(reason: 'after rescheduleAll');
  }

  void _handleResponse(NotificationResponse response) {
    debugPrint(
      '[Notify] response type=${response.notificationResponseType} '
      'payload=${response.payload}',
    );
    final id = _parseProductId(response.payload);
    if (id == null) return;
    onTap?.call(id);
  }

  int? _parseProductId(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    return int.tryParse(payload);
  }
}
