import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/local/db.dart';
import 'package:drift/drift.dart' as drift;

import '../../../routes/app_pages.dart';

class SessionController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();
  final ApiClient apiClient = Get.find<ApiClient>();

  var sessionIdList = <String>[].obs;
  var selectedSessionIds = <String>[].obs;
  var isLoading = false.obs;
  var progressMessage = "".obs;
  var progressValue = 0.0.obs;

  SessionController(this.repository);

  @override
  void onInit() {
    super.onInit();
    selectedSessionIds.addAll(storage.sessionIds);
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    isLoading.value = true;
    try {
      final dateStr = apiClient.apiService.getFormattedDate();

      final sessions = await apiClient.apiService.getSessions(
        fromDate: '2024-01-01',
        toDate: dateStr,
      );

      sessionIdList.clear();
      for (var session in sessions) {
        bool used = await repository.isSessionUsed(session.sessionId);
        if (!used) {
          sessionIdList.add(session.sessionId);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch sessions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSession(String id) {
    if (selectedSessionIds.contains(id)) {
      selectedSessionIds.remove(id);
    } else {
      selectedSessionIds.add(id);
    }
  }

  Future<void> saveAndDownload() async {
    if (selectedSessionIds.isEmpty) {
      Get.snackbar("Error", "Please select at least one session.");
      return;
    }

    isLoading.value = true;
    storage.sessionIds = selectedSessionIds;
    await repository.clearInventoryData();

    try {
      for (int i = 0; i < selectedSessionIds.length; i++) {
        String ssnId = selectedSessionIds[i];
        progressMessage.value =
            "Preparing Session Data (${i + 1}/${selectedSessionIds.length})...";
        await _downloadSessionData(ssnId, i + 1, selectedSessionIds.length);
      }
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Download Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _downloadSessionData(
      String ssnId, int currentSsn, int totalSsn) async {
    int currentPage = 1;
    int totalPage = 1;

    do {
      progressMessage.value =
          "Downloading $ssnId\nPage $currentPage of $totalPage\n(Session $currentSsn of $totalSsn)";

      final sessionData = await apiClient.apiService.getSessionData(
        sessionId: ssnId,
        pageNo: currentPage,
        dataRowSize: 50000,
      );

      totalPage = sessionData.totalPage;

      if (sessionData.status && sessionData.data.isNotEmpty) {
        List<dynamic> data = sessionData.data;
        List<InventoryDataCompanion> companions = data.map((item) {
          return InventoryDataCompanion.insert(
            sessionId: drift.Value(item['SessionId']?.toString()),
            barcode: drift.Value(item['Barcode']?.toString()),
            sBarcode: drift.Value(item['sBarcode']?.toString()),
            userBarcode: drift.Value(item['USER_BARCODE']?.toString().trim()),
            startQty: drift.Value((item['StartQty'] as num?)?.toDouble()),
            scanQty: drift.Value((item['ScanQty'] as num?)?.toDouble()),
            scanStartDate: drift.Value(item['ScanStartDate']?.toString()),
            mrp: drift.Value((item['MRP'] as num?)?.toDouble()),
            description: drift.Value(item['Description']?.toString()),
            cpu: drift.Value((item['CPU'] as num?)?.toDouble()),
          );
        }).toList();

        await repository.addInventoryList(companions);
      }

      currentPage++;
    } while (currentPage <= totalPage);
  }
}
