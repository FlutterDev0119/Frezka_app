import 'dart:convert';
import 'dart:io';
import 'package:apps/utils/library.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../../utils/shared_prefences.dart';
import '../../genAI_pv/model/generate_sql_model.dart';
import '../model/additional_narrative_model.dart';
import '../model/execute_prompt_model.dart';
import '../model/fetch_clinical_data.dart';
import 'package:open_file/open_file.dart' as ofx;

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
  var fetchClinicalData = Rxn<FetchClinicalDataRes>();
  var executePromptRes = Rxn<ExecutePromptRes>();
  var generateSQLQuery = ''.obs;
  final RxString sqlQuery = ''.obs;
  var errorMessage = ''.obs;
  RxList<SqlDataItem> safetyReports = <SqlDataItem>[].obs;
  RxBool isExpanded = false.obs;
  RxBool fileCopyTap = false.obs;
  RxString uploadContent = ''.obs;

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
    fileCopyTap.value = false;
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


  Future<void> fetchClinical(String query, {String? userId, required String userName}) async {
    try {
      isLoading.value = true;
      if (userId == null) {
        log('Error fetching Clinical Data: userId is null');
        errorMessage.value = 'User ID cannot be null.';
        return;
      }
      final response = await ClinicalPromptServiceApis.fetchClinicalData(query: query, userName: userName, userId: userId);
      fetchClinicalData.value = response;
    } catch (e) {
      log('Error fetching Clinical Data: $e');
      errorMessage.value = 'Error occurred while fetching clinical data.';
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> additionalNarrative({required String query, required List<String> SafetyReport, required List<String> checkbox, required String narrative}) async {
    try {
      isLoading.value = true;
      log("----------------------------");
log(executePromptRes.value?.output.toString() ?? '');
      log("----------------------------");
      final request = {
        "query": query,
        "SafetyReport": genAIDropdownValue.value == 'Upload File' ? [uploadContent.value] :SafetyReport,
        "checkbox": checkbox,
        "narrative": executePromptRes.value?.output.toString() ?? '',
      };

      final response = await ClinicalPromptServiceApis.fetchAdditionalNarrative(request: request);
      additionalNarrativeRes.value = response;
      _logLongString(request.toString());
    } catch (e) {
      print('Error fetching Additional Narrative: $e');
    } finally {
      isLoading.value = false;
    }
  }
  void _logLongString(String message, {int chunkSize = 800}) {
    final pattern = RegExp('.{1,$chunkSize}');
    for (final match in pattern.allMatches(message)) {
      log(match.group(0)!);
    }
  }
  Future<void> executePrompt({required List<String> studies, required List<String> checkbox}) async {//required String userId,required String user_name
    try {
      isLoading.value = true;
      String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);
      String Fullname = '';
      String id = '';
      if (userJson.isNotEmpty) {
        var userMap = jsonDecode(userJson);
        var userModel = UserModel.fromJson(userMap); // Replace with your actual model
        Fullname = "${userModel.firstName} ${userModel.lastName}";
        id = userModel.id.toString();
      }
      final request = {
        "studies":genAIDropdownValue.value == 'Upload File' ? [uploadContent.value] : studies,
        "checkbox": checkbox,
        "userId": id,
        "user_name": Fullname,
      };

      final response = await ClinicalPromptServiceApis.executePrompt(request: request);
      executePromptRes.value = response;
    } catch (e) {
      print('Error fetching Additional Narrative: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // Future<String> decodeExcel(File file) async {
  //   var bytes = file.readAsBytesSync();
  //   var excel = Excel.decodeBytes(bytes);
  //   StringBuffer buffer = StringBuffer();
  //
  //   for (var table in excel.tables.keys) {
  //     var rows = excel.tables[table]!.rows;
  //     for (var row in rows) {
  //       buffer.writeln(row.map((cell) => cell?.value.toString() ?? '').join(','));
  //     }
  //     break;
  //   }
  //
  //   return buffer.toString();
  // }
  // void onSourceSelected(File file) async {
  //   final fileName = file.path.split('/').last;
  //   final ext = fileName.split('.').last.toLowerCase();
  //
  //   String? content;
  //
  //   try {
  //     if (['txt', 'csv', 'json'].contains(ext)) {
  //       content = await file.readAsString();
  //     } else if (['xlsx', 'xls'].contains(ext)) {
  //       content = await decodeExcel(file);
  //     } else {
  //       toast('Unsupported file format: .$ext');
  //       return;
  //     }
  //   } catch (e) {
  //     toast('Error decoding file: $e');
  //     return;
  //   }
  //
  //   if (fileNames.contains(fileName)) {
  //     toast("File '$fileName' already selected.");
  //     return;
  //   }
  //
  //   final confirmed = await Get.bottomSheet<bool>(
  //     AppDialogueComponent(
  //       titleText: "Do you want to upload this attachment?",
  //       confirmText: "Upload",
  //       onConfirm: () {},
  //     ),
  //     isScrollControlled: true,
  //   );
  //   if (confirmed == true) {
  //     fileNames.clear();
  //     imageFiles.clear();
  //
  //     imageFiles.add(file);
  //     fileNames.add(fileName);
  //   }
  // }
  void onSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      // String fileName = imageSource.path.split('/').last;
      // bool isDuplicate = fileNames.contains(fileName);
      final filePath = imageSource.path;
      final fileName = filePath.split('/').last;
      final extension = filePath.split('.').last.toLowerCase();
      final isDuplicate = fileNames.contains(fileName);
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
      if (['txt', 'xml', 'csv'].contains(extension)) {
        final content = await imageSource.readAsString();
        uploadContent.value = content; // Save the read content
      } else if (extension == 'pdf') {
        // Implement PDF reading logic here if needed
        toast("PDF reading not implemented yet.");
      } else if (['docx', 'xlsx', 'xls'].contains(extension)) {
        final result = await ofx.OpenFile.open(filePath);
        if (result.type != ofx.ResultType.done) {
          toast("Can't open this file on your device.");
        }
      } else {
        toast("Unsupported file type.");
      }
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

  bool isTableData(String output) {
    // Basic check for markdown-style table
    return output.contains('|') && output.contains('\n');
  }

}

