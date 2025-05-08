import 'package:apps/modules/translation_memory/model/translation_model.dart';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

enum SortColumn {
  language,
  sourcePhrase,
  translationEdits,
  approver,
  actions,
}

class TranslationMemoryController extends BaseController {
  var allFiles = <TranslationMemory>[].obs;
  var isLoading = false.obs;
  var showSearchField = false.obs;
  var searchQuery = ''.obs;
  var selectedSearchField = ''.obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

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

  void setLoading(bool value) {
    isLoading.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
