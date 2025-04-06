import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/library.dart';

class PromptAdminController extends GetxController {
  // Toggle States
  var isChecked = false.obs;
  var isSuffixVisible = false.obs;

  // Index Management
  var currentIndex = 0.obs;

  // Text Editing
  TextEditingController inputController = TextEditingController();

  // Images
  final Rx<File?> roleImage = Rx<File?>(null); // Gallery
  final Rx<File?> sourceImage = Rx<File?>(null); // Camera

  // Dropdown / Selection
  final RxString selectedRole = "Select Role".obs;

  // Headings
  final RxString taskText = "Task".obs;
  final RxString verifyText = "Verify".obs;

  // User input tags
  var userInput = [
    "# Adverse Event Reporting",
    "# Sampling",
    "# Aggregate Reporting",
    "# PV Agreements",
    "# Risk Management",
  ].obs;

  /// =====================
  /// IMAGE PICKING METHODS
  /// =====================

  Future<void> pickRoleImage() async {
    try {
      await Permission.photos.request();
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        roleImage.value = File(pickedImage.path);
      }
    } catch (e) {
      print("Error picking role image: $e");
    }
  }

  Future<void> pickSourceImage() async {
    try {
      await Permission.camera.request();
      if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        sourceImage.value = File(pickedImage.path);
      }
    } catch (e) {
      print("Error picking source image: $e");
    }
  }

  /// =====================
  /// TEXT & ROLE MANAGEMENT
  /// =====================

  void setRole(String role) => selectedRole.value = role;

  void updateTask(String newTitle) => taskText.value = newTitle;

  void updateVerifyText(String newText) => verifyText.value = newText;

  /// =====================
  /// ICON TOGGLE & INPUT
  /// =====================

  void toggleIcon() => isChecked.toggle();

  void changeByUser() =>
      isSuffixVisible.value = inputController.text.isNotEmpty;

  void userSubmittedData() {
    final input = inputController.text.trim();
    if (input.isNotEmpty && !userInput.contains("#$input")) {
      userInput.add("#$input");
      inputController.clear();
    }
  }

  void setTextFromList(int index) {
    if (index >= 0 && index < userInput.length) {
      inputController.text = userInput[index];
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      await Permission.photos.request();
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        sourceImage.value = File(pickedImage.path);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
