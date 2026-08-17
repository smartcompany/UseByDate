import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/providers/providers.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/theme/app_theme.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _nameController = TextEditingController();
  DateTime? _expiryDate;
  bool _notifyEnabled = true;
  String? _reason;
  String? _source;
  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _hydrateFrom(ProductWithPhoto item) {
    if (_hydrated) return;
    _nameController.text = item.product.name;
    _expiryDate = parseIsoDate(item.product.expiryDate);
    _notifyEnabled = item.product.notifyEnabled;
    _reason = item.product.reason;
    _source = item.product.expirySource;
    _hydrated = true;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _expiryDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) return;
    setState(() {
      _expiryDate = dateOnly(picked);
      _source = 'user';
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.addAtLeastOneItem)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(productRepositoryProvider).updateProduct(
            id: widget.productId,
            name: name,
            expiryDate: _expiryDate,
            notifyEnabled: _notifyEnabled,
            expirySource: _source ?? 'user',
            reason: _reason,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.saveFailed(error.toString()))),
      );
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProductTitle),
        content: Text(l10n.deleteProductMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(productRepositoryProvider).deleteProduct(widget.productId);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetailTitle),
        actions: [
          IconButton(
            tooltip: l10n.delete,
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
          ),
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorWithMessage(e.toString()))),
        data: (item) {
          if (item == null) {
            return Center(child: Text(l10n.productNotFound));
          }
          _hydrateFrom(item);
          final locale = Localizations.localeOf(context).toString();
          final sourceLabel = switch (_source) {
            'printed' => l10n.sourcePrinted,
            'estimated' => l10n.sourceEstimated,
            'user' => l10n.sourceUser,
            _ => null,
          };

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.file(
                    File(item.resolvedImagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: AppTheme.hairline,
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.itemNameLabel,
                  hintText: l10n.itemNameHint,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.expiryDateLabel),
                subtitle: Text(
                  _expiryDate == null
                      ? l10n.noExpiryDate
                      : DateFormat.yMMMd(locale).format(_expiryDate!),
                ),
                trailing: TextButton(
                  onPressed: _pickDate,
                  child: Text(l10n.pickExpiryDate),
                ),
              ),
              if (_expiryDate != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => setState(() {
                      _expiryDate = null;
                      _source = 'user';
                    }),
                    child: Text(l10n.clearExpiryDate),
                  ),
                ),
              if (sourceLabel != null) Chip(label: Text(sourceLabel)),
              if (_reason != null && _reason!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(l10n.reasonLabel, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(_reason!, style: Theme.of(context).textTheme.bodySmall),
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.notifyEnabledTitle),
                subtitle: Text(l10n.notifyEnabledSubtitle),
                value: _notifyEnabled,
                onChanged: (value) => setState(() => _notifyEnabled = value),
              ),
            ],
          );
        },
      ),
    );
  }
}
