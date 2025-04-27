import 'dart:developer';
import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../../utils/library.dart';
import '../model/inherit_fetch_doc_model.dart';
import '../model/new_prompt_response_model.dart';
import '../model/role_model.dart';

class PromptAdminController extends BaseController {
  // Loading State
  var isChecked = false.obs;
  var isSuffixVisible = false.obs;
  var currentIndex = 0.obs;

  // UI Data
  final RxString selectedRole = "Select a Role".obs;
  final RxString taskText = "Task".obs;
  final RxString verifyText = "Verify".obs;

  // Text Input
  final TextEditingController inputController = TextEditingController();

  // Images
  final Rx<File?> roleImage = Rx<File?>(null);
  final Rx<File?> sourceImage = Rx<File?>(null);

  final selectedTags = <String>[].obs;
  final selectedTagsInherit = <String>[].obs;
  final classificationMap = <String, List<String>>{}.obs;
  final RxString selectedParentTag = ''.obs;

  RxString responseText = ''.obs;

  final roles = [
    'Select a Role',
    'Case Intake User',
    'Case Data Entry Analyst',
    'Aggregate Reports Author',
    'Safety Scientist',
    'Drug Safety Associate',
    'Clinical Devops Specialist',
    'Clinical Research Associate',
  ].obs;

  var selectedSources = <String>[].obs;
  final List<String> dataSources = ['XML', 'PDF', 'DOCX', 'XLSX','Data Lake','API'].obs;
  // var selectedSource = RxnString();

  var selectedItems = <String>[].obs;
  final selectedFileNames = <String, String>{}.obs;

  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;

  void addItem(String item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }

  void toggleIcon() => isChecked.toggle();

  void selectParentTag(String tag) {
    if (selectedParentTag.value == tag) {
      selectedParentTag.value = '';
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

  // void addTag(String tag) {
  //   if (!selectedTags.contains(tag)) {
  //     selectedTags.add(tag);
  //   }
  // }
  void addTag(String tag) {
    if (selectedParentTag.value == tag) {
      selectedParentTag.value = '';
      selectedTags.clear(); // Clear the list if deselected
    } else {
      selectedParentTag.value = tag;
      selectedTags.value = [tag]; // Only allow one selected
    }
  }

  void addTagInherit(String tag) {
    if (!selectedTagsInherit.contains(tag)) {
      selectedTagsInherit.add(tag);
      inputController.text = tag;
    }
  }
  void toggleSubTag(String subTag) {
    if (selectedTags.contains(subTag)) {
      selectedTags.clear(); // Deselect if already selected
    } else {
      selectedTags.value = [subTag];
      inputController.text = subTag;// Select only this one
    }
  }

  /// Text Management

  void setRole(String role) => selectedRole.value = role;

  void updateTask(String newTitle) => taskText.value = newTitle;

  void updateVerifyText(String newText) => verifyText.value = newText;

  void changeByUser() => isSuffixVisible.value = inputController.text.isNotEmpty;

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

  /// role


  Future<void> fetchRolePrompt(String role) async {
    if (isLoading.value) return;
    setLoading(true);

    try {
      final RoleResponse result = await PromptAdminServiceApis.getRolePromptResponse(
        request: {"role": role},
      );
      responseText.value = result.output;
    } catch (e) {
      toast("Error: $e");
      log("Error fetching role prompt: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> createNewPrompt(Map<String, dynamic> requestData) async {
    if (isLoading.value) return;
    setLoading(true);

    try {
      final NewPromptResponse result = await PromptAdminServiceApis.createNewPrompt(
        request: requestData,
      );
      toast("Prompt Created: ${result.message}");
      log("New Prompt Data: ${result.data?.promptName}");
    } catch (e) {
      toast("Error: $e");
      log("Error creating new prompt: $e");
    } finally {
      setLoading(false);
    }
  }
// Handle source selection for image upload
//   void onSourceSelected(ImageSource imageSource, String item) async {
//     final pickedFile = await pickFilesFromDevice(allowMultipleFiles: true);
//     if (pickedFile.isNotEmpty) {
//       Get.bottomSheet(
//         AppDialogueComponent(
//           titleText: "Do you want to upload this attachment?",
//           confirmText: "Upload",
//           onConfirm: () {
//             imageFiles.addAll(pickedFile);
//             fileNames.addAll(pickedFile.map((e) => e.path.split('/').last));
//           },
//         ),
//         isScrollControlled: true,
//       );
//     }
//   }
  void onSourceSelected(ImageSource source, String item) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      imageFiles.add(file);
      final fileName = file.path.split('/').last;

      // Update specific item
      selectedFileNames[item] = fileName;
    }
  }

}