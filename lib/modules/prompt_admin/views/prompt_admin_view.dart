import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../controllers/prompt_admin_controller.dart';

class PromptAdminScreen extends StatelessWidget {
  final PromptAdminController controller = Get.put(PromptAdminController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomPadding: true,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Prompt Admin",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
      ),
      isLoading: controller.isLoading,
      body: Container(
        color: appDashBoardCardColor,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Text("Prompt Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: appBackGroundColor)),
              10.height,
              TextField(
                controller: controller.inputController,
                // onEditingComplete: controller.userSubmittedData,
                // readOnly: true,
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
                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal, // Make it scrollable horizontally
                      //     child: Row(
                      //       children: controller.classificationMap.keys.map((tag) {
                      //         final isSelected = controller.selectedParentTag.value == tag;
                      //
                      //         return GestureDetector(
                      //           onTap: () => controller.addTag(tag),
                      //           child: Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between chips
                      //             child: Chip(
                      //               label: Text(
                      //                 "# $tag",
                      //                 style: TextStyle(
                      //                   fontWeight: FontWeight.w500,
                      //                   color: isSelected ? Colors.white : Colors.black87,
                      //                 ),
                      //               ),
                      //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //               backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.4) : appBackGroundColor.withOpacity(0.1),
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Make it scrollable horizontally
                          child: Row(
                            children: controller.tags.map((tag) {
                              final isSelected = controller.selectedParentTag.value == tag;

                              return GestureDetector(
                                onTap: () async {
                                  controller.addTag(tag);
                                  await setValue("group", tag);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between chips
                                  child: Chip(
                                    label: Text(
                                      "# $tag",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? appBackGroundColor : Colors.black87,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // adjust the roundness
                                      side: BorderSide(
                                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: isSelected ? appDashBoardCardColor : appWhiteColor,
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
                                    // Expanded(
                                    //   child: Obx(() => SingleChildScrollView(
                                    //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: controller.classificationMap.entries.map((entry) {
                                    //             final category = entry.key;
                                    //             final isSelected = controller.selectedTags.contains(category);
                                    //
                                    //             return GestureDetector(
                                    //               onTap: () => controller.addTag(category),
                                    //               child: Chip(
                                    //                 label: Text(
                                    //                   category,
                                    //                   style: TextStyle(
                                    //                     fontWeight: FontWeight.w500,
                                    //                     color: isSelected ? appBackGroundColor : Colors.black87,
                                    //                   ),
                                    //                 ),
                                    //                 backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                                    //               ),
                                    //             );
                                    //           }).toList(),
                                    //         ),
                                    //       )),
                                    // ),
                                    // Expanded(
                                    //   child: SingleChildScrollView(
                                    //     scrollDirection: Axis.vertical,
                                    //     padding: const EdgeInsets.only(right: 16, left: 10,top: 5, bottom: 1),
                                    //     child: Wrap(
                                    //       children: controller.tags.map((category) {
                                    //         final isSelected = controller.selectedTags.contains(category);
                                    //
                                    //         return GestureDetector(
                                    //           onTap: () => controller.addTag(category),
                                    //           child: Padding(
                                    //             padding: const EdgeInsets.symmetric(vertical: 2.0), // optional: adds spacing between chips
                                    //             child: Chip(
                                    //               label: Text(
                                    //                 "# $category",
                                    //                 style: TextStyle(
                                    //                   fontWeight: FontWeight.w500,
                                    //                   color: isSelected ? appBackGroundColor : Colors.black87,
                                    //                 ),
                                    //               ),
                                    //               backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       }).toList(),
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: controller.tags.map((category) {
                                            final isSelected = controller.selectedTags.contains(category);

                                            return GestureDetector(
                                              onTap: () => controller.addTag(category),
                                              child: Padding(
                                                padding: const EdgeInsets.only(), // spacing between chips
                                                child: Chip(
                                                  label: Text(
                                                    "# $category",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isSelected ? appBackGroundColor : Colors.black87,
                                                    ),
                                                  ),
                                                  backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )
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
                                                        color: appWhiteColor,
                                                      ),
                                                    ),
                                                  ),

                                                  // Prompt Chips
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: prompts.map((prompt) {
                                                      final isSelected = controller.selectedTags.contains(prompt);
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 14),
                                                        child: GestureDetector(
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
              Obx(() {
                if (!controller.isChecked.value) {
                  return SizedBox.shrink(); // If not checked, show nothing
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: -8,
                      children: controller.subTags.map((subTag) {
                        final isSelected = controller.selectedTags.contains(subTag);

                        return GestureDetector(
                          onTap: () async {
                            controller.toggleSubTag(subTag);

                            await setValue("promptName", subTag);
                          },
                          child: Chip(
                            label: Text(
                              "+ $subTag",
                              style: TextStyle(
                                color: isSelected ? Colors.blueAccent : Colors.black,
                              ),
                            ),
                            backgroundColor: isSelected ? appDashBoardCardColor : appWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? Colors.blueAccent : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),

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
              //         children: items.map((subTag) {
              //           final isSelected = controller.selectedTags.contains(subTag);
              //           return GestureDetector(
              //             onTap: () {
              //               controller.toggleSubTag(subTag);
              //             },
              //             child: Chip(
              //               label: Text(
              //                 subTag,
              //                 style: TextStyle(
              //                   color: isSelected ? Colors.blueAccent : Colors.black,
              //                 ),
              //               ),
              //               backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
              //             ),
              //           );
              //         }).toList(),
              //       ),
              //       12.height,
              //     ],
              //   );
              // }),

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
                          _buildOption("Source Type", Icons.folder, 1),
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
                            content = buildRoleSection(context);
                            break;
                          case 1:
                            content = buildChooseImageSection(context);
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
                      Obx(() {
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              // controller.createNewPrompt();
                              if (controller.currentIndex.value < 4) {
                                controller.currentIndex.value++;
                              } else {
                                controller.currentIndex.value = 0;
                              }
                              if (controller.currentIndex.value == 4) {
                                //  String promptName = getStringAsync("promptName");
                                //  String Role = getStringAsync("Role");
                                //
                                //  List<String> Sources =  controller.selectedSources.toList();
                                //  String action =  controller.actionController.text;
                                // String group = getStringAsync("group");
                                // log("promptName---------------$promptName");
                                // log("Role---------------$Role");
                                // log("Sources---------------$Sources");
                                // log("action---------------$action");
                                // log("group---------------$group");
                                String promptName = getStringAsync("promptName").trim();
                                String role = getStringAsync("Role").trim();
                                List<String> sources = controller.selectedSources.toList();
                                String action = controller.actionController.text.trim();
                                String group = getStringAsync("group").trim();

                                Map<String, dynamic> payload = {
                                  "prompt_name": promptName.isNotEmpty ? promptName : "",
                                  "role": {
                                    "user_role": role.isNotEmpty ? role : "",
                                  },
                                  "group": group.isNotEmpty ? group : "",
                                  "source": sources.isNotEmpty ? sources : [],
                                  "metadata": {},
                                  "task": action.isNotEmpty ? action : "",
                                };

                                log("Payload: ${jsonEncode(payload)}");
                                await controller.createNewPrompt(payload);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appBackGroundColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(controller.currentIndex.value == 3 ? "Save" : "Next", style: TextStyle(color: appWhiteColor)),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildOption(String label, IconData icon, int index) {
  //   return Obx(() {
  //     bool isSelected = controller.currentIndex.value == index;
  //
  //     return Expanded(
  //       child: GestureDetector(
  //         onTap: () => controller.currentIndex.value = index,
  //         child: Card(
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //           color: isSelected ? appBackGroundColor : Colors.grey.shade200,
  //           elevation: 4,
  //           // margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(icon, color: isSelected ? Colors.white : appBackGroundColor),
  //                 const SizedBox(height: 6),
  //                 Text(
  //                   label,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(
  //                     color: isSelected ? Colors.white : appBackGroundColor,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _buildOption(String label, IconData icon, int index) {
    return Obx(() {
      // Determine if the option has a value
      bool? hasValue = false;
      if (index == 0) {
        String role = getStringAsync("Role").trim();
        hasValue = role.isNotEmpty && role != "Select a Role";
      } else if (index == 1) {
        List<String> sources = controller.selectedSources.toList();
        hasValue = sources.isNotEmpty;
      } else if (index == 2) {
        String? metaCodeData = controller.selectedFileNames["Code list"];
        log("metaCodeData--------------$metaCodeData");
        String? metaTemplateData = controller.selectedTemplateFileNames["Template"];
        hasValue = metaCodeData!.isNotEmpty || metaTemplateData!.isNotEmpty;
        log("--------------hasValue----------$hasValue");
      } else if (index == 3) {
        String action = controller.actionController.text.trim();
        hasValue = action.isNotEmpty;
      }

      bool isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.currentIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? appBackGroundColor : (hasValue ? appGreenColor : appWhiteColor),
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

  Widget buildRoleSection(BuildContext context) {
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
              Text("User Role", style: Theme.of(context).textTheme.titleLarge), //TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Obx(() => Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.grey.shade400, // Change to red or another color as needed
                    //     width: 1.5,
                    //   ),
                    //   borderRadius: BorderRadius.circular(8),
                    //   color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),

                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: appDashBoardCardColor,
                      isExpanded: true,
                      underline: SizedBox(),
                      // Remove the default underline
                      value: controller.selectedRole.value,
                      onChanged: (String? newValue) async {
                        controller.selectedRole.value = newValue!;
                        if (newValue != "Select a Role") controller.fetchRolePrompt(newValue);
                        await setValue("Role", newValue);
                      },
                      items: controller.roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),
                  )),

              // Obx(() => DropdownButton<String>(
              //       isExpanded: true,
              //       value: controller.selectedRole.value,
              //       onChanged: (String? newValue) async{
              //         controller.selectedRole.value = newValue!;
              //         controller.fetchRolePrompt(newValue);
              //         await setValue("Role", newValue);
              //       },
              //       items: controller.roles.map((String role) {
              //         return DropdownMenuItem<String>(
              //           value: role,
              //           child: Text(role),
              //         );
              //       }).toList(),
              //     )),
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
                        // decoration: InputDecoration(
                        //   border: OutlineInputBorder(),
                        // ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              // width: 0.5,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              10.height,
            ],
          )),
    );
  }

  Widget buildChooseImageSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Obx(() {
        final availableSources = controller.dataSources.where((source) => !controller.selectedSources.contains(source)).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Primary Data Source",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: controller.selectedSources.isEmpty
                        ? Text(
                            "Select Data Source",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: controller.selectedSources.map((source) {
                              return Container(
                                margin: EdgeInsets.only(top: 2, bottom: 2),
                                child: Chip(
                                  label: Text(source),
                                  backgroundColor: Colors.blue.shade50,
                                  labelStyle: TextStyle(color: Colors.blue),
                                  deleteIconColor: Colors.blue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  onDeleted: () {
                                    controller.selectedSources.remove(source);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  PopupMenuButton<String>(
                    color: appDashBoardCardColor,
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      controller.selectedSources.add(value);
                      log("---------$value");
                    },
                    itemBuilder: (context) {
                      return availableSources.map((source) {
                        return PopupMenuItem<String>(
                          value: source,
                          child: Text(source),
                        );
                      }).toList();
                    },
                    enabled: availableSources.isNotEmpty,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 10),
          ],
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
                              width: item == "Other" ? 0 : 28,
                              height: 28,
                              child: Obx(() {
                                final isLocked = controller.lockStates[item] ?? true;
                                return PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  icon: item == "Other" ? SizedBox() : Icon(Icons.menu, size: 16, color: Colors.blue),
                                  onSelected: (value) {
                                    log("--------------------value----$value");
                                    switch (value) {
                                      case 'View':
                                        if (controller.selectedItems.contains("Code list")) {
                                          showViewPopup(
                                            context,
                                            controller.selectedFileNames[item] ?? "No file chosen",
                                          );
                                        }
                                        if (controller.selectedItems.contains("Template")) {
                                          showViewPopup(
                                            context,
                                            controller.selectedFileNames[item] ?? "No file chosen",
                                          );
                                        }
                                        break;
                                      case 'Replace':
                                        if (controller.selectedItems.contains("Code list")) {
                                          showReplacePopup(
                                            context,
                                            controller.selectedFileNames[item] ?? "No file chosen",
                                            () async {
                                              // First clear the old file
                                              controller.selectedFileNames[item] = "";

                                              // Now immediately open the file picker to choose new file
                                              final result = await Get.bottomSheet(
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                ImageSourceSelectionComponent(
                                                  onSourceSelected: (imageSource) {
                                                    hideKeyboard(context);
                                                    controller.onSourceSelected(imageSource, item); // pass the item name
                                                  },
                                                ),
                                              );
                                            },
                                            () {
                                              controller.removeItem(item);
                                            },
                                          );
                                        }
                                        if (controller.selectedItems.contains("Template")) {
                                          showReplacePopup(
                                            context,
                                            controller.selectedTemplateFileNames[item] ?? "No file chosen",
                                            () async {
                                              // First clear the old file
                                              controller.selectedTemplateFileNames[item] = "";

                                              // Now immediately open the file picker to choose new file
                                              final result = await Get.bottomSheet(
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                ImageSourceSelectionComponent(
                                                  onSourceSelected: (imageSource) {
                                                    hideKeyboard(context);
                                                    controller.onSourceTempSelected(imageSource, item); // pass the item name
                                                  },
                                                ),
                                              );
                                            },
                                            () {
                                              controller.removeItem(item);
                                            },
                                          );
                                        }
                                        break;
                                      case 'Unlock':
                                        controller.lockStates[item] = !(controller.lockStates[item] ?? true);
                                        break;
                                      case 'Remove':
                                        log("remove-----------------------$item");
                                        log("remove-----------------------${controller.selectedItems}");
                                        controller.removeItem(item);
                                        if ("Code list" == item) {
                                          toast("code ");
                                          controller.selectedFileNames[item] = "";
                                        }
                                        if ("Template" == item) {
                                          controller.selectedTemplateFileNames[item] = '';
                                          toast("temp");
                                        }

                                        break;
                                    }
                                  },
                                  // itemBuilder: (context) => [
                                  //   PopupMenuItem(
                                  //       value: 'View',enabled: !isLocked, child: Row(children: [Icon(Icons.visibility, size: 16), SizedBox(width: 6), Text("View")])),
                                  //   PopupMenuDivider(),
                                  //   PopupMenuItem(
                                  //       value: 'Replace',enabled: !isLocked, child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 6), Text("Replace")])),
                                  //   PopupMenuDivider(),
                                  //   // PopupMenuItem(
                                  //   //     value: 'Unlock', child: Row(children: [Icon(Icons.lock_open, size: 16), SizedBox(width: 6), Text("Unlock")])),
                                  //   PopupMenuItem(
                                  //       value: 'Unlock',
                                  //       child: Row(
                                  //         children: [
                                  //           Icon(isLocked ? Icons.lock_open : Icons.lock, size: 16),
                                  //           SizedBox(width: 6),
                                  //           Text(isLocked ? "Unlock" : "Lock"),
                                  //         ],
                                  //       )),
                                  //   PopupMenuDivider(),
                                  //   PopupMenuItem(
                                  //       value: 'Remove',enabled: !isLocked, child: Row(children: [Icon(Icons.close, size: 16), SizedBox(width: 6), Text("Remove")])),
                                  // ],
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'View',
                                      enabled: !isLocked, // disable if locked
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility, size: 16, color: isLocked ? Colors.grey : null),
                                          SizedBox(width: 6),
                                          Text("View", style: TextStyle(color: isLocked ? Colors.grey : null)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'Replace',
                                      enabled: !isLocked, // disable if locked
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 16, color: isLocked ? Colors.grey : null),
                                          SizedBox(width: 6),
                                          Text("Replace", style: TextStyle(color: isLocked ? Colors.grey : null)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'Unlock',
                                      child: Row(
                                        children: [
                                          Icon(isLocked ? Icons.lock_open : Icons.lock, size: 16),
                                          SizedBox(width: 6),
                                          Text(isLocked ? "Unlock" : "Lock"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'Remove',
                                      enabled: !isLocked, // disable if locked
                                      child: Row(
                                        children: [
                                          Icon(Icons.close, size: 16, color: isLocked ? Colors.grey : null),
                                          SizedBox(width: 6),
                                          Text("Remove", style: TextStyle(color: isLocked ? Colors.grey : null)),
                                        ],
                                      ),
                                    ),
                                  ],

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // adjust as needed
                                  ),
                                );
                              }),
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
                        Get.bottomSheet(
                          enableDrag: true,
                          isScrollControlled: true,
                          ImageSourceSelectionComponent(
                            onSourceSelected: (imageSource) {
                              hideKeyboard(context);
                              controller.onSourceSelected(imageSource, "Code list");
                            },
                          ),
                        );
                      },
                      child: Text('Choose File'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                    SizedBox(width: 10),
                    Obx(() {
                      final fileName = controller.selectedFileNames["Code list"];
                      return Expanded(
                        // or use Flexible
                        child: Marquee(
                          child: Text(
                            (fileName?.isEmpty ?? true) ? "No file chosen" : fileName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      );
                    })
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
                        Get.bottomSheet(
                          enableDrag: true,
                          isScrollControlled: true,
                          ImageSourceSelectionComponent(
                            onSourceSelected: (imageSource) {
                              hideKeyboard(context);
                              controller.onSourceTempSelected(imageSource, "Template");
                            },
                          ),
                        );
                      },
                      child: Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Obx(() {
                      final fileName = controller.selectedTemplateFileNames["Template"];
                      return Expanded(
                        // or use Flexible
                        child: Marquee(
                          child: Text(
                            (fileName?.isEmpty ?? true) ? "No file chosen" : fileName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      );
                    })
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
            child: TextField(
              controller: controller.actionController,
              maxLines: null,
              // Allow infinite lines (multiline)
              expands: true,
              // Makes the TextField fill the container
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: InputBorder.none, // Remove the default border
              ),
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerifySection() {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(child: Text("Verify", style: TextStyle(fontSize: 20, color: appWhiteColor))),

        // ElevatedButton(
        //   onPressed: () => controller.verifyText.value = "Verified",
        //   child: Text("Verify Now"),
        // ),
      ],
    );
  }

  void showViewPopup(
    BuildContext context,
    String filename,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3), // slight background dim
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            3.width,
            Expanded(
              child: Text(
                filename,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: "Close",
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  void showReplacePopup(BuildContext context, String filename, VoidCallback onReplace, VoidCallback onRemove) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Replace File'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  filename.isEmpty ? "No file chosen" : filename,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.close, color: Colors.red),
              //   onPressed: () {
              //     Navigator.pop(context);
              //     onRemove();
              //   },
              //   tooltip: 'Remove',
              // ),
            ],
          ),
          actions: [
            AppButton(
              child: Text('Cancel'),
              onTap: () {
                Get.back();
              },
            ),
            filename.isEmpty
                ? SizedBox()
                : AppButton(
                    color: appBackGroundColor,
                    child: Text(
                      'Replace',
                      style: TextStyle(color: appWhiteColor),
                    ),
                    onTap: () {
                      Get.back();
                      onReplace();
                    },
                  ),
          ],
        );
      },
    );
  }
}
