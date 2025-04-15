import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/common_base.dart';
import '../controllers/prompt_admin_controller.dart';

class PromptAdminScreen extends StatelessWidget {
  final PromptAdminController controller = Get.put(PromptAdminController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Prompt Admin",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
      ),
      isLoading: controller.isLoading,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text("Prompt Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: appBackGroundColor)),
            10.height,
            TextField(
              controller: controller.inputController,
              // onEditingComplete: controller.userSubmittedData,
              decoration: appInputDecoration(
                context: context,
                hintText: "Enter Prompt Name",
                hintStyle: TextStyle(color:appGreyColor),
                filled: true,
                fillColor: appWhiteColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            10.height,

            /// Selected Tags View + Filter Icon on Right
            Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tags Section
                    Expanded(
                      child: Wrap(
                        spacing: 2.0,
                        runSpacing: 2.0,
                        children: controller.selectedTags.map((tag) {
                          final isActive = controller.selectedParentTag.value == tag;

                          return GestureDetector(
                            onTap: () => controller.selectParentTag(tag),
                            child: Chip(
                              label: Text("# $tag"),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: isActive ? appBackGroundColor.withOpacity(0.4) : appBackGroundColor.withOpacity(0.1),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// Spacer to push icon to right
                    8.width,

                    /// Filter Icon (Dropdown)
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 500, minWidth: 300),
                              decoration: BoxDecoration(
                                color: appBackGroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// Title Row with background color
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: appBackGroundColor,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Classification",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.white),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 1, thickness: 1),

                                  /// Chip List Section (Full Width)
                                  Expanded(
                                    child: Obx(() => SingleChildScrollView(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: controller.classificationMap.entries.map((entry) {
                                              final category = entry.key;
                                              final isSelected = controller.selectedTags.contains(category);

                                              return GestureDetector(
                                                onTap: () => controller.addTag(category),
                                                child: Chip(
                                                  label: Text(
                                                    category,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isSelected ? appBackGroundColor : Colors.black87,
                                                    ),
                                                  ),
                                                  backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          Assets.iconsFilterDownArrow,
                          width: 25,
                          height: 25,
                          color: appBackGroundColor,
                        ),
                      ),
                    ),
                  ],
                )),

            10.height,

            /// Inherit Checkbox
            Obx(() => Row(
                  children: [
                    Text("Inherit", style: TextStyle(fontSize: 18, color: appBackGroundColor)),
                    IconButton(
                      color: appBackGroundColor,
                      icon: Icon(controller.isChecked.value ? Icons.check_box : Icons.check_box_outline_blank),
                      onPressed: controller.toggleIcon,
                    ),
                  ],
                )),
            10.height,

            /// Conditionally Show Chips If Inherit Checked
            Obx(() {
              if (!controller.isChecked.value || controller.selectedParentTag.value.isEmpty) {
                return const SizedBox.shrink();
              }

              final tag = controller.selectedParentTag.value;
              final items = controller.classificationMap[tag] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: -8,
                    children: items
                        .map((subTag) => GestureDetector(
                              onTap: () {
                                //controller.addTag(subTag);
                              },
                              child: Chip(
                                label: Text(subTag),
                                backgroundColor: controller.selectedTags.contains(subTag) ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                              ),
                            ))
                        .toList(),
                  ),
                  12.height,
                ],
              );
            }),

            10.height,
            Container(
              height: size.height / 2,
              decoration: BoxDecoration(
                color: appBackGroundColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  10.height,
                  Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      _buildOption("Role", Icons.person, 0),
                      _buildOption("Choose Image", Icons.folder, 1),
                      _buildOption("Click", Icons.camera_alt, 2),
                      _buildOption("Task", Icons.list_rounded, 3),
                      _buildOption("Verify", Icons.verified, 4),
                    ],
                  ),
                  10.height,
                  Obx(() {
                    int index = controller.currentIndex.value;
                    if (index == 0) {
                      return Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: controller.pickImageFromGallery,
                            child: Obx(() => controller.roleImage.value != null
                                ? Image.file(controller.roleImage.value!, height: size.height / 4)
                                : Card(
                                    color: appDashBoardCardColor,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Select a file", style: TextStyle(fontSize: 20)),
                                    ),
                                  )),
                          ),
                        ),
                      );
                    } else if (index == 1) {
                      return Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: controller.pickImageFromGallery,
                            child: Obx(() => controller.roleImage.value != null
                                ? Image.file(controller.roleImage.value!, height: size.height / 4)
                                : Card(
                                    color: appDashBoardCardColor,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Choose Image from Gallery", style: TextStyle(fontSize: 20)),
                                    ),
                                  )),
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      return Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: controller.pickImageFromCamera,
                            child: Obx(() => controller.sourceImage.value != null
                                ? Image.file(controller.sourceImage.value!, height: size.height / 4)
                                : Card(
                                    color: appDashBoardCardColor,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Click A Photo", style: TextStyle(fontSize: 20)),
                                    ),
                                  )),
                          ),
                        ),
                      );
                    } else if (index == 3) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              20.height,
                              Text("Task", style: const TextStyle(fontSize: 20)),
                              ElevatedButton(
                                onPressed: () => controller.taskText.value = "Updated Task",
                                child: const Text("Update Task"),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (index == 4) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              20.height,
                              Text("Verify", style: const TextStyle(fontSize: 20)),
                              ElevatedButton(
                                onPressed: () => controller.verifyText.value = "Verified",
                                child: const Text("Verify Now"),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBackGroundColor,
                        ),
                        child: Text("Next", style: TextStyle(color: appWhiteColor)),
                      ),
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

  Widget _buildOption(String label, IconData icon, int index) {
    return Obx(() {
      bool isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.currentIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? appBackGroundColor : appWhiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appBackGroundColor, width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isSelected ? appWhiteColor : appBackGroundColor),
              6.width,
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? appWhiteColor : appBackGroundColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
