// import 'dart:io';
// import 'package:apps/utils/common/base_controller.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../utils/library.dart';
// import '../model/inherit_fetch_doc_model.dart';
//
// class PromptAdminController extends BaseController {
//   // Toggle States
//   var isChecked = false.obs;
//   var isSuffixVisible = false.obs;
//
//   // Index Management
//   var currentIndex = 0.obs;
//
//   // Text Editing
//   TextEditingController inputController = TextEditingController();
//
//   // Images
//   final Rx<File?> roleImage = Rx<File?>(null); // Gallery
//   final Rx<File?> sourceImage = Rx<File?>(null); // Camera
//
//   // Dropdown / Selection
//   final RxString selectedRole = "Select Role".obs;
//
//   // Headings
//   final RxString taskText = "Task".obs;
//   final RxString verifyText = "Verify".obs;
//
//   // User input tags
//   var adverseEventReportingList = <String>[].obs;
//
//   var userInput = [
//     "# Adverse Event Reporting",
//     "# Sampling",
//     "# Aggregate Reporting",
//     "# PV Agreements",
//     "# Risk Management",
//   ].obs;
//
//   /// =====================
//   /// IMAGE PICKING METHODS
//   /// =====================
//   Future<void> getInheritDoc() async {
//     if (isLoading.value) return;
//     setLoading(true);
//
//     try {
//       final PromptInherit? promptData = await PromptAdminServiceApis.getPromptInherit();
//
//       if (promptData != null) {
//         adverseEventReportingList.assignAll(promptData.adverseEventReporting);
//         Get.snackbar("Success", "Data fetched successfully!");
//       } else {
//         Get.snackbar("Error", "Failed to fetch data");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Error fetching data: ${e.toString()}");
//     } finally {
//       setLoading(false);
//     }
//   }
//
//   Future<void> pickRoleImage() async {
//     try {
//       await Permission.photos.request();
//       if (await Permission.photos.isPermanentlyDenied) {
//         openAppSettings();
//         return;
//       }
//       final pickedImage =
//           await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         roleImage.value = File(pickedImage.path);
//       }
//     } catch (e) {
//       print("Error picking role image: $e");
//     }
//   }
//
//   Future<void> pickSourceImage() async {
//     try {
//       await Permission.camera.request();
//       if (await Permission.camera.isPermanentlyDenied) {
//         openAppSettings();
//         return;
//       }
//       final pickedImage =
//           await ImagePicker().pickImage(source: ImageSource.camera);
//       if (pickedImage != null) {
//         sourceImage.value = File(pickedImage.path);
//       }
//     } catch (e) {
//       print("Error picking source image: $e");
//     }
//   }
//
//   /// =====================
//   /// TEXT & ROLE MANAGEMENT
//   /// =====================
//
//   void setRole(String role) => selectedRole.value = role;
//
//   void updateTask(String newTitle) => taskText.value = newTitle;
//
//   void updateVerifyText(String newText) => verifyText.value = newText;
//
//   /// =====================
//   /// ICON TOGGLE & INPUT
//   /// =====================
//
//   void toggleIcon() => isChecked.toggle();
//
//   void changeByUser() =>
//       isSuffixVisible.value = inputController.text.isNotEmpty;
//
//   void userSubmittedData() {
//     final input = inputController.text.trim();
//     if (input.isNotEmpty && !userInput.contains("#$input")) {
//       userInput.add("#$input");
//       inputController.clear();
//     }
//   }
//
//   void setTextFromList(int index) {
//     if (index >= 0 && index < userInput.length) {
//       inputController.text = userInput[index];
//     }
//   }
//

// }
import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  final RxList<String> adverseEventReportingList = <String>[].obs;

  // Local Static Tags
  // final RxList<String> userInput = [
  //   "# Adverse Event Reporting",
  //   "# Sampling",
  //   "# Aggregate Reporting",
  //   "# PV Agreements",
  //   "# Risk Management",
  // ].obs;

  // Images
  final Rx<File?> roleImage = Rx<File?>(null);
  final Rx<File?> sourceImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    getInheritDoc();
  }

  /// ================
  /// Fetch API Data
  /// ================
  Future<void> getInheritDoc() async {
    if (isLoading.value) return;
    setLoading(true);

    try {
      final PromptInherit? promptData =
      await PromptAdminServiceApis.getPromptInherit();

      if (promptData != null) {
        adverseEventReportingList.assignAll(promptData.adverseEventReporting);
        Get.snackbar("Success", "Data fetched successfully!");
      } else {
        Get.snackbar("Error", "Failed to fetch data");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching data: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }

  /// ================
  /// Image Pickers
  /// ================
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

  /// ================
  /// Text Management
  /// ================
  void setRole(String role) => selectedRole.value = role;

  void updateTask(String newTitle) => taskText.value = newTitle;

  void updateVerifyText(String newText) => verifyText.value = newText;

  void toggleIcon() => isChecked.toggle();

  void changeByUser() =>
      isSuffixVisible.value = inputController.text.isNotEmpty;
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
