import 'dart:io';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../genAI_pv/model/generate_sql_model.dart';
import '../model/additional_narrative_model.dart';

class GenAIClinicalController extends GetxController {
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;

  RxMap<String, List<String>> filteredClassificationMap = <String, List<String>>{}.obs;
  RxMap<String, List<String>> classificationMap = <String, List<String>>{}.obs;
  RxSet<String> selectedChips = <String>{}.obs;
  RxSet<String> selectedTags = <String>{}.obs;
  RxBool isLoading = false.obs;
  RxBool isAdditionalNarrative = false.obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController personalizeController = TextEditingController();

  // Filtered data for displaying in the UI
  RxMap<String, List<String>> filteredAttributes = <String, List<String>>{}.obs;
  var genAIDropdownValue = 'Upload File'.obs;
  var dataLakeInput = ''.obs;
  RxBool isShowSqlIcon = false.obs;
  var tags = <String>[].obs;
  final RxString selectedParentTag = ''.obs;
  var additionalNarrativeRes = Rxn<AdditionalNarrativeRes>();
  var generateSQLQuery = ''.obs;
  final RxString sqlQuery = ''.obs;
  var errorMessage = ''.obs;
  RxList<SqlDataItem> safetyReports = <SqlDataItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDocsClinical();
    // Ensure chip list resets when search is cleared
    searchController.addListener(() {
      filterAttributes(searchController.text);
    });
    // tags.assignAll([
    //   "Trials Risk Analysis",
    //   "Investigator Details",
    //   "Studies Dropout Rates",
    //   "Clinical Trials Details",
    // ]);
    isAdditionalNarrative.value = false;
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
        // tags.assignAll(data.output!.keys.toList());
        tags.assignAll(data.output!.values.expand((list) => list).toList());
        log("data.output!.keys.toList()----------------${data.output!.keys.toList()}");
        log("data.output!.value.toList()----------------${data.output!.values.toList()}");
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
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
      generateSQLQuery.value = response.sqlQuery;

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

      final response = await ClinicalPromptServiceApis.fetchAdditionalNarrative(request: request);
      additionalNarrativeRes.value = response;
    } catch (e) {
      print('Error fetching Additional Narrative: $e');
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
}
