import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:use_by_date/l10n/app_localizations.dart';
import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/l10n/translator_locale.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/providers/providers.dart';
import 'package:use_by_date/services/photo_add_ad_gate.dart';
import 'package:use_by_date/services/photo_pick_service.dart';
import 'package:use_by_date/theme/app_theme.dart';

enum _AiStatusKind { analyzing, empty, found, failed }

class AddItemsScreen extends ConsumerStatefulWidget {
  const AddItemsScreen({super.key, required this.initialImagePaths});

  final List<String> initialImagePaths;

  @override
  ConsumerState<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends ConsumerState<AddItemsScreen> {
  late final List<String> _imagePaths;
  final List<DraftProduct> _items = [];
  bool _analyzing = false;
  bool _saving = false;
  _AiStatusKind? _statusKind;
  String? _statusError;
  int? _foundCount;

  @override
  void initState() {
    super.initState();
    _imagePaths = [
      ...widget.initialImagePaths.take(PhotoPickService.maxPhotos),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) => _runAi());
  }

  Future<void> _runAi() async {
    if (_imagePaths.isEmpty) return;
    setState(() {
      _analyzing = true;
      _statusKind = _AiStatusKind.analyzing;
      _statusError = null;
    });

    try {
      final locale = Localizations.localeOf(context);
      final items = await ref.read(expiryAnalysisServiceProvider).analyze(
            _imagePaths,
            targetLanguage: translatorTargetCode(locale),
            capturedAt: todayIsoDate(),
          );
      if (!mounted) return;
      final pathByImageId = <String, String>{
        for (var i = 0; i < _imagePaths.length; i++)
          'photo-${i + 1}': _imagePaths[i],
      };
      setState(() {
        _items
          ..clear()
          ..addAll(
            items.map(
              (item) => DraftProduct.fromAnalyzed(
                item,
                sourceImagePath:
                    pathByImageId[item.imageId] ?? _imagePaths.first,
              ),
            ),
          );
        _foundCount = items.length;
        _statusKind =
            items.isEmpty ? _AiStatusKind.empty : _AiStatusKind.found;
        _analyzing = false;
      });
      unawaited(PhotoAddAdGate.recordSuccessfulAiCalls(_imagePaths.length));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _statusKind = _AiStatusKind.failed;
        _statusError = error.toString();
      });
    }
  }

  Future<void> _save() async {
    final named = _items.where((item) => item.name.trim().isNotEmpty).toList();
    if (named.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.addAtLeastOneItem)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(productRepositoryProvider).createFromDrafts(
            sourceImagePaths: _imagePaths,
            drafts: named,
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

  Future<void> _pickDate(DraftProduct item) async {
    final now = DateTime.now();
    final initial = item.expiryDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) return;
    setState(() {
      item.expiryDate = dateOnly(picked);
      item.expirySource = 'user';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canSave = !_analyzing && !_saving;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addItemsTitle),
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            l10n.photosCountLabel(
              _imagePaths.length,
              PhotoPickService.maxPhotos,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _PhotoThumb(path: _imagePaths[index]);
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_analyzing) const LinearProgressIndicator(),
          if (_statusKind != null) ...[
            const SizedBox(height: 8),
            Text(
              _statusText(l10n),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          for (var i = 0; i < _items.length; i++)
            _DraftItemCard(
              key: ObjectKey(_items[i]),
              item: _items[i],
              onNameChanged: (value) => setState(() => _items[i].name = value),
              onPickDate: () => _pickDate(_items[i]),
              onClearDate: () => setState(() {
                _items[i].expiryDate = null;
                _items[i].expirySource = 'user';
              }),
              onRemove: () => setState(() => _items.removeAt(i)),
            ),
          TextButton.icon(
            onPressed: _analyzing
                ? null
                : () => setState(
                      () => _items.add(
                        DraftProduct.manual(
                          sourceImagePath: _imagePaths.first,
                        ),
                      ),
                    ),
            icon: const Icon(Icons.add),
            label: Text(l10n.addItemManually),
          ),
        ],
      ),
    );
  }

  String _statusText(AppLocalizations l10n) {
    switch (_statusKind) {
      case _AiStatusKind.analyzing:
        return l10n.analyzingPhoto;
      case _AiStatusKind.empty:
        return l10n.noItemsDetected;
      case _AiStatusKind.found:
        return l10n.itemsFoundCount(_foundCount ?? 0);
      case _AiStatusKind.failed:
        return l10n.aiDetectFailed(_statusError ?? '');
      case null:
        return '';
    }
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          errorBuilder: (_, _, _) => const ColoredBox(
            color: AppTheme.hairline,
            child: Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}

class _DraftItemCard extends StatefulWidget {
  const _DraftItemCard({
    super.key,
    required this.item,
    required this.onNameChanged,
    required this.onPickDate,
    required this.onClearDate,
    required this.onRemove,
  });

  final DraftProduct item;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onRemove;

  @override
  State<_DraftItemCard> createState() => _DraftItemCardState();
}

class _DraftItemCardState extends State<_DraftItemCard> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final sourceLabel = switch (widget.item.expirySource) {
      'printed' => l10n.sourcePrinted,
      'estimated' => l10n.sourceEstimated,
      'user' => l10n.sourceUser,
      _ => null,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.item.sourceImagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(widget.item.sourceImagePath!),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox(
                        width: 48,
                        height: 48,
                        child: ColoredBox(
                          color: AppTheme.hairline,
                          child: Icon(Icons.broken_image_outlined, size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.itemNameLabel,
                      hintText: l10n.itemNameHint,
                    ),
                    onChanged: widget.onNameChanged,
                  ),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onPickDate,
                    child: Text(
                      widget.item.expiryDate == null
                          ? l10n.pickExpiryDate
                          : DateFormat.yMMMd(locale)
                              .format(widget.item.expiryDate!),
                    ),
                  ),
                ),
                if (widget.item.expiryDate != null)
                  TextButton(
                    onPressed: widget.onClearDate,
                    child: Text(l10n.clearExpiryDate),
                  ),
              ],
            ),
            if (sourceLabel != null) ...[
              const SizedBox(height: 8),
              Chip(label: Text(sourceLabel)),
            ],
            if (widget.item.reason != null &&
                widget.item.reason!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                widget.item.reason!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
