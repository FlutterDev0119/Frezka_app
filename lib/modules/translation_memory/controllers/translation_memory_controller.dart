import 'package:apps/modules/translation_memory/model/translation_model.dart';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

enum SortColumn {
  id,
  sourceLanguage,
  originalCount,
  translatedCount,
  score,
}

class TranslationMemoryController extends BaseController {
  // final allFiles = <TranslationItem>[].obs;
  final filteredFiles = <TranslationItem>[].obs;

  final sortColumn = SortColumn.id.obs;
  final isAscending = true.obs;
  final selectedLanguage = ''.obs;

  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  var selectedMode = 'Review'.obs;
  RxBool isCardSelected = false.obs;

  late ScrollController translatedScrollController = ScrollController();
  late ScrollController translatedScrollController1 = ScrollController();
  final List<String> modes = ['Review', 'Edit', 'Peer Review', 'Certify'];

  RxString reverseTranslatedText = ''.obs;

  // var isEditing = false.obs;
  // var translatedText = ''.obs;
  //
  // void toggleEditing() {
  //   isEditing.value = !isEditing.value;
  // }
  //
  // void setText(String text) {
  //   translatedText.value = text;
  // }
  var isEditing = false.obs;
  late TextEditingController translatedTextController;
  @override
  void onInit() {
    super.onInit();
    translatedScrollController = ScrollController();
    translatedScrollController1 = ScrollController();
    translatedTextController = TextEditingController();
    fetchData();
  }

  void exitEditMode() {
    isEditing.value = false;
    reverseTranslatedText.value = translatedTextController.text;
  }

  void updateSelectedMode(String mode) {
    selectedMode.value = mode;
  }

  List<Map<String, dynamic>>? getListFromStorage() {
    List<Map<String, dynamic>>? storedItems = getStringListAsync("setid_list")
        ?.map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    return storedItems;
  }

  /// Fetch all MetaPhrase work list
  Future<void> fetchData() async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseList();
      // allFiles.assignAll(result);
      // _applySortAndFilter();
    } catch (e) {
      print('Error fetching MetaPhrase list: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Fetch details by ID and set selected translation report
  void fetchMetaDataById(String id) async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseListById(id);

      if (result != null && result.isNotEmpty) {
        var fileData = result.first;

        // selectedTranslationReport.value = fileData;
      } else {
        errorMessage.value = 'No data found for this file.';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      print('Fetch error: $e');
    } finally {
      setLoading(false);
      isLoading.value = false;
    }
  }

  /// Reverse translate
  Future<void> fetchReverseTranslation(String translatedText) async {
    try {
      isLoading.value = true;
      final response = await MetaPhrasePVServiceApis.reverseTranslate(request: {
        "text": translatedText,
      });
      reverseTranslatedText.value = response.reverseTranslated;
    } catch (e) {
      print('Reverse translation error: $e');
      reverseTranslatedText.value =
          'Error occurred during reverse translation.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Sort and filter list together
  // void _applySortAndFilter() {
  //   List<TranslationItem> tempList = [...allFiles];

  //   // Apply filter if any
  //   if (selectedLanguage.isNotEmpty) {
  //     tempList = tempList
  //         .where((file) => file.sourceLanguage == selectedLanguage.value)
  //         .toList();
  //   }

  //   // Apply sort
  //   tempList.sort((a, b) {
  //     int compare;
  //     switch (sortColumn.value) {
  //       case SortColumn.id:
  //         compare = a.id.compareTo(b.id);
  //         break;
  //       case SortColumn.sourceLanguage:
  //         compare = a.sourceLanguage
  //             .toLowerCase()
  //             .compareTo(b.sourceLanguage.toLowerCase());
  //         break;
  //       case SortColumn.originalCount:
  //         compare = a.originalCount.compareTo(b.originalCount);
  //         break;
  //       case SortColumn.translatedCount:
  //         compare = a.translatedCount.compareTo(b.translatedCount);
  //         break;
  //       case SortColumn.score:
  //         compare = a.score.compareTo(b.score);
  //         break;
  //     }
  //     return isAscending.value ? compare : -compare;
  //   });

  //   filteredFiles.assignAll(tempList);
  // }

  /// Trigger sorting by a column
  void toggleSort(SortColumn column) {
    if (sortColumn.value == column) {
      isAscending.toggle();
    } else {
      sortColumn.value = column;
      isAscending.value = true;
    }
    // _applySortAndFilter();
  }

  /// Filter list by source language
  void filterByLanguage(String language) {
    selectedLanguage.value = language;
    // _applySortAndFilter();
  }

  @override
  void dispose() {
    translatedScrollController.dispose();
    translatedScrollController1.dispose();
    super.dispose();
  }
}
