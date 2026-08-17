import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:use_by_date/l10n/app_localizations.dart';
import 'package:use_by_date/screens/home_screen.dart';
import 'package:use_by_date/screens/product_detail_screen.dart';
import 'package:use_by_date/services/ad_settings.dart';
import 'package:use_by_date/services/expiry_notification_service.dart';
import 'package:use_by_date/theme/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await MobileAds.instance.initialize();
    } catch (e, st) {
      debugPrint('MobileAds init error: $e\n$st');
    }
  }

  await AdSettings.initialize();

  runApp(const ProviderScope(child: UseByDateApp()));
}

class UseByDateApp extends StatefulWidget {
  const UseByDateApp({super.key});

  @override
  State<UseByDateApp> createState() => _UseByDateAppState();
}

class _UseByDateAppState extends State<UseByDateApp> {
  bool _didInitNotifications = false;

  Future<void> _initNotifications(AppLocalizations l10n) async {
    if (_didInitNotifications) {
      ExpiryNotificationService.shared.updateLocalizations(l10n);
      return;
    }
    _didInitNotifications = true;
    await ExpiryNotificationService.shared.initialize(
      l10n: l10n,
      onTap: _openProduct,
    );
    await ExpiryNotificationService.shared.requestPermission();
    final launchId = await ExpiryNotificationService.shared.launchProductId();
    if (launchId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openProduct(launchId));
    }
  }

  void _openProduct(int productId) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initNotifications(l10n);
        });
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
