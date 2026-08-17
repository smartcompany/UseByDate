import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:use_by_date/data/database.dart';
import 'package:use_by_date/services/expiry_analysis_service.dart';
import 'package:use_by_date/services/expiry_notification_service.dart';
import 'package:use_by_date/services/image_store.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';

enum HomeLayoutMode { grid, list }

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final imageStoreProvider = Provider<ImageStore>((ref) => ImageStore());

final reminderSettingsServiceProvider = Provider<ReminderSettingsService>(
  (ref) => ReminderSettingsService.shared,
);

final notificationServiceProvider = Provider<ExpiryNotificationService>(
  (ref) => ExpiryNotificationService.shared,
);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    db: ref.watch(databaseProvider),
    imageStore: ref.watch(imageStoreProvider),
    notifications: ref.watch(notificationServiceProvider),
    reminderSettings: ref.watch(reminderSettingsServiceProvider),
  );
});

final expiryAnalysisServiceProvider = Provider<ExpiryAnalysisService>(
  (ref) => ExpiryAnalysisService(),
);

class ReminderSettingsNotifier extends AsyncNotifier<ReminderSettings> {
  @override
  Future<ReminderSettings> build() {
    return ref.read(reminderSettingsServiceProvider).load();
  }

  Future<void> setNotifyDaysBefore(int days) async {
    await ref.read(reminderSettingsServiceProvider).setNotifyDaysBefore(days);
    await ref.read(productRepositoryProvider).rescheduleAll();
    state = AsyncData(await ref.read(reminderSettingsServiceProvider).load());
  }

  Future<void> setNotifyTime({required int hour, required int minute}) async {
    await ref.read(reminderSettingsServiceProvider).setNotifyTime(
          hour: hour,
          minute: minute,
        );
    await ref.read(productRepositoryProvider).rescheduleAll();
    state = AsyncData(await ref.read(reminderSettingsServiceProvider).load());
  }
}

final reminderSettingsProvider =
    AsyncNotifierProvider<ReminderSettingsNotifier, ReminderSettings>(
  ReminderSettingsNotifier.new,
);

class HomeLayoutNotifier extends AsyncNotifier<HomeLayoutMode> {
  static const _prefsKey = 'home_layout_mode';

  @override
  Future<HomeLayoutMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    return raw == HomeLayoutMode.grid.name
        ? HomeLayoutMode.grid
        : HomeLayoutMode.list;
  }

  Future<void> setMode(HomeLayoutMode mode) async {
    state = AsyncData(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }

  Future<void> toggle() async {
    final current = state.value ?? HomeLayoutMode.list;
    await setMode(
      current == HomeLayoutMode.grid
          ? HomeLayoutMode.list
          : HomeLayoutMode.grid,
    );
  }
}

final homeLayoutProvider =
    AsyncNotifierProvider<HomeLayoutNotifier, HomeLayoutMode>(
  HomeLayoutNotifier.new,
);

final productsProvider =
    FutureProvider.autoDispose<List<ProductWithPhoto>>((ref) {
  return ref.watch(productRepositoryProvider).listProducts();
});

final productDetailProvider =
    FutureProvider.autoDispose.family<ProductWithPhoto?, int>((ref, id) {
  return ref.watch(productRepositoryProvider).getById(id);
});
