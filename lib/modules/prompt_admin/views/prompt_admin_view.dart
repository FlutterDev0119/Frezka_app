
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/prompt_admin_controller.dart';

class PromptAdminScreen extends StatelessWidget {
  final PromptAdminController controller = Get.put(PromptAdminController());

  final List<Widget> pages = [
    Role(),
    SourceType(),
    MetaDataUser(),
    Task(),
    Verify(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(230, 243, 247, 248),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            Text("Prompt Name", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 83, 130, 161))),
            SizedBox(height: 10),
            // Obx(() =>
            TextField(
              controller: controller.inputController,
              onEditingComplete: controller.userSubmittedData,
              decoration: InputDecoration(
                hintText: "Enter Prompt Name",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: controller.userSubmittedData,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
      // ),
            SizedBox(height: 10),
            Obx(() => Wrap(
              spacing: 2.0,
              runSpacing: 1.0,
              children: List.generate(
                controller.userInput.length,
                    (index) => GestureDetector(
                  onTap: () => controller.setTextFromList(index),
                  child: Chip(label: Text(controller.userInput[index])),
                ),
              ),
            )),
            SizedBox(height: 10),
            Obx(() => Row(
              children: [
                Text("Inherit", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 83, 130, 161))),
                IconButton(
                  icon: Icon(controller.isChecked.value ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: controller.toggleIcon,
                ),
              ],
            )),
            SizedBox(height: 10),
            Container(
              height: size.height / 2,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 215, 219, 238),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _buildOption("Role", Icons.person, 2),
                      _buildOption("Choose Image", Icons.folder, 0),
                      _buildOption("Click", Icons.camera_alt, 1),
                      _buildOption("Task", Icons.list_rounded, 3),
                      _buildOption("Verify", Icons.verified, 4),
                    ],
                  ),
                  SizedBox(height: 10),
                   Obx(() => Expanded(child: pages[controller.currentIndex.value])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 83, 130, 161),
                        ),
                        child: Text("Next", style: TextStyle(color: Colors.white)),
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
    return GestureDetector(
      onTap: () => controller.currentIndex.value = index,
      child: Container(
        height: 35,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 247, 243, 243),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Color.fromARGB(255, 83, 130, 161)),
              SizedBox(width: 5),
              Text(label, style: TextStyle(color: Color.fromARGB(255, 83, 130, 161), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
class RoleController extends GetxController {
  var image = Rx<File?>(null);

  Future pickImage() async {
    try {
      await Permission.camera.request();
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image.value = File(pickedImage.path);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleController controller = Get.put(RoleController());
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: controller.pickImage,
          child: Obx(() => controller.image.value != null
              ? Image.file(
            controller.image.value!,
            height: size.height / 4,
          )
              : Card(
            color: const Color.fromARGB(255, 246, 246, 248),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Select a file",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
        ),
      ],
    );
  }
}
class MetaDataUserController extends GetxController {
  var selectedRole = "Select Role".obs;

  void setRole(String role) {
    selectedRole.value = role;
  }
}class MetaDataUser extends StatelessWidget {
  const MetaDataUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MetaDataUserController()); // Inject Controller

    return Container(
      height: 250,
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color.fromARGB(255, 240, 236, 236),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "User Role",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 83, 130, 161),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: Obx(() => ExpansionTile(
                      title: Text(controller.selectedRole.value),
                      children: [
                        ...["Role 1", "Role 2", "Role 3", "Role 4"]
                            .map((role) => ListTile(
                          title: Text(role, style: TextStyle(fontSize: 20)),
                          onTap: () => controller.setRole(role),
                        ))
                            .toList(),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SourceTypeController extends GetxController {
  var image = Rx<File?>(null);

  Future pickImage() async {
    try {
      await Permission.camera.request();
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image.value = File(pickedImage.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}
class SourceType extends StatelessWidget {
  const SourceType({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SourceTypeController()); // Inject Controller
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: controller.pickImage,
          child: Obx(() => controller.image.value != null
              ? Image.file(
            controller.image.value!,
            height: size.height / 4,
          )
              : Card(
            color: const Color.fromARGB(255, 247, 247, 250),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Click A Photo",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
        ),
      ],
    );
  }
}
class TaskController extends GetxController {
  var taskTitle = "Task".obs; // Reactive string

  void updateTask(String newTitle) {
    taskTitle.value = newTitle;
  }
}
class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.put(TaskController());

    return Obx(() => Text(
      controller.taskTitle.value,
      style: const TextStyle(fontSize: 20),
    ));
  }
}
class VerifyController extends GetxController {
  var verifyText = "Verify".obs; // Reactive variable

  void updateText(String newText) {
    verifyText.value = newText;
  }
}
class Verify extends StatelessWidget {
  const Verify({super.key});

  @override
  Widget build(BuildContext context) {
    final VerifyController controller = Get.put(VerifyController());

    return Obx(() => Text(
      controller.verifyText.value,
      style: const TextStyle(fontSize: 20),
    ));
  }
}