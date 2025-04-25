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
              readOnly: true,
              decoration: appInputDecoration(
                context: context,
                hintText: "Enter Prompt Name",
                hintStyle: TextStyle(color: appGreyColor),
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Make it scrollable horizontally
                        child: Row(
                          children: controller.classificationMap.keys.map((tag) {
                            final isSelected = controller.selectedParentTag.value == tag;

                            return GestureDetector(
                              onTap: () => controller.addTag(tag),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between chips
                                child: Chip(
                                  label: Text(
                                    "# $tag",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.4) : appBackGroundColor.withOpacity(0.1),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
                    Spacer(),

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
                                          "Select Prompt",
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
                                    child: Obx(
                                      () => SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: controller.classificationMap.entries.map((entry) {
                                            final category = entry.key;
                                            final prompts = entry.value;

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Section Title
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: Text(
                                                    "#$category",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),

                                                // Prompt Chips
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: prompts.map((prompt) {
                                                    final isSelected = controller.selectedTags.contains(prompt);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        controller.addTagInherit(prompt);
                                                      },
                                                      child: Chip(
                                                        label: Text(
                                                          prompt,
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
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
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

            /// Conditionally Show Chips If Inherit Checked
            // Obx(() {
            //   if (!controller.isChecked.value || controller.selectedParentTag.value.isEmpty) {
            //     return const SizedBox.shrink();
            //   }
            //
            //   final tag = controller.selectedParentTag.value;
            //   final items = controller.classificationMap[tag] ?? [];
            //
            //   return Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Wrap(
            //         spacing: 6,
            //         runSpacing: -8,
            //         children: items
            //             .map((subTag) => GestureDetector(
            //                   onTap: () {
            //                     controller.addTagInherit(subTag);
            //                   },
            //                   child: Chip(
            //                     label: Text(subTag),
            //                     backgroundColor:
            //                         controller.selectedTags.contains(subTag) ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
            //                   ),
            //                 ))
            //             .toList(),
            //       ),
            //       12.height,
            //     ],
            //   );
            // }),
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
                    children: items.map((subTag) {
                      final isSelected = controller.selectedTags.contains(subTag);
                      return GestureDetector(
                        onTap: () {
                          controller.toggleSubTag(subTag);
                        },
                        child: Chip(
                          label: Text(
                            subTag,
                            style: TextStyle(
                              color: isSelected ? Colors.blueAccent : Colors.black,
                            ),
                          ),
                          backgroundColor: isSelected
                              ? appBackGroundColor.withOpacity(0.2)
                              : Colors.grey.shade200,
                        ),
                      );
                    }).toList(),
                  ),
                  12.height,
                ],
              );
            }),


            10.height,
            Container(
              decoration: BoxDecoration(
                color: appBackGroundColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        _buildOption("Role", Icons.person, 0),
                        _buildOption("Choose Image", Icons.folder, 1),
                        _buildOption("Metadata", Icons.info_outline_rounded, 2),
                        _buildOption("Task", Icons.list_rounded, 3),
                        _buildOption("Verify", Icons.verified, 4),
                      ],
                    ),
                    10.height,
                    Obx(() {
                      int index = controller.currentIndex.value;

                      Widget content;
                      switch (index) {
                        case 0:
                          content = buildRoleSection();
                          break;
                        case 1:
                          content = buildChooseImageSection();
                          break;
                        case 2:
                          content = buildClickSection(context);
                          break;
                        case 3:
                          content = buildTaskSection();
                          break;
                        case 4:
                          content = buildVerifySection();
                          break;
                        default:
                          content = SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: content,
                      );
                    }),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // controller.createNewPrompt();
                          if (controller.currentIndex.value < 4) {
                            controller.currentIndex.value++;
                          } else {
                            controller.currentIndex.value = 0;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBackGroundColor,
                        ),
                        child: Text("Next", style: TextStyle(color: appWhiteColor)),
                      ),
                    ),
                  ],
                ),
              ),
            )
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

  Widget buildStyledOption(String label) {
    return GestureDetector(
      onTap: () {
        // Optional: Handle label tap
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget buildRoleSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedRole.value,
                    onChanged: (String? newValue) {
                      controller.selectedRole.value = newValue!;
                      controller.fetchRolePrompt(newValue);
                    },
                    items: controller.roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                  )),
              controller.responseText.value.isNotEmpty ? 20.height : SizedBox(),
              controller.responseText.value.isNotEmpty ? Text("Response", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : SizedBox(),
              controller.responseText.value.isNotEmpty ? 8.height : SizedBox(),
              Obx(
                () => controller.responseText.value.isNotEmpty
                    ? TextField(
                        readOnly: true,
                        controller: TextEditingController(text: controller.responseText.value)
                          ..selection = TextSelection.collapsed(offset: controller.responseText.value.length),
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )
                    : SizedBox(),
              ),
              8.height,
            ],
          )),
    );
  }

  Widget buildChooseImageSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Primary Data Source',
            border: InputBorder.none,
          ),
          hint: Text("Select data sources"),
          value: controller.selectedSource.value,
          isExpanded: true,
          items: controller.dataSources.map((source) {
            return DropdownMenuItem(
              value: source,
              child: Text(source),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedSource.value = value;
          },
        );
      }),
    );
  }

  Widget buildClickSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),

        /// Selected Items Container
        Obx(
          () => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            constraints: BoxConstraints(minHeight: 48),
            child: controller.selectedItems.isEmpty
                ? Center(child: Text("No items selected", style: TextStyle(color: Colors.grey)))
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: controller.selectedItems.map((item) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item, style: TextStyle(color: Colors.blue)),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.menu, size: 16, color: Colors.blue),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'View':
                                      break;
                                    case 'Replace':
                                      showReplacePopup(
                                        context,
                                        controller.selectedFileNames[item] ?? "10.png",
                                            () {
                                          // Simulate file replace with "No file chosen"
                                          controller.selectedFileNames[item] = "";
                                        },
                                            () {
                                          controller.removeItem(item);
                                        },
                                      );
                                      break;
                                    case 'Unlock':
                                      // Handle Unlock
                                      break;
                                    case 'Remove':
                                      controller.removeItem(item);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 'View', child: Row(children: [Icon(Icons.visibility, size: 16), SizedBox(width: 6), Text("View")])),
                                  PopupMenuItem(
                                      value: 'Replace', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 6), Text("Replace")])),
                                  PopupMenuItem(
                                      value: 'Unlock', child: Row(children: [Icon(Icons.lock_open, size: 16), SizedBox(width: 6), Text("Unlock")])),
                                  PopupMenuItem(
                                      value: 'Remove', child: Row(children: [Icon(Icons.close, size: 16), SizedBox(width: 6), Text("Remove")])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
        SizedBox(height: 20),

        /// Add Buttons
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                if (controller.selectedItems.contains("Code list")) {
                  controller.removeItem("Code list");
                } else {
                  controller.addItem("Code list");
                }
              },
              child: Text('+ Code list'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (controller.selectedItems.contains("Template")) {
                  controller.removeItem("Template");
                } else {
                  controller.addItem("Template");
                }
              },
              child: Text('+ Template'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (controller.selectedItems.contains("Other")) {
                  controller.removeItem("Other");
                } else {
                  controller.addItem("Other");
                }
              },
              child: Text('+ Other'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ],
        ),

        /// Conditional Upload Section
        SizedBox(height: 20),
        Obx(() {
          final showCodeListUpload = controller.selectedItems.contains("Code list");
          final showTemplateUpload = controller.selectedItems.contains("Template");

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCodeListUpload) ...[
                Text("Upload Code list File:"),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle file pick for Code list
                      },
                      child: Text('Choose File'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                    SizedBox(width: 10),
                    Obx(() {
                      final fileName = controller.selectedFileNames["Code list"]; // or "Template"
                      return Text(
                        fileName == null || fileName.isEmpty || fileName == "No file chosen"
                            ? "No file chosen"
                            : fileName,
                      );
                    }),

                  ],
                ),
                SizedBox(height: 20),
              ],
              if (showTemplateUpload) ...[
                Text("Upload Template File:"),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle file pick for Template
                      },
                      child: Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("No file chosen"),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget buildTaskSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF6FAFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Icon(Icons.open_in_new, size: 28, color: Colors.black87),
          SizedBox(height: 12),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVerifySection() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text("Verify", style: TextStyle(fontSize: 20)),
        ElevatedButton(
          onPressed: () => controller.verifyText.value = "Verified",
          child: Text("Verify Now"),
        ),
      ],
    );
  }

  void showReplacePopup(
    BuildContext context,
    String filename,
    VoidCallback onReplace,
    VoidCallback onRemove,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.only(left: 100, top: 200), // adjust to position near the button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(filename),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.edit, size: 18, color: Colors.blue),
                onPressed: () {

                  Navigator.pop(context);
                  onReplace();
                },
                tooltip: "Replace",
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  onRemove();
                },
                tooltip: "Remove",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
