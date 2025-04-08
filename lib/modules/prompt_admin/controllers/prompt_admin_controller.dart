import 'dart:developer';
import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/library.dart';
import '../model/inherit_fetch_doc_model.dart';

class PromptAdminController extends BaseController {
  // Loading State
  var isChecked = false.obs;
  var isSuffixVisible = false.obs;
  var currentIndex = 0.obs;

  // UI Data
  final RxString selectedRole = "Select Role".obs;
  final RxString taskText = "Task".obs;
  final RxString verifyText = "Verify".obs;

  // Text Input
  final TextEditingController inputController = TextEditingController();

  // Images
  final Rx<File?> roleImage = Rx<File?>(null);
  final Rx<File?> sourceImage = Rx<File?>(null);

  final selectedTags = <String>[].obs;
  final classificationMap = <String, List<String>>{}.obs;
  final RxString selectedParentTag = ''.obs;

  void toggleIcon() => isChecked.toggle();

  void selectParentTag(String tag) {
    if (selectedParentTag.value == tag) {
      selectedParentTag.value = ''; // deselect if tapped again
    } else {
      selectedParentTag.value = tag;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInheritDoc();
  }

  /// Fetch API Data

  Future<void> getInheritDoc() async {
    if (isLoading.value) return;
    setLoading(true);

    try {
      final PromptInherit? promptData = await PromptAdminServiceApis.getPromptInherit();

      if (promptData != null) {
        classificationMap.assignAll(promptData.output);
      }
    } catch (e) {
      toast(e.toString());
      log(e.toString());
    } finally {
      setLoading(false);
    }
  }

  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  /// Image Pickers

  Future<void> pickRoleImage() async {
    await _handlePermissionAndPick(
      permission: Permission.photos,
      source: ImageSource.gallery,
      setter: (file) => roleImage.value = file,
    );
  }

  Future<void> pickSourceImage() async {
    await _handlePermissionAndPick(
      permission: Permission.camera,
      source: ImageSource.camera,
      setter: (file) => sourceImage.value = file,
    );
  }

  Future<void> _handlePermissionAndPick({
    required Permission permission,
    required ImageSource source,
    required void Function(File) setter,
  }) async {
    try {
      await permission.request();
      if (await permission.isPermanentlyDenied) {
        openAppSettings();
        return;
      }

      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setter(File(pickedImage.path));
      }
    } on PlatformException catch (e) {
      print("Image picking error: $e");
    }
  }

  /// Text Management

  void setRole(String role) => selectedRole.value = role;

  void updateTask(String newTitle) => taskText.value = newTitle;

  void updateVerifyText(String newText) => verifyText.value = newText;

  void changeByUser() => isSuffixVisible.value = inputController.text.isNotEmpty;

  //
  // void userSubmittedData() {
  //   final input = inputController.text.trim();
  //   if (input.isNotEmpty && !userInput.contains("#$input")) {
  //     userInput.add("#$input");
  //     inputController.clear();
  //   }
  // }

  // void setTextFromList(int index) {
  //   if (index >= 0 && index < userInput.length) {
  //     inputController.text = userInput[index];
  //   }
  // }
  Future<void> pickImageFromGallery() async {
    try {
      await Permission.photos.request();
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        roleImage.value = File(pickedImage.path);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      await Permission.camera.request();
      if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
      }
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        sourceImage.value = File(pickedImage.path);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
