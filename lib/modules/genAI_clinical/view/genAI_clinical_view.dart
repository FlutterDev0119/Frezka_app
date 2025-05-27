// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../../../generated/assets.dart';
// import '../../../utils/common/colors.dart';
// import '../../../utils/app_scaffold.dart';
// import '../../../utils/component/image_source_selection_component.dart';
// import '../controllers/engageAI_controller.dart';
//
// class GeneralClinicController extends GetxController {
//   var selectedFile = ''.obs;
// }
//
// class GenAIClinicalScreen extends StatelessWidget {
//   final GenAIClinicalController controller = Get.put(GenAIClinicalController());
//
//   GenAIClinicalScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       isLoading: controller.isLoading,
//       appBarBackgroundColor: appBackGroundColor,
//       appBarTitleText: "GenAI Clinical",
//       appBarTitleTextStyle: TextStyle(
//         fontSize: 20,
//         color: appWhiteColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Get.bottomSheet(
//                       enableDrag: true,
//                       isScrollControlled: true,
//                       ImageSourceSelectionComponent(
//                         onSourceSelected: (imageSource) {
//                           hideKeyboard(context);
//                           controller.onSourceSelected(imageSource);
//                         },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: appBackGroundColor),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       'Upload File',
//                       style: TextStyle(
//                         color: appBackGroundColor,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 10.width,
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.fileNames.isEmpty) {
//                       return Text('No files selected');
//                     }
//
//                     return Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: appBackGroundColor),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: controller.fileNames.asMap().entries.map((entry) {
//                             final index = entry.key;
//                             final fileName = entry.value;
//
//                             return Container(
//                               margin: EdgeInsets.only(right: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.shade100,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // File name
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 8),
//                                     child: Text(
//                                       fileName,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   // Popup menu suffix icon
//                                   PopupMenuButton<String>(
//                                     padding: EdgeInsets.zero,
//                                     onSelected: (value) {
//                                       if (value == 'view') {
//                                         toast('Viewing ${controller.fileNames[index]}');
//                                       } else if (value == 'remove') {
//                                         controller.fileNames.removeAt(index);
//                                         controller.imageFiles.removeAt(index);
//                                       }
//                                     },
//                                     icon: Icon(Icons.menu, size: 18),
//                                     itemBuilder: (context) => [
//                                       PopupMenuItem(
//                                         value: 'view',
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.remove_red_eye, size: 18),
//                                             SizedBox(width: 8),
//                                             Text('View'),
//                                           ],
//                                         ),
//                                       ),
//                                       PopupMenuItem(
//                                         value: 'remove',
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.close, size: 18, color: Colors.red),
//                                             SizedBox(width: 8),
//                                             Text('Remove', style: TextStyle(color: Colors.red)),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//
//
//             /// curate he response
//             Card(
//               margin: EdgeInsets.only(top: 24),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(Icons.build, color: Colors.blue),
//                         SizedBox(width: 8),
//                         Text(
//                           'Curate The Response',
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Ready to Use Prompts',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     // Text(
//                     //   'Selected Attributes:',
//                     //   style: TextStyle(fontWeight: FontWeight.w600),
//                     // ),
//                     Obx(() {
//                       if (controller.selectedChips.isEmpty) {
//                         return Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             'Selected Attributes',
//                             style: TextStyle(color: appGreyColor),
//                           ),
//                           //SizedBox(width: double.infinity,height: 12,), // Empty space but with a border
//                         );
//                       }
//
//                       return Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: controller.selectedChips.map((chip) {
//                               return Container(
//                                 margin: EdgeInsets.only(right: 8),
//                                 padding: EdgeInsets.symmetric(horizontal: 8),
//                                 decoration: BoxDecoration(
//                                   color: appDashBoardCardColor,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(chip),
//                                     PopupMenuButton<String>(
//                                       icon: Icon(Icons.menu, size: 18),
//                                       onSelected: (value) {
//                                         if (value == 'view') {
//                                           toast('Viewing "$chip"');
//                                         } else if (value == 'remove') {
//                                           controller.toggleChip(chip);
//                                         }
//                                       },
//                                       itemBuilder: (context) => [
//                                         PopupMenuItem(
//                                           value: 'view',
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.remove_red_eye, size: 18),
//                                               SizedBox(width: 8),
//                                               Text('View'),
//                                             ],
//                                           ),
//                                         ),
//                                         PopupMenuItem(
//                                           value: 'remove',
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.close, size: 18, color: Colors.red),
//                                               SizedBox(width: 8),
//                                               Text('Remove', style: TextStyle(color: Colors.red)),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     }),
//                     /// Filter Icon (Dropdown)
//                     GestureDetector(
//                       onTap: () {
//                         Get.dialog(
//                           Dialog(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                             child: Container(
//                               constraints: const BoxConstraints(maxHeight: 500, minWidth: 300),
//                               decoration: BoxDecoration(
//                                 color: appBackGroundColor,
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   /// Title Row with background color
//                                   Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                     decoration: BoxDecoration(
//                                       color: appBackGroundColor,
//                                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Text(
//                                           "Classification",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.close, color: Colors.white),
//                                           onPressed: () => Get.back(),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   const Divider(height: 1, thickness: 1),
//
//                                   /// Chip List Section (Full Width)
//                                   Expanded(
//                                     child: Obx(() => SingleChildScrollView(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: controller.classificationMap.entries.map((entry) {
//                                           final category = entry.key; // Clinical category, e.g., 'Investigator Analysis'
//                                           final isSelected = controller.selectedTags.contains(category);
//
//                                           return GestureDetector(
//                                             onTap: () => controller.addTag(category),
//                                             child: Chip(
//                                               label: Text(
//                                                 category,
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: isSelected ? appBackGroundColor : Colors.black87,
//                                                 ),
//                                               ),
//                                               backgroundColor: isSelected ? appBackGroundColor.withOpacity(0.2) : Colors.grey.shade200,
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                     )),
//                                   )
//
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Image.asset(
//                           Assets.iconsFilterDownArrow,
//                           width: 25,
//                           height: 25,
//                           color: appBackGroundColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Obx(() {
//                       final prompts = controller.classificationMap.values.expand((e) => e).toList();
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: prompts.map((chip) {
//                             final isSelected = controller.selectedChips.contains(chip);
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 8),
//                               child: FilterChip(
//                                 showCheckmark: false,
//                                 label: Text(chip),
//                                 selected: isSelected,
//                                 onSelected: (_) => controller.toggleChip(chip),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Personalize The Prompt',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Enter The Prompt',
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../../../utils/shared_prefences.dart';
import '../../forgot_password/model/forgot_password_model.dart';
import '../controllers/genAI_clinical_controller.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as ex;

class GenAIClinicalScreen extends StatelessWidget {
  final GenAIClinicalController controller = Get.put(GenAIClinicalController());

  GenAIClinicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "GenAI Clinical",
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
                          items: ['Upload File', 'API'].map((String value) {
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
                                                          ), // Adds a horizontal divider
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
                                      // Text(
                                      //   'Select File',
                                      //   style: primaryTextStyle(),
                                      //   overflow: TextOverflow.ellipsis,
                                      // )
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
                                                      .fetchClinical(
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
                                                            controller.fileCopyTap(true);

                                                            // final sqlText = controller.generateSQLQuery.value.isNotEmpty
                                                            //     ? controller.generateSQLQuery.value
                                                            //     : 'No SQL generated';
                                                            // showDialog(
                                                            //   context: Get.context!,
                                                            //   builder: (_) =>
                                                            //       AlertDialog(
                                                            //         title: Text("Generated SQL"),
                                                            //         content: SingleChildScrollView(
                                                            //           child: Text(sqlText),
                                                            //         ),
                                                            //         actions: [
                                                            //           AppButton(
                                                            //             color: appBackGroundColor,
                                                            //             onTap: () => Get.back(),
                                                            //             child: Text(
                                                            //               'Close',
                                                            //               style: TextStyle(color: white),
                                                            //             ),
                                                            //           )
                                                            //         ],
                                                            //       ),
                                                            // );
                                                          },
                                                          // onPressed: () {
                                                          //   final sqlText = controller.generateSQLResponse.value?.sqlQuery ?? 'No SQL generated';
                                                          //
                                                          //   showDialog(
                                                          //     context: Get.context!,
                                                          //     builder: (_) => AlertDialog(
                                                          //       title: Text("Generated SQL"),
                                                          //       content: SingleChildScrollView(
                                                          //         child: Text(sqlText),
                                                          //       ),
                                                          //       actions: [
                                                          //         AppButton(
                                                          //           color: appBackGroundColor,
                                                          //           onTap:  () => Get.back(),
                                                          //           child: Text(
                                                          //             'Close',
                                                          //             style: TextStyle(color: white),
                                                          //           ),
                                                          //         )
                                                          //       ],
                                                          //     ),
                                                          //   );
                                                          // },
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

        /// Show data of FetchClinicalDataRes with image and scrollable in both axes
        Obx(() {
          if (controller.fileCopyTap == true) {
            final res = controller.fetchClinicalData.value;
            if (res == null || res.data.isEmpty) {
              return SizedBox.shrink();
            }
            // Show the full JSON response in a scrollable box
            final prettyJson = const JsonEncoder.withIndent('  ').convert(
              res.data.map((e) => e.toJson()).toList(),
            );
            return Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: appWhiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appBackGroundColor.withOpacity(0.2)),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SelectableText(
                      prettyJson,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        }),
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
                      5.height,
                      // Display Selected Tags
                      Obx(() {
                        if (controller.selectedTags.isEmpty) {
                          return Row(
                            children: [
                              Container(
                                height: 40,
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: appWhiteColor),
                                child: Text(
                                  'Selected Attributes',
                                  style: TextStyle(color: appGreyColor),
                                ),
                              ).expand(),
                              SizedBox(width: 2),
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: appWhiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.logout, color: appBackGroundColor, size: 20),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          );
                        }
        
                        return Row(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: controller.selectedTags.map((attribute) {
                                    return Container(
                                      height: 35,
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
                                            icon: Icon(Icons.menu, size: 18),
                                            onSelected: (value) {
                                              if (value == 'view') {
                                                toast('Viewing "$attribute"');
                                              } else if (value == 'remove') {
                                                controller.removeAttribute(attribute);
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
                            ).expand(),
                            2.width,
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              width: 40,
                              // height: 40,
                              decoration: BoxDecoration(
                                color: controller.selectedTags.isEmpty? appWhiteColor:appBackGroundColor,
                                borderRadius: BorderRadius.circular(8), // rounded square
                              ),
                              child: IconButton(
                                icon: Icon(Icons.logout, color: appWhiteColor, size: 20),
                                onPressed: () {
                                  log(controller.dataLakeInput.value);
                                  log(controller.selectedTags);
                                  log(controller.personalizeController.text);

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
                                  // Handle translation
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                      10.height,
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
                          //             child: GestureDetector(
                          //               onTap: () => controller.toggleSelection(chip), // Replaced toggleChip with toggleSelection
                          //               child: FilterChip(
                          //                 label: Text(chip),
                          //                 selected: isSelected,
                          //                 onSelected: (_) => controller.toggleSelection(chip),
                          //                 // Replaced toggleChip with toggleSelection
                          //                 selectedColor: appBackGroundColor,
                          //                 backgroundColor: Colors.grey.shade200,
                          //               ),
                          //             ),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     );
                          //   }),
                          // ),
                          Expanded(
                            child: Obx(() {
                              final tags = controller.tags;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: tags.map((tag) {
                                    final isSelected = controller.selectedParentTag.value == tag;
                                    final isInSelectedTags = controller.selectedTags.contains(tag);
        
                                    final showRedBorder = isSelected && isInSelectedTags;
        
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: showRedBorder ? appBackGroundColor : Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                            color: appWhiteColor),
                                        child: GestureDetector(
                                          onTap: () async {
                                            controller.toggleSelection(tag);
                                            await setValue("group", tag);
                                          },
                                          child: Chip(
                                            label: Text(
                                              "+ $tag",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isInSelectedTags ? appBackGroundColor : Colors.black87,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              side: BorderSide(
                                                color: isInSelectedTags ? Colors.blueAccent : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: isInSelectedTags ? appDashBoardCardColor : appWhiteColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 2),
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: controller.filteredClassificationMap.entries.map((entry) {
                                                    final category = entry.key; // Investigator Analysis or Site Analysis
                                                    final attributes = entry.value;
        
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "# ${category}",
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: appWhiteColor),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: attributes.map((attribute) {
                                                            final isSelected = controller.selectedTags.contains(attribute);
                                                            log("isSelected-------------------2----$isSelected");
                                                            return GestureDetector(
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
                                child: Image.asset(
                                  Assets.iconsFilterDownArrow,
                                  width: 25,
                                  height: 25,
                                  color: appBackGroundColor,
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: appWhiteColor,
                            ),
                            child: TextField(
                              controller: controller.personalizeController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter The Prompt',
                              ),
                            ),
                          ).expand(),
                          2.width,
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: 40,
                            // height: 40,
                            decoration: BoxDecoration(
                              color: appBackGroundColor,
                              borderRadius: BorderRadius.circular(8), // rounded square
                            ),
                            child: IconButton(
                              icon: Icon(Icons.logout, color: appWhiteColor, size: 20),
                              onPressed: () {
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
                                // Handle translation
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              5.height,
              // Obx(
              //         () {
              //       return controller.isAdditionalNarrative.value == true
              //           ? Container(
              //         width: double.infinity,
              //         padding: EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           color: appBackGroundColor.withOpacity(0.3),
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 15),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               // Row(children: [
              //               //   Text("AI Powered Response",style: TextStyle(fontWeight: FontWeight.w600)),
              //               //
              //               // ],),
              //               SingleChildScrollView(
              //                 scrollDirection: Axis.horizontal,
              //                 child: Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     const Icon(Icons.auto_awesome, size: 18),      // sparkle icon
              //                     const SizedBox(width: 4),
              //                     const Text(
              //                       'AI Powered Response',
              //                       style: TextStyle(fontWeight: FontWeight.w600),
              //                     ),
              //                     const SizedBox(width: 8),
              //
              //                     // copy response
              //                     IconButton(
              //                       icon: const Icon(Icons.content_copy),
              //                       tooltip: 'Copy response',
              //                       onPressed: (){},//copyResponse,                     // TODO: implement
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //
              //                     // show prompt
              //                     IconButton(
              //                       icon: const Icon(Icons.visibility),
              //                       tooltip: 'Show prompt',
              //                       onPressed:(){},// showPrompt,                       // TODO: implement
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //
              //                     // download as .txt
              //                     IconButton(
              //                       icon: const Icon(Icons.description_outlined),
              //                       tooltip: 'Download as .txt',
              //                       onPressed: (){},//downloadTxt,                      // TODO: implement
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //
              //                     // download as .xlsx
              //                     IconButton(
              //                       icon: const Icon(Icons.table_chart_outlined),
              //                       tooltip: 'Download as .xlsx',
              //                       onPressed:(){},// downloadXlsx,                     // TODO: implement
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //
              //                     // download as .pdf
              //                     IconButton(
              //                       icon: const Icon(Icons.picture_as_pdf),
              //                       tooltip: 'Download as .pdf',
              //                       onPressed: (){},//downloadPdf,                      // TODO: implement
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //
              //                     // expand / collapse
              //                     IconButton(
              //                       icon: const Icon(Icons.open_in_full),
              //                       tooltip: 'Expand response',
              //                       onPressed:(){},// toggleExpand,
              //                       padding: EdgeInsets.zero,
              //                       constraints: const BoxConstraints(),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               10.height,
              //               Text(
              //                 controller.additionalNarrativeRes.value?.output ?? '',
              //                 style: TextStyle(fontSize: 16),
              //               ),
              //             ],
              //           ),
              //         ),
              //       )
              //           : SizedBox();
              //     }
              // )
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
                                    final text = controller.additionalNarrativeRes.value?.output ?? '';
                                    if (text.isNotEmpty) {
                                      Clipboard.setData(ClipboardData(text: text));
                                      toast('Response copied!');
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),

                                // Show prompt
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  tooltip: 'Show prompt',
                                  onPressed: () {
                                    final prompt = controller.personalizeController.text;
                                    showDialog(
                                      context: Get.context!,
                                      builder: (_) => AlertDialog(
                                        title: Text('Prompt'),
                                        content: Text(prompt.isNotEmpty ? prompt : 'No prompt available.'),
                                        actions: [
                                          AppButton(
                                            onTap: () => Get.back(),
                                            child: Text('Close',style:TextStyle(color: appWhiteColor),),
                                            color: appBackGroundColor,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),

                                // Download as .txt
                                IconButton(
                                  icon: const Icon(Icons.description_outlined),
                                  tooltip: 'Download as .txt',
                                  onPressed: () async {
                                    final text = controller.additionalNarrativeRes.value?.output ?? '';
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
                                    final text = controller.additionalNarrativeRes.value?.output ?? '';
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
                                    final text = controller.additionalNarrativeRes.value?.output ?? '';
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
                                    final text = controller.additionalNarrativeRes.value?.output ?? '';
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
                              controller.additionalNarrativeRes.value?.output ?? '',
                              style: TextStyle(fontSize: 16),
                            ).expand(),
                          )
                              : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                            controller.additionalNarrativeRes.value?.output ?? '',
                            style: TextStyle(fontSize: 16),
                            // maxLines: 5,
                            // overflow: TextOverflow.ellipsis,
                          )),)
                        ],
                      ),
                    ),
                  )
                      : SizedBox();
                },
              ),
              // controller.isAdditionalNarrative.value
              //     ? Container(
              //         width: double.infinity,
              //         padding: EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           color: appBackGroundColor.withOpacity(0.3),
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 15),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 controller.additionalNarrativeRes.value?.output ?? '',
              //                 style: TextStyle(fontSize: 16),
              //               ),
              //             ],
              //           ),
              //         ),
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
