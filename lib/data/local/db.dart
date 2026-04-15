import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

class ScanItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemCode => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get userBarcode => text().nullable()();
  TextColumn get sBarcode => text().nullable()();
  TextColumn get itemDescription => text().nullable()();
  TextColumn get scanQty => text().nullable()();
  TextColumn get adjQty => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get zoneName => text().nullable()();
  TextColumn get scQty => text().nullable()();
  TextColumn get srQty => text().nullable()();
  TextColumn get enQty => text().nullable()();
  TextColumn get createDate => text().nullable()();
  TextColumn get systemQty => text().nullable()();
  TextColumn get sQty => text().nullable()();
  TextColumn get outletCode => text().nullable()();
  TextColumn get salePrice => text().nullable()();
  TextColumn get cpu => text().nullable()();
  TextColumn get sessionId => text().nullable()();
}

class TempScanItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemCode => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get userBarcode => text().nullable()();
  TextColumn get sBarcode => text().nullable()();
  TextColumn get itemDescription => text().nullable()();
  TextColumn get scanQty => text().nullable()();
  TextColumn get adjQty => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get zoneName => text().nullable()();
  TextColumn get scQty => text().nullable()();
  TextColumn get srQty => text().nullable()();
  TextColumn get enQty => text().nullable()();
  TextColumn get createDate => text().nullable()();
  TextColumn get systemQty => text().nullable()();
  TextColumn get sQty => text().nullable()();
  TextColumn get outletCode => text().nullable()();
  TextColumn get salePrice => text().nullable()();
  TextColumn get cpu => text().nullable()();
  TextColumn get sessionId => text().nullable()();
}

class InventoryData extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get sBarcode => text().nullable()();
  TextColumn get userBarcode => text().nullable()();
  RealColumn get startQty => real().nullable()();
  RealColumn get scanQty => real().nullable()();
  TextColumn get scanStartDate => text().nullable()();
  RealColumn get mrp => real().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get cpu => real().nullable()();
}

class UsedSessionData extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().nullable()();
}

@DriftDatabase(tables: [
  ScanItems,
  TempScanItems,
  InventoryData,
  UsedSessionData,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'inventorydb'));
    return NativeDatabase(file);
  });
}
