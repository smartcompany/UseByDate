import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:use_by_date/config/store_links.dart';
import 'package:use_by_date/l10n/l10n_extensions.dart';
import 'package:use_by_date/providers/providers.dart';
import 'package:use_by_date/services/camera_album_settings.dart';
import 'package:use_by_date/services/expiry_notification_service.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';
import 'package:use_by_date/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool? _saveToAlbum;

  @override
  void initState() {
    super.initState();
    _loadSaveToAlbum();
  }

  Future<void> _loadSaveToAlbum() async {
    final enabled = await CameraAlbumSettings.isEnabled();
    if (!mounted) return;
    setState(() => _saveToAlbum = enabled);
  }

  Future<void> _setSaveToAlbum(bool value) async {
    setState(() => _saveToAlbum = value);
    await CameraAlbumSettings.setEnabled(value);
  }

  Future<void> _requestNotifications() async {
    final granted =
        await ExpiryNotificationService.shared.requestPermission();
    if (!mounted) return;
    if (granted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.notificationPermissionDenied)),
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    final l10n = context.l10n;
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    try {
      await Share.share(
        '${l10n.shareAppMessage}\n${StoreLinks.shareUrls()}',
        subject: l10n.appTitle,
        sharePositionOrigin: origin,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shareAppFailed(e.toString()))),
      );
    }
  }

  Future<void> _pickTime(ReminderSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.notifyHour,
        minute: settings.notifyMinute,
      ),
    );
    if (picked == null) return;
    await ref.read(reminderSettingsProvider.notifier).setNotifyTime(
          hour: picked.hour,
          minute: picked.minute,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mutedStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.muted);
    final saveToAlbum = _saveToAlbum;
    final settingsAsync = ref.watch(reminderSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.photo_album_outlined),
            title: Text(l10n.settingsSaveToAlbumTitle),
            subtitle: Text(l10n.settingsSaveToAlbumSubtitle, style: mutedStyle),
            value: saveToAlbum ?? false,
            onChanged: saveToAlbum == null ? null : _setSaveToAlbum,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.settingsNotificationsTitle),
            subtitle: Text(l10n.settingsNotificationsSubtitle, style: mutedStyle),
            onTap: _requestNotifications,
          ),
          ListTile(
            leading: const Icon(Icons.ios_share_outlined),
            title: Text(l10n.shareAppTitle),
            subtitle: Text(l10n.shareAppSubtitle, style: mutedStyle),
            onTap: () => _shareApp(context),
          ),
          settingsAsync.when(
            loading: () => const ListTile(
              leading: Icon(Icons.event_repeat_outlined),
              title: LinearProgressIndicator(),
            ),
            error: (e, _) => ListTile(
              title: Text(l10n.errorWithMessage(e.toString())),
            ),
            data: (settings) {
              final time = TimeOfDay(
                hour: settings.notifyHour,
                minute: settings.notifyMinute,
              );
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event_repeat_outlined),
                    title: Text(l10n.settingsNotifyDaysTitle),
                    subtitle: Text(
                      settings.notifyDaysBefore == 0
                          ? l10n.settingsNotifyDaysOnDay
                          : l10n.settingsNotifyDaysBefore(
                              settings.notifyDaysBefore,
                            ),
                      style: mutedStyle,
                    ),
                    trailing: DropdownButton<int>(
                      value: ReminderSettingsSpec.notifyDaysChoices.contains(
                        settings.notifyDaysBefore,
                      )
                          ? settings.notifyDaysBefore
                          : ReminderSettingsSpec.notifyDaysBefore,
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(reminderSettingsProvider.notifier)
                            .setNotifyDaysBefore(value);
                      },
                      items: [
                        for (final days
                            in ReminderSettingsSpec.notifyDaysChoices)
                          DropdownMenuItem(
                            value: days,
                            child: Text(
                              days == 0
                                  ? l10n.settingsNotifyDaysOnDay
                                  : l10n.settingsNotifyDaysBefore(days),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text(l10n.settingsNotifyTimeTitle),
                    subtitle: Text(time.format(context), style: mutedStyle),
                    onTap: () => _pickTime(settings),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
