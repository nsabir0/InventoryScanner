import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/local/db.dart';
import 'package:drift/drift.dart' as drift;

import '../../../routes/app_pages.dart';

class SessionController extends GetxController {
  final InventoryRepository repository;
  final StorageService storage = Get.find<StorageService>();
  ApiService get _apiCall => Get.find<ApiClient>().apiService;

  var sessionIdList = <String>[].obs;
  var selectedSessionIds = <String>[].obs;
  var isLoading = false.obs;
  var progressMessage = "".obs;
  var progressValue = 0.0.obs;

  // For double back press
  DateTime? lastBackPress;

  SessionController(this.repository);

  @override
  void onInit() {
    super.onInit();
    selectedSessionIds.addAll(storage.sessionIds);
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    isLoading.value = true;
    try {
      final dateStr = _apiCall.getFormattedDate();

      final sessions = await _apiCall.getSessions(
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
      String errorMessage = e.toString();
      // Extract clean error message
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.split('Exception:').last.trim();
      }
      Get.snackbar(
        "Session Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
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
      Get.snackbar(
        "Error",
        "Please select at least one session.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    storage.sessionIds = selectedSessionIds;
    await repository.clearInventoryData();

    final errorMessages = <String>[];

    try {
      for (int i = 0; i < selectedSessionIds.length; i++) {
        String ssnId = selectedSessionIds[i];
        progressMessage.value =
            "Preparing Session Data (${i + 1}/${selectedSessionIds.length})...";

        final errors =
            await _downloadSessionData(ssnId, i + 1, selectedSessionIds.length);
        errorMessages.addAll(errors);
      }

      // Show completion message
      if (errorMessages.isNotEmpty) {
        Get.snackbar(
          "Completed with Errors",
          "Downloaded with ${errorMessages.length} error(s). Check logs for details.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          "Success",
          "All Session Data Saved Successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }

      // Navigate to home
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        "Download Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> _downloadSessionData(
      String ssnId, int currentSsn, int totalSsn) async {
    int currentPage = 1;
    int totalPage = 1;
    final errors = <String>[];

    do {
      progressMessage.value =
          "Saving Offline Session Data ($currentSsn/$totalSsn)\n(Dataset ${currentPage - 1}/$totalPage)";

      try {
        final sessionData = await _apiCall.getSessionData(
          sessionId: ssnId,
          pageNo: currentPage,
          dataRowSize: 80000,
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

          // Update progress
          progressValue.value = (currentPage * 100) / totalPage;
        } else {
          final errorMsg = "Status false for session $ssnId, page $currentPage";
          errors.add(errorMsg);
        }

        currentPage++;
      } catch (e) {
        final errorMsg = "Error in session: $ssnId, page: $currentPage - $e";
        errors.add(errorMsg);
        currentPage++;
      }
    } while (currentPage <= totalPage);

    return errors;
  }
}
