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

class ExpiryNotificationService {
  ExpiryNotificationService._();
  static final ExpiryNotificationService shared = ExpiryNotificationService._();

  static const _channelId = 'expiry_reminders';
  static const _channelName = 'Expiry reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationTapCallback? onTap;
  AppLocalizations? _l10n;
  bool _initialized = false;

  Future<void> initialize({
    required AppLocalizations l10n,
    NotificationTapCallback? onTap,
  }) async {
    _l10n = l10n;
    this.onTap = onTap;
    if (_initialized) return;

    tz_data.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _handleResponse,
    );
    _initialized = true;
  }

  void updateLocalizations(AppLocalizations l10n) {
    _l10n = l10n;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
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
      if (granted != true) return false;
    }
    return true;
  }

  Future<int?> launchProductId() async {
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp != true) return null;
    return _parseProductId(launch?.notificationResponse?.payload);
  }

  Future<void> scheduleForProduct(
    Product product,
    ReminderSettings settings,
  ) async {
    await cancelForProduct(product.id);
    if (!product.notifyEnabled) return;

    final expiry = parseIsoDate(product.expiryDate);
    if (expiry == null) return;

    final fireDate = DateTime(
      expiry.year,
      expiry.month,
      expiry.day,
    ).subtract(Duration(days: settings.notifyDaysBefore));
    final scheduled = tz.TZDateTime(
      tz.local,
      fireDate.year,
      fireDate.month,
      fireDate.day,
      settings.notifyHour,
      settings.notifyMinute,
    );
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    final l10n = _l10n;
    if (l10n == null) return;

    final body = settings.notifyDaysBefore == 0
        ? l10n.notificationBodyOnDay(product.name)
        : l10n.notificationBodyBefore(product.name, settings.notifyDaysBefore);

    try {
      await _plugin.zonedSchedule(
        product.id,
        l10n.notificationTitle,
        body,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: l10n.settingsNotificationsSubtitle,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: product.id.toString(),
      );
    } catch (error, stackTrace) {
      debugPrint('[ExpiryNotificationService] schedule failed: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> cancelForProduct(int productId) {
    return _plugin.cancel(productId);
  }

  Future<void> rescheduleAll(
    List<Product> products,
    ReminderSettings settings,
  ) async {
    await _plugin.cancelAll();
    for (final product in products) {
      await scheduleForProduct(product, settings);
    }
  }

  void _handleResponse(NotificationResponse response) {
    final id = _parseProductId(response.payload);
    if (id == null) return;
    onTap?.call(id);
  }

  int? _parseProductId(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    return int.tryParse(payload);
  }
}
