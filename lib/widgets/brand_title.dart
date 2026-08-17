import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:use_by_date/theme/app_theme.dart';

class _TitleParts {
  const _TitleParts({required this.lead, required this.emphasis});

  final String lead;
  final String emphasis;
}

_TitleParts _splitAppTitle(String title, Locale locale) {
  switch (locale.languageCode) {
    case 'ko':
      return const _TitleParts(lead: 'AI', emphasis: '유통기한 알리미');
    case 'en':
      return const _TitleParts(lead: 'AI', emphasis: 'Expiry Reminder');
    case 'ja':
      return const _TitleParts(lead: 'AI', emphasis: '賞味期限リマインダー');
    case 'zh':
      return const _TitleParts(lead: 'AI', emphasis: '保质期提醒');
    default:
      final parts = title.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return _TitleParts(
          lead: parts.sublist(0, parts.length - 1).join(' '),
          emphasis: parts.last,
        );
      }
      return _TitleParts(lead: '', emphasis: title);
  }
}

/// Home AppBar brand mark — accent bar + two-line type.
class BrandTitle extends StatelessWidget {
  const BrandTitle({
    super.key,
    required this.title,
    this.large = false,
  });

  final String title;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final parts = _splitAppTitle(title, Localizations.localeOf(context));
    final barHeight = large ? 40.0 : 30.0;
    final leadSize = large ? 15.0 : 13.0;
    final emphasisSize = large ? 30.0 : 24.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3,
          height: barHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.coral,
                AppTheme.coralDeep.withValues(alpha: 0.85),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (parts.lead.isNotEmpty)
                Text(
                  parts.lead,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: leadSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    height: 1.1,
                    color: AppTheme.ink.withValues(alpha: 0.72),
                  ),
                ),
              Text(
                parts.emphasis,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: emphasisSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.05,
                  color: AppTheme.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
