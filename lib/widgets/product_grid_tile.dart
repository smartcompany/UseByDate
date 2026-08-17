import 'dart:io';

import 'package:flutter/material.dart';

import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/theme/app_theme.dart';
import 'package:use_by_date/widgets/product_list_tile.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({
    super.key,
    required this.item,
    required this.notifyDaysBefore,
    required this.onTap,
  });

  final ProductWithPhoto item;
  final int notifyDaysBefore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final expiry = parseIsoDate(item.product.expiryDate);
    final urgency = urgencyFor(expiry, notifyDaysBefore);
    final subtitle = _subtitle(context, expiry);
    final accent = switch (urgency) {
      ExpiryUrgency.expired => AppTheme.expired,
      ExpiryUrgency.today => AppTheme.today,
      ExpiryUrgency.soon => AppTheme.soon,
      ExpiryUrgency.later => AppTheme.coral,
      ExpiryUrgency.noDate => AppTheme.muted,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(item.resolvedImagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: AppTheme.hairline,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppTheme.muted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
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
