// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../colors.dart';
// import '../controllers/prompt_admin_controller.dart';
//
// class PromptAdminScreen extends StatelessWidget {
//   final PromptAdminController controller = Get.put(PromptAdminController());
//
//   final List<Widget> pages = [
//     Role(),
//     SourceType(),
//     MetaDataUser(),
//     Task(),
//     Verify(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.appBackground,
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.all(8.0),
//           children: [
//             Text("Prompt Name",
//                 style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primary)),
//             SizedBox(height: 10),
//             TextField(
//               controller: controller.inputController,
//               onEditingComplete: controller.userSubmittedData,
//               decoration: InputDecoration(
//                 hintText: "Enter Prompt Name",
//                 hintStyle: TextStyle(color: AppColors.greyColor),
//                 // suffixIcon: IconButton(
//                 //   icon: Icon(Icons.add),
//                 //   onPressed: controller.userSubmittedData,
//                 // ),
//                 filled: true,
//                 fillColor: AppColors.whiteColor,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 // border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 5),
//             Obx(() => Wrap(
//               spacing: 2.0,
//               runSpacing: 2.0,
//               children: List.generate(
//                 controller.userInput.length,
//                     (index) => GestureDetector(
//                   onTap: () => controller.setTextFromList(index),
//                   child: Chip(
//                     label: Text(controller.userInput[index]),
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                 ),
//               ),
//             )),
//             SizedBox(height: 10),
//             Obx(() => Row(
//               children: [
//                 Text("Inherit",
//                     style: TextStyle(
//                         fontSize: 18, color: AppColors.primary)),
//                 IconButton(
//                   color: AppColors.background,
//                   icon: Icon(controller.isChecked.value
//                       ? Icons.check_box
//                       : Icons.check_box_outline_blank),
//                   onPressed: controller.toggleIcon,
//                 ),
//               ],
//             )),
//             SizedBox(height: 10),
//             Container(
//               height: size.height / 2,
//               decoration: BoxDecoration(
//                 color: AppColors.background.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 8,
//                     children: [
//                       _buildOption("Role", Icons.person, 2),
//                       _buildOption("Choose Image", Icons.folder, 0),
//                       _buildOption("Click", Icons.camera_alt, 1),
//                       _buildOption("Task", Icons.list_rounded, 3),
//                       _buildOption("Verify", Icons.verified, 4),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Obx(() => Expanded(child: pages[controller.currentIndex.value])),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                         ),
//                         child:
//                         Text("Next", style: TextStyle(color: AppColors.whiteColor)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOption(String label, IconData icon, int index) {
//     return Obx(() {
//       bool isSelected = controller.currentIndex.value == index;
//
//       return GestureDetector(
//         onTap: () => controller.currentIndex.value = index,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           margin: EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             color: isSelected ? AppColors.primary : AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: AppColors.primary,
//               width: 1.5,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 20,
//                 color: isSelected ? AppColors.whiteColor : AppColors.primary,
//               ),
//               SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: isSelected ? AppColors.whiteColor : AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
//
// class RoleController extends GetxController {
//   var image = Rx<File?>(null);
//
//   Future pickImage() async {
//     try {
//       await Permission.camera.request();
//       if (await Permission.photos.isPermanentlyDenied) {
//         openAppSettings();
//       }
//       final pickedImage =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         image.value = File(pickedImage.path);
//       }
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
// }
//
// class Role extends StatelessWidget {
//   const Role({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final RoleController controller = Get.put(RoleController());
//     Size size = MediaQuery.of(context).size;
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: controller.pickImage,
//           child: Obx(() => controller.image.value != null
//               ? Image.file(
//             controller.image.value!,
//             height: size.height / 4,
//           )
//               : Card(
//             color: AppColors.cardColor,
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 "Select a file",
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           )),
//         ),
//       ],
//     );
//   }
// }
//
// class MetaDataUserController extends GetxController {
//   var selectedRole = "Select Role".obs;
//
//   void setRole(String role) {
//     selectedRole.value = role;
//   }
// }
//
// class MetaDataUser extends StatelessWidget {
//   const MetaDataUser({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MetaDataUserController());
//
//     return Container(
//       height: 250,
//       width: 250,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//             color: AppColors.cardColor,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     "User Role",
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Theme(
//                     data: ThemeData(dividerColor: Colors.transparent),
//                     child: Obx(() => ExpansionTile(
//                       title: Text(controller.selectedRole.value),
//                       children: [
//                         ...["Role 1", "Role 2", "Role 3", "Role 4"]
//                             .map((role) => ListTile(
//                           title: Text(role,
//                               style: TextStyle(fontSize: 20)),
//                           onTap: () => controller.setRole(role),
//                         ))
//                             .toList(),
//                       ],
//                     )),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SourceTypeController extends GetxController {
//   var image = Rx<File?>(null);
//
//   Future pickImage() async {
//     try {
//       await Permission.camera.request();
//       if (await Permission.photos.isPermanentlyDenied) {
//         openAppSettings();
//       }
//       final pickedImage =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//       if (pickedImage != null) {
//         image.value = File(pickedImage.path);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
// }
//
// class SourceType extends StatelessWidget {
//   const SourceType({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SourceTypeController());
//     Size size = MediaQuery.of(context).size;
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: controller.pickImage,
//           child: Obx(() => controller.image.value != null
//               ? Image.file(
//             controller.image.value!,
//             height: size.height / 4,
//           )
//               : Card(
//             color: AppColors.cardColor,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "Click A Photo",
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           )),
//         ),
//       ],
//     );
//   }
// }
//
// class TaskController extends GetxController {
//   var taskTitle = "Task".obs;
//
//   void updateTask(String newTitle) {
//     taskTitle.value = newTitle;
//   }
// }
//
// class Task extends StatelessWidget {
//   const Task({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final TaskController controller = Get.put(TaskController());
//
//     return Obx(() => Text(
//       controller.taskTitle.value,
//       style: const TextStyle(fontSize: 20),
//     ));
//   }
// }
//
// class VerifyController extends GetxController {
//   var verifyText = "Verify".obs;
//
//   void updateText(String newText) {
//     verifyText.value = newText;
//   }
// }
//
// class Verify extends StatelessWidget {
//   const Verify({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final VerifyController controller = Get.put(VerifyController());
//
//     return Obx(() => Text(
//       controller.verifyText.value,
//       style: const TextStyle(fontSize: 20),
//     ));
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
      appBarBackgroundColor: AppColors.primary,
      appBarTitleText: "Prompt Admin",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: AppColors.whiteColor,
      ),
      body:
    SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text("Prompt Name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.inputController,
              onEditingComplete: controller.userSubmittedData,
              decoration: appInputDecoration(
                context: context,
                hintText: "Enter Prompt Name",
                hintStyle: TextStyle(color: AppColors.greyColor),
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Wrap(
              spacing: 2.0,
              runSpacing: 2.0,
              children: List.generate(
                controller.userInput.length,
                    (index) => GestureDetector(
                  onTap: () => controller.setTextFromList(index),
                  child: Chip(
                    label: Text(controller.userInput[index]),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 10),
            Obx(() => Row(
              children: [
                Text("Inherit", style: TextStyle(fontSize: 18, color: AppColors.primary)),
                IconButton(
                  color: AppColors.primary,
                  icon: Icon(controller.isChecked.value
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  onPressed: controller.toggleIcon,
                ),
              ],
            )),
            const SizedBox(height: 10),
            Container(
              height: size.height / 2,
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                              color: AppColors.cardColor,
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
                              color: AppColors.cardColor,
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
                              color: AppColors.cardColor,
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
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 20),
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
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text("Next", style: TextStyle(color: AppColors.whiteColor)),
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
            color: isSelected ? AppColors.primary : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isSelected ? AppColors.whiteColor : AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.whiteColor : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
