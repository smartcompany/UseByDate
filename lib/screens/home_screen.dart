import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/providers/providers.dart';
import 'package:use_by_date/screens/add_items_screen.dart';
import 'package:use_by_date/screens/product_detail_screen.dart';
import 'package:use_by_date/screens/settings_screen.dart';
import 'package:use_by_date/services/photo_add_ad_gate.dart';
import 'package:use_by_date/services/photo_pick_flow_overlay.dart';
import 'package:use_by_date/services/photo_pick_service.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';
import 'package:use_by_date/theme/app_theme.dart';
import 'package:use_by_date/widgets/brand_title.dart';
import 'package:use_by_date/widgets/product_grid_tile.dart';
import 'package:use_by_date/widgets/product_list_tile.dart';
import 'package:use_by_date/widgets/swipe_reveal_delete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _openSwipeItemKey;
  bool _pickFlowActive = false;
  String? _pickFlowMessage;

  static const _bottomBarHeight = 80.0;

  PhotoPickFlowOverlay get _pickFlowOverlay => PhotoPickFlowOverlay(
        show: (message) {
          if (!mounted) return;
          setState(() {
            _pickFlowActive = true;
            _pickFlowMessage = message;
          });
        },
        hide: () {
          if (!mounted) return;
          setState(() {
            _pickFlowActive = false;
            _pickFlowMessage = null;
          });
        },
      );

  Future<void> _runPickFlow(Future<void> Function() work) async {
    try {
      await work();
    } finally {
      _pickFlowOverlay.hide();
    }
  }

  Future<void> _openAddFromAlbum() async {
    await _runPickFlow(() async {
      final allowed = await PhotoAddAdGate.confirmBeforePick(
        context,
        flowOverlay: _pickFlowOverlay,
      );
      if (!allowed || !mounted) return;
      _pickFlowOverlay.hide();
      final paths = await PhotoPickService.pickFromAlbum(context);
      if (paths.isEmpty || !mounted) return;
      await _pushAddItems(paths);
    });
  }

  Future<void> _openAddFromCamera() async {
    await _runPickFlow(() async {
      final l10n = context.l10n;
      final allowed = await PhotoAddAdGate.confirmBeforePick(
        context,
        flowOverlay: _pickFlowOverlay,
      );
      if (!allowed || !mounted) return;

      _pickFlowOverlay.hide();
      final pickedPath = await PhotoPickService.pickCameraRaw(context: context);
      if (pickedPath == null || !mounted) return;

      _pickFlowOverlay.show(l10n.preparingPhoto);
      final path = await PhotoPickService.prepareCameraPhoto(
        context,
        pickedPath,
      );
      if (path == null || !mounted) return;
      await _pushAddItems([path]);
    });
  }

  Future<void> _pushAddItems(List<String> imagePaths) async {
    final wasEmpty = ref.read(productsProvider).value?.isEmpty ?? true;
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddItemsScreen(initialImagePaths: imagePaths),
      ),
    );
    if (saved == true) {
      ref.invalidate(productsProvider);
      if (wasEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.firstSaveHint)),
        );
      }
    }
  }

  Future<void> _openDetail(ProductWithPhoto item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: item.product.id),
      ),
    );
    ref.invalidate(productsProvider);
  }

  Future<bool> _confirmDelete() async {
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
    return ok == true;
  }

  Future<void> _confirmAndDelete(ProductWithPhoto item) async {
    final confirmed = await _confirmDelete();
    if (!confirmed) return;
    setState(() => _openSwipeItemKey = null);
    await ref.read(productRepositoryProvider).deleteProduct(item.product.id);
    ref.invalidate(productsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final productsAsync = ref.watch(productsProvider);
    final layoutAsync = ref.watch(homeLayoutProvider);
    final layout = layoutAsync.value ?? HomeLayoutMode.list;
    final settings = ref.watch(reminderSettingsProvider).value;
    final notifyDays =
        settings?.notifyDaysBefore ?? ReminderSettingsSpec.notifyDaysBefore;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPad = _bottomBarHeight + bottomInset + 20;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 20,
        toolbarHeight: 72,
        title: BrandTitle(title: l10n.appTitle),
        actions: [
          IconButton(
            tooltip: layout == HomeLayoutMode.grid
                ? l10n.layoutListTooltip
                : l10n.layoutGridTooltip,
            onPressed: () => ref.read(homeLayoutProvider.notifier).toggle(),
            icon: Icon(
              layout == HomeLayoutMode.grid
                  ? Icons.view_agenda_outlined
                  : Icons.grid_view_rounded,
            ),
          ),
          IconButton(
            tooltip: l10n.settingsTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.homeGradient),
        child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(l10n.errorWithMessage(e.toString())),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: bottomPad),
                    child: const _EmptyState(),
                  );
                }
                if (layout == HomeLayoutMode.grid) {
                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return ProductGridTile(
                        item: item,
                        notifyDaysBefore: notifyDays,
                        onTap: () => _openDetail(item),
                      );
                    },
                  );
                }
                final grouped = _group(products, notifyDays);
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 0, 12, bottomPad),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped[index];
                    if (entry is _SectionHeader) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 8, 6),
                        child: Text(
                          entry.label,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.muted,
                                  ),
                        ),
                      );
                    }
                    final item = (entry as _SectionItem).item;
                    final itemKey = item.product.id.toString();
                    return SwipeRevealDelete(
                      itemKey: itemKey,
                      openItemKey: _openSwipeItemKey,
                      onOpenChanged: (key) =>
                          setState(() => _openSwipeItemKey = key),
                      deleteLabel: l10n.delete,
                      onDelete: () => _confirmAndDelete(item),
                      child: ColoredBox(
                        color: AppTheme.background,
                        child: ProductListTile(
                          item: item,
                          notifyDaysBefore: notifyDays,
                          onTap: () {
                            if (_openSwipeItemKey != null) {
                              setState(() => _openSwipeItemKey = null);
                              return;
                            }
                            _openDetail(item);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset + 12),
                child: _PhotosStyleBottomBar(
                  onCamera: _openAddFromCamera,
                  onAlbum: _openAddFromAlbum,
                  cameraTooltip: l10n.camera,
                  albumTooltip: l10n.album,
                ),
              ),
            ),
            if (_pickFlowActive)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Material(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 24, 28, 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _pickFlowMessage ?? l10n.preparingPhoto,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
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
    );
  }

  List<_ListEntry> _group(List<ProductWithPhoto> products, int notifyDays) {
    final l10n = context.l10n;
    final buckets = <ExpiryUrgency, List<ProductWithPhoto>>{
      ExpiryUrgency.expired: [],
      ExpiryUrgency.today: [],
      ExpiryUrgency.soon: [],
      ExpiryUrgency.later: [],
      ExpiryUrgency.noDate: [],
    };
    for (final item in products) {
      final urgency = urgencyFor(
        parseIsoDate(item.product.expiryDate),
        notifyDays,
      );
      buckets[urgency]!.add(item);
    }

    final labels = {
      ExpiryUrgency.expired: l10n.sectionExpired,
      ExpiryUrgency.today: l10n.sectionToday,
      ExpiryUrgency.soon: l10n.sectionSoon,
      ExpiryUrgency.later: l10n.sectionLater,
      ExpiryUrgency.noDate: l10n.sectionNoDate,
    };

    final entries = <_ListEntry>[];
    for (final urgency in ExpiryUrgency.values) {
      final items = buckets[urgency]!;
      if (items.isEmpty) continue;
      entries.add(_SectionHeader(labels[urgency]!));
      for (final item in items) {
        entries.add(_SectionItem(item));
      }
    }
    return entries;
  }
}

sealed class _ListEntry {}

class _SectionHeader extends _ListEntry {
  _SectionHeader(this.label);
  final String label;
}

class _SectionItem extends _ListEntry {
  _SectionItem(this.item);
  final ProductWithPhoto item;
}

class _PhotosStyleBottomBar extends StatelessWidget {
  const _PhotosStyleBottomBar({
    required this.onCamera,
    required this.onAlbum,
    required this.cameraTooltip,
    required this.albumTooltip,
  });

  final VoidCallback onCamera;
  final VoidCallback onAlbum;
  final String cameraTooltip;
  final String albumTooltip;

  static const _railColor = Color(0xE6C46842);
  static const _railHeight = 46.0;
  static const _sideButtonSize = 40.0;
  static const _sideIconSize = 20.0;
  static const _cameraButtonSize = 64.0;
  static const _cameraIconSize = 30.0;
  static const _cameraGap = 10.0;

  Widget _albumButton({required bool interactive}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _railColor,
        borderRadius: BorderRadius.circular(_railHeight / 2),
        boxShadow: interactive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: _sideButtonSize + 8,
        height: _railHeight,
        child: IconButton(
          tooltip: interactive ? albumTooltip : null,
          onPressed: interactive ? onAlbum : null,
          iconSize: _sideIconSize,
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            foregroundColor: Colors.white.withValues(alpha: 0.92),
            highlightColor: Colors.white12,
          ),
          icon: const Icon(Icons.photo_library_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cameraButton = Material(
      elevation: 8,
      shadowColor: AppTheme.coralDeep.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.coral,
              AppTheme.coralDeep,
            ],
          ),
        ),
        child: SizedBox(
          width: _cameraButtonSize,
          height: _cameraButtonSize,
          child: IconButton(
            tooltip: cameraTooltip,
            onPressed: onCamera,
            iconSize: _cameraIconSize,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.photo_camera_rounded, color: Colors.white),
          ),
        ),
      ),
    );

    return SizedBox(
      height: _cameraButtonSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _albumButton(interactive: true),
          const SizedBox(width: _cameraGap),
          cameraButton,
          const SizedBox(width: _cameraGap),
          IgnorePointer(
            child: Opacity(
              opacity: 0,
              child: _albumButton(interactive: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyHomePrompt(
              icon: Icons.sentiment_dissatisfied_outlined,
              iconColor: AppTheme.muted,
              child: Text(
                l10n.emptyHomeTitle,
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  height: 1.3,
                  color: AppTheme.ink.withValues(alpha: 0.9),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _EmptyHomePrompt(
              icon: Icons.school_rounded,
              iconColor: AppTheme.teal,
              child: Text(
                l10n.emptyHomeBody,
                style: textTheme.titleMedium?.copyWith(
                  color: AppTheme.coralDeep,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                  letterSpacing: -0.15,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 28),
            _EmptyHomeStep(
              number: '1',
              label: l10n.emptyHomeStep1,
              icon: Icons.photo_camera_outlined,
            ),
            const SizedBox(height: 14),
            _EmptyHomeStep(
              number: '2',
              label: l10n.emptyHomeStep2,
              icon: Icons.event_available_outlined,
            ),
            const SizedBox(height: 14),
            _EmptyHomeStep(
              number: '3',
              label: l10n.emptyHomeStep3,
              icon: Icons.notifications_outlined,
            ),
            const SizedBox(height: 28),
            Text(
              l10n.emptyHomeCtaHint,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.muted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHomePrompt extends StatelessWidget {
  const _EmptyHomePrompt({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 36, color: iconColor),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}

class _EmptyHomeStep extends StatelessWidget {
  const _EmptyHomeStep({
    required this.number,
    required this.label,
    required this.icon,
  });

  final String number;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            number,
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.coral,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
        ),
        Icon(icon, size: 22, color: AppTheme.coralDeep),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }
}
