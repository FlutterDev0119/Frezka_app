import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../controllers/engageAI_controller.dart';

class EngageAIScreen extends StatelessWidget {
  final EngageAIController controller = Get.put(EngageAIController());

  EngageAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "GenAI PV",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final chat = controller.messages[index];
                      return Align(
                        alignment: chat.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: chat.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!chat.isUser) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage(Assets.imagesDoctor), // Correct usage
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: chat.isUser ? Colors.blueAccent : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  chat.message,
                                  style: TextStyle(color: chat.isUser ? Colors.white : Colors.black87),
                                ),
                              ),
                            ),
                            if (chat.isUser) ...[
                              const SizedBox(width: 8),
                              //
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blueAccent, // Or any background color
                                child: Text(
                                  controller.firstLetter.value, // <-- Your "SS" initials
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  )),
            ),
            if (controller.isLoading.value)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Image.asset(
                      Assets.iconsSend,
                      width: 24,
                      height: 24,
                      color: appBackGroundColor, // optional tint
                    ),
                    onPressed: () {
                      final text = controller.textController.text.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(text);
                        controller.textController.clear();
                      }
                    },
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appBackGroundColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_rounded, color: appWhiteColor),
                      onPressed: () {
                        controller.clearChat();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
