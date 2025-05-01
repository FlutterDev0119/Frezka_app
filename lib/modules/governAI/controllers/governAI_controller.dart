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
  var traceList = <Trace>[].obs;
  var countTracesList = <CountTracesModel>[].obs;
  var isLoading = true.obs;
  final sortGovernColumn = SortGovernColumn.id.obs;
  final isAscending = true.obs;
  var filteredReasons = <String>[].obs;
  var selectedReason = ''.obs;
  final allFiles = <Trace>[].obs;
  final filteredFiles = <Trace>[].obs;

  final executionTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await fetchTraces();
    await fetchCountTraces();
  }

  // Fetch Traces list from API
  Future<void> fetchTraces() async {
    try {
      isLoading(true);
      final result = await GovernAIServiceApis.fetchTracesList();
      traceList.assignAll(result); // Add the fetched traces to the observable list
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
    List<Trace> tempList = [...allFiles];

    // Apply filter if any
    if (executionTime.isNotEmpty) {
      tempList = tempList.where((file) => file.executionTime == executionTime.value).toList();
    }

    // Apply sort
    tempList.sort((a, b) {
      int compare;
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
          compare = a.latency!.compareTo(b.latency as num);
          break;
        case SortGovernColumn.tokens:
          compare = a.tokens!.compareTo(b.tokens as num);
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
