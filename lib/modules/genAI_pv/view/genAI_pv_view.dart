import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../../../utils/shared_prefences.dart';
import '../../forgot_password/model/forgot_password_model.dart';
import '../controllers/genAI_pv_controller.dart';

class GenAIPVScreen extends StatelessWidget {
  final GenAIPVController controller = Get.put(GenAIPVController());

  GenAIPVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomPadding: true,
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "GenAI PV",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
      ),
      body: Container(
        color: appDashBoardCardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Upload File Section
                Column(
                  children: [
                    // Dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: appBackGroundColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => DropdownButton<String>(
                            value: controller.genAIDropdownValue.value,
                            isExpanded: true,
                            underline: SizedBox(),
                            items: ['Upload File', 'Data Lake'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: primaryTextStyle()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              controller.genAIDropdownValue.value = newValue!;
                            },
                          )),
                    ),
                    10.height,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: controller.genAIDropdownValue.value == 'Upload File'
                                        ? Obx(() {
                                            final files = controller.fileNames;

                                            if (files.isEmpty) {
                                              return Text('Select File', style: primaryTextStyle());
                                            }

                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(files.length, (index) {
                                                  final fileName = files[index];
                                                  return Container(
                                                    margin: EdgeInsets.only(right: 8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.shade100,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 8),
                                                          child: Text(
                                                            fileName,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                        PopupMenuButton<String>(
                                                          padding: EdgeInsets.zero,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10), // Rounded corners
                                                          ),
                                                          onSelected: (value) {
                                                            if (value == 'view') {
                                                              toast('Viewing ${controller.fileNames[index]}');
                                                            } else if (value == 'remove') {
                                                              controller.fileNames.removeAt(index);
                                                              controller.imageFiles.removeAt(index);
                                                            }
                                                          },
                                                          icon: Icon(Icons.menu, size: 18),
                                                          itemBuilder: (context) => [
                                                            PopupMenuItem(
                                                              value: 'view',
                                                              child: Row(
                                                                children: [
                                                                  Icon(Icons.remove_red_eye, size: 18),
                                                                  SizedBox(width: 8),
                                                                  Text('View'),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuDivider(), // Adds a horizontal divider
                                                            PopupMenuItem(
                                                              value: 'remove',
                                                              child: Row(
                                                                children: [
                                                                  Icon(Icons.close, size: 18, color: Colors.red),
                                                                  SizedBox(width: 8),
                                                                  Text('Remove', style: TextStyle(color: Colors.red)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            );
                                          })
                                        : TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Include your query',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) => controller.dataLakeInput.value = value,
                                          )),
                                5.width,
                                Obx(() {
                                  // Icon changes dynamically
                                  IconData icon = controller.genAIDropdownValue.value == 'Upload File' ? Icons.attach_file : Icons.logout;
                                  return GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        ImageSourceSelectionComponent(
                                          onSourceSelected: (imageSource) {
                                            hideKeyboard(context);
                                            controller.onSourceSelected(imageSource);
                                          },
                                        ),
                                      );
                                    },
                                    child: icon == Icons.logout
                                        ? Container(
                                            margin: EdgeInsets.only(top: 5, bottom: 5),
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: appBackGroundColor,
                                              borderRadius: BorderRadius.circular(8), // rounded square
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.logout, color: appWhiteColor, size: 20),
                                              onPressed: () {
                                                String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);
                                                String Fullname = '';
                                                String id = '';
                                                if (userJson.isNotEmpty) {
                                                  var userMap = jsonDecode(userJson);
                                                  var userModel = UserModel.fromJson(userMap); // Replace with your actual model
                                                  Fullname = "${userModel.firstName} ${userModel.lastName}";
                                                  id = userModel.id.toString();
                                                }
                                                if (controller.genAIDropdownValue.value != 'Upload File') {
                                                  log(controller.dataLakeInput.value);
                                                  if (controller.dataLakeInput.value.isEmpty) {
                                                    toast("Please Include your query.");
                                                    return;
                                                  }

                                                  if (controller.dataLakeInput.value.isNotEmpty) {
                                                    controller
                                                        .fetchGenerateSQL(
                                                      controller.dataLakeInput.value,
                                                      userId: id,
                                                      userName: Fullname,
                                                    )
                                                        .then(
                                                      (value) {
                                                        controller.isShowSqlIcon.value = true;
                                                      },
                                                    );
                                                  }
                                                }
                                                // Handle translation
                                              },
                                            ),
                                          )
                                        : Icon(icon, color: appBackGroundColor),
                                  );
                                }),
                                5.width,
                                Obx(() {
                                  return controller.genAIDropdownValue.value == 'Upload File'
                                      ? SizedBox()
                                      : GestureDetector(onTap: () {
                                          showDialog(
                                            context: Get.context!,
                                            builder: (_) => AlertDialog(
                                              title: Text("Box"),
                                              content: Text("Open Box"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text("Close"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }, child: Obx(() {
                                          return controller.genAIDropdownValue.value == 'Upload File'
                                              ? SizedBox()
                                              : GestureDetector(
                                                  onTap: () {},
                                                  child: controller.isShowSqlIcon.value
                                                      ? Container(
                                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            color: appBackGroundColor,
                                                            borderRadius: BorderRadius.circular(8), // rounded square
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(Icons.file_copy_rounded, color: appWhiteColor, size: 20),
                                                            onPressed: () {
                                                              final sqlText = controller.generateSQLResponse.value?.sqlQuery ?? 'No SQL generated';

                                                              showDialog(
                                                                context: Get.context!,
                                                                builder: (_) => AlertDialog(
                                                                  title: Text("Generated SQL"),
                                                                  content: SingleChildScrollView(
                                                                    child: Text(sqlText),
                                                                  ),
                                                                  actions: [
                                                                    AppButton(
                                                                      color: appBackGroundColor,
                                                                      onTap: () => Get.back(),
                                                                      child: Text(
                                                                        'Close',
                                                                        style: TextStyle(color: white),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : SizedBox(),

                                                  // Icon(Icons.file_copy_rounded, color: appBackGroundColor),
                                                );
                                        }));
                                }),
                              ],
                            ),

                            // /// File list shown only if dropdown is 'Upload File'
                            // Obx(() {
                            //   if (controller.genAIDropdownValue.value != 'Upload File' || controller.fileNames.isEmpty) {
                            //     return SizedBox();
                            //   }
                            //
                            //   return Container(
                            //     margin: EdgeInsets.only(top: 12),
                            //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(color: appBackGroundColor),
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     child: SingleChildScrollView(
                            //       scrollDirection: Axis.horizontal,
                            //       child: Row(
                            //         children: controller.fileNames.asMap().entries.map((entry) {
                            //           final index = entry.key;
                            //           final fileName = entry.value;
                            //
                            //           return Container(
                            //             margin: EdgeInsets.only(right: 8),
                            //             decoration: BoxDecoration(
                            //               color: Colors.blue.shade100,
                            //               borderRadius: BorderRadius.circular(6),
                            //             ),
                            //             child: Row(
                            //               mainAxisSize: MainAxisSize.min,
                            //               children: [
                            //                 Padding(
                            //                   padding: EdgeInsets.only(left: 8),
                            //                   child: Text(
                            //                     fileName,
                            //                     overflow: TextOverflow.ellipsis,
                            //                     style: TextStyle(color: Colors.black),
                            //                   ),
                            //                 ),
                            //                 PopupMenuButton<String>(
                            //                   padding: EdgeInsets.zero,
                            //                   onSelected: (value) {
                            //                     if (value == 'view') {
                            //                       toast('Viewing ${controller.fileNames[index]}');
                            //                     } else if (value == 'remove') {
                            //                       controller.fileNames.removeAt(index);
                            //                       controller.imageFiles.removeAt(index);
                            //                     }
                            //                   },
                            //                   icon: Icon(Icons.menu, size: 18),
                            //                   itemBuilder: (context) => [
                            //                     PopupMenuItem(
                            //                       value: 'view',
                            //                       child: Row(
                            //                         children: [
                            //                           Icon(Icons.remove_red_eye, size: 18),
                            //                           SizedBox(width: 8),
                            //                           Text('View'),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                     PopupMenuItem(
                            //                       value: 'remove',
                            //                       child: Row(
                            //                         children: [
                            //                           Icon(Icons.close, size: 18, color: Colors.red),
                            //                           SizedBox(width: 8),
                            //                           Text('Remove', style: TextStyle(color: Colors.red)),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           );
                            //         }).toList(),
                            //       ),
                            //     ),
                            //   );
                            // }),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                10.height,
                // Curate the Response Section
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: appBackGroundColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.build, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Curate The Response',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ready to Use Prompts',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        4.height,
                        // Display Selected Tags
                        Obx(() {
                          if (controller.selectedTags.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: appWhiteColor),
                              child: Text(
                                'Selected Attributes',
                                style: TextStyle(color: appGreyColor),
                              ),
                            );
                          }

                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: appWhiteColor),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.selectedTags.map((attribute) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 8),
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: appDashBoardCardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(attribute),
                                        PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Rounded corners
                                          ),
                                          icon: Icon(Icons.menu, size: 18),
                                          onSelected: (value) {
                                            if (value == 'view') {
                                              toast('Viewing "$attribute"');
                                            } else if (value == 'remove') {
                                              controller.removeAttribute(attribute);
                                            } else if (value == 'edit') {
                                              toast("Edit");
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'view',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.remove_red_eye, size: 18),
                                                  SizedBox(width: 8),
                                                  Text('View'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuDivider(),
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 18),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuDivider(),
                                            PopupMenuItem(
                                              value: 'remove',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.close, size: 18, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Remove', style: TextStyle(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: appBackGroundColor,
                                borderRadius: BorderRadius.circular(8), // rounded square
                              ),
                              child: Builder(
                                builder: (context) {
                                  return IconButton(
                                    key: controller.menuKey,
                                    icon: const Icon(Icons.translate, color: Colors.white, size: 20),
                                    onPressed: () async {
                                      final RenderBox renderBox = controller.menuKey.currentContext!.findRenderObject() as RenderBox;
                                      final Offset offset = renderBox.localToGlobal(Offset.zero);
                                      final Size size = renderBox.size;

                                      final selectedLang = await showMenu<String>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        color: appWhiteColor,
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                          offset.dx,
                                          offset.dy + size.height,
                                          offset.dx + size.width,
                                          offset.dy,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            value: 'en',
                                            onTap: () {
                                              controller.tags.assignAll([
                                                "Adverse Event Reporting",
                                                "Aggregate Reporting",
                                                "Investigator Analysis",
                                                "PV Agreements",
                                                "Quality Control",
                                                "Reconciliation",
                                                "Risk Management",
                                                "Sampling",
                                                "Site Analysis",
                                                "System",
                                                "Trial Analysis",
                                              ]);
                                              // controller.getDocsLanguage(language: "en");
                                            },
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Image.asset('assets/images/flag/english.png', width: 20, height: 20),
                                                const SizedBox(width: 8),
                                                const Text("English"),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              controller.getDocsLanguage(language: "ja");
                                            },
                                            value: 'ja',
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Image.asset('assets/images/flag/japanese.png', width: 20, height: 20),
                                                const SizedBox(width: 8),
                                                const Text("Japanese"),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          PopupMenuItem(
                                            onTap: () {
                                              controller.getDocsLanguage(language: "es");
                                            },
                                            value: 'es',
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Image.asset('assets/images/flag/spanish.png', width: 20, height: 20),
                                                const SizedBox(width: 8),
                                                const Text("Spanish"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );

                                      if (selectedLang != null) {
                                        print('Selected language: $selectedLang');
                                      }
                                    },
                                  );
                                },
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.translate, color: Colors.white, size: 20),
                              //   onPressed: () async {
                              //     final selectedLang = await showMenu<String>(
                              //       context: context,
                              //       position: RelativeRect.fromLTRB(0, 0, 0, 0), // Adjust as needed
                              //       items: [
                              //         PopupMenuItem(
                              //           value: 'en',
                              //           child: Row(
                              //             children: [
                              //               Image.asset('assets/images/flag/english.png', width: 20, height: 20), // Add your US flag
                              //               const SizedBox(width: 8),
                              //               const Text("English"),
                              //             ],
                              //           ),
                              //         ),
                              //         PopupMenuItem(
                              //           value: 'ja',
                              //           child: Row(
                              //             children: [
                              //               Image.asset('assets/images/flag/japanese.png', width: 20, height: 20), // Japan flag
                              //               const SizedBox(width: 8),
                              //               const Text("Japanese"),
                              //             ],
                              //           ),
                              //         ),
                              //         PopupMenuItem(
                              //           value: 'es',
                              //           child: Row(
                              //             children: [
                              //               Image.asset('assets/images/flag/spanish.png', width: 20, height: 20), // Spain flag
                              //               const SizedBox(width: 8),
                              //               const Text("Spanish"),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //
                              //     if (selectedLang != null) {
                              //       // Handle selected language
                              //       print('Selected language: $selectedLang');
                              //     }
                              //   },
                              // ),
                            ),
                            2.width,
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: appBackGroundColor,
                                borderRadius: BorderRadius.circular(8), // rounded square
                              ),
                              child: IconButton(
                                icon: Icon(Icons.login_outlined, color: appWhiteColor, size: 20),
                                onPressed: () {
                                  // Handle send
                                },
                              ),
                            ),
                          ],
                        ),

                        // Filter Icon for Selecting Attributes
                        Row(
                          children: [
                            // Expanded(
                            //   child: Obx(() {
                            //     final prompts = controller.classificationMap.values.expand((e) => e).toList();
                            //     return SingleChildScrollView(
                            //       scrollDirection: Axis.horizontal,
                            //       child: Row(
                            //         children: prompts.map((chip) {
                            //           final isSelected = controller.selectedChips.contains(chip);
                            //           return Padding(
                            //             padding: const EdgeInsets.all(4.0),
                            //             child:
                            //                 // GestureDetector(
                            //                 //   onTap: () => controller.toggleSelection(chip), // Replaced toggleChip with toggleSelection
                            //                 //   child: FilterChip(
                            //                 //     label: Text(chip,style: TextStyle(color: appWhiteColor),),
                            //                 //     selected: isSelected,
                            //                 //     onSelected: (_) => controller.toggleSelection(chip),
                            //                 //     selectedColor: appBackGroundColor,
                            //                 //     checkmarkColor: appWhiteColor,
                            //                 //     backgroundColor: appGreyColor.withOpacity(0.7),
                            //                 //   ),
                            //                 // ),
                            //                 GestureDetector(
                            //               onTap: () => controller.toggleSelection(chip),
                            //               child: FilterChip(
                            //                 label: Text(
                            //                   "# $chip",
                            //                   style: TextStyle(
                            //                     fontWeight: FontWeight.w500,
                            //                     color: isSelected ? appBackGroundColor : Colors.black87,
                            //                   ),
                            //                 ),
                            //                 selected: isSelected,
                            //                 onSelected: (_) => controller.toggleSelection(chip),
                            //                 selectedColor: appDashBoardCardColor,
                            //                 backgroundColor: appWhiteColor,
                            //                 shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.circular(8),
                            //                   side: BorderSide(
                            //                     color: isSelected ? Colors.blueAccent : Colors.transparent,
                            //                     width: 1.5,
                            //                   ),
                            //                 ),
                            //                 showCheckmark: false,
                            //                 // to match the simple Chip style without the checkmark
                            //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            //               ),
                            //             ),
                            //           );
                            //         }).toList(),
                            //       ),
                            //     );
                            //   }),
                            // ),
                            // Expanded(
                            //   child: SingleChildScrollView(
                            //     scrollDirection: Axis.horizontal, // Make it scrollable horizontally
                            //     child: Row(
                            //       children: controller.tags.map((tag) {
                            //         final isSelected = controller.selectedParentTag.value == tag;
                            //
                            //         return GestureDetector(
                            //           onTap: () async {
                            //             controller.addTag(tag);
                            //             await setValue("group", tag);
                            //           },
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between chips
                            //             child: Chip(
                            //               label: Text(
                            //                 "# $tag",
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.w500,
                            //                   color: isSelected ? appBackGroundColor : Colors.black87,
                            //                 ),
                            //               ),
                            //               shape: RoundedRectangleBorder(
                            //                 borderRadius: BorderRadius.circular(8), // adjust the roundness
                            //                 side: BorderSide(
                            //                   color: isSelected ? Colors.blueAccent : Colors.transparent,
                            //                   width: 1.5,
                            //                 ),
                            //               ),
                            //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            //               backgroundColor: isSelected ? appDashBoardCardColor : appWhiteColor,
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Obx(() {
                                final tags = controller.tags;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: tags.map((tag) {
                                      final isSelected = controller.selectedParentTag.value == tag;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            controller.addTag(tag);
                                            await setValue("group", tag);
                                          },
                                          child: Chip(
                                            label: Text(
                                              "# $tag",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isSelected ? appBackGroundColor : Colors.black87,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
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
                                );
                              }),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(Dialog(
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
                                            // Title Row
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
                                                    "select prompt",
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
                                            Container(
                                              margin: const EdgeInsets.all(16),
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: appWhiteColor,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey.shade300),
                                              ),
                                              child: TextField(
                                                controller: controller.searchController,
                                                decoration: InputDecoration(
                                                  labelText: 'Search Attributes',
                                                  prefixIcon: Icon(Icons.search),
                                                  suffixIcon: controller.searchController.text.isNotEmpty
                                                      ? IconButton(
                                                          icon: Icon(Icons.clear),
                                                          onPressed: () {
                                                            controller.searchController.clear();
                                                          },
                                                        )
                                                      : null,
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),

                                            // Chip List Section
                                            Expanded(
                                              child: Obx(
                                                () => SingleChildScrollView(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: controller.filteredClassificationMap.entries.map((entry) {
                                                      final category = entry.key;
                                                      final attributes = entry.value;

                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              category,
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appWhiteColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: attributes.map((attribute) {
                                                              final isSelected = controller.selectedTags.contains(attribute);

                                                              return
                                                                  //   GestureDetector(
                                                                  //   onTap: () => controller.toggleAttribute(attribute),
                                                                  //   child: Chip(
                                                                  //     label: Text(
                                                                  //       "# $attribute",
                                                                  //       style: TextStyle(
                                                                  //         fontWeight: FontWeight.w500,
                                                                  //         color: isSelected ? appBackGroundColor : Colors.black87,
                                                                  //       ),
                                                                  //     ),
                                                                  //     shape: RoundedRectangleBorder(
                                                                  //       borderRadius: BorderRadius.circular(8),
                                                                  //       side: BorderSide(
                                                                  //         color: isSelected ? Colors.blueAccent : Colors.transparent,
                                                                  //         width: 1.5,
                                                                  //       ),
                                                                  //     ),
                                                                  //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  //     backgroundColor: isSelected ? appDashBoardCardColor : appWhiteColor,
                                                                  //   ),
                                                                  // );

                                                                  GestureDetector(
                                                                onTap: () => controller.toggleAttribute(attribute),
                                                                child: Chip(
                                                                  label: Text(attribute),
                                                                  backgroundColor:
                                                                      isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
                                                                  labelStyle: TextStyle(color: isSelected ? appBackGroundColor : Colors.black87),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                          const SizedBox(height: 16),
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
                                    )).then((_) {
                                      // Clear the search controller and filtered list after dialog is closed
                                      controller.searchController.clear();
                                      controller.filteredClassificationMap.assignAll(controller.classificationMap);
                                    });
                                    ;
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Personalize The Prompt',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Expanded TextField
                            Expanded(
                              child: Container(
                                height: 48, // fixed height
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  color: appWhiteColor,
                                ),
                                child: Center(
                                  // centers the text vertically
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter the prompt',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 2),

                            // Send Button with matching height
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: appWhiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.login_outlined, color: appBackGroundColor, size: 20),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
