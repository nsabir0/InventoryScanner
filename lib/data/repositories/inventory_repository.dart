import 'package:drift/drift.dart';
import '../local/db.dart';

class InventoryRepository {
  final AppDatabase db;

  InventoryRepository(this.db);

  // Scan Items
  Future<List<ScanItem>> getAllScanItems() => db.select(db.scanItems).get();

  Future<int> addScanItem(ScanItemsCompanion item) =>
      db.into(db.scanItems).insert(item);

  Future<bool> deleteScanItem(int id) =>
      (db.delete(db.scanItems)..where((t) => t.id.equals(id)))
          .go()
          .then((value) => value > 0);

  Future<ScanItem?> getSingleScanItem(String sBarcode, String mrp) async {
    final query = db.select(db.scanItems)
      ..where((t) => t.sBarcode.equals(sBarcode) & t.salePrice.equals(mrp));
    return await query.getSingleOrNull();
  }

  Future<bool> updateScanItem(ScanItem item) =>
      db.update(db.scanItems).replace(item);

  Future<void> deleteAllScanItems() => db.delete(db.scanItems).go();

  // Temp Scan Items
  Future<List<TempScanItem>> getAllTempScanItems() =>
      db.select(db.tempScanItems).get();

  Future<int> addTempScanItem(TempScanItemsCompanion item) =>
      db.into(db.tempScanItems).insert(item);

  Future<bool> deleteTempScanItem(int id) =>
      (db.delete(db.tempScanItems)..where((t) => t.id.equals(id)))
          .go()
          .then((value) => value > 0);

  Future<bool> updateTempScanItem(TempScanItem item) =>
      db.update(db.tempScanItems).replace(item);

  Future<void> deleteAllTempScanItems() => db.delete(db.tempScanItems).go();

  Future<double?> getTotalScanQty() async {
    final sumExpr = db.scanItems.scanQty.cast<double>().sum();
    final query = db.selectOnly(db.scanItems)..addColumns([sumExpr]);
    final result = await query.map((row) => row.read(sumExpr)).getSingle();
    return result;
  }

  Future<double?> getTempTotalScanQty() async {
    final sumExpr = db.tempScanItems.scanQty.cast<double>().sum();
    final query = db.selectOnly(db.tempScanItems)..addColumns([sumExpr]);
    final result = await query.map((row) => row.read(sumExpr)).getSingle();
    return result;
  }

  // Inventory Data (Offline Cache)
  Future<void> addInventoryList(List<InventoryDataCompanion> items) async {
    await db.batch((batch) {
      batch.insertAll(db.inventoryData, items);
    });
  }

  Future<void> clearInventoryData() => db.delete(db.inventoryData).go();

  Future<int> countInventoryItems() async {
    final countExp = db.inventoryData.id.count();
    final query = db.selectOnly(db.inventoryData)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }

  Future<List<InventoryDataData>> getInventoryItemByBarcode(String barcode) {
    return (db.select(db.inventoryData)
          ..where((t) => t.barcode.equals(barcode) | t.sBarcode.equals(barcode)))
        .get();
  }

  Future<InventoryDataData?> getSingleInventoryItem(String sBarcode, String mrp) async {
    final query = db.select(db.inventoryData)
      ..where((t) => t.sBarcode.equals(sBarcode) & t.mrp.equals(double.tryParse(mrp) ?? 0));
    return await query.getSingleOrNull();
  }

  Future<List<InventoryDataData>> searchInventory(String key) {
    return (db.select(db.inventoryData)
          ..where((t) =>
              t.barcode.equals(key) |
              t.sBarcode.equals(key) |
              t.userBarcode.equals(key) |
              t.description.like('%$key%')))
        .get();
  }

  // Used Sessions
  Future<void> addUsedSessions(List<String> ids) async {
    await db.batch((batch) {
      batch.insertAll(
          db.usedSessionData,
          ids
              .map(
                  (id) => UsedSessionDataCompanion.insert(sessionId: Value(id)))
              .toList());
    });
  }

  Future<bool> isSessionUsed(String id) async {
    final query = db.select(db.usedSessionData)
      ..where((t) => t.sessionId.equals(id));
    final result = await query.get();
    return result.isNotEmpty;
  }

  Future<List<String>> getUsedSessionIds() async {
    final results = await db.select(db.usedSessionData).get();
    return results.map((e) => e.sessionId ?? '').where((s) => s.isNotEmpty).toList();
  }
}
