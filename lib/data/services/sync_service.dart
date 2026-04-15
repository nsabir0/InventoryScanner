import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../repositories/inventory_repository.dart';
import '../providers/api_client.dart';
import 'storage_service.dart';

class SyncService extends GetxService {
  final InventoryRepository repository;
  final ApiClient apiClient = Get.find<ApiClient>();
  final StorageService storage = Get.find<StorageService>();

  SyncService(this.repository);

  Future<void> syncScanItems() async {
    final items = await repository.getAllScanItems();
    if (items.isEmpty) return;

    int batchSize = 10;
    for (int i = 0; i < items.length; i += batchSize) {
      int end = (i + batchSize < items.length) ? i + batchSize : items.length;
      final batch = items.sublist(i, end);

      final payload = batch
          .map((item) => {
                'UserID': item.userId,
                'DeviceID': item.deviceId,
                'SessionId': item.sessionId,
                'OutletCode': item.outletCode,
                'ZoneName': item.zoneName,
                'ItemCode': item.itemCode,
                'Barcode': item.barcode,
                'User_Barcode': item.userBarcode,
                'sBarcode': item.sBarcode,
                'ItemDescription': item.itemDescription,
                'SalePrice':
                    double.tryParse(item.salePrice ?? '0')?.toStringAsFixed(6),
                'SystemQty': item.systemQty,
                'ScanQty': item.scanQty,
                'ScQty': item.scQty,
                'AdjQty': item.adjQty,
                'SrQty': item.srQty,
                'EnQty': item.enQty,
                'Sqty': item.sQty,
                'ScanDate': item.createDate,
                'CPU': item.cpu,
              })
          .toList();

      try {
        // Build URL from storage
        String baseUrl = storage.baseUrl;
        if (!baseUrl.endsWith('/')) baseUrl += '/';
        final url = Uri.parse('${baseUrl}Data/SaveInventory');

        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;
          if (responseData['Status'] == true) {
            for (var item in batch) {
              await repository.deleteScanItem(item.id);
            }
          }
        } else {
          throw Exception(
              'HTTP ${response.statusCode}: ${response.reasonPhrase}');
        }
      } catch (e) {
        rethrow;
      }
    }
  }
}
