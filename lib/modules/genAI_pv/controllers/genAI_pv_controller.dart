
import 'dart:io';

import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';

class GenAIPVController extends GetxController {
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;

  RxMap<String, List<String>> filteredClassificationMap = <String, List<String>>{}.obs;
  RxMap<String, List<String>> classificationMap = <String, List<String>>{}.obs;
  RxSet<String> selectedChips = <String>{}.obs;
  RxSet<String> selectedTags = <String>{}.obs;
  RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  // Filtered data for displaying in the UI
  RxMap<String, List<String>> filteredAttributes = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getDocsClinical();
    // Ensure chip list resets when search is cleared
    searchController.addListener(() {
      filterAttributes(searchController.text);
    });

  }

  // Method to toggle selection for both chips and attributes (unified logic)
  void toggleSelection(String label) {
    if (selectedChips.contains(label)) {
      selectedChips.remove(label);
    } else {
      selectedChips.add(label);
    }

    if (selectedTags.contains(label)) {
      selectedTags.remove(label);
    } else {
      selectedTags.add(label);
    }
  }

  // Fetch clinical document data (populate classificationMap and selectable attributes)
  Future<void> getDocsClinical() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final data = await ClinicalPromptServiceApis.getDocsClinical();
      if (data != null && data.output != null) {
        classificationMap.assignAll(data.output!);
        filteredClassificationMap.assignAll(data.output!);
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Handle source selection for image upload
  void onSourceSelected(ImageSource imageSource) async {
    final pickedFile = await pickFilesFromDevice(allowMultipleFiles: true);
    if (pickedFile.isNotEmpty) {
      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.addAll(pickedFile);
            fileNames.addAll(pickedFile.map((e) => e.path.split('/').last));
          },
        ),
        isScrollControlled: true,
      );
    }
  }

  // Toggle the selection of attributes (now unified with chips)
  void toggleAttribute(String attribute) {
    toggleSelection(attribute);
  }

  // Remove selected attribute (if needed, this can be the same as toggle)
  void removeAttribute(String attribute) {
    selectedTags.remove(attribute);
  }
  // Method to filter attributes based on the search query
  void filterAttributes(String query) {
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      filteredClassificationMap.assignAll(classificationMap);
      return;
    }

    final newFiltered = <String, List<String>>{};
    classificationMap.forEach((category, attributes) {
      final matches = attributes.where((attr) => attr.toLowerCase().contains(trimmed)).toList();
      if (matches.isNotEmpty) {
        newFiltered[category] = matches;
      }
    });

    filteredClassificationMap.assignAll(newFiltered);
  }
}
