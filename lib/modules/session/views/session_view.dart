import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/session_controller.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.sessionIdList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sessionIdList.isEmpty) {
          return const Center(child: Text("No session found"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.sessionIdList.length,
                itemBuilder: (context, index) {
                  final sessionId = controller.sessionIdList[index];
                  return Obx(() => CheckboxListTile(
                    title: Text("Session - $sessionId"),
                    value: controller.selectedSessionIds.contains(sessionId),
                    onChanged: (val) => controller.toggleSession(sessionId),
                  ));
                },
              ),
            ),
            if (controller.isLoading.value)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(controller.progressMessage.value, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.saveAndDownload(),
                  child: const Text("SAVE & DOWNLOAD"),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
