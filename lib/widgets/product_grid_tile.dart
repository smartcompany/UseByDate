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
    this.selecting = false,
    this.selected = false,
    this.onLongPress,
  });

  final ProductWithPhoto item;
  final int notifyDaysBefore;
  final VoidCallback onTap;
  final bool selecting;
  final bool selected;
  final VoidCallback? onLongPress;

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
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
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
                  if (selecting)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.coral.withValues(alpha: 0.35)
                            : Colors.black.withValues(alpha: 0.12),
                        border: selected
                            ? Border.all(color: AppTheme.coral, width: 2.5)
                            : null,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Material(
                            color: selected
                                ? AppTheme.coral
                                : Colors.white.withValues(alpha: 0.92),
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                selected
                                    ? Icons.check_rounded
                                    : Icons.circle_outlined,
                                size: 20,
                                color: selected
                                    ? Colors.white
                                    : AppTheme.muted.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
