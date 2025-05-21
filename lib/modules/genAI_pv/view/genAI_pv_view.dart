import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/pdf_viewer.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../../../utils/shared_prefences.dart';
import '../../forgot_password/model/forgot_password_model.dart';
import '../../meta_phrase_pv/controllers/meta_phrase_pv_controller.dart';
import '../controllers/genAI_pv_controller.dart';
import 'package:open_file/open_file.dart' as ofx;

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
                      child: Obx(() =>
                          DropdownButton<String>(
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
                                                    onSelected: (value) async {
                                                      if (value == 'view') {
                                                        // toast('Viewing ${controller.fileNames[index]}');


                                                        File file = controller.imageFiles[index];
                                                        String filePath = file.path;
                                                        String extension = filePath
                                                            .split('.')
                                                            .last
                                                            .toLowerCase();

                                                        if (['txt', 'xml', 'csv'].contains(extension)) {
                                                          String content = await file.readAsString();
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                AlertDialog(
                                                                  title: Text('$extension File'),
                                                                  content: SingleChildScrollView(child: Text(content)),
                                                                  actions: [
                                                                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
                                                                  ],
                                                                ),
                                                          );
                                                        } else if (extension == 'pdf') {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) => PDFViewerPage(filePath: filePath),
                                                            ),
                                                          );
                                                        } else if (['png', 'jpg'].contains(extension)) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                AlertDialog(
                                                                  title: Text('Image Preview'),
                                                                  content: Image.file(file),
                                                                  actions: [
                                                                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
                                                                  ],
                                                                ),
                                                          );
                                                        } else if (['docx', 'xlsx', 'xls'].contains(extension)) {
                                                          final result = await ofx.OpenFile.open(filePath);

                                                          if (result.type != ofx.ResultType.done) {
                                                            toast("Can't open this file on your device.");
                                                          }
                                                        } else {
                                                          toast("Unsupported file type.");
                                                        }
                                                      } else if (value == 'remove') {
                                                        controller.fileNames.removeAt(index);
                                                        controller.imageFiles.removeAt(index);
                                                      }
                                                    },
                                                    icon: Icon(Icons.menu, size: 18),
                                                    itemBuilder: (context) =>
                                                    [
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
                                      builder: (_) =>
                                          AlertDialog(
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
                                            final sqlText = controller.generateSQLQuery.value.isNotEmpty
                                                ? controller.generateSQLQuery.value
                                                : 'No SQL generated';
                                            showDialog(
                                              context: Get.context!,
                                              builder: (_) =>
                                                  AlertDialog(
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
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                10.height,
                // Scrollable Header Buttons Row
                Obx(
                  () {
                    return controller.safetyReports.isNotEmpty
                        ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          _headerButton("Safety Report ID"),
                          _headerButton("Initial Receipt Date"),
                          _headerButton("Awareness Date"),
                          _headerButton("Study"),
                          _headerButton("Primary Product"),
                          _headerButton("Primary Event"),
                          _headerButton("Occur Country"),
                          _headerButton("Seriousness"),
                        ],
                      ),
                    )
                        : SizedBox();
                  }
                ),
                Obx(
                   () {
                    return controller.safetyReports.isNotEmpty ? 10.height : SizedBox();
                  }
                ), Obx(
                   () {
                    return controller.selectedReports.length.toString().isNotEmpty ?  Text('${controller.selectedReports.length} File Selected') : SizedBox();
                  }
                ),
                  Obx(
                   () {
                    return controller.safetyReports.isNotEmpty ? 10.height : SizedBox();
                  }
                ),
                Obx(
                  () {
                    return controller.safetyReports.isNotEmpty ? buildSafetyReportCards() : SizedBox();
                  }
                ),

                controller.safetyReports.isNotEmpty ? 10.height : SizedBox(),
                // Curate the Response Section
                Obx(
                  () {
                    return Container(
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
                                              itemBuilder: (context) =>
                                              [
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
                                                  controller.tags.assignAll(controller.classificationMap.keys.toList());
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
                                ),
                                2.width,
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: controller.selectedTags.isEmpty? appWhiteColor:appBackGroundColor,
                                    borderRadius: BorderRadius.circular(8), // rounded square
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.login_outlined, color:controller.selectedTags.isEmpty ? appBackGroundColor: appWhiteColor, size: 20),
                                    onPressed: () {
                                      controller
                                          .narrativeGeneration(
                                          SafetyReport: "",
                                          prompt: controller.dataLakeInput.value.toString(),

                                          checkbox: controller.selectedTags.toList(),
                                          userId: controller.id,
                                          userName: controller.Fullname)
                                          .then(
                                            (value) {
                                          controller.isAdditionalNarrative(true);
                                        },
                                      );
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
                                ///Parent tag show
                                Obx(() {
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: controller.tags.map((tag) {
                                          final isSelected = controller.selectedTags.contains(tag);

                                          return GestureDetector(
                                            onTap: () async {
                                              controller.addTag(tag);
                                              await setValue("group", tag);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between chips
                                              child: Chip(
                                                label: Text(
                                                  "+ $tag",
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
                                  );
                                }),
                                // Expanded(
                                //   child: Obx(() {
                                //     final tags = controller.tags;
                                //     return SingleChildScrollView(
                                //       scrollDirection: Axis.horizontal,
                                //       child: Row(
                                //         children: tags.map((tag) {
                                //           final isSelected = controller.selectedParentTag.value == tag;
                                //           return Padding(
                                //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                //             child: GestureDetector(
                                //               onTap: () async {
                                //                 controller.addTag(tag);
                                //                 await setValue("group", tag);
                                //               },
                                //               child: Chip(
                                //                 label: Text(
                                //                   "# $tag",
                                //                   style: TextStyle(
                                //                     fontWeight: FontWeight.w500,
                                //                     color: isSelected ? appBackGroundColor : Colors.black87,
                                //                   ),
                                //                 ),
                                //                 shape: RoundedRectangleBorder(
                                //                   borderRadius: BorderRadius.circular(8),
                                //                   side: BorderSide(
                                //                     color: isSelected ? Colors.blueAccent : Colors.transparent,
                                //                     width: 1.5,
                                //                   ),
                                //                 ),
                                //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //                 backgroundColor: isSelected ? appDashBoardCardColor : appWhiteColor,
                                //               ),
                                //             ),
                                //           );
                                //         }).toList(),
                                //       ),
                                //     );
                                //   }),
                                // ),

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
                                                        () =>
                                                        SingleChildScrollView(
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
                                                                      "# $category",
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
                                                                            labelStyle: TextStyle(
                                                                                color: isSelected ? appBackGroundColor : Colors.black87),
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
                                        controller: controller.personalizeController,
                                        onChanged: controller.updateTextState,
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
                                Obx(() {
                                  final hasText = controller.isTextNotEmpty.value;

                                  return Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: hasText ? appBackGroundColor : appWhiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.login_outlined,
                                        color: hasText ? appWhiteColor : appBackGroundColor,
                                        size: 20,
                                      ),
                                      onPressed: hasText
                                          ? () {
                                        log(controller.dataLakeInput.value);
                                        log(controller.selectedTags);
                                        log(controller.personalizeController.text);
                                        // if (controller.dataLakeInput.value.isEmpty) {
                                        //   toast("Please Include your query.");
                                        //   return;
                                        // } else {
                                        controller
                                            .additionalNarrative(
                                            query: controller.dataLakeInput.value.toString(),
                                            SafetyReport: "",
                                            checkbox: controller.selectedTags.toList(),
                                            narrative: "")
                                            .then(
                                              (value) {
                                            controller.isAdditionalNarrative(true);
                                          },
                                        );
                                        // }
                                      }
                                          : null,
                                    ),
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
                5.height,
                Obx(
                        () {
                      return controller.isAdditionalNarrative.value == true
                          ? Container(
                        width: double.infinity,
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
                              // Row(children: [
                              //   Text("AI Powered Response",style: TextStyle(fontWeight: FontWeight.w600)),
                              //
                              // ],),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.auto_awesome, size: 18),      // sparkle icon
                                    const SizedBox(width: 4),
                                    const Text(
                                      'AI Powered Response',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 8),

                                    // copy response
                                    IconButton(
                                      icon: const Icon(Icons.content_copy),
                                      tooltip: 'Copy response',
                                      onPressed: (){},//copyResponse,                     // TODO: implement
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    // show prompt
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      tooltip: 'Show prompt',
                                      onPressed:(){},// showPrompt,                       // TODO: implement
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    // download as .txt
                                    IconButton(
                                      icon: const Icon(Icons.description_outlined),
                                      tooltip: 'Download as .txt',
                                      onPressed: (){},//downloadTxt,                      // TODO: implement
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    // download as .xlsx
                                    IconButton(
                                      icon: const Icon(Icons.table_chart_outlined),
                                      tooltip: 'Download as .xlsx',
                                      onPressed:(){},// downloadXlsx,                     // TODO: implement
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    // download as .pdf
                                    IconButton(
                                      icon: const Icon(Icons.picture_as_pdf),
                                      tooltip: 'Download as .pdf',
                                      onPressed: (){},//downloadPdf,                      // TODO: implement
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),

                                    // expand / collapse
                                    IconButton(
                                      icon: const Icon(Icons.open_in_full),
                                      tooltip: 'Expand response',
                                      onPressed:(){},// toggleExpand,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              10.height,
                              Text(
                                controller.additionalNarrativeRes.value?.output ?? '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                          : SizedBox();
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerButton(String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        // color: appWhiteColor,
        decoration: BoxDecoration(
          color: appBackGroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(left: 2,right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget buildSafetyReportCards() {
    return Obx(() {
      final reports = controller.safetyReports;

      if (reports.isEmpty) {
        return const Center(child: Text("No reports found."));
      }

      return Container(
        height: 220,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: reports.length,
          itemBuilder: (context, index) {
            return _buildSafetyReportList(index); // each card
          },
        ),
      );
    });
  }

  // Widget _buildSafetyReportList(int index) {
  //   final item = controller.safetyReports[index]; // SqlDataItem
  //
  //   return Card(
  //     color: appDashBoardCardColor,
  //     margin: const EdgeInsets.symmetric(vertical: 6),
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: appBackGroundColor)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _reportRow("Safety Report ID", item.reportMeta["Safety Report ID"] ?? ''),
  //           _reportRow("Initial Receipt Date", item.reportMeta["Initial Receipt Date"] ?? ''),
  //           _reportRow("Awareness Date", item.reportMeta["Awareness Date"] ?? ''),
  //           _reportRow("Study", item.reportMeta["Study"] ?? ''),
  //           _reportRow("Primary Product", item.reportMeta["Primary Product"] ?? ''),
  //           _reportRow("Primary Event", item.reportMeta["Primary Event"] ?? ''),
  //           _reportRow("Occur Country", item.reportMeta["Occur Country"] ?? ''),
  //           _reportRow("Seriousness", item.reportMeta["Seriousness"] ?? ''),
  //           // _reportRow("Raw XML", item.xmlContent), // Optional
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSafetyReportList(int index) {
    final item = controller.safetyReports[index]; // SqlDataItem

    return Card(
      color: appDashBoardCardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: appBackGroundColor)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Checkbox(
                activeColor: appBackGroundColor,
                value: controller.selectedReports.contains(item),
                onChanged: (isSelected) {
                  if (isSelected == true) {
                    controller.selectedReports.add(item);
                      final selectedReport = controller.selectedReports.firstWhere(
                      (report) => report.reportMeta["Safety Report ID"] == item.reportMeta["Safety Report ID"],
                      orElse: () => item,
                    );
                    log("--------------${selectedReport.xmlContent}");
                    if (isSelected == true) {
                      controller.selectedReports.add(item);
                      final selectedReport = controller.selectedReports.firstWhere(
                            (report) => report.reportMeta["Safety Report ID"] == item.reportMeta["Safety Report ID"],
                        orElse: () => item,
                      );
                      log("--------------${selectedReport.xmlContent}");
                      controller.selectedXmlContents.add(selectedReport); // Add the entire SqlDataItem to the list
                    } else {
                      controller.selectedReports.remove(item);
                      controller.selectedXmlContents.remove(item); // Remove the entire SqlDataItem from the list
                    }
                  } else {
                    controller.selectedReports.remove(item);
                  }
                },
              );
            }),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _reportRow("Safety Report ID", item.reportMeta["Safety Report ID"] ?? ''),
                  _reportRow("Initial Receipt Date", item.reportMeta["Initial Receipt Date"] ?? ''),
                  _reportRow("Awareness Date", item.reportMeta["Awareness Date"] ?? ''),
                  _reportRow("Study", item.reportMeta["Study"] ?? ''),
                  _reportRow("Primary Product", item.reportMeta["Primary Product"] ?? ''),
                  _reportRow("Primary Event", item.reportMeta["Primary Event"] ?? ''),
                  _reportRow("Occur Country", item.reportMeta["Occur Country"] ?? ''),
                  _reportRow("Seriousness", item.reportMeta["Seriousness"] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
