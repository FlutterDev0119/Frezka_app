import 'dart:io';

import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../model/doc_language_model.dart';
import '../model/generate_sql_model.dart';

class GenAIPVController extends GetxController {
  final GlobalKey menuKey = GlobalKey();
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;
  var genAIDropdownValue = 'Upload File'.obs;
  RxMap<String, List<String>> filteredClassificationMap = <String, List<String>>{}.obs;
  RxMap<String, List<String>> classificationMap = <String, List<String>>{}.obs;
  RxSet<String> selectedChips = <String>{}.obs;
  RxSet<String> selectedTags = <String>{}.obs;
  RxBool isLoading = false.obs;
  RxBool isShowSqlIcon = false.obs;
  final TextEditingController searchController = TextEditingController();

  var tags = <String>[].obs;


  // List<String> tags = [
  //   "Adverse Event Reporting",
  //   "Aggregate Reporting",
  //   "Investigator Analysis",
  //   "PV Agreements",
  //   "Quality Control",
  //   "Reconciliation",
  //   "Risk Management",
  //   "Sampling",
  //   "Site Analysis",
  //   "System",
  //   "Trial Analysis",
  // ];
  // Filtered data for displaying in the UI
  RxMap<String, List<String>> filteredAttributes = <String, List<String>>{}.obs;
  final RxString selectedParentTag = ''.obs;


  var generateSQLResponse = Rxn<GenerateSQL>();
  var generateDataLanaguageResponse = Rxn<DocLanguage>();
  var errorMessage = ''.obs;
  var dataLakeInput = ''.obs;
  RxString selectedFileName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGenAIDocs();
    searchController.addListener(() {
      filterAttributes(searchController.text);
    });
    tags.assignAll([
      "Adverse Event Reporting",
      "Aggregate Reporting",
      "Investigator Analysis",
      "PV Agreements",
      "Quality Control",
      "Reconciliation",
      "Risk Management",
      "Sampling",
      "Site Analysis",
      "System",
      "Trial Analysis",
    ]);
  }

  void addTag(String tag) {
    if (selectedParentTag.value == tag) {
      // Deselect if the same tag is tapped again
      selectedParentTag.value = '';
      selectedTags.clear();
    } else {
      // Select the new tag and update list
      selectedParentTag.value = tag;
      selectedTags.assignAll([tag]);
    }
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
  Future<void> fetchGenAIDocs() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final data = await GenAIPVServiceApis.fetchGenAIDocs();
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

  void onSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      String fileName = imageSource.path.split('/').last;
      bool isDuplicate = fileNames.contains(fileName);

      if (isDuplicate) {
        toast("File already added");
        return;
      }

      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.add(imageSource);
            fileNames.add(fileName);
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


  Future<void> fetchGenerateSQL(String query, {String? userId, required String userName}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {
        "query": query,
        "userId": userId,
        "user_name": userName,
      };

      final response = await GenAIPVServiceApis.getGenerateSQL(request: request);
      generateSQLResponse.value = response;
    } catch (e) {
      print('Error fetching GenerateSQL: $e');
      errorMessage.value = 'Error occurred while fetching data.';
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> getDocsLanguage({required String language}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final request = {
  //       "language": language
  //     };
  //
  //     final response = await GenAIPVServiceApis.getDocsLanguage(request: request);
  //     generateDataLanaguageResponse.value = response;
  //   } catch (e) {
  //     print('Error fetching GenerateSQL: $e');
  //     errorMessage.value = 'Error occurred while fetching data.';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> getDocsLanguage({required String language}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {
        "language": language
      };

      final response = await GenAIPVServiceApis.getDocsLanguage(request: request);
      generateDataLanaguageResponse.value = response;

      /// Update tags from response
      if (response?.output != null && response!.output.isNotEmpty) {
        tags.assignAll(response.output);
      }
    } catch (e) {
      print('Error fetching language data: $e');
      errorMessage.value = 'Error occurred while fetching data.';
    } finally {
      isLoading.value = false;
    }
  }

}
