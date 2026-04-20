import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrIsOld =
            now.difference(controller.lastPressedAt.value) >
                const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrIsOld) {
          controller.lastPressedAt.value = now;
          Get.snackbar(
            "Logout",
            "Press back again to logout",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          controller.logout();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Scanner'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Get.toNamed(Routes.SETTINGS),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => controller.logout(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Obx(() => Text(
                            controller.totalInventoryItems.value > 0
                                ? "Total Items: ${controller.totalInventoryItems.value}"
                                : "No items are found",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                            controller.sessionText.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.blueGrey),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildMenuButton(
                icon: Icons.qr_code_scanner,
                label: "SCAN ITEMS",
                onPressed: () => Get.toNamed(Routes.SCAN),
              ),
              /* const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.visibility,
                label: "VIEW SCAN ITEMS",
                onPressed: () => Get.toNamed(Routes.VIEW_SCANS),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.inventory_2,
                label: "VIEW TEMP SCAN ITEMS",
                onPressed: () => Get.toNamed(Routes.VIEW_TEMP_SCANS),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.sync,
                label: "IMPORT SESSIONS",
                onPressed: () => Get.toNamed(Routes.SESSION),
              ), */
              const SizedBox(height: 12),
              _buildMenuButton(
                icon: Icons.edit_note,
                label: "ADJUST QUANTITY",
                onPressed: () => Get.toNamed(Routes.ADJUST),
              ),
              const SizedBox(height: 24),
              // Show delete button only if there are active sessions
              if (controller.storage.sessionIds.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _showDeleteConfirmation(context),
                  child: const Text("DELETE RUNNING SESSIONS"),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final passwordController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Do you want to Delete All the running sessions?"),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Enter Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(
            onPressed: () {
              controller.deleteSessions(passwordController.text);
              Get.back();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
