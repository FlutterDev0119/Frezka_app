import 'package:apps/utils/library.dart';
import '../model/count_traces_model.dart';
import '../model/fetch_traces_model.dart';
enum SortGovernColumn {
  id,
  name,
  executionTime,
  totalCost,
  latency,
  tokens,
  user,
  recommendedAction
}
class GovernAIController extends GetxController {
  var traceList = <TraceData>[].obs;
  var countTracesList = <CountTracesModel>[].obs;
  var isLoading = true.obs;
  final sortGovernColumn = SortGovernColumn.id.obs;
  final isAscending = true.obs;
  var filteredReasons = <String>[].obs;
  var selectedReason = ''.obs;
  final allFiles = <TraceData>[].obs;
  final filteredFiles = <TraceData>[].obs;

  final executionTime = ''.obs;

  RxInt currentPage = 1.obs;
  RxInt totalItems = 0.obs;
  RxString lastTappedCategory = ''.obs;
  RxString lastTappedDate = ''.obs;
  @override
  void onInit() {
    super.onInit();
    init();
  }
  @override
  void onClose() {
    // Clear all data and reset states
    traceList.clear();
    countTracesList.clear();
    allFiles.clear();
    filteredFiles.clear();
    executionTime.value = '';
    selectedReason.value = '';
    filteredReasons.clear();
    sortGovernColumn.value = SortGovernColumn.id;
    isAscending.value = true;
    super.onClose();
  }

  init() async {
    // await fetchTraces();
    await fetchCountTraces();
  }

  // Fetch Traces list from API
  // Future<void> fetchTraces(String tappedCategory, String tappedDate) async {
  //   try {
  //     isLoading(true);
  //     final result = await GovernAIServiceApis.fetchTracesList(tappedCategory,tappedDate);
  //     traceList.assignAll(result); // Add the fetched traces to the observable list
  //     filteredFiles.value = List.from(result);
  //   } catch (e) {
  //     print('Error fetching traces: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  // Future<void> fetchTraces(String tappedCategory, String tappedDate) async {
  //   try {
  //     isLoading(true);
  //     final result = await GovernAIServiceApis.fetchTracesList(tappedCategory, tappedDate);
  //
  //     allFiles.assignAll(result);
  //     filteredFiles.assignAll(result);
  //     traceList.assignAll(result);
  //   } catch (e) {
  //     print('Error fetching traces: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  Future<void> fetchTraces(String tappedCategory, String tappedDate, int page) async {
    try {
      isLoading(true);
      final result = await GovernAIServiceApis.fetchTracesList(tappedCategory, tappedDate, page);

      if (page == 1) {
        allFiles.assignAll(result);
      } else {
        allFiles.addAll(result);
      }

      final uniqueList = allFiles.toSet().toList();
      allFiles.assignAll(uniqueList);
      filteredFiles.assignAll(uniqueList);
      traceList.assignAll(uniqueList);
      currentPage.value = page;

      print("----------1-------------${filteredFiles.length}");
      print("---------1--------------${allFiles.length}");
    } catch (e) {
      print('Error fetching traces: $e');
    } finally {
      isLoading(false);
    }
  }


  // Fetch CountTraces list from API
  Future<void> fetchCountTraces() async {
    try {
      isLoading(true);
      final result = await GovernAIServiceApis.fetchCountTracesList();
      countTracesList.assignAll(result);

    } catch (e) {
      print('Error fetching CountTraces: $e'); // This will help debug the error
    } finally {
      isLoading(false);
    }
  }

  /// Sort and filter list together
  void _applySortAndFilter() {
    List<TraceData> tempList = [...allFiles];

    if (executionTime.value.isNotEmpty) {
      tempList = tempList.where((file) => file.executionTime == executionTime.value).toList();
    }
    // 🔃 Apply sort based on selected column
    tempList.sort((a, b) {
      int compare = 0;
      switch (sortGovernColumn.value) {
        case SortGovernColumn.id:
          compare = a.id.compareTo(b.id);
          break;
        case SortGovernColumn.name:
          compare = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortGovernColumn.executionTime:
          compare = a.executionTime.compareTo(b.executionTime);
          break;
        case SortGovernColumn.totalCost:
          compare = a.totalCost.compareTo(b.totalCost);
          break;
        case SortGovernColumn.latency:
          compare = (a.latency ?? 0).compareTo(b.latency ?? 0);
          break;
        case SortGovernColumn.tokens:
          compare = (a.tokens ?? 0).compareTo(b.tokens ?? 0);
          break;
        case SortGovernColumn.user:
          compare = a.user.toLowerCase().compareTo(b.user.toLowerCase());
          break;
        case SortGovernColumn.recommendedAction:
          compare = a.recommendedAction.toLowerCase().compareTo(b.recommendedAction.toLowerCase());
          break;
      }

      return isAscending.value ? compare : -compare;
    });

    filteredFiles.assignAll(tempList);
  }



  /// Trigger sorting by a column
  void toggleSort(SortGovernColumn column) {
    executionTime.value = ''; // Clear filter before sorting
    if (sortGovernColumn.value == column) {
      isAscending.toggle();
    } else {
      sortGovernColumn.value = column;
      isAscending.value = true;
    }
    _applySortAndFilter();
  }

  /// Filter list by source language
  void filterByLanguage(String language) {
    executionTime.value = language;
    _applySortAndFilter();
  }


}
