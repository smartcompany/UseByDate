import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/theme/app_theme.dart';

enum ExpiryUrgency { expired, today, soon, later, noDate }

ExpiryUrgency urgencyFor(DateTime? expiry, int notifyDaysBefore) {
  if (expiry == null) return ExpiryUrgency.noDate;
  final today = dateOnly(DateTime.now());
  final days = dateOnly(expiry).difference(today).inDays;
  if (days < 0) return ExpiryUrgency.expired;
  if (days == 0) return ExpiryUrgency.today;
  if (days <= notifyDaysBefore) return ExpiryUrgency.soon;
  return ExpiryUrgency.later;
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.item,
    required this.notifyDaysBefore,
    required this.onTap,
  });

  final ProductWithPhoto item;
  final int notifyDaysBefore;
  final VoidCallback onTap;

  static const _thumbSize = 72.0;

  @override
  Widget build(BuildContext context) {
    final expiry = parseIsoDate(item.product.expiryDate);
    final urgency = urgencyFor(expiry, notifyDaysBefore);
    final subtitle = _subtitle(context, expiry);
    final accent = switch (urgency) {
      ExpiryUrgency.expired => AppTheme.expired,
      ExpiryUrgency.today => AppTheme.today,
      ExpiryUrgency.soon => AppTheme.soon,
      ExpiryUrgency.later => AppTheme.olive,
      ExpiryUrgency.noDate => AppTheme.muted,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: _thumbSize,
                  height: _thumbSize,
                  child: Image.file(
                    File(item.resolvedImagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: AppTheme.hairline,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppTheme.muted,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (expiry != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.yMMMd(Localizations.localeOf(context).toString())
                            .format(expiry),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.muted.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(BuildContext context, DateTime? expiry) {
    final l10n = context.l10n;
    if (expiry == null) return l10n.noExpiryDate;
    final today = dateOnly(DateTime.now());
    final days = dateOnly(expiry).difference(today).inDays;
    if (days < 0) return l10n.expiredDaysAgo(-days);
    if (days == 0) return l10n.expiresToday;
    if (days == 1) return l10n.expiresTomorrow;
    return l10n.daysLeft(days);
  }
}
