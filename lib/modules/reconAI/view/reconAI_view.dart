import 'dart:io';

import 'package:apps/utils/library.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/component/app_widgets.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../controllers/reconAI_controller.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as ex;
class ReconAIScreen extends StatelessWidget {
  final ReconAIController controller = Get.put(ReconAIController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Recon AI",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: Container(
        color: AppColors.appBackground,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Source & Target Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source Section
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appDashBoardCardColor, // Light background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                              8.width,
                              Text('Source', style: boldTextStyle()),
                            ],
                          ),
                          12.height,
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: appBackGroundColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Obx(() => DropdownButton<String>(
                                      value: controller.sourceDropdownValue.value,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      items: ['Upload File', 'Data Lake'].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: primaryTextStyle()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        controller.sourceDropdownValue.value = newValue!;
                                      },
                                    )),
                              ),
                              10.height,
                              // Query Input
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
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
                                                          if (value == 'remove') {
                                                            final removedName = controller.fileNames[index];

                                                            if (removedName.startsWith('Source')) {
                                                              controller.sourceCsv.value = "";
                                                            } else if (removedName.startsWith('Target')) {
                                                              controller.targetCsv.value = "";
                                                            } else if (removedName.startsWith('Metadata')) {
                                                              controller.metadataCsv.value = "";
                                                            }

                                                            controller.fileNames.removeAt(index);
                                                            controller.imageFiles.removeAt(index);
                                                          }
                                                          // controller.fileNames.removeAt(index);
                                                          // controller.imageFiles.removeAt(index);
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
                                      }),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {
                                        controller.sourceDropdownValue.value == 'Upload File'
                                            ? Get.bottomSheet(
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                ImageSourceSelectionComponent(
                                                  onSourceSelected: (imageSource) {
                                                    hideKeyboard(context);
                                                    controller.onSourceSelected(imageSource);
                                                  },
                                                ),
                                              ).then(
                                                (value) {
                                                  print("-------------source--------------${controller.sourceCsv.value}");
                                                },
                                              )
                                            : SizedBox();
                                      },
                                      child: Obx(() {
                                        // Dynamically change icon based on dropdown value
                                        IconData icon = controller.sourceDropdownValue.value == 'Upload File' ? Icons.attach_file : Icons.cloud;
                                        return Icon(icon, color: appBackGroundColor);
                                      }),
                                    ),
                                    5.width,
                                    Obx(() {
                                      return controller.sourceDropdownValue.value == 'Upload File'
                                          ? SizedBox()
                                          : Icon(Icons.file_copy_rounded, color: appBackGroundColor);
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          12.height,
                          // Buttons
                          Row(
                            children: [
                              AppButton(
                                text: '#Report',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                              8.width,
                              AppButton(
                                text: '#Source data',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                            ],
                          ),

                          20.height,
                          // Target Section

                          Row(
                            children: [
                              Icon(Icons.cloud_done_outlined, color: Colors.green),
                              8.width,
                              Text('Target', style: boldTextStyle()),
                            ],
                          ),
                          12.height,
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
                                      value: controller.targetDropdownValue.value,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      items: ['Upload File', 'Data Lake'].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: primaryTextStyle()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        controller.targetDropdownValue.value = newValue!;
                                      },
                                    )),
                              ),
                              10.height,
                              // Query Input
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        final files = controller.targetFileNames;

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
                                                          toast('Viewing ${controller.targetFileNames[index]}');
                                                        } else if (value == 'remove') {
                                                          controller.targetFileNames.removeAt(index);
                                                          controller.targetImageFiles.removeAt(index);
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
                                      }),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          ImageSourceSelectionComponent(
                                            onSourceSelected: (imageSource) {
                                              hideKeyboard(context);
                                              controller.onTargetSourceSelected(imageSource);
                                            },
                                          ),
                                        );
                                      },
                                      child: Obx(() {
                                        // Dynamically change icon based on dropdown value
                                        IconData icon = controller.targetDropdownValue.value == 'Upload File' ? Icons.attach_file : Icons.cloud;
                                        return Icon(icon, color: appBackGroundColor);
                                      }),
                                    ),
                                    5.width,
                                    Obx(() {
                                      return controller.targetDropdownValue.value == 'Upload File'
                                          ? SizedBox()
                                          : GestureDetector(
                                              onTap: () {
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
                                              },
                                              child: Icon(Icons.file_copy_rounded, color: appBackGroundColor),
                                            );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          12.height,
                          // Buttons
                          Row(
                            children: [
                              AppButton(
                                text: '#Report',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                              8.width,
                              AppButton(
                                text: '#Source data',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appDashBoardCardColor, // Light background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MetaData", style: boldTextStyle(color: appBackGroundColor)),
                          12.height,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    final files = controller.metaFileNames;

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
                                                      toast('Viewing ${controller.metaFileNames[index]}');
                                                    } else if (value == 'remove') {
                                                      controller.metaFileNames.removeAt(index);
                                                      controller.metaImageFiles.removeAt(index);
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
                                  }),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        ImageSourceSelectionComponent(
                                          onSourceSelected: (imageSource) {
                                            hideKeyboard(context);
                                            controller.onMetaSourceSelected(imageSource);
                                          },
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.attach_file, color: appBackGroundColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 12),
                    //   padding: EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: appDashBoardCardColor, // Light background
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text("Compare Data set", style: boldTextStyle(color: appBackGroundColor)),
                    //       12.height,
                    //       Container(
                    //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Obx(() {
                    //           return Column(
                    //             children: [
                    //               Text("Ready to Use Prompts", style: boldTextStyle(color: appBackGroundColor)),
                    //               Obx(
                    //                 () => ElevatedButton(
                    //                   style: ButtonStyle(
                    //                     shape: MaterialStateProperty.all(
                    //                       RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                    //                       ),
                    //                     ),
                    //                     elevation: MaterialStateProperty.all(2.0),
                    //                     backgroundColor: MaterialStateProperty.all(
                    //                       controller.isReadyToReconcile.value ? appBackGroundColor : appWhiteColor,
                    //                     ),
                    //                     minimumSize: MaterialStateProperty.all(
                    //                       Size(double.infinity, 48.0),
                    //                     ),
                    //                   ),
                    //                   onPressed: controller.isReadyToReconcile.value
                    //                       ? () async {
                    //                           print("Source CSV:");
                    //                           print(controller.sourceCsv.value.toString());
                    //
                    //                           print("Target CSV:");
                    //                           print(controller.targetCsv.value.toString());
                    //
                    //                           print("Metadata CSV:");
                    //                           print(controller.metadataCsv.value.toString());
                    //
                    //                           controller.reconReconciliation(
                    //                             sourceCSV: controller.sourceCsv.value.toString(),
                    //                             targetCSV: controller.targetCsv.value.toString(),
                    //                             metadataCSV: controller.metadataCsv.value.toString(),
                    //                           );
                    //                         }
                    //                       : null,
                    //                   child: Text(
                    //                     "Reconciliation",
                    //                     style: boldTextStyle(
                    //                       color: controller.isReadyToReconcile.value ? appWhiteColor : appBackGroundColor,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               5.height,
                    //               AppButtonWidget(
                    //                 elevation: 0,
                    //                 text: "Recommendation",
                    //                 buttonColor: appWhiteColor,
                    //                 textStyle: boldTextStyle(color: appBackGroundColor),
                    //                 onTap: () {},
                    //               ),
                    //             ],
                    //           );
                    //         }),
                    //       ),
                    //     ],
                    //   ),
                    // )
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appDashBoardCardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Compare Data set", style: boldTextStyle(color: appBackGroundColor)),
                          12.height,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text("Ready to Use Prompts", style: boldTextStyle(color: appBackGroundColor)),
                                Obx(
                                      () => ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      ),
                                      elevation: MaterialStateProperty.all(2.0),
                                      backgroundColor: MaterialStateProperty.all(
                                        controller.isReadyToReconcile.value ? appBackGroundColor : appWhiteColor,
                                      ),
                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.0)),
                                    ),
                                    onPressed: controller.isReadyToReconcile.value
                                        ? () async {
                                      print("Source CSV:");
                                      print(controller.sourceCsv.value.toString());

                                      print("Target CSV:");
                                      print(controller.targetCsv.value.toString());

                                      print("Metadata CSV:");
                                      print(controller.metadataCsv.value.toString());

                                      controller.reconReconciliation(
                                        sourceCSV: controller.sourceCsv.value.toString(),
                                        targetCSV: controller.targetCsv.value.toString(),
                                        metadataCSV: controller.metadataCsv.value.toString(),
                                      );
                                    }
                                        : null,
                                    child: Text(
                                      "Reconciliation",
                                      style: boldTextStyle(
                                        color: controller.isReadyToReconcile.value ? appWhiteColor : appBackGroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                15.height,
                                AppButtonWidget(
                                  elevation: 0,
                                  text: "Recommendation",
                                  buttonColor: appWhiteColor,
                                  textStyle: boldTextStyle(color: appBackGroundColor),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          Obx(
                                () {
                              return controller.isLastMessageShow.value == true
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
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.auto_awesome, size: 18), // sparkle icon
                                            const SizedBox(width: 4),
                                            const Text(
                                              'AI Powered Response',
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(width: 8),

                                            // Copy response
                                            IconButton(
                                              icon: const Icon(Icons.content_copy),
                                              tooltip: 'Copy response',
                                              onPressed: () {
                                                final text = controller.lastMessage.value ?? '';
                                                if (text.isNotEmpty) {
                                                  Clipboard.setData(ClipboardData(text: text));
                                                  toast('Response copied!');
                                                }
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),

                                            // Show prompt
                                            // IconButton(
                                            //   icon: const Icon(Icons.visibility),
                                            //   tooltip: 'Show prompt',
                                            //   onPressed: () {
                                            //     final prompt = controller.personalizeController.text;
                                            //     showDialog(
                                            //       context: Get.context!,
                                            //       builder: (_) => AlertDialog(
                                            //         title: Text('Prompt'),
                                            //         content: Text(prompt.isNotEmpty ? prompt : 'No prompt available.'),
                                            //         actions: [
                                            //           AppButton(
                                            //             onTap: () => Get.back(),
                                            //             child: Text('Close',style:TextStyle(color: appWhiteColor),),
                                            //             color: appBackGroundColor,
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     );
                                            //   },
                                            //   padding: EdgeInsets.zero,
                                            //   constraints: const BoxConstraints(),
                                            // ),

                                            // Download as .txt
                                            IconButton(
                                              icon: const Icon(Icons.description_outlined),
                                              tooltip: 'Download as .txt',
                                              onPressed: () async {
                                                final text = controller.lastMessage.value ?? '';
                                                if (text.isEmpty) {
                                                  toast('No response to download.');
                                                  return;
                                                }
                                                final directory = await getTemporaryDirectory();
                                                final file = File('${directory.path}/response.txt');
                                                await file.writeAsString(text);
                                                toast('TXT downloaded to ${file.path}');
                                                await OpenFile.open(file.path);
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),

                                            // Download as .xlsx
                                            IconButton(
                                              icon: const Icon(Icons.table_chart_outlined),
                                              tooltip: 'Download as .xlsx',
                                              onPressed: () async {
                                                final text = controller.lastMessage.value ?? '';
                                                if (text.isEmpty) {
                                                  toast('No response to download.');
                                                  return;
                                                }
                                                // Simple xlsx: one cell with the response
                                                // You may want to use a package like excel: ^2.0.0

                                                final excel = ex.Excel.createExcel();
                                                final sheet = excel['Sheet1'];
                                                sheet.appendRow([ex.TextCellValue(text)]);
                                                // sheet.appendRow([text]);
                                                final directory = await getTemporaryDirectory();
                                                final file = File('${directory.path}/response.xlsx');
                                                await file.writeAsBytes(excel.encode()!);
                                                toast('XLSX downloaded to ${file.path}');
                                                await OpenFile.open(file.path);
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),

                                            // Download as .pdf
                                            IconButton(
                                              icon: const Icon(Icons.picture_as_pdf),
                                              tooltip: 'Download as .pdf',
                                              onPressed: () async {
                                                final text = controller.lastMessage.value ?? '';
                                                if (text.isEmpty) {
                                                  toast('No response to download.');
                                                  return;
                                                }
                                                // Use pdf package

                                                final pdf = pw.Document();
                                                pdf.addPage(
                                                  pw.Page(
                                                    build: (pw.Context context) => pw.Text(text),
                                                  ),
                                                );
                                                final directory = await getTemporaryDirectory();
                                                final file = File('${directory.path}/response.pdf');
                                                await file.writeAsBytes(await pdf.save());
                                                toast('PDF downloaded to ${file.path}');
                                                await OpenFile.open(file.path);
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),

                                            // // Expand / collapse
                                            // IconButton(
                                            //   icon: Obx(() => Icon(controller.isExpanded.value ? Icons.close_fullscreen : Icons.open_in_full)),
                                            //   tooltip: controller.isExpanded.value ? 'Collapse response' : 'Expand response',
                                            //   onPressed: () {
                                            //     controller.isExpanded.toggle();
                                            //   },
                                            //   padding: EdgeInsets.zero,
                                            //   constraints: const BoxConstraints(),
                                            // ),

                                            // Show response in full screen dialog
                                            IconButton(
                                              icon: const Icon(Icons.fullscreen),
                                              tooltip: 'Show response fullscreen',
                                              onPressed: () {
                                                final text = controller.lastMessage.value ?? '';
                                                showDialog(
                                                  context: Get.context!,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return Dialog(
                                                      insetPadding: EdgeInsets.zero,
                                                      backgroundColor: Colors.transparent,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            AppBar(
                                                              backgroundColor: appBackGroundColor,
                                                              automaticallyImplyLeading: false,
                                                              title: const Text('AI Powered Response', style: TextStyle(color: Colors.white)),
                                                              actions: [
                                                                IconButton(
                                                                  icon: const Icon(Icons.close, color: Colors.white),
                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(16.0),
                                                                child: SingleChildScrollView(
                                                                  child: Text(
                                                                    text,
                                                                    style: const TextStyle(fontSize: 16),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.height,
                                      Obx(() => controller.isExpanded.value
                                          ? SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          controller.lastMessage.value ?? '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                          : Text(
                                        controller.lastMessage.value ?? '',
                                        style: TextStyle(fontSize: 16),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  ),
                                ),
                              )
                               : SizedBox();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
