import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:use_by_date/data/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Photos, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'use_by_date'));

  @override
  int get schemaVersion => 1;

  Future<List<Product>> getProductsByExpiry() {
    return (select(products)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.expiryDate,
                  mode: OrderingMode.asc,
                ),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  Future<Product?> getProductById(int id) {
    return (select(products)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Photo?> getPhotoById(int id) {
    return (select(photos)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> countProductsForPhoto(int photoId) async {
    final countExp = products.id.count();
    final query = selectOnly(products)
      ..addColumns([countExp])
      ..where(products.photoId.equals(photoId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> insertPhoto({required String imagePath}) {
    return into(photos).insert(PhotosCompanion.insert(imagePath: imagePath));
  }

  Future<int> insertProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  Future<void> updateProduct(int id, ProductsCompanion values) {
    return (update(products)..where((t) => t.id.equals(id))).write(values);
  }

  Future<void> deleteProductRow(int id) {
    return (delete(products)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deletePhotoRow(int id) {
    return (delete(photos)..where((t) => t.id.equals(id))).go();
  }
}
