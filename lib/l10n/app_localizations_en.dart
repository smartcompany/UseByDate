// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Expiry Reminder';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get emptyHomeTitle => 'When does this expire?';

  @override
  String get emptyHomeBody =>
      'Upload a photo and we\'ll read or estimate product names and expiry dates, then remind you in time. Here\'s how to shoot it.';

  @override
  String get emptyHomeStep1 =>
      'Screenshot an order list from a grocery or shopping app';

  @override
  String get emptyHomeStep2 => 'Photo several items together as a group';

  @override
  String get emptyHomeStep3 => 'Photo the expiry date printed on the package';

  @override
  String get emptyHomeCtaHint =>
      'Review and save the results. Start with the camera or album below';

  @override
  String get camera => 'Camera';

  @override
  String get album => 'Album';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get layoutGridTooltip => 'Grid view';

  @override
  String get layoutListTooltip => 'List view';

  @override
  String get preparingPhoto => 'Preparing your photo…';

  @override
  String get imageCompressFailed => 'Couldn\'t compress the image.';

  @override
  String get cameraPermissionDenied =>
      'Camera access is off. Turn it on in Settings to take photos.';

  @override
  String get photoPermissionDenied =>
      'Photo library access is off. Turn it on in Settings to choose photos.';

  @override
  String get openSettings => 'Settings';

  @override
  String get analyzingPhoto => 'Looking for foods and expiry dates…';

  @override
  String get noItemsDetected => 'No foods detected. Add items manually.';

  @override
  String itemsFoundCount(int count) {
    return '$count items found. Edit if needed.';
  }

  @override
  String aiDetectFailed(String error) {
    return 'Recognition failed. You can add items manually.\n$error';
  }

  @override
  String get addItemsTitle => 'Review items';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get retake => 'Retake';

  @override
  String get gallery => 'Gallery';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String photosCountLabel(int count, int max) {
    return '$count of $max photos';
  }

  @override
  String maxPhotosReached(int count) {
    return 'You can add up to $count photos.';
  }

  @override
  String get addItemManually => 'Add item';

  @override
  String get itemNameLabel => 'Name';

  @override
  String get itemNameHint => 'e.g. Milk';

  @override
  String get expiryDateLabel => 'Expiry date';

  @override
  String get noExpiryDate => 'No date yet';

  @override
  String get pickExpiryDate => 'Choose date';

  @override
  String get clearExpiryDate => 'Clear date';

  @override
  String get sourcePrinted => 'Printed date';

  @override
  String get sourceEstimated => 'Estimated';

  @override
  String get sourceUser => 'Edited';

  @override
  String get reasonLabel => 'Why this date';

  @override
  String get addAtLeastOneItem => 'Add at least one item with a name.';

  @override
  String saveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get firstSaveHint =>
      'Saved. You\'ll get a reminder before it expires.';

  @override
  String get sectionExpired => 'Expired';

  @override
  String get sectionToday => 'Today';

  @override
  String get sectionSoon => 'Soon';

  @override
  String get sectionLater => 'Later';

  @override
  String get sectionNoDate => 'No date';

  @override
  String daysLeft(int count) {
    return '$count days left';
  }

  @override
  String expiredDaysAgo(int count) {
    return 'Expired $count days ago';
  }

  @override
  String get expiresToday => 'Expires today';

  @override
  String get expiresTomorrow => 'Expires tomorrow';

  @override
  String get productDetailTitle => 'Item';

  @override
  String get deleteProductTitle => 'Delete item';

  @override
  String get deleteProductMessage => 'Delete this item and its reminder?';

  @override
  String get productNotFound => 'Item not found';

  @override
  String get notifyEnabledTitle => 'Reminder';

  @override
  String get notifyEnabledSubtitle => 'Notify on the reminder day';

  @override
  String get settingsNotifyDaysTitle => 'Remind me';

  @override
  String get settingsNotifyDaysOnDay => 'On the expiry day';

  @override
  String settingsNotifyDaysBefore(int count) {
    return '$count days before';
  }

  @override
  String get settingsNotifyTimeTitle => 'Reminder time';

  @override
  String get settingsSaveToAlbumTitle => 'Save camera photos to gallery';

  @override
  String get settingsSaveToAlbumSubtitle =>
      'Also keep shots in the device Photos / Gallery app';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Allow alerts so reminders can appear on time';

  @override
  String get notificationPermissionDenied =>
      'Notifications are off. Turn them on in system settings to get reminders.';

  @override
  String get notificationTitle => 'Use by today';

  @override
  String notificationBodyOnDay(String name) {
    return '$name expires today.';
  }

  @override
  String notificationBodyBefore(String name, int count) {
    return '$name expires in $count days.';
  }

  @override
  String get photoAddAdTitle => 'Watch an ad to add a food photo?';

  @override
  String photoAddAdMessage(int count) {
    return 'A short ad appears every $count times you successfully analyze a photo. Watch it to open the camera or album and add more foods.';
  }

  @override
  String get photoAddAdContinue => 'Watch ad & add photo';

  @override
  String get photoAddAdTitleScan => 'Watch an ad to scan again?';

  @override
  String photoAddAdMessageScan(int count) {
    return 'A short ad appears every $count successful photo analyses. Watch it to run AI expiry detection again on these photos.';
  }

  @override
  String get photoAddAdContinueScan => 'Watch ad & scan again';

  @override
  String get photoAddAdCancel => 'Cancel';

  @override
  String get photoAddAdLoading => 'Loading ad…';

  @override
  String get selectItemsTooltip => 'Select items';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get deselectAll => 'Deselect all';

  @override
  String get deleteSelectedTitle => 'Delete selected items';

  @override
  String deleteSelectedMessage(int count) {
    return 'Delete $count selected items and their reminders?';
  }

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get shareAppTitle => 'Share app';

  @override
  String get shareAppSubtitle => 'Send a download link to friends';

  @override
  String get shareAppMessage =>
      'AI Expiry Reminder — track food expiry from photos';

  @override
  String shareAppFailed(String error) {
    return 'Couldn\'t share: $error';
  }
}
