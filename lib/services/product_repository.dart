import 'package:drift/drift.dart';

import 'package:use_by_date/data/database.dart';
import 'package:use_by_date/models/expiry_models.dart';
import 'package:use_by_date/services/expiry_notification_service.dart';
import 'package:use_by_date/services/image_store.dart';
import 'package:use_by_date/services/reminder_settings_service.dart';

class ProductWithPhoto {
  const ProductWithPhoto({
    required this.product,
    required this.photo,
    required this.resolvedImagePath,
  });

  final Product product;
  final Photo photo;
  final String resolvedImagePath;
}

class ProductRepository {
  ProductRepository({
    required this.db,
    required this.imageStore,
    required this.notifications,
    required this.reminderSettings,
  });

  final AppDatabase db;
  final ImageStore imageStore;
  final ExpiryNotificationService notifications;
  final ReminderSettingsService reminderSettings;

  Future<List<ProductWithPhoto>> listProducts() async {
    final rows = await db.getProductsByExpiry();
    final result = <ProductWithPhoto>[];
    for (final product in rows) {
      final attached = await _attachPhoto(product);
      if (attached != null) result.add(attached);
    }
    result.sort(_compareByExpiry);
    return result;
  }

  Future<ProductWithPhoto?> getById(int id) async {
    final product = await db.getProductById(id);
    if (product == null) return null;
    return _attachPhoto(product);
  }

  Future<void> createFromDrafts({
    required List<String> sourceImagePaths,
    required List<DraftProduct> drafts,
  }) async {
    final named = drafts.where((d) => d.name.trim().isNotEmpty).toList();
    if (named.isEmpty) return;
    if (sourceImagePaths.isEmpty) {
      throw StateError('At least one image is required');
    }

    final settings = await reminderSettings.load();
    final photoIdByPath = <String, int>{};

    for (final draft in named) {
      final sourcePath = draft.sourceImagePath ?? sourceImagePaths.first;
      var photoId = photoIdByPath[sourcePath];
      if (photoId == null) {
        final storedPath = await imageStore.persistImage(sourcePath);
        photoId = await db.insertPhoto(imagePath: storedPath);
        photoIdByPath[sourcePath] = photoId;
      }

      final name = draft.name.trim();
      final id = await db.insertProduct(
        ProductsCompanion.insert(
          photoId: photoId,
          name: name,
          expiryDate: Value(
            draft.expiryDate == null ? '' : formatIsoDate(draft.expiryDate!),
          ),
          expirySource: draft.expirySource ?? 'user',
          confidence: Value(draft.confidence),
          reason: Value(draft.reason ?? ''),
          notifyEnabled: Value(draft.notifyEnabled),
        ),
      );
      final saved = await db.getProductById(id);
      if (saved != null) {
        await notifications.scheduleForProduct(saved, settings);
      }
    }
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required DateTime? expiryDate,
    required bool notifyEnabled,
    String? expirySource,
    String? reason,
  }) async {
    await db.updateProduct(
      id,
      ProductsCompanion(
        name: Value(name.trim()),
        expiryDate: Value(expiryDate == null ? '' : formatIsoDate(expiryDate)),
        expirySource: Value(expirySource ?? 'user'),
        reason: Value(reason ?? ''),
        notifyEnabled: Value(notifyEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final saved = await db.getProductById(id);
    if (saved == null) return;
    final settings = await reminderSettings.load();
    await notifications.scheduleForProduct(saved, settings);
  }

  Future<void> deleteProduct(int id) async {
    final product = await db.getProductById(id);
    if (product == null) return;
    await notifications.cancelForProduct(id);
    final photoId = product.photoId;
    await db.deleteProductRow(id);
    final remaining = await db.countProductsForPhoto(photoId);
    if (remaining > 0) return;
    final photo = await db.getPhotoById(photoId);
    if (photo != null) {
      await imageStore.deleteImage(photo.imagePath);
      await db.deletePhotoRow(photoId);
    }
  }

  Future<void> deleteProducts(Iterable<int> ids) async {
    for (final id in ids) {
      await deleteProduct(id);
    }
  }

  Future<void> rescheduleAll() async {
    final settings = await reminderSettings.load();
    final products = await db.getProductsByExpiry();
    await notifications.rescheduleAll(products, settings);
  }

  Future<ProductWithPhoto?> _attachPhoto(Product product) async {
    final photo = await db.getPhotoById(product.photoId);
    if (photo == null) return null;
    final resolved = await imageStore.resolvePath(photo.imagePath);
    return ProductWithPhoto(
      product: product,
      photo: photo,
      resolvedImagePath: resolved,
    );
  }

  int _compareByExpiry(ProductWithPhoto a, ProductWithPhoto b) {
    final aDate = parseIsoDate(a.product.expiryDate);
    final bDate = parseIsoDate(b.product.expiryDate);
    if (aDate == null && bDate == null) {
      return a.product.name.compareTo(b.product.name);
    }
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    final byDate = aDate.compareTo(bDate);
    if (byDate != 0) return byDate;
    return a.product.name.compareTo(b.product.name);
  }
}
