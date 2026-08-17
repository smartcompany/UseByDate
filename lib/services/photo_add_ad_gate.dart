import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_lib/share_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:use_by_date/config/api_config.dart';
import 'package:use_by_date/l10n/app_localizations.dart';
import 'package:use_by_date/services/api_settings_service.dart';
import 'package:use_by_date/services/photo_pick_flow_overlay.dart';

/// Gates camera/album entry with an interstitial every N successful AI runs.
///
/// Interval `photo_add_ad_every` comes from `GET /api/settings` (server-editable).
/// Ad unit IDs are loaded via [AdService] from the same settings JSON.
///
/// The counter advances only in [recordSuccessfulAiCall] after a successful
/// analyze API response — not when opening the camera or album.
enum PhotoAddAdPurpose {
  /// Open camera or album to add food photos.
  addPhoto,

  /// Re-run AI analysis on the current photos.
  scanAgain,
}

abstract final class PhotoAddAdGate {
  static const _countKey = 'photo_add_ad_count';

  /// Fallback when `/api/settings` omits or fails to load `photo_add_ad_every`.
  /// Matches server `settings.json` product value.
  static const _settingsFallbackEvery = 5;

  static int? _every;
  static var _settingsLoaded = false;

  static int get every {
    final value = _every;
    if (value == null || value < 1) return _settingsFallbackEvery;
    return value;
  }

  /// Loads interval + AdMob IDs from the API (and preloads the next interstitial).
  static Future<void> ensureSettingsLoaded() async {
    if (_settingsLoaded) return;

    try {
      final baseUrl = await ApiSettingsService.shared.getApiBaseUrl();
      final resolved =
          baseUrl.isEmpty ? ApiConfig.photoApiBaseUrl : baseUrl;
      AdService.shared.setBaseUrl(resolved);
      final loaded = await AdService.shared.loadSettings();
      debugPrint('[PhotoAddAdGate] AdService loaded=$loaded');

      final uri = Uri.parse('$resolved/api/settings');
      final response = await http.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final raw = data['photo_add_ad_every'];
          if (raw is int && raw > 0) {
            _every = raw;
          } else if (raw is num && raw.toInt() > 0) {
            _every = raw.toInt();
          }
        }
      }
      debugPrint('[PhotoAddAdGate] photo_add_ad_every=$every');
      unawaited(AdService.shared.preloadAd());
    } catch (error, stackTrace) {
      debugPrint('[PhotoAddAdGate] settings load error: $error');
      debugPrint('$stackTrace');
      _every = _settingsFallbackEvery;
    } finally {
      _settingsLoaded = true;
    }
  }

  /// Call after a successful analyze API response (including empty items).
  static Future<void> recordSuccessfulAiCall() async {
    await ensureSettingsLoaded();
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    final next = count + 1;
    await prefs.setInt(_countKey, next);
    debugPrint('[PhotoAddAdGate] AI success count $next/$every');
  }

  /// Returns `true` if the user may proceed to pick a photo / scan again.
  ///
  /// When successful AI runs already reached [every], shows a confirm dialog,
  /// then an interstitial if the user chooses to continue, and resets the
  /// counter. Opening the picker alone does not increment the counter.
  static Future<bool> confirmBeforePick(
    BuildContext context, {
    PhotoAddAdPurpose purpose = PhotoAddAdPurpose.addPhoto,
    PhotoPickFlowOverlay? flowOverlay,
  }) async {
    await ensureSettingsLoaded();
    if (!context.mounted) return false;

    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    final threshold = every;

    if (count < threshold) {
      debugPrint('[PhotoAddAdGate] free pick (AI count $count/$threshold)');
      return true;
    }

    if (!context.mounted) return false;
    final l10n = AppLocalizations.of(context);
    final isScan = purpose == PhotoAddAdPurpose.scanAgain;
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isScan ? l10n.photoAddAdTitleScan : l10n.photoAddAdTitle,
          ),
          content: Text(
            isScan
                ? l10n.photoAddAdMessageScan(threshold)
                : l10n.photoAddAdMessage(threshold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.photoAddAdCancel),
            ),
            FilledButton(
              onPressed: () {
                if (flowOverlay != null) {
                  flowOverlay.show(l10n.photoAddAdLoading);
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                isScan
                    ? l10n.photoAddAdContinueScan
                    : l10n.photoAddAdContinue,
              ),
            ),
          ],
        );
      },
    );

    if (proceed != true) {
      debugPrint('[PhotoAddAdGate] user cancelled ad gate (result=$proceed)');
      return false;
    }
    if (!context.mounted) return false;

    debugPrint('[PhotoAddAdGate] user confirmed — showing interstitial');
    final adOk = await _showInterstitial(
      context,
      flowOverlay: flowOverlay,
    );
    if (!adOk) {
      debugPrint('[PhotoAddAdGate] ad failed/skipped; allowing pick');
    } else {
      debugPrint('[PhotoAddAdGate] ad dismissed; allowing pick');
    }

    await prefs.setInt(_countKey, 0);
    return true;
  }

  static Future<bool> _showInterstitial(
    BuildContext context, {
    PhotoPickFlowOverlay? flowOverlay,
  }) async {
    final l10n = AppLocalizations.of(context);
    var completed = false;
    final completer = Completer<void>();
    final useExternalOverlay = flowOverlay != null;
    final navigator = Navigator.of(context, rootNavigator: true);
    var loadingDismissed = false;
    late final Route<void> loadingRoute;

    void dismissLoading() {
      if (useExternalOverlay) return;
      if (loadingDismissed) return;
      loadingDismissed = true;
      if (loadingRoute.isActive) {
        navigator.removeRoute(loadingRoute);
      }
    }

    void finish({required bool adCompleted}) {
      completed = adCompleted;
      dismissLoading();
      if (!completer.isCompleted) completer.complete();
    }

    if (useExternalOverlay) {
      flowOverlay.show(l10n.photoAddAdLoading);
    } else {
      loadingRoute = PageRouteBuilder<void>(
        opaque: true,
        barrierDismissible: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (ctx, animation, secondaryAnimation) {
          return PopScope(
            canPop: false,
            child: Material(
              color: Colors.black.withValues(alpha: 0.72),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.photoAddAdLoading,
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      unawaited(navigator.push(loadingRoute));
      await WidgetsBinding.instance.endOfFrame;
    }

    try {
      await AdService.shared.showAd(
        onAdShown: dismissLoading,
        onAdDismissed: () => finish(adCompleted: true),
        onAdFailedToShow: () => finish(adCompleted: false),
      );
    } catch (error) {
      debugPrint('[PhotoAddAdGate] showAd error: $error');
      finish(adCompleted: false);
    }

    try {
      await completer.future.timeout(const Duration(seconds: 90));
    } catch (_) {
      debugPrint('[PhotoAddAdGate] ad wait timed out');
      finish(adCompleted: false);
    }

    unawaited(AdService.shared.preloadAd());
    return completed;
  }
}
