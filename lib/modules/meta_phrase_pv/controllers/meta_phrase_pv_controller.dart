import 'package:apps/utils/library.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// class MetaPhraseController extends GetxController {
//   final worklist = <TranslationFile>[].obs;
//   final filteredList = <TranslationFile>[].obs;
//   final selectedLanguage = RxnString();
//   final languages = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     worklist.assignAll([
//       TranslationFile(id: '20.docx', language: 'Spanish (es)', originalCount: 152, translatedCount: 135, score: 53),
//       TranslationFile(id: '18.docx', language: 'German (de)', originalCount: 171, translatedCount: 197, score: 66),
//       TranslationFile(id: '17.docx', language: 'Japanese (ja)', originalCount: 29, translatedCount: 75, score: 55),
//       TranslationFile(id: '12.docx', language: 'Spanish (es)', originalCount: 1432, translatedCount: 1419, score: 68),
//       TranslationFile(id: '10.docx', language: 'Japanese (ja)', originalCount: 299, translatedCount: 878, score: 46),
//     ]);
//     filteredList.assignAll(worklist);
//     languages.assignAll(worklist.map((e) => e.language).toSet());
//   }
//
//   void filterByLanguage(String? lang) {
//     selectedLanguage.value = lang;
//     if (lang == null || lang.isEmpty) {
//       filteredList.assignAll(worklist);
//     } else {
//       filteredList.assignAll(worklist.where((e) => e.language == lang));
//     }
//   }
//
//   void sortByScore() {
//     filteredList.sort((a, b) => b.score.compareTo(a.score));
//   }
// }
// class TranslationFile {
//   final String id;
//   final String language;
//   final int originalCount;
//   final int translatedCount;
//   final int score;
//
//   TranslationFile({
//     required this.id,
//     required this.language,
//     required this.originalCount,
//     required this.translatedCount,
//     required this.score,
//   });
// // }
// class MetaPhraseController extends GetxController {
//   final allFiles = <TranslationFile>[].obs;
//   final filteredFiles = <TranslationFile>[].obs;
//
//   // Filters
//   var identifierFilter = ''.obs;
//   var languageFilter = ''.obs;
//   var originalCountFilter = ''.obs;
//   var translatedCountFilter = ''.obs;
//   var scoreFilter = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     allFiles.assignAll([
//       TranslationFile(id: '20.docx', language: 'Spanish (es)', originalCount: 152, translatedCount: 135, score: 53),
//       TranslationFile(id: '18.docx', language: 'German (de)', originalCount: 171, translatedCount: 197, score: 66),
//       TranslationFile(id: '17.docx', language: 'Japanese (ja)', originalCount: 29, translatedCount: 75, score: 55),
//       TranslationFile(id: '12.docx', language: 'Spanish (es)', originalCount: 1432, translatedCount: 1419, score: 68),
//       TranslationFile(id: '10.docx', language: 'Japanese (ja)', originalCount: 299, translatedCount: 878, score: 46),
//     ]);
//     applyFilters();
//   }
//
//   void applyFilters() {
//     filteredFiles.assignAll(allFiles.where((file) {
//       return file.id.toLowerCase().contains(identifierFilter.value.toLowerCase()) &&
//           file.language.toLowerCase().contains(languageFilter.value.toLowerCase()) &&
//           file.originalCount.toString().contains(originalCountFilter.value) &&
//           file.translatedCount.toString().contains(translatedCountFilter.value) &&
//           file.score.toString().contains(scoreFilter.value);
//     }).toList());
//   }
//
//   void updateFilter({
//     String? id,
//     String? lang,
//     String? original,
//     String? translated,
//     String? score,
//   }) {
//     if (id != null) identifierFilter.value = id;
//     if (lang != null) languageFilter.value = lang;
//     if (original != null) originalCountFilter.value = original;
//     if (translated != null) translatedCountFilter.value = translated;
//     if (score != null) scoreFilter.value = score;
//     applyFilters();
//   }
// }
class TranslationFile {
  final String id;
  final String language;
  final int originalCount;
  final int translatedCount;
  final int score;

  TranslationFile({
    required this.id,
    required this.language,
    required this.originalCount,
    required this.translatedCount,
    required this.score,
  });
}
enum SortColumn { id, language, originalCount, translatedCount, score }

class MetaPhraseController extends GetxController {
  final allFiles = <TranslationFile>[].obs;
  final filteredFiles = <TranslationFile>[].obs;

  var sortColumn = SortColumn.id.obs;
  var isAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    allFiles.assignAll([
      TranslationFile(id: '20.docx', language: 'Spanish (es)', originalCount: 152, translatedCount: 135, score: 53),
      TranslationFile(id: '18.docx', language: 'German (de)', originalCount: 171, translatedCount: 197, score: 66),
      TranslationFile(id: '17.docx', language: 'Japanese (ja)', originalCount: 29, translatedCount: 75, score: 55),
      TranslationFile(id: '12.docx', language: 'Spanish (es)', originalCount: 1432, translatedCount: 1419, score: 68),
      TranslationFile(id: '10.docx', language: 'Japanese (ja)', originalCount: 299, translatedCount: 878, score: 46),
    ]);
    sortList(); // Initial sort
  }

  void sortList() {
    List<TranslationFile> sorted = [...allFiles];
    sorted.sort((a, b) {
      int compare;
      switch (sortColumn.value) {
        case SortColumn.id:
          compare = a.id.compareTo(b.id);
          break;
        case SortColumn.language:
          compare = a.language.compareTo(b.language);
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
      isAscending.toggle(); // toggle direction
    } else {
      sortColumn.value = column;
      isAscending.value = true; // default to ascending on new column
    }
    sortList();
  }
}
