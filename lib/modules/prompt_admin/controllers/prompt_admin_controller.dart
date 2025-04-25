import 'dart:developer';
import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
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

  final List<String> dataSources = ['XML', 'PDF', 'DOCX', 'XLSX','Data Lake','API'];
  var selectedSource = RxnString();

  var selectedItems = <String>[].obs;
  final selectedFileNames = <String, String>{}.obs;
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

}