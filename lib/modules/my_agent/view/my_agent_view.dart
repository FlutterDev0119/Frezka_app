import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/dropdown_tile.dart';
import '../../../utils/common/colors.dart';
import '../controllers/my_agent_controller.dart';

class MyAgentScreen extends StatelessWidget {
  final MyAgentController controller = Get.put(MyAgentController());

  MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
        //
        AppScaffold(
      resizeToAvoidBottomPadding: true,
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "My Agent",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agent Name Input Field
              TextField(
                decoration: appInputDecoration(
                  context: context,
                  labelText: "Enter Agent Name",
                  labelStyle: TextStyle(
                    color: appTextColor,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: controller.agentNameController,
                onChanged: (value) {
                  controller.updateAgentName(value);
                },
              ),
              10.height,

              // Chips + Text Input
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: appDashBoardCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.focusNode.requestFocus();
                    },
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // Displaying chips and text items
                              ...controller.contentItems.map((item) {
                                if (item is TextItem) {
                                  return Text(
                                    item.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appTextColor,
                                    ),
                                  );
                                } else if (item is ChipItem) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: appBackGroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: appBackGroundColor, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.chipText,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: appTextColor,
                                          ),
                                        ),
                                        4.width,
                                        GestureDetector(
                                          onTap: () {
                                            controller.contentItems.remove(item);
                                          },
                                          child: const Icon(Icons.close, color: appRedColor, size: 18),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (item is NewLineItem) {
                                  return const SizedBox(width: double.infinity);
                                } else {
                                  return const SizedBox();
                                }
                              }).toList(),

                              // Hidden transparent text field for typing
                              SizedBox(
                                width: 5,
                                child: TextField(
                                  controller: controller.textController,
                                  focusNode: controller.focusNode,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.transparent,
                                    fontSize: 16,
                                  ),
                                  cursorColor: appTextColor,
                                  onChanged: (value) {
                                    controller.updateLastTextItem(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SEND button positioned
                        Obx(
                          () => Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: controller.isSendButtonEnabled
                                  ? () async {
                                      await controller.hitlSend();
                                    }
                                  : null,
                              child: Image.asset(
                                Assets.iconsSend,
                                width: 25,
                                height: 25,
                                color: controller.isSendButtonEnabled ? appTextColor : appGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              10.height,
              // Display dynamic responses (entered text and chips)
              // Obx(() {
              //   if (controller.responseData.isNotEmpty) {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: controller.responseData.map((data) {
              //         return Container(
              //           margin: const EdgeInsets.only(bottom: 8),
              //           padding: const EdgeInsets.all(12),
              //           width: double.infinity,
              //           decoration: BoxDecoration(
              //             color: appDashBoardCardColor,
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: Text(
              //             data, // Display dynamic response (text + chips)
              //             style: TextStyle(fontSize: 16, color: appTextColor),
              //           ),
              //         );
              //       }).toList(),
              //     );
              //   } else {
              //     return const SizedBox();
              //   }
              // }),
              Obx(() {
                if (controller.responseData.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.responseData.map((data) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appDashBoardCardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data, // Dynamic response text
                                style: TextStyle(fontSize: 16, color: appTextColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: controller.isSendButtonEnabled ? () async => await controller.hitlSend() : null,
                              child: Opacity(opacity: controller.isSendButtonEnabled ? 1.0 : 0.5, child: Icon(Icons.play_circle_outline)),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                                onTap: () {
                                  // controller.viewResult();
                                },
                                child: Icon(Icons.remove_red_eye)
                                // Image.asset(
                                //   Assets.iconsIcFile,
                                //   width: 20,
                                //   height: 20,
                                //   color: appTextColor,
                                // ),
                                ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const SizedBox();
                }
              }),

              // Expansion Tiles
              DropdownTile(
                title: "Pre-Configured Test Data",
                items: controller.dropdownItems,
                controller: controller,
              ),
              DropdownTile(
                title: "Ready To Use Agents",
                items: controller.agentItems,
                controller: controller,
              ),
              DropdownTile(
                title: "Scheduler",
                items: controller.Scheduler,
                // controller: controller,
              ),
              DropdownTile(
                title: "My Agents",
                items: controller.myAgents,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
