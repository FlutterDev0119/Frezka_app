import 'dart:convert';

import 'package:apps/modules/translation_memory/model/save_annotations.dart';
import 'package:apps/modules/translation_memory/model/translation_model.dart';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/shared_prefences.dart';
import '../model/ai_translation_memory_model.dart';
import '../model/staging_translation_memory.dart';

enum SortColumn {
  language,
  sourcePhrase,
  translationEdits,
  approver,
  actions,
}

class TranslationMemoryController extends BaseController {
  var isLoading = false.obs;

  ///all

  var showSearchField = false.obs;
  var searchQuery = ''.obs;
  var selectedSearchField = ''.obs;

  TextEditingController searchController = TextEditingController();

/// Staging (Pending)

  var allStagingFiles = <StagingTranslationRes>[].obs;
  var showStagingSearchField = false.obs;
  var searchStagingQuery = ''.obs;
  var selectedStagingSearchField = ''.obs;
  TextEditingController searchStagingController = TextEditingController();

  /// Approve Translation
  var allFiles = <TranslationMemory>[].obs;


  /// AI
  var allAIFiles = <AiTranslationMemoryRes>[].obs;
  var showAISearchField = false.obs;
  var searchAIQuery = ''.obs;
  var selectedAISearchField = ''.obs;

  TextEditingController searchAIController = TextEditingController();

  var selectedOption = 'Pending Approval'.obs;

  final options = ['Pending Approval', 'AI Suggestions'];

  void setSelected(String value) {
    selectedOption.value = value;
  }
  String Fullname = '';
  String id = '';
  var editPendingAnnotation = ''.obs;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() async {
    String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);

    if (userJson.isNotEmpty) {
      var userMap = jsonDecode(userJson);
      var userModel = UserModel.fromJson(userMap); // Replace with your actual model
      Fullname = "${userModel.firstName} ${userModel.lastName}";
      id = userModel.id.toString();
    }
    await fetchStagingTranslationMemoryList();
    await fetchData();
    await fetchAITranslationMemoryList();
  }

  /// Staging (Pending)
  //========================================================================================
  Future<void> fetchStagingTranslationMemoryList() async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final result = await TranslationMemoryServiceApis.fetchStagingTranslationMemoryList();
      allStagingFiles.clear();
      allStagingFiles.assignAll(result);
    } catch (e) {
      print('Error fetching Translation Memory list: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateStaging({required int id, required String en, required String es}) async {
    try {
      setLoading(true);
      var response = await TranslationMemoryServiceApis.updateStagingMemory(id: id, en: en, es: es);

      if (response['success'] != null) {
        toast(response['success'].toString());
      }
      await fetchData();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update translation');
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteStagingTranslationMemory(id) async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final result = await TranslationMemoryServiceApis.fetchStagingTranslationMemoryListDelete(id);

    } catch (e) {
      print('Error Delete Translation Memory list: $e');
    } finally {
      setLoading(false);
    }
  }
  //========================================================================================




  /// Staging (Pending)
  //========================================================================================
  Future<void> fetchData() async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final result = await TranslationMemoryServiceApis.fetchTranslationMemoryList();
      allFiles.clear();
      allFiles.assignAll(result);
    } catch (e) {
      print('Error fetching Translation Memory list: $e');
    } finally {
      setLoading(false);
    }
  }
  //========================================================================================





  Future<void> fetchAITranslationMemoryList() async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final result = await TranslationMemoryServiceApis.fetchAITranslationMemoryList();
      allAIFiles.clear();
      allAIFiles.assignAll(result);
    } catch (e) {
      print('Error fetching Translation Memory list: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateTranslation({required int id, required String en, required String es}) async {
    try {
      setLoading(true);
      var response = await TranslationMemoryServiceApis.updateTranslationMemory(id: id, en: en, es: es);

      if (response['success'] != null) {
        toast(response['success'].toString());
      }
      await fetchData();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update translation');
    } finally {
      setLoading(false);
    }
  }

  // Function to delete a translation memory item
  Future<void> deleteTranslation(int id) async {
    try {
      setLoading(true);
      var response = await TranslationMemoryServiceApis.deleteTranslationMemory(id: id);

      // Check for success response
      if (response['success'] != null) {
        toast(response['success'].toString());
      }

      await fetchData();
    } catch (e) {
      toast(e.toString());
    } finally {
      setLoading(false); // Stop the loading indicator
    }
  }

  // Future<void> saveAnnotation(int id) async {
  //   try {
  //     setLoading(true);
  //     var response = await TranslationMemoryServiceApis.saveAnnotation(request: );
  //
  //     // Check for success response
  //     if (response['success'] != null) {
  //       toast(response['success'].toString());
  //     }
  //
  //     await fetchData();
  //   } catch (e) {
  //     toast(e.toString());
  //   } finally {
  //     setLoading(false); // Stop the loading indicator
  //   }
  // }
  Future<void> saveAnnotation(id) async {
    try {
      isLoading.value = true;

      final request = {
        "comment":"test",
        "translation_edits_id":id,
        "user_id":id,
        "username":Fullname,
      };

      final response = await TranslationMemoryServiceApis.saveAnnotation(request: request);
      editPendingAnnotation.value = response.success;
      fetchData();
    } catch (e) {
      print('Error fetching GenerateSQL: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Optional: Filtered list
  List<TranslationMemory> get filteredFiles {
    if (searchQuery.isEmpty) {
      return allFiles;
    } else {
      return allFiles.where((file) {
        final query = searchQuery.value.toLowerCase();
        if (selectedSearchField.value == "Language") {
          return file.lang.toLowerCase().contains(query);
        } else if (selectedSearchField.value == "Source Phrase") {
          return file.en.toLowerCase().contains(query);
        } else if (selectedSearchField.value == "Approver") {
          return file.name.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    }
  }
  List<StagingTranslationRes> get filteredStagingFiles {
    if (searchStagingQuery.isEmpty) {
      return allStagingFiles;
    } else {
      return allStagingFiles.where((file) {
        final query = searchStagingQuery.value.toLowerCase();
        if (selectedStagingSearchField.value == "Language") {
          return file.lang.toLowerCase().contains(query);
        } else if (selectedStagingSearchField.value == "Source Phrase") {
          return file.en.toLowerCase().contains(query);
        } else if (selectedStagingSearchField.value == "Approver") {
          return file.name.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    }
  }
  List<AiTranslationMemoryRes> get filteredAIFiles {
    if (searchAIQuery.isEmpty) {
      return allAIFiles;
    } else {
      return allAIFiles.where((file) {
        final query = searchAIQuery.value.toLowerCase();
        if (selectedAISearchField.value == "Language") {
          return file.lang.toLowerCase().contains(query);
        } else if (selectedAISearchField.value == "Source Phrase") {
          return file.en.toLowerCase().contains(query);
        } else if (selectedAISearchField.value == "Approver") {
          return file.name.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    }
  }
  void setLoading(bool value) {
    isLoading.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchStagingController.dispose();
    searchAIController.dispose();
    super.onClose();
  }
}
