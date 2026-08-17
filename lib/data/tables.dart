import 'package:drift/drift.dart';

class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get photoId => integer().references(Photos, #id)();
  TextColumn get name => text()();
  /// Calendar date as `YYYY-MM-DD`, or empty when unknown.
  TextColumn get expiryDate => text().withDefault(const Constant(''))();
  /// `printed` | `estimated` | `user`
  TextColumn get expirySource => text()();
  RealColumn get confidence => real().nullable()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  BoolColumn get notifyEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
