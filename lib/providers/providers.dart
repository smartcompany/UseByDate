import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:use_by_date/data/database.dart';
import 'package:use_by_date/services/expiry_analysis_service.dart';
import 'package:use_by_date/services/expiry_notification_service.dart';
import 'package:use_by_date/services/image_store.dart';
import 'package:use_by_date/services/product_repository.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';

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

final productsProvider =
    FutureProvider.autoDispose<List<ProductWithPhoto>>((ref) {
  return ref.watch(productRepositoryProvider).listProducts();
});

final productDetailProvider =
    FutureProvider.autoDispose.family<ProductWithPhoto?, int>((ref, id) {
  return ref.watch(productRepositoryProvider).getById(id);
});
