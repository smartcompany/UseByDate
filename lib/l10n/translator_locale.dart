import 'package:flutter/material.dart';

/// App locale languageCode sent to the analyze API (`contentLanguage`).
/// Supported: en, ko, ja, zh (Simplified Chinese). Matches AppLocalizations.
String translatorTargetCode(Locale locale) {
  switch (locale.languageCode) {
    case 'ko':
    case 'ja':
    case 'zh':
    case 'en':
      return locale.languageCode;
    default:
      return 'en';
  }
}
