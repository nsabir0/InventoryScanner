import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/session_controller.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Double back press to exit like native Android
        await _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Sessions'),
          centerTitle: true,
        ),
        body: Obx(() {
          // Show loading when fetching session list
          if (controller.isLoading.value && controller.sessionIdList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Fetching Sessions..."),
                ],
              ),
            );
          }

          // No sessions found
          if (controller.sessionIdList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Session Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "All sessions have been used or no sessions available",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Go Back"),
                  ),
                ],
              ),
            );
          }

          // Show session list with checkboxes
          return Column(
            children: [
              // Session count header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${controller.sessionIdList.length} sessions available. Select sessions to download.",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Session list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.sessionIdList.length,
                  itemBuilder: (context, index) {
                    final sessionId = controller.sessionIdList[index];
                    return Obx(() => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: CheckboxListTile(
                            title: Text(
                              "Session - $sessionId",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "Tap to select for download",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            value: controller.selectedSessionIds
                                .contains(sessionId),
                            onChanged: (val) =>
                                controller.toggleSession(sessionId),
                            activeColor: Colors.blue,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ));
                  },
                ),
              ),

              // Progress indicator during download
              if (controller.isLoading.value)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        controller.progressMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => LinearProgressIndicator(
                            value: controller.progressValue.value > 0
                                ? controller.progressValue.value / 100
                                : null,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          )),
                    ],
                  ),
                ),

              // Save & Download button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _showDownloadConfirmation(),
                    icon: const Icon(Icons.download),
                    label: const Text(
                      "SAVE & DOWNLOAD",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Double back press implementation
    final DateTime now = DateTime.now();
    if (controller.lastBackPress != null &&
        now.difference(controller.lastBackPress!) <
            const Duration(seconds: 2)) {
      return true;
    }
    controller.lastBackPress = now;
    Get.snackbar(
      "Exit",
      "Press back again to exit",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    return false;
  }

  void _showDownloadConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Do you want to download the selected sessions?"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "This will clear existing inventory data and download ${controller.selectedSessionIds.length} session(s).",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.saveAndDownload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }
}
