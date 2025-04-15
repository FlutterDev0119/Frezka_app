import 'package:apps/utils/library.dart';
import 'package:get/get.dart'; // Ensure you're importing GetX base
import '../model/open_worklist_model.dart';
import '../model/transalted_model.dart';

enum SortColumn {
  id,
  sourceLanguage,
  originalCount,
  translatedCount,
  score,
}

class MetaPhraseController extends GetxController {
  final allFiles = <TranslationWork>[].obs;
  final filteredFiles = <TranslationWork>[].obs;
  var selectedFile = Rxn<TranslationReport>();

  var sortColumn = SortColumn.id.obs;
  var isAscending = true.obs;

  // Optional: for filtering by language
  var selectedLanguage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseList();
      allFiles.assignAll(result);
      sortList(); // Sort initially
    } catch (e) {
      print('Error fetching MetaPhrase list: $e');
    }
  }
  Future<void> fetchMetaDataById(String id) async {
    try {
      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseListById(id);
      if (result.isNotEmpty) {
        // Set the first item from the result list to the selectedFile
        selectedFile.value = result.first;
      } else {
        // Handle case where no data is returned for the provided id
        print('No data found for the provided id');
      }
    } catch (e) {
      print('Error fetching MetaPhrase list for id $id: $e');
    }
  }

  void sortList() {
    List<TranslationWork> sorted = [...allFiles];
    sorted.sort((a, b) {
      int compare;
      switch (sortColumn.value) {
        case SortColumn.id:
          compare = a.id.compareTo(b.id);
          break;
        case SortColumn.sourceLanguage:
          compare = a.sourceLanguage.toLowerCase().compareTo(b.sourceLanguage.toLowerCase());
          break;
        case SortColumn.originalCount:
          compare = a.originalCount.compareTo(b.originalCount);
          break;
        case SortColumn.translatedCount:
          compare = a.translatedCount.compareTo(b.translatedCount);
          break;
        case SortColumn.score:
          compare = a.score.compareTo(b.score);
          break;
      }
      return isAscending.value ? compare : -compare;
    });

    filteredFiles.assignAll(sorted);
  }

  void toggleSort(SortColumn column) {
    if (sortColumn.value == column) {
      isAscending.toggle();
    } else {
      sortColumn.value = column;
      isAscending.value = true;
    }
    sortList();
  }

  // Optional: Filter by source language
  void filterByLanguage(String language) {
    selectedLanguage.value = language;
    if (language.isEmpty) {
      filteredFiles.assignAll(allFiles);
    } else {
      filteredFiles.assignAll(
        allFiles.where((file) => file.sourceLanguage == language).toList(),
      );
    }
  }
}
