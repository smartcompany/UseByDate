import 'package:flutter/widgets.dart';

import 'package:use_by_date/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
