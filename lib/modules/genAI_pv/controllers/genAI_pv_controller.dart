import 'dart:io';

import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../genAI_clinical/model/additional_narrative_model.dart';
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

  // Filtered data for displaying in the UI
  RxMap<String, List<String>> filteredAttributes = <String, List<String>>{}.obs;
  final RxString selectedParentTag = ''.obs;

  var generateSQLQuery = ''.obs;
  var generateDataLanaguageResponse = Rxn<DocLanguage>();
  var errorMessage = ''.obs;
  var dataLakeInput = ''.obs;
  RxString selectedFileName = ''.obs;

  RxList<SqlDataItem> safetyReports = <SqlDataItem>[].obs;
  final RxString sqlQuery = ''.obs;
  var additionalNarrativeRes = Rxn<AdditionalNarrativeRes>();
  final TextEditingController personalizeController = TextEditingController();
  final isTextNotEmpty = false.obs;
  RxBool isAdditionalNarrative = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchGenAIDocs();
    searchController.addListener(() {
      filterAttributes(searchController.text);
    });
    isAdditionalNarrative.value = false;
    // tags.assignAll([
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
    // ]);
  }

  void updateTextState(String text) {
    isTextNotEmpty.value = text.trim().isNotEmpty;
  }
  // void addTag(String tag) {
  //   if (selectedParentTag.value == tag) {
  //     // Deselect if the same tag is tapped again
  //     selectedParentTag.value = '';
  //     selectedTags.clear();
  //   } else {
  //     // Select the new tag and update list
  //     selectedParentTag.value = tag;
  //     selectedTags.assignAll([tag]);
  //   }
  // }
  void addTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
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
        tags.assignAll(data.output!.keys.toList());
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


  // Future<void> fetchGenerateSQL(String query, {String? userId, required String userName}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final request = {
  //       "query": query,
  //       "userId": userId,
  //       "user_name": userName,
  //     };
  //
  //     final response = await GenAIPVServiceApis.getGenerateSQL(request: request);
  //     generateSQLResponse.value = response;
  //     final List<dynamic> rawData = response.data;
  //     safetyReports.value = rawData
  //         .map((item) => Map<String, String>.from(item))
  //         .toList();
  //       } catch (e) {
  //     print('Error fetching GenerateSQL: $e');
  //     errorMessage.value = 'Error occurred while fetching data.';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  // ✅ Controller Method
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
      generateSQLQuery.value = response.sqlQuery;

      // if (response.data.isNotEmpty) {
      //   generateSQLResponse.value = response.data.first; // if you want to use it
      // }
      // generateSQLResponse.value = response.sqlQuery;
      // Set the SQL query text
      sqlQuery.value = response.sqlQuery;

      // Extract safety report list from the response
      safetyReports.value = response.data;

    } catch (e) {
      print('Error fetching GenerateSQL: $e');
      errorMessage.value = 'Error occurred while fetching data.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> additionalNarrative({required String query, required String SafetyReport, required List<String> checkbox, required String narrative}) async {
    try {
      isLoading.value = true;

      final request = {
        "query": query,
        "SafetyReport": [],
        "checkbox": checkbox,
        "narrative": '',
      };

      final response = await GenAIPVServiceApis.fetchAdditionalNarrative(request: request);
      additionalNarrativeRes.value = response;
    } catch (e) {
      print('Error fetching Additional Narrative: $e');
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
