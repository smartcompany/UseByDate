import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Use By Date'**
  String get appTitle;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @emptyHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'When does this expire?'**
  String get emptyHomeTitle;

  /// No description provided for @emptyHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Photo the package. We\'ll read the date or estimate it, then remind you.'**
  String get emptyHomeBody;

  /// No description provided for @emptyHomeStep1.
  ///
  /// In en, this message translates to:
  /// **'Photo one item or several together'**
  String get emptyHomeStep1;

  /// No description provided for @emptyHomeStep2.
  ///
  /// In en, this message translates to:
  /// **'Check the name and expiry date'**
  String get emptyHomeStep2;

  /// No description provided for @emptyHomeStep3.
  ///
  /// In en, this message translates to:
  /// **'Get a reminder on or before that day'**
  String get emptyHomeStep3;

  /// No description provided for @emptyHomeCtaHint.
  ///
  /// In en, this message translates to:
  /// **'Start with the camera or album below'**
  String get emptyHomeCtaHint;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @preparingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Preparing your photo…'**
  String get preparingPhoto;

  /// No description provided for @imageCompressFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t compress the image.'**
  String get imageCompressFailed;

  /// No description provided for @analyzingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Looking for foods and expiry dates…'**
  String get analyzingPhoto;

  /// No description provided for @noItemsDetected.
  ///
  /// In en, this message translates to:
  /// **'No foods detected. Add items manually.'**
  String get noItemsDetected;

  /// No description provided for @itemsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items found. Edit if needed.'**
  String itemsFoundCount(int count);

  /// No description provided for @aiDetectFailed.
  ///
  /// In en, this message translates to:
  /// **'Recognition failed. You can add items manually.\n{error}'**
  String aiDetectFailed(String error);

  /// No description provided for @addItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Review items'**
  String get addItemsTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgain;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photosCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} photos'**
  String photosCountLabel(int count, int max);

  /// No description provided for @maxPhotosReached.
  ///
  /// In en, this message translates to:
  /// **'You can add up to {count} photos.'**
  String maxPhotosReached(int count);

  /// No description provided for @addItemManually.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemManually;

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get itemNameLabel;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milk'**
  String get itemNameHint;

  /// No description provided for @expiryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDateLabel;

  /// No description provided for @noExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'No date yet'**
  String get noExpiryDate;

  /// No description provided for @pickExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get pickExpiryDate;

  /// No description provided for @clearExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearExpiryDate;

  /// No description provided for @sourcePrinted.
  ///
  /// In en, this message translates to:
  /// **'Printed date'**
  String get sourcePrinted;

  /// No description provided for @sourceEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get sourceEstimated;

  /// No description provided for @sourceUser.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get sourceUser;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Why this date'**
  String get reasonLabel;

  /// No description provided for @addAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item with a name.'**
  String get addAtLeastOneItem;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save: {error}'**
  String saveFailed(String error);

  /// No description provided for @firstSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Saved. You\'ll get a reminder before it expires.'**
  String get firstSaveHint;

  /// No description provided for @sectionExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get sectionExpired;

  /// No description provided for @sectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sectionToday;

  /// No description provided for @sectionSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get sectionSoon;

  /// No description provided for @sectionLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get sectionLater;

  /// No description provided for @sectionNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get sectionNoDate;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeft(int count);

  /// No description provided for @expiredDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Expired {count} days ago'**
  String expiredDaysAgo(int count);

  /// No description provided for @expiresToday.
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get expiresToday;

  /// No description provided for @expiresTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Expires tomorrow'**
  String get expiresTomorrow;

  /// No description provided for @productDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get productDetailTitle;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this item and its reminder?'**
  String get deleteProductMessage;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get productNotFound;

  /// No description provided for @notifyEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get notifyEnabledTitle;

  /// No description provided for @notifyEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify on the reminder day'**
  String get notifyEnabledSubtitle;

  /// No description provided for @settingsNotifyDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get settingsNotifyDaysTitle;

  /// No description provided for @settingsNotifyDaysOnDay.
  ///
  /// In en, this message translates to:
  /// **'On the expiry day'**
  String get settingsNotifyDaysOnDay;

  /// No description provided for @settingsNotifyDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} days before'**
  String settingsNotifyDaysBefore(int count);

  /// No description provided for @settingsNotifyTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get settingsNotifyTimeTitle;

  /// No description provided for @settingsSaveToAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Save camera photos to gallery'**
  String get settingsSaveToAlbumTitle;

  /// No description provided for @settingsSaveToAlbumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Also keep shots in the device Photos / Gallery app'**
  String get settingsSaveToAlbumSubtitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow alerts so reminders can appear on time'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Turn them on in system settings to get reminders.'**
  String get notificationPermissionDenied;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Use by today'**
  String get notificationTitle;

  /// No description provided for @notificationBodyOnDay.
  ///
  /// In en, this message translates to:
  /// **'{name} expires today.'**
  String notificationBodyOnDay(String name);

  /// No description provided for @notificationBodyBefore.
  ///
  /// In en, this message translates to:
  /// **'{name} expires in {count} days.'**
  String notificationBodyBefore(String name, int count);

  /// No description provided for @photoAddAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to add a food photo?'**
  String get photoAddAdTitle;

  /// No description provided for @photoAddAdMessage.
  ///
  /// In en, this message translates to:
  /// **'A short ad appears every {count} times you successfully analyze a photo. Watch it to open the camera or album and add more foods.'**
  String photoAddAdMessage(int count);

  /// No description provided for @photoAddAdContinue.
  ///
  /// In en, this message translates to:
  /// **'Watch ad & add photo'**
  String get photoAddAdContinue;

  /// No description provided for @photoAddAdTitleScan.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to scan again?'**
  String get photoAddAdTitleScan;

  /// No description provided for @photoAddAdMessageScan.
  ///
  /// In en, this message translates to:
  /// **'A short ad appears every {count} successful photo analyses. Watch it to run AI expiry detection again on these photos.'**
  String photoAddAdMessageScan(int count);

  /// No description provided for @photoAddAdContinueScan.
  ///
  /// In en, this message translates to:
  /// **'Watch ad & scan again'**
  String get photoAddAdContinueScan;

  /// No description provided for @photoAddAdCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get photoAddAdCancel;

  /// No description provided for @photoAddAdLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading ad…'**
  String get photoAddAdLoading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
